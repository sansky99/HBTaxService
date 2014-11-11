//
//  HBLoginViewController.h
//  XJTaxTrain
//
//  Created by khuang on 14-7-7.
//  Copyright (c) 2014年 servyou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QCListViewController.h"

@interface PhoneInfo : NSObject
@property (nonatomic, strong) NSString *ID;
@property (nonatomic, strong) NSString *name;
@end


//1.6 登录
@interface HBLoginViewController : UIViewController


@property (strong, nonatomic) QCListViewController * moduleViewC;
@property (strong, nonatomic) NSNumber * moduleID;

@property (weak, nonatomic) IBOutlet UITextField *txtID;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (nonatomic) CGRect rectContainerView;

@end
