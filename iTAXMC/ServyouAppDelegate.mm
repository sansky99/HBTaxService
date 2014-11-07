//
//  ServyouAppDelegate.m
//  XJTaxTrain
//
//  Created by khuang on 14-7-7.
//  Copyright (c) 2014年 servyou. All rights reserved.
//

#import "ServyouAppDelegate.h"
#import "MessageCenter/MessageCenter.h"

#import "XGPush.h"

#import "UMSocial.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialQQHandler.h"
#import "UMSocialTencentWeiboHandler.h"
#import "SevryouChannelCenter.h"
#include "CompatibleaPrintf.h"
#import "UIImage+Color.h"

#import "JSONKit.h"
#import "ASIFormDataRequest.h"
#import "RevealController.h"

#import "UserInfo.h"
#import "NSData+Encryption.h"
#import "ASIFormDataRequest.h"
#import <MobileCoreServices/UTCoreTypes.h>
#import "GTMBase64.h"
 static  NSString *DES_KEY = @"JDLSJDLS";

#define Update_Alert_Tag 200001

@implementation ServyouAppDelegate
@synthesize vc;
@synthesize channelCenter = _channelCenter;
@synthesize wtLoginUnable = _wtLoginUnable;

NSString *const kNewXGPushNotification = @"kNewXGPushNotification";
NSString *const KNowDateStringNotification = @"KNowDateStringNotification";


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
//    _channelCenter = [[SevryouChannelCenter alloc] init];
//    [self.channelCenter sendChannelCenterHttpRequest];
    
    [ServyouDefines sharedDatabase];
 
    [self setupNavgationAttributes];
    
    //信鸽推送
    [self zcXG:nil];
    
    //百度地图
    [self baiduMap];
    
    //[self tryLogin];
    
    //通知消息中心刷新
    [[MessageCenter sharedMessageCenter] refreshMessages];
    
    //显示启动图片3秒，留0.5s给LaunchImage
    [NSThread sleepForTimeInterval:1.5];
    
    [UMSocialData setAppKey:@"53bba91b56240b3d4603208a"];//友盟AppKey值
    
    [UMSocialQQHandler setSupportWebView:YES];//
    
    [UMSocialQQHandler setQQWithAppId:@"1101738021" appKey:@"zE6IdUvLgOJ0DXMg" url:@"http://www.baidu.com"];//QQ
    
    [UMSocialWechatHandler setWXAppId:@"wxc2491f3676b00c87" appSecret:@"63ded6e1c0d6fc299714b84ff14755f7" url:@"http://www.baidu.com"];
    
    [UMSocialTencentWeiboHandler openSSOWithRedirectUrl:@"http://sns.whalecloud.com/tencent2/callback"];

//    [[NSNotificationCenter defaultCenter] postNotificationName:@"kLoginSuccess" object:@{@"kLoginTag":[body valueForKey:@"tag"]}];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(zcXG:) name:@"kLoginSuccess" object:nil];
    self.wtLoginUnable = NO;
    return YES;
}

-(void)zcXG:(NSNotification*)notifications{
    NSLog(@"~~~+++~~+++~~~+++~~~+++~~~+++~~~+++");
   // [XGPush unRegisterDevice];

    //运行环境
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound)];
    
    //信鸽start
    [XGPush startApp:2200049523 appKey:@"IX9S9B37VX7J"];
    
    id data = [notifications.object objectForKey:@"kLoginTag"];
    
    if ([data isKindOfClass:[NSArray class]] || [data isKindOfClass:[NSMutableArray class]])
    {
        NSArray *items = (NSArray *)data;
        NSInteger row = 0;
        for (NSString *tag in items) {
            if (row == 0) {
                [XGPush setAccount:tag];
            }
            else{
                [self XgPush:tag];
            }
            row++;
        }
    }
    else if ([data isKindOfClass:[NSString class]] ||[data isKindOfClass:[NSMutableString class]])
    {
        NSString *tag = (NSString *)data;
        [self XgPush:tag];
    }
}


