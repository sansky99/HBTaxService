//
//  HBMainViewController.h
//  XJTaxTrain
//
//  Created by khuang on 14-7-7.
//  Copyright (c) 2014年 servyou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTouchesViewController.h"

//1.2 首页
@interface HBMainViewController : BaseTouchesViewController
{
    NSMutableArray *tableArray;
    
     NSMutableArray *tableArrayNumber;
    
    //更新版本
    NSString * newVerUrl;
    
    SevryouChannelCenter *center;
}

@property (nonatomic,weak) UIViewController *rootViewController;

@property (nonatomic,retain) NSDictionary * releaseInfo;
@end
