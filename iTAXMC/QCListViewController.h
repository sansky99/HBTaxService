//
//  QCListViewController.h
//  QCSliderTableView
//
//  Created by “ 邵鹏 on 14-4-16.
//  Copyright (c) 2014年 Scasy. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface QCListViewController : UIViewController

{
    BOOL contain;
    CGPoint startPoint;
    CGPoint originPoint,startButtonCenter;
    
    UIScrollView * bgView;
    
    NSMutableDictionary * dication;
}

@property (strong , nonatomic) NSMutableArray *itemArray;

@property (strong,  nonatomic) NSMutableDictionary * tabNumber;

@property (strong, nonatomic) NSNumber *moduleID;//一级ID

@property (nonatomic,assign) int twoID;//二级ID

@property (nonatomic,weak) UIViewController *rootViewController;
@property (strong,  nonatomic) NSMutableDictionary * viewData;

- (void)viewDidCurrentView;
-(void) switchModuleView:(NSNumber*) moduleID;

@end

