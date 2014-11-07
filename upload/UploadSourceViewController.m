//
//  UploadSourceViewController.m
//  HBTaxService
//
//  Created by khuang on 14-11-4.
//  Copyright (c) 2014年 servyou. All rights reserved.
//

#import "UploadSourceViewController.h"
#include "CompatibleaPrintf.h"
#import "ASIFormDataRequest.h"
#import <MobileCoreServices/UTCoreTypes.h>
#import "ZAActivityBar.h"
#import "JSONKit.h"

static uint     MAX_CACHE = 50;
static NSString *DES_KEY = @"JDLSJDLS";
static NSString *HB_HTTP_URL = @"http://192.168.29.102:7001/bondegate/bondeServiceServlet";

@implementation CachedImageItem
@synthesize path, image;
@end

@interface UploadSourceViewController () <UINavigationBarDelegate, UIImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *labUploaded;
@property (weak, nonatomic) IBOutlet UICollectionView *gridCached;
@property (weak, nonatomic) IBOutlet UIButton *btnAlbum;
@property (weak, nonatomic) IBOutlet UIButton *btnCamera;
@property (weak, nonatomic) IBOutlet UIView *deleteContainer;
@property (weak, nonatomic) IBOutlet UIButton *btnCancel;
@property (weak, nonatomic) IBOutlet UIButton *btnDelete;

@property (nonatomic, strong) UIImage *uploadedImage;
@property (nonatomic, strong) NSMutableArray *arrayCachedImage;
@end

@implementation UploadSourceViewController
@synthesize typeID, typeName, nsrsbh;
@synthesize uploadedImage, arrayCachedImage;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NeedOffsetWhenIOS7NavBar
    self.hidesBottomBarWhenPushed = TRUE;
    
    self.gridCached.allowsSelection = TRUE;
    self.gridCached.allowsMultipleSelection = TRUE;
    
    arrayCachedImage = [[NSMutableArray alloc] initWithCapacity:MAX_CACHE];
    
    [self searchCachedImage];
    [self refreshLimitation];
    
    //测试代码
    self.nsrsbh = @"131025755471767";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
//相册
- (IBAction)onAlbum:(id)sender {
    [self onCancel:nil];

    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
    {
        UIImagePickerController *picker =
        [[UIImagePickerController alloc] init];
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        picker.allowsEditing = TRUE;
        picker.mediaTypes = @[(NSString*)kUTTypeImage];
        picker.delegate = self;
        [self presentViewController:picker animated:YES completion:nil];
    }
}
//拍照
- (IBAction)onTakePhoto:(id)sender {
    [self onCancel:nil];
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *picker =
        [[UIImagePickerController alloc] init];
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        picker.allowsEditing = TRUE;
//        picker.showsCameraControls = TRUE;
        picker.mediaTypes = @[(NSString*)kUTTypeImage];
        picker.delegate = self;
        [self presentViewController:picker animated:YES completion:nil];
    }
}
//删除选中
- (IBAction)onDelete:(id)sender {
    NSArray *indexPathes = [self.gridCached indexPathsForSelectedItems];

    NSMutableIndexSet *indexSet = [[NSMutableIndexSet alloc] init];
    for (NSIndexPath *ip in indexPathes)
    {
        [indexSet addIndex:ip.row];
        CachedImageItem *item =self.arrayCachedImage[ip.row];
        [[NSFileManager defaultManager] removeItemAtPath:item.path error:nil];
    }
    [self.arrayCachedImage removeObjectsAtIndexes:indexSet];
    [self.gridCached deleteItemsAtIndexPaths:indexPathes];
    [self posDeleteBar];
    [self refreshLimitation];
}
//取消选中
- (IBAction)onCancel:(id)sender {
    NSArray *indexPathes = [self.gridCached indexPathsForSelectedItems];
    
    for (NSIndexPath *ip in indexPathes)
    {
        [self.gridCached deselectItemAtIndexPath:ip animated:TRUE];
        UIView *btn = [[self.gridCached cellForItemAtIndexPath:ip] viewWithTag:101];
        btn.hidden = TRUE;
    }
    [self posDeleteBar];
}

