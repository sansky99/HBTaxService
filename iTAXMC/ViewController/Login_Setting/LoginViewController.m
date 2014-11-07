//
//  LoginViewController.m
//  XJTaxTrain
//
//  Created by khuang on 14-7-7.
//  Copyright (c) 2014年 servyou. All rights reserved.
//

#import "LoginViewController.h"
#import <CommonCrypto/CommonDigest.h>
#import "UserInfo.h"

#import "ServyouDefines.h"
#import "ZAActivityBar.h"
#import "ASIFormDataRequest.h"
#import "JSONKit.h"
#import "MyActivityIndicatorView.h"
#import "SevryouChannelCenter.h"
static const int MAX_LEN = 30;

#define login_alert_errortag 20011

@interface LoginViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIButton *btnForget;
@property (nonatomic, strong) MyActivityIndicatorView *activityIndicatorView;
@end

@implementation LoginViewController
@synthesize rectContainerView, activityIndicatorView;
@synthesize moduleID, moduleViewC;

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
    
    self.txtID.leftViewMode = UITextFieldViewModeAlways;
    self.txtID.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"leftUser"]];
    self.txtID.text = [ServyouDefines sharedUserInfo].userID;

    self.txtPassword.leftViewMode = UITextFieldViewModeAlways;
    self.txtPassword.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"leftPassword" ]];
//    self.txtPassword.leftView.frame = CGRectMake(5, 0, self.txtPassword.bounds.size.height, self.txtPassword.bounds.size.height);

    self.txtID.delegate = self;
    self.txtPassword.delegate = self;
    
    activityIndicatorView = [[MyActivityIndicatorView alloc] initWithParentView:self.view];
    
    [self initForgetBtn];
    //测试代码
//    self.txtID.text = @"65900173837720X";           //222.82.214.195:7003
//    self.txtID.text = @"440307766382735";         //192.168.110.178,  pwd:123456
}

- (void)initForgetBtn
{
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"忘记密码？"];
    NSRange strRange = {0,[str length]-1};
    [str addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:strRange];
    [self.btnForget setAttributedTitle:str forState:UIControlStateNormal];
}

-(void) viewWillAppear:(BOOL)animated
{
    self.navigationItem.leftBarButtonItem = [self getBarButtonItemWithTitle:@"返回"
                                                                        sel:@selector(didBackItem:)];
    self.navigationItem.rightBarButtonItem = [self getBarButtonItemWithTitle:@"注册"
                                                                         sel:@selector(didRegister:)];
}


-(void) viewWillDisappear:(BOOL)animated
{
 	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
 	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIBarButtonItem *)getBarButtonItemWithTitle:(NSString *)aTitle sel:(SEL)aSel
{
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithTitle:aTitle
                                                                style:UIBarButtonItemStyleBordered
                                                               target:self
                                                               action:aSel];
    return barItem;
}


- (void)authParseWithDict:(NSDictionary *)aDict
{
    UserInfo *userInfo = [ServyouDefines sharedUserInfo];
    userInfo.userID = self.txtID.text;
    userInfo.password = self.txtPassword.text;
    userInfo.groupName = [aDict valueForKey:@"groupName"];
    userInfo.groupID = [aDict valueForKey:@"groupId"];
    userInfo.key = [aDict valueForKey:@"key"];
    [userInfo save];
}

- (IBAction)onForget:(id)sender
{
//    ForgetPasswordViewController *forgetPassword = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([ForgetPasswordViewController class])];
//    [self.navigationController pushViewController:forgetPassword animated:YES];
}

- (IBAction)didBackItem:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)didRegister:(id)sender
{
//    UIStoryboard *storyBoard = self.storyboard;
//    RegisterViewController *registerView = [storyBoard instantiateViewControllerWithIdentifier:NSStringFromClass([RegisterViewController class])];
//    [self.navigationController pushViewController:registerView animated:YES];
}

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
        [ZAActivityBar showWithStatus:@"请输入密码" image:nil duration:2 forAction:@""];
        return;
    }

    NSString *urlString = [[NSString alloc] initWithFormat:@"%@%@",SERVER_ACCOUNT,SERVER_ACCOUNTLOGIN_URL ];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:urlString]];
    [request setPostValue:self.txtID.text forKey:@"account"];
    [request setPostValue:self.txtPassword.text/*[self md5: self.txtPassword.text]*/ forKey:@"password"];
    [request setPostValue:@"1" forKey:@"type"];
    [request setPostValue:@"STJRIOS" forKey:@"channelId"];
//    [request setPostValue:self.txtPassword.text forKey:@"password"];
#if 0
#ifdef _TEST_ENV_                //测试环境
    [request setPostValue:@0 forKey:@"encrypt"];
#else
    [request setPostValue:@1 forKey:@"encrypt"];
#endif
#endif
    request.delegate = self;
    [request startAsynchronous];
    activityIndicatorView.hidden = FALSE;
    [activityIndicatorView startAnimating];
}

- (void)requestFailed:(ASIHTTPRequest *)theRequest
{
    activityIndicatorView.hidden = TRUE;
	NSLog(@"%@", [NSString stringWithFormat:@"Request failed:\r\n%@",[[theRequest error] localizedDescription]]);
    [ZAActivityBar showWithStatus:Public_HttpRequest_Error image:nil duration:2 forAction:@""];
}

