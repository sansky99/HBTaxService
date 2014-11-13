//
//  CalendarViewController.h
//  XJTaxService
//
//  Created by khuang on 14-9-23.
//  Copyright (c) 2014年 servyou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CalendarItem : NSObject<NSCoding>
@property (nonatomic, strong) NSNumber *month;
@property (nonatomic, strong) NSNumber *day;
@property (nonatomic, strong) NSString *content;
@end

@interface CalendarViewController : UIViewController

@property (nonatomic, strong) NSNumber *moduleID;

@end
