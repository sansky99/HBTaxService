//
//  HBMainViewController.m
//  XJTaxTrain
//
//  Created by khuang on 14-7-7.
//  Copyright (c) 2014年 servyou. All rights reserved.
//

#import "HBMainViewController.h"
#import "SGFocusImageFrame.h"
#import "SGFocusImageItem.h"
#import "JSBadgeView.h"
#import "LatestNotificationEntity.h"
#import "MessageCenter.h"
#import "SevryouChannelCenter.h"//渠道中心
#import "ChannelCenterDo.h"
#include "CompatibleaPrintf.h"

#import "HBSettingViewController.h"
#import "RevealController.h"

#import "SVProgressHUD.h"

#import "ChannelDetailsViewController.h"

#import "JSONKit.h"
#import "ChannelCenterData.h"

#import "Login_Setting/HBLoginViewController.h"

#import "UploadTypeTableViewController.h"

@interface HBMainViewController ()<SGFocusImageFrameDelegate>
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIView *midView;
@property (strong, nonatomic) NSArray *items;
@property (strong, nonatomic) SGFocusImageFrame *focusImage;
@property (strong, nonatomic) HBSettingViewController *settingVC;

-(BOOL) reloadItems;
@end

@implementation HBMainViewController
@synthesize items, focusImage, settingVC;
@synthesize releaseInfo = _releaseInfo;

-(id) init
{
    if (self = [super init])
    {
        items = nil;
    }
    return self;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {}
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    center = [[SevryouChannelCenter alloc] init];
    
    if ([[ServyouDefines sharedUserInfo] isLogin])
    {
        [self kXGPushNotificationCenterAction:nil];
    }
    
     [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackTranslucent];

    CGRect   focusImageFrame = CGRectMake(0,0, self.view.frame.size.width, 160);
    self.navigationItem.title = @"河北国税";
    NeedOffsetWhenIOS7NavBar
    
    UIButton *loginButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 41, 39)];
    [loginButton addTarget:self action:@selector(onSetting:) forControlEvents:UIControlEventTouchUpInside];
    [loginButton setImage:[UIImage imageNamed:@"menu"] forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:loginButton];
    
    //滚动图片
    UIImage *img = [UIImage imageNamed:@"banner1.jpg"];
    SGFocusImageItem *item1 = [[SGFocusImageItem alloc] initWithTitle:@"" image:img tag:0];
    SGFocusImageItem *item2 = [[SGFocusImageItem alloc] initWithTitle:@"" image:[UIImage imageNamed:@"banner2.jpg"] tag:1];
    SGFocusImageItem *item3 = [[SGFocusImageItem alloc] initWithTitle:@"" image:[UIImage imageNamed:@"banner3.jpg"] tag:2];
    
    focusImage = [[SGFocusImageFrame alloc] initWithFrame:focusImageFrame delegate:self focusImageItems:item1, item2, item3,nil];
    [self reloadItems];
    [self.topView addSubview:focusImage];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onNewMessage:) name:kNewMessageNotification object:nil];
    [[MessageCenter sharedMessageCenter] refreshMessages];
    
    
    //渠道中心监听 NSString *const kChannelNotificationCenter =
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(kXGPushNotificationCenterAction:) name:@"kNewXGPushNotification" object:nil];
    
    //渠道中心监听 NSString *const kChannelNotificationCenter =
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(kXGPushNotificationCenterAction:) name:@"kChannelNotificationCenter" object:nil];
    
    
    //版本检测
    [self versionDetection];
}

#pragma mark - 版本检测
-(void)versionDetection{
    
    //获取当前的版本信息
    NSString * ver = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSLog(@"ver = %@",ver);
    
    //携带当前版本去匹配版本
    [self onCheckVersion:ver];
}

