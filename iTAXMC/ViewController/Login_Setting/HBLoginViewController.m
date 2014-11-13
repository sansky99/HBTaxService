//
//  HBLoginViewController.m
//  XJTaxTrain
//
//  Created by khuang on 14-7-7.
//  Copyright (c) 2014年 servyou. All rights reserved.
//

#import "HBLoginViewController.h"
#import <CommonCrypto/CommonDigest.h>
#import "UserInfo.h"
#import "CompatibleaPrintf.h"
#import "ServyouDefines.h"
#import "ZAActivityBar.h"
#import "ASIFormDataRequest.h"
#import "JSONKit.h"
#import "MyActivityIndicatorView.h"
#import "SevryouChannelCenter.h"
static const int MAX_LEN = 30;

#define login_alert_errortag 20011

enum VerifyStep{
    VS_GetPhones
,   VS_GetPwd
,   VS_Login
};


@implementation PhoneInfo
@synthesize ID, name;
@end



@interface HBLoginViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIButton *btnUser;
@property (weak, nonatomic) IBOutlet UIView *viewBottom;

@property (nonatomic, strong) MyActivityIndicatorView *activityIndicatorView;
@property (nonatomic, strong) NSMutableArray *infoPhones;
@property (nonatomic, strong) NSMutableArray *btnPhones;
@property (nonatomic) enum VerifyStep    step;
@end

@implementation HBLoginViewController
@synthesize rectContainerView, activityIndicatorView;
@synthesize moduleID, moduleViewC, infoPhones, btnPhones, step;

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
    
    NeedOffsetWhenIOS7NavBar

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navBack"] style:UIBarButtonItemStylePlain target:self action:@selector(onBack)];

//    self.txtID.text = [ServyouDefines sharedUserInfo].userID;

    self.txtID.delegate = self;
    self.txtPassword.delegate = self;
    
    activityIndicatorView = [[MyActivityIndicatorView alloc] initWithParentView:self.view];
    
    infoPhones = [[NSMutableArray alloc] initWithCapacity:5];
    btnPhones = [[NSMutableArray alloc] initWithCapacity:5];
    
    self.viewBottom.hidden = TRUE;
    [self.txtID becomeFirstResponder];
    
//    //测试代码
//    self.txtID.text = @"131025755471767";
//    self.txtPassword.text = @"183163";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) onBack
{
    [self.view endEditing:TRUE];
    [self dismissViewControllerAnimated:TRUE completion:nil];
}

//- (void)authParseWithDict:(NSDictionary *)aDict
//{
//    UserInfo *userInfo = [ServyouDefines sharedUserInfo];
//    userInfo.userID = self.txtID.text;
//    userInfo.password = self.txtPassword.text;
//    userInfo.userName = [aDict valueForKey:@"groupName"];
//    userInfo.groupID = [aDict valueForKey:@"groupId"];
//    userInfo.key = [aDict valueForKey:@"key"];
//    [userInfo save];
//}

//获取用户手机号
- (IBAction)onUser:(id)sender {
    [self.txtID resignFirstResponder];
    self.txtID.text = [self.txtID.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

    if (self.txtID.text.length == 0)
    {
        [ZAActivityBar showWithStatus:@"请输入纳税人识别号" image:nil duration:1.5 forAction:@""];
        [self.txtID performSelector:@selector(becomeFirstResponder) withObject:nil afterDelay:1.5];
        return;
    }

    
    ASIFormDataRequest * request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:HB_HTTP_URL]];
    request.requestMethod = @"POST";
    [request addRequestHeader:@"TradeId" value:@"APP.LOGIN.LXRXX"];
    [request addRequestHeader:@"MessageType" value:@"JSON-HTTP"];
    [request addRequestHeader:@"ChannelId" value:@"HB_APP"];
    [request addRequestHeader:@"Controls" value:@"crypt,DES;code,BASE64;"];
    
    NSString *body = [NSString stringWithFormat:@"{\"nsrsbh\":\"%@\"}", self.txtID.text];
    NSData *bodyData = [body dataUsingEncoding:NSUTF8StringEncoding];
    NSData *bodyEncode = [UserInfo DESEncrypt:bodyData WithKey:DES_KEY];
    [request appendPostString: [ASIHTTPRequest base64forData:bodyEncode]];
    //    NSLog(@"%@", [ASIHTTPRequest base64forData:bodyEncode]);
    
    request.delegate = self;
    self.step = VS_GetPhones;
    [request startAsynchronous];
}