//add by hellen
#pragma mark- 样式
- (void) setupNavgationAttributes {
    UIColor *navigationTextColor = [UIColor whiteColor];
    
    [[UINavigationBar appearance] setTitleTextAttributes:@{
                                                           NSForegroundColorAttributeName : navigationTextColor
                                                           }];
    
    if (OSVersionIsAtLeastiOS7())
    {
        [[UINavigationBar appearance] setBarTintColor: [UIColor colorWithRed:20/255.f green:90/255.f blue:200/255.f alpha:1]];
        
        [[UINavigationBar appearance] setTintColor: [UIColor whiteColor]];
    }
    else
    {
        UIColor *color = [UIColor colorWithRed:20/255.f green:90/255.f blue:200/255.f alpha:1];
        CGFloat red, green, blue, alpha;
        [color getRed:&red green:&green blue:&blue alpha:&alpha];
        
        UIColor *calibratedColor = [UIColor colorWithRed:red green:green blue:blue alpha:0.66];
        UIImage *image =  [UIImage imageWithRect:CGRectMake(0, 0, 320, 44) color:calibratedColor];
        
        [[UINavigationBar appearance] setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    }
 

    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8];
    shadow.shadowOffset = CGSizeMake(0, 1);
    
    [[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                           [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0], NSForegroundColorAttributeName,
                                                           shadow, NSShadowAttributeName,
                                                           [UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:18.f], NSFontAttributeName, nil]];
}


#pragma mark - 百度地图
-(void)baiduMap{
    _mapManager = [[BMKMapManager alloc]init];
    // 如果要关注网络及授权验证事件，请设定     generalDelegate参数
    BOOL ret = [_mapManager start:@"TwoxIAlehkrYia2vEdWLDZrx" generalDelegate:self];
    if (!ret)
    {
        NSLog(@"启动成功!");
    }
}

-(void)onGetNetworkState:(int)iError
{
    if (iError == 0)
    {
        NSLog(@"网络连接正常");
    }
    else
    {
        NSLog(@"网络错误:%d",iError);
    }
}
-(void)onGetPermissionState:(int)iError
{
    if (iError == 0)
    {
        NSLog(@"授权成功");
    }
    else
    {
        NSLog(@"授权失败:%d",iError);
    }
}

#pragma mark - 信鸽推送
-(void)XgPush:(NSString *)tag{
    
    //设置账号
    NSLog(@"%@",tag);
    
    void (^tagsuccessBlock)(void) = ^(void){
        NSLog(@"~~~tag 设置成功");
    };
    
    void (^tagerrorBlock)(void) = ^(void){
        NSLog(@"~~~tag 设置失败");
    };
    
    //设置tag
    [XGPush setTag:tag successCallback:tagsuccessBlock errorCallback:tagerrorBlock];
}

//获取deviceToken
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    
    NSString *str = [NSString
                     stringWithFormat:@"Device Token=%@",deviceToken];
    NSLog(@"%@",str);
    //获取手机deviceToken
    NSString* deviceTokenStr = [XGPush getDeviceToken:deviceToken];
    
    
    //打印获取的deviceToken的字符串
    NSLog(@"deviceTokenStr is %@",deviceTokenStr);
    
    void (^successBlock)(void) = ^(void){
        //设备注册成功之后的处理
        NSLog(@"设备注册成功,deviceToken =%@",deviceTokenStr);

        
        void (^tagsuccessBlock)(void) = ^(void){
            NSLog(@"~~~tag 设置成功");
        };
        
        void (^tagerrorBlock)(void) = ^(void){
            NSLog(@"~~~tag 设置失败");
        };
    };
    
    void (^errorBlock)(void) = ^(void){
        //设备注册失败之后的处理
        NSLog(@"设备注册失败");
    };
    
    //注册设备
    [XGPush registerDevice:deviceToken successCallback:successBlock errorCallback:errorBlock];
}

//如果deviceToken获取不到会进入此事件
- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)err {
    
    NSString *str = [NSString stringWithFormat: @"Error: %@",err];
    
    NSLog(@"deviceToken获取不到错误信息:%@",str);
    
}

#pragma mark - 收到远程推送通知
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    void (^successBlock)(void) = ^(void){
        
        //成功之后的处理
        NSLog(@"推送反馈(app运行时)反馈成功[xgpush]handleReceiveNotification successBlock = %@",userInfo);
        


        [self kChannelCenter];
        
        [XGPush clearLocalNotifications];
    };
    
    void (^errorBlock)(void) = ^(void){
        //失败之后的处理
        NSLog(@"推送反馈(app运行时)反馈失败[xgpush]handleReceiveNotification errorBlock");
    };
    
    void (^completion)(void) = ^(void){
        //失败之后的处理
        NSLog(@"推送反馈(app运行时)反馈失败[xg push completion]userInfo is");
    };
    
    //推送反馈(app在运行时),支持回调版本
    [XGPush handleReceiveNotification:userInfo successCallback:successBlock errorCallback:errorBlock completion:completion];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    
    NSDate *nowDate = [NSDate date];
    NSString *nowDateStr = [ServyouDefines dateStringFormDateWithFormat:Public_Date_Format date:nowDate];
    [[NSUserDefaults standardUserDefaults] setObject:nowDateStr forKey:KNowDateStringNotification];
    
    
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    NSDate *nowDate = [NSDate date];
    NSString *oldDateString = [[NSUserDefaults standardUserDefaults] objectForKey:KNowDateStringNotification];
    NSDate *oldDate = [ServyouDefines dateFormDateStringWithFormat:Public_Date_Format dateStr:oldDateString];
    NSTimeInterval timerInterval = [nowDate timeIntervalSinceDate:oldDate];
    if (timerInterval >= 600)
    {
        
        if ([[ServyouDefines sharedUserInfo]isLogin])
        {
            self.wtLoginUnable = YES;
        }
    }
    //关闭定时器
