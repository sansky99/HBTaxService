//
//  OverduePaymentViewController.m
//  iTAXMC
//
//  Created by khuang on 14-7-23.
//  Copyright (c) 2014年 servyou. All rights reserved.
//

#import "OverduePaymentViewController.h"
#import "ZAActivityBar.h"
#import "DatePickerView.h"
#import "UIViewController+KeyboardClose.h"
#include "CompatibleaPrintf.h"

@interface OverduePaymentViewController ()<UITextFieldDelegate, DatePickerViewDelegate>
{
    NSDate *dateLimit;
    NSDate *datePay;
    
    DatePickerView *datePickerView;
    BOOL    pickerForLimit;
}
@end

@implementation OverduePaymentViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

SYNeedNavBarDoback
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (!OSVersionIsAtLeastiOS7()) {
        SYNavBackButton
    }
    NeedOffsetWhenIOS7NavBar
    
    self.title = @"滞纳金计算";
    self.containerView.backgroundColor = [ServyouDefinesUI ColorGray];
    
    [self.btnLimitDate setTitleColor:[ServyouDefinesUI ColorBlue] forState:UIControlStateNormal];
    [self.btnPayDate setTitleColor:[ServyouDefinesUI ColorBlue] forState:UIControlStateNormal];
    [self.txtMount setTextColor:[ServyouDefinesUI ColorBlue]];
    self.txtMount.delegate = self;
    [self.txtOverdueDay setTextColor:[ServyouDefinesUI ColorBlue]];
    [self.txtOverduePay setTextColor:[ServyouDefinesUI ColorBlue]];
   
    UIEdgeInsets insets = UIEdgeInsetsMake(5, 25, 30, 40);
    UIImage *image = [[UIImage imageNamed:@"comboxBGnoArrow"] resizableImageWithCapInsets:insets];
    [self.btnLimitDate setBackgroundImage:image forState:UIControlStateNormal];
    [self.btnLimitDate setBackgroundImage:image forState:UIControlStateHighlighted];
    [self.btnPayDate setBackgroundImage:image forState:UIControlStateNormal];
    [self.btnPayDate setBackgroundImage:image forState:UIControlStateHighlighted];
    [self.txtMount setBackground:image];
    
    insets = UIEdgeInsetsMake(5, 7, 15, 10);
    image = [[UIImage imageNamed:@"sawtooth"] resizableImageWithCapInsets:insets];
    [self.containerResult setBackgroundImage:image forState:UIControlStateNormal];
    
    [self.btnCalc setBackgroundImage:[ServyouDefinesUI buttonBG] forState:UIControlStateNormal];
    self.btnCalc.backgroundColor = [UIColor clearColor];
    
    UILabel *lb = [[UILabel alloc] init];
    lb.backgroundColor = [UIColor clearColor];
    lb.font = self.txtMount.font;
    lb.text = @" 元  ";
    [lb sizeToFit];
    self.txtMount.rightView = lb;
    self.txtMount.rightViewMode = UITextFieldViewModeAlways;
    
    lb = [[UILabel alloc] init];
    lb.backgroundColor = [UIColor clearColor];
    lb.text = @" 天  ";
    lb.font = self.txtOverdueDay.font;
    [lb sizeToFit];
    self.txtOverdueDay.rightView = lb;
    self.txtOverdueDay.rightViewMode = UITextFieldViewModeAlways;

    lb = [[UILabel alloc] init];
    lb.backgroundColor = [UIColor clearColor];
    lb.font = self.txtOverduePay.font;
    lb.text = @" 元  ";
    [lb sizeToFit];
    self.txtOverduePay.rightView = lb;
    self.txtOverduePay.rightViewMode = UITextFieldViewModeAlways;
    
    datePickerView = [[DatePickerView alloc] initWithParentView:self.containerView];
    datePickerView.delegate = self;
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd"];
    NSString *d = [df stringFromDate:[NSDate date]];
    datePay =  dateLimit = [df dateFromString:d];

    [self clearResult];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self registerKeyboardCloseButtonForIphone];
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self unregisterKeyboardCloseButton];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)onLimitDate:(id)sender {
    [self.txtMount resignFirstResponder];
    [datePickerView showDate:dateLimit centerRect:self.btnLimitDate.frame];
    pickerForLimit = TRUE;
}
- (IBAction)onPayDate:(id)sender {
    [self.txtMount resignFirstResponder];
    [datePickerView showDate:datePay centerRect:self.btnPayDate.frame];
    pickerForLimit = FALSE;
}

- (IBAction)onCalc:(id)sender {
    [self.txtMount resignFirstResponder];

    if (dateLimit == [dateLimit laterDate: datePay])
    {
        [self showWarning:@"缴纳日期需晚于限缴期限"];
        return;
    }
    
    double mount = [self.txtMount.text doubleValue];
    if (mount < 1e-2)
    {
        [self showWarning:@"请输入滞纳税款金额，最小0.01元"];
        return;
    }

    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    unsigned int unitFlag = NSDayCalendarUnit;
    NSDateComponents *components = [calendar components:unitFlag fromDate:dateLimit toDate:datePay options:0];
    int days = [components day];
    
    [self doCalc:mount days:days];
}

-(void) clearResult
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd"];
    [self.btnLimitDate setTitle:[df stringFromDate:dateLimit] forState:UIControlStateNormal];
    [self.btnPayDate setTitle:[df stringFromDate:datePay] forState:UIControlStateNormal];
    
    self.txtOverdueDay.text = @"0";
    self.txtOverduePay.text = @"0.00";
}
-(void) doCalc:(double) mount days:(NSInteger) days
{
    double r = 5e-4 * mount * days;
    self.txtOverdueDay.text = [NSString stringWithFormat:@"%d", days];
    self.txtOverduePay.text = [ServyouDefines getCurrencyFormatValue:r];
}
-(void) showWarning:(NSString*) msg
{
    [ZAActivityBar showWithStatus:msg image:nil duration:2 forAction:@""];
}

#pragma mark - UITextFieldDelegate
////////////////////////////////
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSMutableString *newtxt = [NSMutableString stringWithString:textField.text];
    
    [newtxt replaceCharactersInRange:range withString:string];
    
    return ([newtxt length] <= 12);
}

#pragma mark - DatePickerViewDelegate
-(void) onSelectDate:(NSDate *)date
{
    if (pickerForLimit)
        dateLimit = date;
    else
        datePay = date;
    [datePickerView hide];
    [self clearResult];
}
@end
