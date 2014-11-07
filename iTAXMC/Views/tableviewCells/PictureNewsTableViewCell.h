//
//  PictureNewsTableViewCell.h
//  XJTaxService
//
//  Created by hellen.zhou on 14-9-15.
//  Copyright (c) 2014年 servyou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+WebCache.h"

@interface PictureNewsTableViewCell : UITableViewCell
@property (nonatomic,strong,readonly) UILabel *titleTextLable;
@property (nonatomic,strong,readonly) UILabel *timeTextLable;
@property (nonatomic,strong,readonly) UIImageView *newsImageView;
@end
