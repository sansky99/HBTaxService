//
//  OverduePaymentViewController.h
//  iTAXMC
//
//  Created by khuang on 14-7-23.
//  Copyright (c) 2014年 servyou. All rights reserved.
//

#import <UIKit/UIKit.h>


//滞纳金, (moduleID: 30108)

@interface OverduePaymentViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIButton *containerResult;
@property (weak, nonatomic) IBOutlet UIButton *btnPayDate;
@property (weak, nonatomic) IBOutlet UIButton *btnLimitDate;
@property (weak, nonatomic) IBOutlet UITextField *txtMount;
@property (weak, nonatomic) IBOutlet UIButton *btnCalc;
@property (weak, nonatomic) IBOutlet UITextField *txtOverdueDay;
@property (weak, nonatomic) IBOutlet UITextField *txtOverduePay;

@end