//更新 上传数提示
-(void) refreshLimitation
{
    self.labUploaded.text = [NSString stringWithFormat:@"已上传   最大上传%d张,已上传%d张", MAX_CACHE, self.arrayCachedImage.count];
    self.btnAlbum.enabled
    = self.btnCamera.enabled
    = (self.arrayCachedImage.count < MAX_CACHE);
}
//查找本地图片
-(void) searchCachedImage
{
    NSString *path = [self cachePath];
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    NSArray *result = [fileManager contentsOfDirectoryAtPath:path error:nil];
    if (result)
    {
        for (NSString *file in result)
        {
            NSDictionary *attri = [fileManager attributesOfItemAtPath:[path stringByAppendingPathComponent:file] error:nil];
            NSString *type = [attri fileType];
            if ([type isEqualToString:NSFileTypeRegular])
            {
                CachedImageItem *item = [[CachedImageItem alloc] init];
                item.path = [path stringByAppendingPathComponent:file];
                [self.arrayCachedImage addObject:item];
            }
        }
        [self.gridCached reloadData];
    }
}
//上传图片
-(void)  doUploadImage:(UIImage*) image
{
    ASIFormDataRequest * request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:HB_HTTP_URL]];
    request.requestMethod = @"POST";
    [request addRequestHeader:@"TradeId" value:@"APP.FBZL.SCZLK"];
    [request addRequestHeader:@"MessageType" value:@"JSON-HTTP"];
    [request addRequestHeader:@"ChannelId" value:@"HB_APP"];
    [request addRequestHeader:@"Controls" value:@"crypt,DES;code,BASE64;"];
    
    NSData * imageData = UIImagePNGRepresentation(image);
    NSString *base64 = [ASIHTTPRequest base64forData:imageData];
   
    NSString *body = [NSString stringWithFormat:@"{\"nsrsbh\":\"%@\",\"swsx_dl_dm\":\"%@\",\"fbzlmc\":\"%@\",\"fbzldata\":\"%@\"}", self.nsrsbh, self.typeID, self.typeName, base64];
    NSData *bodyData = [body dataUsingEncoding:NSUTF8StringEncoding];
    NSData *bodyEncode = [UserInfo DESEncrypt:bodyData WithKey:DES_KEY];
    [request appendPostString: [ASIHTTPRequest base64forData:bodyEncode]];