- (void)requestFinished:(ASIHTTPRequest *)theRequest
{
    
    activityIndicatorView.hidden = TRUE;
    NSLog(@"%@", theRequest.responseString);
    NSDictionary *result = [theRequest.responseString objectFromJSONString];
    NSString *code = [[result objectForKey:@"head"] objectForKey:@"code"];
    NSLog(@"MSG is %@",[[result objectForKey:@"head"] objectForKey:@"msg"]);
    if ([ServyouDefines isServerResultSuccessed:result])
    {
        NSObject *body = [result objectForKey:@"body"];
    
        if ([body isKindOfClass:[NSDictionary class]])
        {
            id appAuthItems = [body valueForKey:@"appAuth"];
            if ([appAuthItems isKindOfClass:[NSArray class]])
            {
                appAuthItems = (NSArray *)appAuthItems;
                for ( NSDictionary *appAuthDict in appAuthItems)
                {
                    [self authParseWithDict:appAuthDict];
                }
            }
            //保存用户信息
            [self saveUserInfo:(NSDictionary *)body];
            
#if 0
            NSMutableArray *items = [[NSMutableArray alloc] init];
            [items addObject:userInfo.userID];
            id data = [body valueForKey:@"tag"];
            if ([data isKindOfClass:[NSArray class]]||[data isKindOfClass:[NSMutableArray class]])
            {
                [items addObjectsFromArray:data];
            }
            else if ([data isKindOfClass:[NSString class]]
                     ||[data isKindOfClass:[NSMutableString class]])
            {
                [items addObject:data];
            }
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"kLoginSuccess" object:@{@"kLoginTag":items}];
#endif
            
            //登录成功后 渠道数据下载
            [self sendChannelCenterForLoginSuccess];

            
            //转至需登录的模块
            if (self.moduleViewC && [self.moduleID intValue] > 0)
            {
                [self dismissViewControllerAnimated:TRUE completion:nil];
                [self.moduleViewC switchModuleView:self.moduleID];
                
            }
            else
            {
//                UIViewController *u1 =self.presentingViewController;
//                [u1.presentingViewController dismissViewControllerAnimated:TRUE completion:nil];
                [self didBackItem:nil];
            }
        }
    }
    //网厅登陆失败
    else if ([code isEqualToString:@"80411127"])
    {
        UserInfo *userInfo = [ServyouDefines sharedUserInfo];
        userInfo.userID = self.txtID.text;
        [userInfo save];
        [self showAlertViewWithTag:login_alert_errortag msg:@"登陆失败，请进行二次验证。"];
    }
    else
    {
        [ZAActivityBar showWithStatus:@"账号或密码错误，请重新录入！" image:nil duration:2 forAction:@""];
        self.txtPassword.text = @"";
        [self.txtPassword performSelector:@selector(becomeFirstResponder) withObject:nil afterDelay:1.9];
    }
}

- (IBAction)onSwipeGesture:(id)sender {
    [self dismissViewControllerAnimated:TRUE completion:nil];
}

//保存key
- (void)saveUserInfo:(NSDictionary *)body
{
    NSArray *xxdyList = [body objectForKey:@"xxdyList"];
    NSString *nsrsbh = StringEmpty;
    for (NSDictionary *xxdyDict in xxdyList)
    {
        nsrsbh = [xxdyDict objectForKey:@"nsrsbh"];
    }
    
    UserInfo *userInfo = [ServyouDefines sharedUserInfo];
    userInfo.userID = self.txtID.text;
    userInfo.password = self.txtPassword.text;
    userInfo.key = [body objectForKey:@"key"];
    userInfo.token = [body objectForKey:@"token"];
    userInfo.nsrsbhStr = nsrsbh;
    userInfo.loginStatus = @"YES";
    [userInfo save];
}

- (void)showAlertViewWithTag:(NSInteger)tag msg:(NSString *)msg
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:StringEmpty
                                                    message:msg
                                                   delegate:self
                                          cancelButtonTitle:@"取消"
                                          otherButtonTitles:@"确定", nil];
    alert.tag = tag;
    [alert show];
}

- (void)showSecondLogin
{
//    SecondLoginViewController *login = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([SecondLoginViewController class])];
//    login.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
//    [login showLoginInViewController:self.parentViewController];
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

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSMutableString *newtxt = [NSMutableString stringWithString:textField.text];

    [newtxt replaceCharactersInRange:range withString:string];

    return ([newtxt length] <= MAX_LEN);
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == login_alert_errortag)
    {
        //点击确定
        if (buttonIndex == 1)
        {
            [self showSecondLogin];
        }
    }
    [alertView dismissWithClickedButtonIndex:buttonIndex animated:YES];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - Keyboard
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (void) handleKeyboardWillShow:(NSNotification *)paramNotification
{
	NSDictionary *userInfo = paramNotification.userInfo;
	
	NSValue *valueEnd = userInfo[UIKeyboardFrameEndUserInfoKey];
	CGRect rtEnd = CGRectMake(0,0,0,0);
	[valueEnd getValue:&rtEnd];
    
    self.rectContainerView = self.containerView.frame;
    self.containerView.frame = CGRectMake(self.rectContainerView.origin.x, self.rectContainerView.origin.y - rtEnd.size.height/2, self.rectContainerView.size.width, self.rectContainerView.size.height);
}

- (void) handleKeyboardWillHide:(NSNotification *)paramNotification
{
    self.containerView.frame = self.rectContainerView;
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
