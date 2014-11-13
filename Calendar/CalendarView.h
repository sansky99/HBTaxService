//
//  CalendarView.h
//  N
//
//  Created by 张乐 on 14-7-25.
//  Copyright (c) 2014年 www.servyou.com.cn. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CalendarView;

@protocol CalendarViewDelegate <NSObject>

@optional
-(void) currentMonthWillChange:(CalendarView*) calendarView month:(NSDate*) month;
-(void) currentMonthDidChange:(CalendarView*) calendarView month:(NSDate*) month;

@end



@interface CalendarView : UIView

{
    BOOL isAnimating;
    
    UILabel * labelCurrentMonth;//顶部文字
    
    BOOL prepAnimationPreviousMonth;//上月
    BOOL prepAnimationNextMonth;//下月
}

@property (nonatomic, weak) id<CalendarViewDelegate> delegate;

@property (nonatomic, retain) NSDate *currentMonth;//本月年月日信息
@property (nonatomic, retain, getter = selectedDate) NSDate *selectedDate;

@property (nonatomic, retain) NSArray *markedDates;
@property (nonatomic, retain) NSArray *markedColors;

@property (nonatomic, retain) UIImageView *animationView_A;
@property (nonatomic, retain) UIImageView *animationView_B;

@property (nonatomic, strong) NSArray* flagDays;

-(float)calendarHeight;

//-(void) setMinMonth:(NSDate*) month;
//-(void) setMaxMonth:(NSDate*) month;
@property (nonatomic) BOOL  limitOneYear;
@end