//    NSLog(@"%@", [ASIHTTPRequest base64forData:bodyEncode]);
    
    request.delegate = self;
    [request startAsynchronous];
}
//保存图片至本地
-(void) saveToCache:(UIImage*) image
{
    NSString *cachePath = [self cachePath];
    NSString *cacheFile = [cachePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png",[NSDate date]]];
    
    NSData *data = UIImagePNGRepresentation(image);
    if ([data writeToFile:cacheFile atomically:YES])
    {
        CachedImageItem *item = [[CachedImageItem alloc] init];
        item.path = cacheFile;
        item.image = image;
        [self.arrayCachedImage insertObject:item atIndex:0];
        [self refreshLimitation];
        [self.gridCached reloadData];
    }
}
//本地保存路径
-(NSString*) cachePath
{
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    NSArray *urls = [fileManager URLsForDirectory:NSCachesDirectory
                                        inDomains:NSUserDomainMask];
    if ([urls count] > 0)
    {
        NSURL *cachesFolder = urls[0];
        NSString *cacheDirectory = [[cachesFolder path] stringByAppendingPathComponent: [self.typeID stringValue]];

        BOOL isDirectory = NO;
        BOOL mustCreate = NO;
        if ([fileManager fileExistsAtPath:cacheDirectory isDirectory:&isDirectory])
        {
            if (isDirectory == NO)
                 mustCreate = YES;
        }
        else
        {
            mustCreate = YES;
        }
    
        if (mustCreate)
        {
            NSError *directoryCreationError = nil;
            if ([fileManager createDirectoryAtPath:cacheDirectory withIntermediateDirectories:YES attributes:nil error:&directoryCreationError])
            {
                return cacheDirectory;
            }
            else
            {
                    NSLog(@"Failed to create the folder with error = %@", cacheDirectory);
            }
        }
        else
            return cacheDirectory;
        
        NSLog(@"%@", cachesFolder);
    }
    
    return nil;
}

#pragma mark - ASIFormDataRequestDelegate
- (void)requestFailed:(ASIHTTPRequest *)theRequest
{
//	NSLog(@"%@", [NSString stringWithFormat:@"Request failed:\r\n%@",[[theRequest error] localizedDescription]]);
    [ZAActivityBar showWithStatus:@"上传失败" image:nil duration:2 forAction:@""];
}

- (void)requestFinished:(ASIHTTPRequest *)theRequest
{
//    NSLog(@"%s:%s:%@",__FILE__,  __FUNCTION__, theRequest.responseString);
    NSString *responseString = theRequest.responseString;
    NSDictionary *jsonObj = [responseString objectFromJSONString];
    if ([jsonObj isKindOfClass:[NSDictionary class]])
     {
         NSString *codeValue = jsonObj[@"code"];
         if ([@"0000" isEqualToString:codeValue])
         {
             [self saveToCache:self.uploadedImage];
         }
     }
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    self.uploadedImage = info[UIImagePickerControllerEditedImage];
    if (nil == self.uploadedImage)
        self.uploadedImage = info[UIImagePickerControllerOriginalImage];
    [picker dismissViewControllerAnimated:TRUE completion:nil];
    
    if (self.uploadedImage)
    {
        [self doUploadImage:self.uploadedImage];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:TRUE completion:nil];
}

#pragma mark - 图片压缩
- (UIImage*)imageWithImage:(UIImage *)sourceImage scaledToWidth:(float) i_width
{
    float oldWidth = sourceImage.size.width;
    float scaleFactor = i_width / oldWidth;
    
    float newHeight = sourceImage.size.height * scaleFactor;
    float newWidth = oldWidth * scaleFactor;
    
    UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight));
    [sourceImage drawInRect:CGRectMake(0, 0, newWidth, newHeight)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

#pragma mark - UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
//    //测试代码
//    return 10;
    
    return self.arrayCachedImage.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"indexPathsForSelectedItems:%@", [collectionView indexPathsForSelectedItems]);
    static NSString *cellID = @"CachedImageGridCellID";
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    
//    //测试代码
//    cell.backgroundColor = [UIColor redColor];
//    return cell;
    
    CachedImageItem *item =(CachedImageItem*)self.arrayCachedImage[indexPath.row];
    if (item.image == nil)
    {
        item.image = [[UIImage alloc] initWithContentsOfFile:item.path];
    }
    
    cell.backgroundColor = [UIColor clearColor];
    UIImageView *iv = (UIImageView*)[cell viewWithTag:100];
    iv.image = item.image;
    iv.contentMode = UIViewContentModeScaleAspectFit;
    
    UIButton *btn = (UIButton*)[cell viewWithTag:101];
    btn.hidden = TRUE;
//    [btn addTarget:self action:@selector(onDelete:) forControlEvents:(UIControlEventTouchUpInside)];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
//    NSLog(@"%s:%@", __FUNCTION__, indexPath);
//    NSLog(@"indexPathsForSelectedItems:%@", [collectionView indexPathsForSelectedItems]);
    UIView *btn = [[collectionView cellForItemAtIndexPath:indexPath] viewWithTag:101];
    btn.hidden = FALSE;
    [self posDeleteBar];
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
//    NSLog(@"%s:%@", __FUNCTION__, indexPath);
//    NSLog(@"indexPathsForSelectedItems:%@", [collectionView indexPathsForSelectedItems]);
    UIView *btn = [[collectionView cellForItemAtIndexPath:indexPath] viewWithTag:101];
    btn.hidden = TRUE;
    [self posDeleteBar];
}

//show/hide DELETE bar
-(void) posDeleteBar
{
    int sel = [self.gridCached indexPathsForSelectedItems].count;
    if (sel > 0)
    {
        [self.btnDelete setTitle:[NSString stringWithFormat:@"删除(%d)", sel] forState:(UIControlStateNormal)];
    }
    self.deleteContainer.hidden = (sel == 0);
}

@end
