//
//  DatePickerView.m
//  iTAXMC
//
//  Created by khuang on 14-7-24.
//  Copyright (c) 2014年 servyou. All rights reserved.
//

#import "DatePickerView.h"

@interface DatePickerView()

@property (nonatomic,strong) UIDatePicker *datePicker;
@property (nonatomic,strong) UIButton *btnOK;
@property (nonatomic,strong) UIButton *btnCancel;
@property (nonatomic,weak) UIView  *parentView;

@end

@implementation DatePickerView
@synthesize delegate, datePicker,btnOK, btnCancel;

- (id)initWithParentView:(UIView*) parent
{
    self = [super initWithFrame:parent.bounds];
    if (self) {
        // Initialization code
        self.parentView = parent;
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
//        [self addTarget:self action:@selector(onCancel:) forControlEvents:UIControlEventTouchUpInside];
        
        datePicker = [[UIDatePicker alloc] init];
        datePicker.datePickerMode = UIDatePickerModeDate;
        datePicker.backgroundColor = [UIColor colorWithWhite:1 alpha:0.85];
        datePicker.locale = [NSLocale localeWithLocaleIdentifier:@"zh-CN"];
        [self addSubview:datePicker];
        datePicker.center = self.center;
        
        btnCancel = [[UIButton alloc] init];
        [btnCancel setTitle:@"取消" forState:(UIControlStateNormal)];
        [btnCancel sizeToFit];
        [self addSubview:btnCancel];
        btnCancel.backgroundColor = [ServyouDefinesUI ColorBlue];
        [btnCancel addTarget:self action:@selector(onCancel:) forControlEvents:UIControlEventTouchUpInside];
        
        btnOK = [[UIButton alloc] init];
        [btnOK setTitle:@"确定" forState:(UIControlStateNormal)];
        [btnOK sizeToFit];
        [self addSubview:btnOK];
        btnOK.backgroundColor = [ServyouDefinesUI ColorBlue];
        [btnOK addTarget:self action:@selector(onOK:) forControlEvents:UIControlEventTouchUpInside];

    }
    return self;
}

-(void) showDate:(NSDate*) date centerRect:(CGRect) rt
{
    [self.datePicker setDate:date animated:FALSE];
//    CGRect rect= CGRectMake(0, -datePicker.frame.size.height, 0, 0);
//    datePicker.frame =rect;

//    btnCancel.hidden = btnOK.hidden = TRUE;
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
    self.datePicker.alpha = self.btnCancel.alpha = self.btnOK.alpha = 0;
    [self.parentView addSubview:self];
    CGRect rect= CGRectMake(0, rt.origin.y + rt.size.height, self.bounds.size.width, datePicker.frame.size.height);
    datePicker.frame =rect;
     btnOK.frame = CGRectMake(rect.origin.x, rect.origin.y + rect.size.height + 10, rect.size.width/2 - 3, btnOK.frame.size.height);
     btnCancel.frame = CGRectMake(rect.origin.x+ rect.size.width/2 + 3, rect.origin.y + rect.size.height + 10, rect.size.width/2 - 3, btnCancel.frame.size.height);
//     btnCancel.hidden = btnOK.hidden = FALSE;
    
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionAllowAnimatedContent|UIViewAnimationOptionShowHideTransitionViews animations:^{
            self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
            self.datePicker.alpha = self.btnCancel.alpha = self.btnOK.alpha = 1;
        }
        completion:nil
     ];
}

-(void) hide
{
//    btnCancel.hidden = btnOK.hidden = TRUE;
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionAllowAnimatedContent|UIViewAnimationOptionShowHideTransitionViews
        animations:^{
            self.datePicker.alpha = self.btnCancel.alpha = self.btnOK.alpha = 0;
            self.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
         }
         completion:^(BOOL finished) {
             [self removeFromSuperview];
//            CGRect rect= CGRectMake(0, -datePicker.frame.size.height, 0, 0);
//            datePicker.frame =rect;
        }
     ];
}

-(void) onOK:(id) sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(onSelectDate:)])
    {
        [self.delegate performSelector:@selector(onSelectDate:) withObject:self.datePicker.date];
    }
}

-(void) onCancel:(id) sender
{
    [self hide];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
