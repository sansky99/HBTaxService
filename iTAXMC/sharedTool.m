////
////  sharedTool.m
////  iTAXMC
////
////  Created by 张乐 on 14-8-25.
////  Copyright (c) 2014年 servyou. All rights reserved.
////
//
//#import "sharedTool.h"
//
//#import "UMSocial.h"
//
//static sharedTool * shared;
//
//@implementation sharedTool
//
//
//- (id)init
//{
//    self = [super init];
//    if (self) {}
//    return self;
//}
//
//
//+(sharedTool *)sharedSingle{
//    
//    if (!shared) {
//        shared = [[sharedTool alloc] init];
//    }
//    
//    return shared;
//}
//
////sina
//-(void)sharedToSina:(UIImage *)image sharedText:(NSString *)text sharedUrl:(NSString *)url sharedView:(UIViewController *)vc{
//    
//    [UMSocialData defaultData].extConfig.sinaData.shareImage = image;
//    [UMSocialData defaultData].extConfig.sinaData.shareText = [NSString stringWithFormat:@"%@ %@",text,url];
//    [UMSocialData defaultData].extConfig.sinaData.urlResource = [[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeDefault url:url];
//    
//    [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina].snsClickHandler(vc.self,[UMSocialControllerService defaultControllerService],YES);
//    
//}
//
////分享到腾讯微博
//-(void)sharedToTencent:(UIImage *)image sharedText:(NSString *)text sharedUrl:(NSString *)url sharedView:(UIViewController *)vc{
//    [UMSocialData defaultData].extConfig.tencentData.shareImage = image;
//    [UMSocialData defaultData].extConfig.tencentData.shareText = text;
//    [UMSocialData defaultData].extConfig.tencentData.urlResource = [[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeDefault url:url];
//    
//    [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToTencent].snsClickHandler(vc.self,[UMSocialControllerService defaultControllerService],YES);
//}
//
////分享到QQ空间
//-(void)sharedToQzone:(UIImage *)image sharedText:(NSString *)text sharedUrl:(NSString *)url sharedView:(UIViewController *)vc{
//    
//    [UMSocialData defaultData].extConfig.qzoneData.title  = text;
//    [UMSocialData defaultData].extConfig.qzoneData.url = url;
//    [UMSocialData defaultData].extConfig.qzoneData.shareImage = image;
//    
//    
//    
//    //    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQzone] content:@"分享文字" image:image location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
//    //        if (response.responseCode == UMSResponseCodeSuccess) {
//    //            NSLog(@"分享成功！");
//    //        }
//    //    }];
//    [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToQzone].snsClickHandler(vc.self,[UMSocialControllerService defaultControllerService],YES);
//    
//}
//
////分享到QQ
//-(void)sharedToQQ:(UIImage *)image sharedText:(NSString *)text sharedUrl:(NSString *)url sharedView:(UIViewController *)vc{
//    
//    [UMSocialData defaultData].extConfig.qqData.qqMessageType = UMSocialQQMessageTypeDefault;
//    [UMSocialData defaultData].extConfig.qqData.title = text;
//    [UMSocialData defaultData].extConfig.qqData.url = url;
//    
//    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQQ] content:text image:image location:nil urlResource:nil presentedController:vc.self completion:^(UMSocialResponseEntity *response){
//        if (response.responseCode == UMSResponseCodeSuccess) {
//            NSLog(@"分享成功！");
//        }
//    }];
//}
//
////分享到朋友圈
//-(void)sharedToWechatTimeline:(UIImage *)image sharedText:(NSString *)text sharedUrl:(NSString *)url sharedView:(UIViewController *)vc{
//    [UMSocialData defaultData].extConfig.wechatTimelineData.wxMessageType = UMSocialWXMessageTypeText;
//    [UMSocialData defaultData].extConfig.wechatTimelineData.title = text;
//    [UMSocialData defaultData].extConfig.wechatTimelineData.url = url;
//    
//    
//    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatTimeline] content:url image:image  location:nil urlResource:nil presentedController:vc.self completion:^(UMSocialResponseEntity *response){
//        if (response.responseCode == UMSResponseCodeSuccess) {
//            NSLog(@"分享成功！");
//        }
//    }];
//    
//    //发送文本两种方式
//    //            1:wxMessageType = UMSocialWXMessageTypeText;  将跳转url写到content内容中
//    //              2:wxMessageType = UMSocialWXMessageTypeWeb;   图片给一个默认的
//    
//}
//
////分享到微信好友
//-(void)sharedToWechatSession:(UIImage *)image sharedText:(NSString *)text sharedUrl:(NSString *)url sharedView:(UIViewController *)vc{
//    
//    [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeWeb;//文本
//    [UMSocialData defaultData].extConfig.title = text;
//    [UMSocialData defaultData].extConfig.wechatSessionData.url = url;
//    
//    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatSession] content:text image:image location:nil urlResource:nil presentedController:vc.self completion:^(UMSocialResponseEntity *response){
//        if (response.responseCode == UMSResponseCodeSuccess) {
//            NSLog(@"分享成功！");
//        }
//    }];
//}
//
////分享到短信
//-(void)sharedToSMS:(UIImage *)image sharedText:(NSString *)text sharedUrl:(NSString *)url sharedView:(UIViewController *)vc{
//    
//    [UMSocialData defaultData].extConfig.smsData.shareText = text;
//    [UMSocialData defaultData].extConfig.smsData.shareImage = image;
//    
//    [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSms].snsClickHandler(vc.self,[UMSocialControllerService defaultControllerService],YES);
//}
//
////分享到邮箱
//-(void)sharedToEmail:(UIImage *)image sharedText:(NSString *)text sharedUrl:(NSString *)url sharedView:(UIViewController *)vc{
// 
//    [UMSocialData defaultData].extConfig.emailData.shareImage = image;
//    [UMSocialData defaultData].extConfig.emailData.shareText = text;
//    [UMSocialData defaultData].extConfig.emailData.urlResource = [[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeDefault url:url];
//
//    
//    [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToEmail].snsClickHandler(vc.self,[UMSocialControllerService defaultControllerService],YES);
//}
//
//
//
//
//@end