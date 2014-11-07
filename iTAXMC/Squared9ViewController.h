//
//  Squared9ViewController.h
//  iTAXMC
//
//  Created by 张乐 on 14-7-31.
//  Copyright (c) 2014年 servyou. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "QCSlideSwitchView.h"
#import "QCListViewController.h"

@interface Squared9ViewController : UIViewController<QCSlideSwitchViewDelegate>
{
    CGFloat _slideSwitchViewY;
    
    QCSlideSwitchView *_slideSwitchView;
    
    NSMutableArray * twoTab;
    
    int TwoTabnumber;
    
    NSMutableArray * ARRAY;
    
    NSArray * TwoTabName;
    
    NSMutableArray * tabViewArray;
    
    //    NSMutableArray * thereTabNumber;
    
    NSMutableDictionary * there;
    
    QCListViewController *_vc1;
    QCListViewController *_vc2;
    QCListViewController *_vc3;
    QCListViewController *_vc4;
    QCListViewController *_vc5;
    QCListViewController *_vc6;
}

//1.3 税务服务 1.4 纳税资讯 1.5 公众服务   9宫格
@property (strong, nonatomic) NSNumber *moduleID;

@property (nonatomic, strong) QCListViewController *vc1;
@property (nonatomic, strong) QCListViewController *vc2;
@property (nonatomic, strong) QCListViewController *vc3;
@property (nonatomic, strong) QCListViewController *vc4;
@property (nonatomic, strong) QCListViewController *vc5;
@property (nonatomic, strong) QCListViewController *vc6;

@end