//获取验证码
- (IBAction)onGetPwd:(id)sender {
    int i=0;
    for (UIButton *btn  in self.btnPhones)
    {
        if (btn.selected)
        {
            PhoneInfo *pi = self.infoPhones[i];
            
            ASIFormDataRequest * request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:HB_HTTP_URL]];
            request.requestMethod = @"POST";
            [request addRequestHeader:@"TradeId" value:@"APP.LOGIN.YZMFS"];
            [request addRequestHeader:@"MessageType" value:@"JSON-HTTP"];
            [request addRequestHeader:@"ChannelId" value:@"HB_APP"];
            [request addRequestHeader:@"Controls" value:@"crypt,DES;code,BASE64;"];
            
            NSString *body = [NSString stringWithFormat:@"{\"nsrsbh\":\"%@\", \"dlrsf\":\"%@\"}", self.txtID.text, pi.ID];
            NSData *bodyData = [body dataUsingEncoding:NSUTF8StringEncoding];
            NSData *bodyEncode = [UserInfo DESEncrypt:bodyData WithKey:DES_KEY];
            [request appendPostString: [ASIHTTPRequest base64forData:bodyEncode]];
//          NSLog(@"%@", [ASIHTTPRequest base64forData:bodyEncode]);
            
            request.delegate = self;
            self.step = VS_GetPwd;
            [request startAsynchronous];
            break;
        }
        i++;
    }
}

//登录
- (IBAction)onLogin:(id)sender {
    [self.txtPassword resignFirstResponder];
    [self.txtID resignFirstResponder];
    
    self.txtID.text = [self.txtID.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    self.txtPassword.text = [self.txtPassword.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
   if (self.txtID.text.length == 0)
   {
       [ZAActivityBar showWithStatus:@"请输入纳税人识别号" image:nil duration:2 forAction:@""];
       return;
   }
    if (self.txtPassword.text.length == 0)
    {
        [ZAActivityBar showWithStatus:@"请输入验证码" image:nil duration:2 forAction:@""];
        return;
    }

    int i=0;
    PhoneInfo *pi = nil;
    for (UIButton *btn  in self.btnPhones)
    {
        if (btn.selected)
        {
            pi = self.infoPhones[i];
            break;
        }
        i++;
    }

    ASIFormDataRequest * request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:HB_HTTP_URL]];
    request.requestMethod = @"POST";
    [request addRequestHeader:@"TradeId" value:@"APP.LOGIN.SFYZ"];
    [request addRequestHeader:@"MessageType" value:@"JSON-HTTP"];
    [request addRequestHeader:@"ChannelId" value:@"HB_APP"];
    [request addRequestHeader:@"Controls" value:@"crypt,DES;code,BASE64;"];
    
    NSString *body = [NSString stringWithFormat:@"{\"nsrsbh\":\"%@\", \"dlrsf\":\"%@\", \"sjyzm\":\"%@\"}", self.txtID.text, pi.ID, self.txtPassword.text];
    NSData *bodyData = [body dataUsingEncoding:NSUTF8StringEncoding];
    NSData *bodyEncode = [UserInfo DESEncrypt:bodyData WithKey:DES_KEY];
    [request appendPostString: [ASIHTTPRequest base64forData:bodyEncode]];
//  NSLog(@"%@", [ASIHTTPRequest base64forData:bodyEncode]);
    
    request.delegate = self;
    self.step = VS_Login;
    [request startAsynchronous];
}

#pragma mark - ASIFormDataRequestDelegate
- (void)requestFailed:(ASIHTTPRequest *)theRequest
{
    activityIndicatorView.hidden = TRUE;
	NSLog(@"%@", [NSString stringWithFormat:@"Request failed:\r\n%@",[[theRequest error] localizedDescription]]);
    [ZAActivityBar showWithStatus:Public_HttpRequest_Error image:nil duration:2 forAction:@""];
}

- (void)requestFinished:(ASIHTTPRequest *)theRequest
{
    activityIndicatorView.hidden = TRUE;

    theRequest.responseEncoding = NSUTF8StringEncoding;
    NSLog(@"%@", theRequest.responseString);
    NSDictionary *result = [theRequest.responseString objectFromJSONString];
    NSDictionary *context = [[result objectForKey:@"context"] objectFromJSONString];
    NSNumber *success = [context objectForKey:@"success"];
    if ([success boolValue])
    {
        if (VS_GetPhones == self.step)
        {
            [self.infoPhones removeAllObjects];
            NSArray *data =  [context objectForKey:@"data"];
            if (data.count == 0)
            {
                [ZAActivityBar showWithStatus:@"未获取到您的联系人手机,请联系税局维护您的联系方式!" image:nil duration:1.5 forAction:@""];
                [self.txtID performSelector:@selector(becomeFirstResponder) withObject:nil afterDelay:1.5];
            }
            else
            {
                for (NSDictionary *item in data)
                {
                    PhoneInfo *pi = [[PhoneInfo alloc] init];
                    pi.ID = [item objectForKey:@"id"];
                    pi.name = [item objectForKey:@"text"];
                    [self.infoPhones addObject:pi];
                 }
                
                [self updatePhones];
                self.viewBottom.hidden = FALSE;
            }
        }
        else if (VS_GetPwd == self.step)
        {

        }
        else if (VS_Login == self.step)
        {
            NSDictionary *data =  [context objectForKey:@"data"];
            NSString *nsrmc = data[@"nsrmc"];
            NSString *nsrsbh = data[@"nsrsbh"];
            NSString *swjgMc = data[@"swjgMc"];
            UserInfo *ui = [ServyouDefines sharedUserInfo];
            ui.orgName = swjgMc;
            ui.userID = nsrsbh;
            ui.userName = nsrmc;
            [ui save];
            
            [self onBack];
        }
//            //登录成功后 渠道数据下载
//            [self sendChannelCenterForLoginSuccess];
//
//            
//            //转至需登录的模块
//            if (self.moduleViewC && [self.moduleID intValue] > 0)
//            {
//                [self dismissViewControllerAnimated:TRUE completion:nil];
//                [self.moduleViewC switchModuleView:self.moduleID];
//                
//            }
//            else
//            {
////                UIViewController *u1 =self.presentingViewController;
////                [u1.presentingViewController dismissViewControllerAnimated:TRUE completion:nil];
////                [self didBackItem:nil];
//            }
     
    }
    else
    {
        NSString *msg = [context objectForKey:@"message"];
        if (msg)
            [ZAActivityBar showWithStatus:msg image:nil duration:2 forAction:@""];
    }

}

