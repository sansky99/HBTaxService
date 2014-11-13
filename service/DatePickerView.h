//
//  DatePickerView.h
//  iTAXMC
//
//  Created by khuang on 14-7-24.
//  Copyright (c) 2014年 servyou. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DatePickerViewDelegate <NSObject>

-(void) onSelectDate:(NSDate*) date;
//-(void) onCancel;

@end

@interface DatePickerView : UIView

@property (nonatomic, weak) id<DatePickerViewDelegate> delegate;

- (id)initWithParentView:(UIView*) parent;
-(void) showDate:(NSDate*) date centerRect:(CGRect) rt;
-(void) hide;

@end
