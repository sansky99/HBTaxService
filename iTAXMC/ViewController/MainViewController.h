//
//  MainViewController.h
//  XJTaxTrain
//
//  Created by khuang on 14-7-7.
//  Copyright (c) 2014年 servyou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTouchesViewController.h"

//1.2 首页
@interface MainViewController : BaseTouchesViewController
{
    NSMutableArray *tableArray;
    
     NSMutableArray *tableArrayNumber;
    
    //更新版本
    NSString * newVerUrl;
    
    SevryouChannelCenter *center;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic,weak) UIViewController *rootViewController;

@property (nonatomic,retain) NSDictionary * releaseInfo;
@end