- (IBAction)onSwipeGesture:(id)sender {
    [self onBack];
}

//显示手机号
-(void) updatePhones
{
    for (int i=self.btnPhones.count; i>self.infoPhones.count; i--)
    {
        [self.btnPhones[i-1] removeFromSuperview];
    }
    for (int i=0; i<self.btnPhones.count; i++)
    {
        [self.viewBottom addSubview:self.btnPhones[i]];
    }
    for (int i=self.btnPhones.count; i<self.infoPhones.count; i++)
    {
        UIButton *btn = [UIButton  buttonWithType:UIButtonTypeCustom];
        btn.backgroundColor = [UIColor whiteColor];
        btn.titleLabel.font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
        btn.layer.borderWidth = 1;
        btn.layer.borderColor = [UIColor blackColor].CGColor;
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [btn setImage:[UIImage imageNamed:@"check_normal"] forState:(UIControlStateNormal)];
        [btn setImage:[UIImage imageNamed:@"check_checked"] forState:(UIControlStateSelected)];
        [btn setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
//        [btn setTitleColor:[UIColor blueColor] forState:(UIControlStateSelected)];
        [btn addTarget:self action:@selector(onSelPhone:) forControlEvents:(UIControlEventTouchUpInside)];
        [self.btnPhones addObject:btn];
        [self.viewBottom addSubview:btn];
    }

    int i = 0;
    for (UIButton *btn in self.btnPhones)
    {
        btn.selected = (i==0);
        btn.frame = CGRectMake(20, 10 + i*35, 280, 30);
        PhoneInfo * pi = self.infoPhones[i++];
        [btn setTitle:pi.name forState:UIControlStateNormal];
        [btn setTitle:pi.name forState:UIControlStateSelected];

    }
}

-(void) onSelPhone:(UIButton*) btn
{
    if (!btn.selected)
    {
        for (UIButton *item in self.btnPhones) {
            item.selected = FALSE;
        }
        btn.selected = TRUE;
    }
}

////保存key
//- (void)saveUserInfo:(NSDictionary *)body
//{
//    NSArray *xxdyList = [body objectForKey:@"xxdyList"];
//    NSString *nsrsbh = StringEmpty;
//    for (NSDictionary *xxdyDict in xxdyList)
//    {
//        nsrsbh = [xxdyDict objectForKey:@"nsrsbh"];
//    }
//    
//    UserInfo *userInfo = [ServyouDefines sharedUserInfo];
//    userInfo.userID = self.txtID.text;
//    userInfo.password = self.txtPassword.text;
//    userInfo.key = [body objectForKey:@"key"];
//    userInfo.token = [body objectForKey:@"token"];
//    userInfo.nsrsbhStr = nsrsbh;
//    userInfo.loginStatus = @"YES";
//    [userInfo save];
//}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSMutableString *newtxt = [NSMutableString stringWithString:textField.text];

    [newtxt replaceCharactersInRange:range withString:string];

    return ([newtxt length] <= MAX_LEN);
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField == self.txtPassword)
    {
        CGRect rt = self.view.bounds;
        self.view.bounds = CGRectMake(0, 200, rt.size.width, rt.size.height);
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == self.txtPassword)
    {
        CGRect rt = self.view.bounds;
        self.view.bounds = CGRectMake(0, 0, rt.size.width, rt.size.height);
    }
}

#pragma mark - MD5
- (NSString *)md5:(NSString *)str
{
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, strlen(cStr), result); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ]; 
}

#pragma mark - 渠道中心登录成功后数据请求
- (void)sendChannelCenterForLoginSuccess
{
    ServyouAppDelegate *appDelegate = (ServyouAppDelegate *)[UIApplication sharedApplication].delegate;
    SevryouChannelCenter *channelCenter = appDelegate.channelCenter = [[SevryouChannelCenter alloc] init];
    [channelCenter sendChannelCenterHttpRequest];
}

@end
