//
//  ChannelDetailsViewController.h
//  iTAXMC
//
//  Created by 张乐 on 14-9-12.
//  Copyright (c) 2014年 servyou. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SevryouChannelCenter.h"

@interface ChannelDetailsViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

{
//    NSArray *  tableArray;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic,strong) NSString * opCode;

@property (nonatomic,strong) NSArray * tableArray;

@property (nonatomic) ChannelCenterEntityType channelType;
@end
