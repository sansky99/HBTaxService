//
//  FontSizeViewController.h
//  iTAXMC
//
//  Created by khuang on 14-7-16.
//  Copyright (c) 2014年 servyou. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface FontSizeViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (nonatomic) NSInteger fontsize;
@end
