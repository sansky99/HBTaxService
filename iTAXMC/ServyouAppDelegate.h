//
//  ServyouAppDelegate.h
//  XJTaxTrain
//
//  Created by khuang on 14-7-7.
//  Copyright (c) 2014年 servyou. All rights reserved.
//

#import <UIKit/UIKit.h>

//#import "BMapKit.h"
@class SevryouChannelCenter;
@class ASIFormDataRequest;
@interface ServyouAppDelegate : UIResponder <UIApplicationDelegate/*,BMKLocationServiceDelegate,BMKGeneralDelegate*/>

{
//    NSString* deviceTokenStr;//手机TokenStr
//    BMKMapManager* _mapManager;
    
    ASIFormDataRequest *upDateRequest;
    
    NSTimer *timer;
}

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) SevryouChannelCenter *channelCenter;
@property (nonatomic) BOOL wtLoginUnable;
@property (weak, nonatomic) UIViewController *vc;
-(void) switchModuleView:(NSNumber*) moduleID;

@end