-(void)onCheckVersion:(NSString *)currentVersion{
    
    //http://itunes.apple.com/cn/lookup?id=918411012
    NSString * URL = @"http://itunes.apple.com/cn/lookup?id=932730597";
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:URL]];
    [request setHTTPMethod:@"POST"];
    
    NSHTTPURLResponse *urlResponse = nil;
    NSError * error = nil;
    
    NSData  * recervedData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
    
    NSString *results = [[NSString alloc] initWithBytes:[recervedData bytes] length:[recervedData length] encoding:NSUTF8StringEncoding];
    
    //    SBJsonParser *jsonParser = [[SBJsonParser alloc] init];
    NSDictionary *dic =  [results objectFromJSONString];
    //    NSDictionary *dic = [[jsonParser objectWithString:results] copy];
    
    if (dic.count == 0) {}else{
        NSArray * infoArray = [dic objectForKey:@"results"];
        
        if ([infoArray count]) {//932730597
            _releaseInfo = [infoArray objectAtIndex:0];
            NSString * lastVersion     = [_releaseInfo objectForKey:@"version"];//获取到AppStore上的版本信息
            
            //            newVerUrl = [_releaseInfo objectForKey:@"trackViewUrl"];//获取到更新链接，跳转到AppStore中
            if (![lastVersion isEqualToString:currentVersion]) {//如果版本信息不一致
                newVerUrl = [_releaseInfo objectForKey:@"trackViewUrl"];//获取到更新链接，跳转到AppStore中
                NSLog(@"~~~~~~~~~~newVerUrl = %@",newVerUrl);
                //[RunTimeShare setVersionUrl:newVerUrl];
                NSString * stringUpdate = [_releaseInfo objectForKey:@"releaseNotes"];
                if (!stringUpdate.length == 0) {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"发现新版本" message:stringUpdate delegate:self cancelButtonTitle:@"更新" otherButtonTitles:@"下次", nil];
                    [alert show];
                }else{
                    NSLog(@"为0");
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"更新" message:@"发现新版本" delegate:self cancelButtonTitle:@"更新" otherButtonTitles:@"下次", nil];
                    [alert show];
                }
            }
        }
    }
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex==0) {
        
        //处理去下载新版本的事情
        
        
        [self version];
    }
}

-(void)version{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:newVerUrl]];
}

-(void)kLogOutNotificationCenterAction:(NSNotification *)notification{
    UIButton *login = (UIButton*)self.navigationItem.rightBarButtonItem.customView;
    [login setImage:[UIImage imageNamed:@"user_logout"]  forState:UIControlStateNormal];
    
}

#pragma mark - 渠道中心刷新数据
-(void)kXGPushNotificationCenterAction:(NSNotification *)notification{
    
    NSLog(@"~~~~~~渠道中心刷新数据~~~~~~");
    
    
    ChannelCenterData *centerData = [[ChannelCenterData alloc] init];
    
    //读取数据
    [centerData loadData];
    
    //最新项
    tableArray = centerData.newestItems;
//    [self.tableView reloadData];
    
    //未读数
    tableArrayNumber = centerData.unReadItems;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self updateLoginStatus];
    //add by zgp  刷新列表
    if ([[ServyouDefines sharedUserInfo] isLogin])
    {
        ChannelCenterData *centerData = [[ChannelCenterData alloc] init];
        //读取数据
        [centerData loadData];
        
        tableArrayNumber = centerData.unReadItems;
//        [self.tableView reloadData];
    }
}

-(void) updateLoginStatus
{
    UIButton *login = (UIButton*)self.navigationItem.rightBarButtonItem.customView;
//    [login setImage:[UIImage imageNamed:@"user_logout"]  forState:UIControlStateNormal];
    if ([[ServyouDefines sharedUserInfo] isLogin])
    {
        [login setImage:[UIImage imageNamed:@"user_login"]  forState:UIControlStateNormal];
    }
    else
    {
        [login setImage:[UIImage imageNamed:@"user_logout"]  forState:UIControlStateNormal];
    }
}

-(void) onNewMessage: (NSDictionary*) userInfo
{
    [self reloadItems];
}

-(BOOL) reloadItems
{
    LatestNotificationEntity *entity = [[LatestNotificationEntity alloc] initWithFMDB: [ServyouDefines sharedDatabase]];
    
    NSString *orderBy = [NSString stringWithFormat: @" ORDER BY %@ DESC", [LatestNotificationEntity timestamp_Col]];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.items = [entity findAllWithOrderBy: orderBy];
//        [self.tableView reloadData];
    });
    
    return (self.items != nil);
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    [segue.destinationViewController setHidesBottomBarWhenPushed:YES];
}

#pragma mark - SGFocusImageFrameDelegate
- (void)foucusImageFrame:(SGFocusImageFrame *)imageFrame didSelectItem:(SGFocusImageItem *)item
{
    NSLog(@"%ld tapped", (long)item.tag);
}

-(void) onSetting :(id) sender
{
//    [[NSNotificationCenter defaultCenter] postNotificationName:kNotifySettingTouchUpInside object:self];
    
    UIViewController *vc =self.parentViewController;
    while (vc && ![vc isKindOfClass:[RevealController class]] ) {
        vc = vc.parentViewController;
    }

    HBSettingViewController *setting = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([HBSettingViewController class])];
    setting.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    vc.modalPresentationStyle = UIModalPresentationCurrentContext;
    [vc presentViewController:setting animated:TRUE completion:nil];
}


- (IBAction)onUpload:(id)sender {
    UploadTypeTableViewController *uploadTypes = [[UploadTypeTableViewController alloc] initWithStyle:(UITableViewStylePlain)];
    uploadTypes.hidesBottomBarWhenPushed = TRUE;
    [self.navigationController pushViewController:uploadTypes animated:TRUE];
}
@end