//    if (timer)
//    {
//        [self stopTimer];
//    }
    
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}



-(void) switchModuleView:(NSNumber*) moduleID
{
    if (self.vc && [self.vc respondsToSelector:@selector(switchModuleView:)])
    {
        [self.vc performSelector:@selector(switchModuleView:) withObject:moduleID];
    }
        
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return  [UMSocialSnsService handleOpenURL:url];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    return  [UMSocialSnsService handleOpenURL:url];
}

- (void)kChannelCenter
{
    if (!self.channelCenter) {
        self.channelCenter = [[SevryouChannelCenter alloc] init];
    }
    [self.channelCenter sendChannelCenterHttpRequest];
}


#if 0
-(void) tryLogin
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UserInfo *ui = [ServyouDefines sharedUserInfo];
        if (ui.userID.length > 0 && ui.password.length > 0)
        {
            ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:SERVER_LOGIN_URL]];
            [request setPostValue:ui.userID forKey:@"account"];
            //    [request setPostValue:[self md5: self.txtPassword.text] forKey:@"password"];
            [request setPostValue:ui.password forKey:@"password"];
#ifdef _TEST_ENV_                //测试环境
            [request setPostValue:@0 forKey:@"encrypt"];
#else
            [request setPostValue:@1 forKey:@"encrypt"];
#endif
            request.delegate = self;
            [request startAsynchronous];
            
        }
    });
}
#endif

- (void)requestFailed:(ASIHTTPRequest *)theRequest
{
	NSLog(@"%@", [NSString stringWithFormat:@"Request failed:\r\n%@",[[theRequest error] localizedDescription]]);
}

- (void)requestFinished:(ASIHTTPRequest *)theRequest
{
    NSLog(@"%@", theRequest.responseString);
    NSDictionary *result = [theRequest.responseString objectFromJSONString];
    
    if (theRequest == upDateRequest)
    {
        //服务端版本号
        NSString *versionStr = [result objectForKey:@"verName"];
        NSDictionary *systomDcit = [[NSBundle mainBundle]infoDictionary];
        //当期版本号
        NSString *currentVersion = [systomDcit objectForKey:@"CFBundleVersion"];
        if (![versionStr isEqualToString:currentVersion])
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示"
                                                            message:@"您当期使用的版本不是最新版本，是否下载最新版本？"
                                                           delegate:self
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:@"取消", nil];
            alert.tag = Update_Alert_Tag;
            [alert show];
            
        }
        
        return;
    }
    
    if ([ServyouDefines isServerResultSuccessed:result])
    {
        NSObject *body = [result objectForKey:@"body"];
        
        if ([body isKindOfClass:[NSDictionary class]])
        {
            NSMutableArray *items = [[NSMutableArray alloc] init];
            UserInfo *user = [ServyouDefines sharedUserInfo];
            [items addObject:user.userID];
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
            //登录成功后 渠道数据下载
            self.channelCenter = [[SevryouChannelCenter alloc] init];
            [self.channelCenter sendChannelCenterHttpRequest];
        }
    }
    
    //登陆成功处理
    
}

#if 0
#pragma mark - 网厅二次验证
- (void)startTimer
{
    timer =  [NSTimer scheduledTimerWithTimeInterval:60*10
                                              target:self
                                            selector:@selector(didTimerForBackground:)
                                            userInfo:nil
                                             repeats:YES];
}

- (void)didTimerForBackground:(id)sender
{
    self.wtLoginUnable = YES;
    [self stopTimer];
}

- (void)stopTimer
{
    [timer invalidate];
    timer = nil;
}
#endif

#pragma mark - 版本更新
//版本更新request
- (void)versionUpdateHttpRequest
{
    upDateRequest = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:SERVER_Public_Update]];
    upDateRequest.delegate = self;
    
    [upDateRequest startAsynchronous];

}



@end
