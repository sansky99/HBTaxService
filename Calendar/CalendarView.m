//
//  CalendarView.m
//  N
//
//  Created by 张乐 on 14-7-25.
//  Copyright (c) 2014年 www.servyou.com.cn. All rights reserved.
//

#import "CalendarView.h"

#import "UIColor+expanded.h"//颜色值
#import "UIView+convenience.h"//大小
#import "NSMutableArray+convenience.h"
#import "NSDate+convenience.h"

#define CalendarViewWidth 320//日历宽度

#define kVRGCalendarViewWidth 320

#define kVRGCalendarViewTopBarHeight 60//距离顶部

#define kVRGCalendarViewDayHeight 44*0.8//item高
#define kVRGCalendarViewDayWidth 44

//左右两边切换月份箭头大小设置
int arrowSize = 16;         //12
int xarrowmargin = 100;
int yarrowmargin = 13;           //15

@implementation CalendarView
@synthesize delegate, flagDays, limitOneYear;

- (id)init{
    
    self = [super initWithFrame:CGRectMake(0, 0, CalendarViewWidth, 0)];
    if (self) {
        self.contentMode = UIViewContentModeBottom;
        self.clipsToBounds = YES;
    }
    
    //顶部年月份
    labelCurrentMonth = [[UILabel alloc] initWithFrame:CGRectMake(34, 0, kVRGCalendarViewWidth-68, 40)];
    labelCurrentMonth.backgroundColor=[UIColor clearColor];
    labelCurrentMonth.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:17];
    labelCurrentMonth.textColor = [UIColor colorWithHexString:@"0x383838"];
    
    [self addSubview:labelCurrentMonth];
    
    self.currentMonth = [NSDate date];
    
    //在当前线程中执行指定的方法，使用默认模式，并指定延迟   - 建立日期
    [self performSelector:@selector(reset) withObject:nil afterDelay:0.1];

    return self;
}

#pragma mark - Drawing
- (void)drawRect:(CGRect)rect{
    
    int firstWeekDay = [self.currentMonth firstWeekDayInMonth]-1; //-1 because weekdays begin at 1, not 0
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy年M月"];
    labelCurrentMonth.text = [formatter stringFromDate:self.currentMonth];
    [labelCurrentMonth sizeToFit];
    labelCurrentMonth.frameX = roundf(self.frame.size.width/2 - labelCurrentMonth.frameWidth/2);
    labelCurrentMonth.frameY = 10;
 
    //[self.currentMonth firstWeekDayInMonth];
    
    CGContextClearRect(UIGraphicsGetCurrentContext(),rect);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGRect rectangle = CGRectMake(0,0,self.frame.size.width,kVRGCalendarViewTopBarHeight);
    CGContextAddRect(context, rectangle);
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextFillPath(context);
    

    
    UIColor * s = [UIColor colorWithRed:37/255.0 green:131/255.0 blue:231/255.0 alpha:1.0];
    
    //左箭头
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, xarrowmargin+arrowSize/1.5, yarrowmargin);
    CGContextAddLineToPoint(context,xarrowmargin+arrowSize/1.5,yarrowmargin+arrowSize);
    CGContextAddLineToPoint(context,xarrowmargin,yarrowmargin+arrowSize/2);
    CGContextAddLineToPoint(context,xarrowmargin+arrowSize/1.5, yarrowmargin);
    if (self.limitOneYear && [self.currentMonth month]==1)
         CGContextSetFillColorWithColor(context,[UIColor colorWithWhite:0.8 alpha:1].CGColor);
    else
        CGContextSetFillColorWithColor(context,s.CGColor);
    CGContextFillPath(context);
    
    //Arrow right
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, self.frame.size.width-(xarrowmargin+arrowSize/1.5), yarrowmargin);
    CGContextAddLineToPoint(context,self.frame.size.width-xarrowmargin,yarrowmargin+arrowSize/2);
    CGContextAddLineToPoint(context,self.frame.size.width-(xarrowmargin+arrowSize/1.5),yarrowmargin+arrowSize);
    CGContextAddLineToPoint(context,self.frame.size.width-(xarrowmargin+arrowSize/1.5), yarrowmargin);
    if (self.limitOneYear && [self.currentMonth month]==12)
        CGContextSetFillColorWithColor(context,[UIColor colorWithWhite:0.8 alpha:1].CGColor);
    else
        CGContextSetFillColorWithColor(context,s.CGColor);
    CGContextFillPath(context);

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat=@"EEE";

    NSMutableArray *weekdays = [[NSMutableArray alloc] initWithArray:[dateFormatter shortWeekdaySymbols]];

    [weekdays moveObjectFromIndex:0 toIndex:6];
    
    [weekdays replaceObjectAtIndex:0 withObject:@"日"];
    [weekdays replaceObjectAtIndex:1 withObject:@"一"];
    [weekdays replaceObjectAtIndex:2 withObject:@"二"];
    [weekdays replaceObjectAtIndex:3 withObject:@"三"];
    [weekdays replaceObjectAtIndex:4 withObject:@"四"];
    [weekdays replaceObjectAtIndex:5 withObject:@"五"];
    [weekdays replaceObjectAtIndex:6 withObject:@"六"];
    
    
    CGContextSetFillColorWithColor(context,s.CGColor);

    //循环显示周天
    for (int i =0; i<[weekdays count]; i++) {
        NSString *weekdayValue = (NSString *)[weekdays objectAtIndex:i];
        
        UIFont *font = [UIFont fontWithName:@"HelveticaNeue" size:12];
        [weekdayValue drawInRect:CGRectMake(i*(kVRGCalendarViewDayWidth+2), 40, kVRGCalendarViewDayWidth+2, 20) withFont:font lineBreakMode:UILineBreakModeClip alignment:UITextAlignmentCenter];
    }
    
    int numRows = [self numRows];//得到本月日历显示多少行
    

    //日历背景
    float gridHeight = numRows*(kVRGCalendarViewDayHeight+2)+1;
    CGRect rectangleGrid = CGRectMake(0,kVRGCalendarViewTopBarHeight,self.frame.size.width,gridHeight);
    CGContextAddRect(context, rectangleGrid);
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextFillPath(context);

    int numBlocks = numRows*7;//每行7个
    
    NSDate *previousMonth = [self.currentMonth offsetMonth:-1];//得到上月
    
    int currentMonthNumDays = [self.currentMonth numDaysInMonth];//得到本月的天数
    int prevMonthNumDays = [previousMonth numDaysInMonth];//得到上月的天数
    
    int selectedDateBlock = ([self.selectedDate day]-1)+firstWeekDay;
 
    //prev next month
    BOOL isSelectedDatePreviousMonth = prepAnimationPreviousMonth;
    BOOL isSelectedDateNextMonth = prepAnimationNextMonth;
    
    if (self.selectedDate!=nil) {
        isSelectedDatePreviousMonth = ([self.selectedDate year]==[self.currentMonth year] && [self.selectedDate month]<[self.currentMonth month]) || [self.selectedDate year] < [self.currentMonth year];
        
        if (!isSelectedDatePreviousMonth) {
            isSelectedDateNextMonth = ([self.selectedDate year]==[self.currentMonth year] && [self.selectedDate month]>[self.currentMonth month]) || [self.selectedDate year] > [self.currentMonth year];
        }
    }
    
    if (isSelectedDatePreviousMonth) {
        int lastPositionPreviousMonth = firstWeekDay-1;
        selectedDateBlock=lastPositionPreviousMonth-([self.selectedDate numDaysInMonth]-[self.selectedDate day]);
    } else if (isSelectedDateNextMonth) {
        selectedDateBlock = [self.currentMonth numDaysInMonth] + (firstWeekDay-1) + [self.selectedDate day];
    }
    
    NSDate *todayDate = [NSDate date];
    int todayBlock = -1;
//    NSLog(@"currentMonth month = %i day = %i, todaydate day = %i",[self.currentMonth month],[self.currentMonth day],[todayDate month]);

    if ([todayDate month] == [self.currentMonth month] && [todayDate year] == [self.currentMonth year]) {
        todayBlock = [todayDate day] + firstWeekDay - 1;
//        NSLog(@"!!!todayBlock = %d",todayBlock);
    }
    
    NSMutableArray * selDays = [[NSMutableArray alloc] initWithCapacity:self.flagDays.count];
    for (NSNumber *item in self.flagDays)
    {
        [selDays addObject:[NSNumber numberWithInt:([item intValue] + firstWeekDay - 1)]];
    }
    
    
    for (int i=0; i<numBlocks; i++)
    {
        int targetDate = i;
        int targetColumn = i%7;
        int targetRow = i/7;
        int targetX = targetColumn * (kVRGCalendarViewDayWidth+2);
        int targetY = kVRGCalendarViewTopBarHeight + targetRow * (kVRGCalendarViewDayHeight+2);
        
        // BOOL isCurrentMonth = NO;
        if (i<firstWeekDay)
        {//上月
            targetDate = (prevMonthNumDays-firstWeekDay)+(i+1);
            CGContextSetFillColorWithColor(context,[UIColor colorWithRed:220/250.0 green:220/250.0 blue:220/250.0 alpha:1].CGColor);
        }
        else if (i>=(firstWeekDay+currentMonthNumDays))
        { //next month
            targetDate = (i+1) - (firstWeekDay+currentMonthNumDays);
//            NSString *hex = (isSelectedDateNextMonth) ? @"0x383838" : @"aaaaaa";
            CGContextSetFillColorWithColor(context,[UIColor colorWithRed:220/250.0 green:220/250.0 blue:220/250.0 alpha:1].CGColor);
        }
        else
        { //current month
            targetDate = (i-firstWeekDay)+1;
            if (todayBlock==i)
            {
                CGContextSetFillColorWithColor(context,[ServyouDefinesUI ColorOrange].CGColor);
            }
            else if ([selDays containsObject:[NSNumber numberWithInt:i]])
            {
                CGRect rt = CGRectMake(targetX+2, targetY+5, kVRGCalendarViewDayWidth, kVRGCalendarViewDayHeight);
                if (kVRGCalendarViewDayWidth > kVRGCalendarViewDayHeight)
                {
                    rt = CGRectMake(targetX+2 + (kVRGCalendarViewDayWidth - kVRGCalendarViewDayHeight)/2, targetY+4, kVRGCalendarViewDayHeight, kVRGCalendarViewDayHeight);
                }
                CGContextAddEllipseInRect(context, rt);
                CGContextSetFillColorWithColor(context, [ServyouDefinesUI ColorOrange].CGColor);
                CGContextFillPath(context);
                
                CGContextSetFillColorWithColor(context,[UIColor whiteColor].CGColor);
            }
            else
            {
                CGContextSetFillColorWithColor(context,[UIColor colorWithRed:55/250.0 green:53/250.0 blue:53/250.0 alpha:1].CGColor);
            }
        }
        
        NSString *date = [NSString stringWithFormat:@"%i",targetDate];
       
        if (todayBlock == i) {
            date = @"今天";
        }
        
        //draw selected date
        if (self.selectedDate && i==selectedDateBlock) {
            CGRect rectangleGrid = CGRectMake(targetX,targetY,kVRGCalendarViewDayWidth+2,kVRGCalendarViewDayHeight+2);
            CGContextAddRect(context, rectangleGrid);
            CGContextSetFillColorWithColor(context, [UIColor colorWithHexString:@"0x006dbc"].CGColor);
            CGContextFillPath(context);
            
            CGContextSetFillColorWithColor(context,
                                           [UIColor whiteColor].CGColor);
        }
//        else if (todayBlock==i) {
//            CGRect rectangleGrid = CGRectMake(targetX,targetY,kVRGCalendarViewDayWidth+2,kVRGCalendarViewDayHeight+2);
//            CGContextAddRect(context, rectangleGrid);
//            CGContextSetFillColorWithColor(context, [UIColor redColor].CGColor);
//            CGContextFillPath(context);
//            CGContextSetFillColorWithColor(context, [UIColor colorWithRed:250/250.0 green:111/250.0 blue:77/250.0 alpha:1].CGColor);
//        }
        //[UIColor colorWithRed:250/250.0 green:111/250.0 blue:77/250.0 alpha:1].CGColor
        

    [date drawInRect:CGRectMake(targetX+2, targetY+10, kVRGCalendarViewDayWidth, kVRGCalendarViewDayHeight) withFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:17] lineBreakMode:UILineBreakModeClip alignment:UITextAlignmentCenter];
    }
    
    //Draw markings
    if (isSelectedDatePreviousMonth || isSelectedDateNextMonth) return;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self];
    
     self.selectedDate=nil;

    if (touchPoint.y > kVRGCalendarViewTopBarHeight) {
        float xLocation = touchPoint.x;
        float yLocation = touchPoint.y-kVRGCalendarViewTopBarHeight;
        
        int column = floorf(xLocation/(kVRGCalendarViewDayWidth+2));
        int row = floorf(yLocation/(kVRGCalendarViewDayHeight+2));
        
        int blockNr = (column+1)+row*7;
        int firstWeekDay = [self.currentMonth firstWeekDayInMonth]-1; //-1 because weekdays begin at 1, not 0
        int date = blockNr-firstWeekDay;
        [self selectDate:date];
        return;
    }
    
    self.markedDates=nil;
    self.markedColors=nil;
    
    CGRect rectArrowLeft = CGRectMake(0, 0, xarrowmargin + arrowSize, 40);
    CGRect rectArrowRight = CGRectMake(self.frame.size.width-(xarrowmargin + arrowSize), 0, xarrowmargin + arrowSize, 40);
    
    //Touch either arrows or month in middle
    if (CGRectContainsPoint(rectArrowLeft, touchPoint)) {
        [self showPreviousMonth];
    } else if (CGRectContainsPoint(rectArrowRight, touchPoint)) {
        [self showNextMonth];
    } else if (CGRectContainsPoint(labelCurrentMonth.frame, touchPoint)) {
        //Detect touch in current month
        int currentMonthIndex = [self.currentMonth month];
        int todayMonth = [[NSDate date] month];
        [self reset];
//        if ((todayMonth!=currentMonthIndex) && [delegate respondsToSelector:@selector(calendarView:switchedToMonth:targetHeight:animated:)]) [delegate calendarView:self switchedToMonth:[currentMonth month] targetHeight:self.calendarHeight animated:NO];
//    }
}

}
-(void)selectDate:(int)date {
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = [gregorian components:NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit fromDate:self.currentMonth];
    [comps setDay:date];
    self.selectedDate = [gregorian dateFromComponents:comps];
    
    int selectedDateYear  = [self.selectedDate year];
    int selectedDateMonth = [self.selectedDate month];
    int currentMonthYear  = [self.currentMonth year];
    int currentMonthMonth = [self.currentMonth month];

    if (selectedDateYear < currentMonthYear) {
        [self showPreviousMonth];
    } else if (selectedDateYear > currentMonthYear) {
        [self showNextMonth];
    } else if (selectedDateMonth < currentMonthMonth) {
        [self showPreviousMonth];
    } else if (selectedDateMonth > currentMonthMonth) {
        [self showNextMonth];
    } else {
        [self setNeedsDisplay];
    }
}

#pragma mark - Next & Previous
-(void)showNextMonth {
//    NSLog(@"showNextMonth");
    if (isAnimating) return;
    
    if (self.limitOneYear && [self.currentMonth month] == 12)
        return;

    self.markedDates=nil;
    isAnimating=YES;
    prepAnimationNextMonth=YES;
    
    [self.delegate currentMonthWillChange:self month:[self.currentMonth offsetMonth:1]];
    
    [self setNeedsDisplay];
    
    int lastBlock = [self.currentMonth firstWeekDayInMonth]+[self.currentMonth numDaysInMonth]-1;
    int numBlocks = [self numRows]*7;
    BOOL hasNextMonthDays = lastBlock<numBlocks;
    
    //Old month
    float oldSize = self.calendarHeight;
    UIImage *imageCurrentMonth = [self drawCurrentState];
    
    //New month
    self.currentMonth = [self.currentMonth offsetMonth:1];
//    if ([delegate respondsToSelector:@selector(calendarView:switchedToMonth:targetHeight: animated:)]) [delegate calendarView:self switchedToMonth:[currentMonth month] targetHeight:self.calendarHeight animated:YES];
    prepAnimationNextMonth=NO;
    [self setNeedsDisplay];
    
    UIImage *imageNextMonth = [self drawCurrentState];
    float targetSize = fmaxf(oldSize, self.calendarHeight);
    UIView *animationHolder = [[UIView alloc] initWithFrame:CGRectMake(0, kVRGCalendarViewTopBarHeight, kVRGCalendarViewWidth, targetSize-kVRGCalendarViewTopBarHeight)];
    [animationHolder setClipsToBounds:YES];
    [self addSubview:animationHolder];

    
    //Animate
    self.animationView_A = [[UIImageView alloc] initWithImage:imageCurrentMonth];
    self.animationView_B = [[UIImageView alloc] initWithImage:imageNextMonth];
    [animationHolder addSubview:self.animationView_A];
    [animationHolder addSubview:self.animationView_B];
    
    if (hasNextMonthDays) {
        self.animationView_B.frameY = self.animationView_A.frameY + self.animationView_A.frameHeight - (kVRGCalendarViewDayHeight+3);
    } else {
        self.animationView_B.frameY = self.animationView_A.frameY + self.animationView_A.frameHeight -3;
    }
    
    //Animation
    __block CalendarView *blockSafeSelf = self;
    [UIView animateWithDuration:.35
                     animations:^{
                         [self updateSize];
                         //blockSafeSelf.frameHeight = 100;
                         if (hasNextMonthDays) {
                             self.animationView_A.frameY = -self.animationView_A.frameHeight + kVRGCalendarViewDayHeight+3;
                         } else {
                             self.animationView_A.frameY = -self.animationView_A.frameHeight + 3;
                         }
                         self.animationView_B.frameY = 0;
                     }
                     completion:^(BOOL finished) {
                         [self.animationView_A removeFromSuperview];
                         [self.animationView_B removeFromSuperview];
                         blockSafeSelf.animationView_A=nil;
                         blockSafeSelf.animationView_B=nil;
                         isAnimating=NO;
                         [animationHolder removeFromSuperview];
                        [self.delegate currentMonthDidChange:self month:self.currentMonth];
                     }
     ];
    
}

-(void)showPreviousMonth {
//    NSLog(@"");
    if (isAnimating) return;
    
    if (self.limitOneYear && [self.currentMonth month] == 1)
        return;
    
    isAnimating=YES;
    self.markedDates=nil;
    
    [self.delegate currentMonthWillChange:self month:[self.currentMonth offsetMonth:-1]];
    //Prepare current screen
    prepAnimationPreviousMonth = YES;
    [self setNeedsDisplay];
    BOOL hasPreviousDays = [self.currentMonth firstWeekDayInMonth]>1;
    float oldSize = self.calendarHeight;
    UIImage *imageCurrentMonth = [self drawCurrentState];
    
    //Prepare next screen
    self.currentMonth = [self.currentMonth offsetMonth:-1];
//    if ([delegate respondsToSelector:@selector(calendarView:switchedToMonth:targetHeight:animated:)]) [delegate calendarView:self switchedToMonth:[currentMonth month] targetHeight:self.calendarHeight animated:YES];
    prepAnimationPreviousMonth=NO;
    [self setNeedsDisplay];
    UIImage *imagePreviousMonth = [self drawCurrentState];
    
    float targetSize = fmaxf(oldSize, self.calendarHeight);
    UIView *animationHolder = [[UIView alloc] initWithFrame:CGRectMake(0, kVRGCalendarViewTopBarHeight, kVRGCalendarViewWidth, targetSize-kVRGCalendarViewTopBarHeight)];
    
    [animationHolder setClipsToBounds:YES];
    [self addSubview:animationHolder];
    
    self.animationView_A = [[UIImageView alloc] initWithImage:imageCurrentMonth];
    self.animationView_B = [[UIImageView alloc] initWithImage:imagePreviousMonth];
    [animationHolder addSubview:self.animationView_A];
    [animationHolder addSubview:self.animationView_B];
    
    if (hasPreviousDays) {
        self.animationView_B.frameY = self.animationView_A.frameY - (self.animationView_B.frameHeight-kVRGCalendarViewDayHeight) + 3;
    } else {
        self.animationView_B.frameY = self.animationView_A.frameY - self.animationView_B.frameHeight + 3;
    }
    
    __block CalendarView *blockSafeSelf = self;
    [UIView animateWithDuration:.35
                     animations:^{
                         [self updateSize];
                         
                         if (hasPreviousDays) {
                             self.animationView_A.frameY = self.animationView_B.frameHeight-(kVRGCalendarViewDayHeight+3);
                             
                         } else {
                             self.animationView_A.frameY = self.animationView_B.frameHeight-3;
                         }
                         
                         self.animationView_B.frameY = 0;
                     }
                     completion:^(BOOL finished) {
                         [self.animationView_A removeFromSuperview];
                         [self.animationView_B removeFromSuperview];
                         blockSafeSelf.animationView_A=nil;
                         blockSafeSelf.animationView_B=nil;
                         isAnimating=NO;
                         [animationHolder removeFromSuperview];
                        [self.delegate currentMonthDidChange:self month:self.currentMonth];
                     }
     ];
}


-(void)reset{
    
    NSCalendar * gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    [gregorian setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];
    
    NSDateComponents *components =
    [gregorian components:(NSYearCalendarUnit | NSMonthCalendarUnit |
                           NSDayCalendarUnit ) fromDate: [NSDate date]];
//    NSLog(@"~~~~~~~~components = %@",components);
    
    self.currentMonth = [gregorian dateFromComponents:components];
//    NSLog(@"今天是:%@",self.currentMonth);
    
    [self updateSize];
    [self.delegate currentMonthDidChange:self month:self.currentMonth];
}


#pragma mark - Draw image for animation
-(UIImage *)drawCurrentState {
    float targetHeight = kVRGCalendarViewTopBarHeight + [self numRows]*(kVRGCalendarViewDayHeight+2)+1;
    
    UIGraphicsBeginImageContext(CGSizeMake(kVRGCalendarViewWidth, targetHeight-kVRGCalendarViewTopBarHeight));
    CGContextRef c = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(c, 0, -kVRGCalendarViewTopBarHeight);    // <-- shift everything up by 40px when drawing.
    [self.layer renderInContext:c];
    UIImage* viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return viewImage;
}

#pragma mark - update size & row count
-(void)updateSize {
    self.frameHeight = [self calendarHeight];//日历的高度
    [self setNeedsDisplay];
}

#pragma mark - 日历的高度
-(float)calendarHeight{
    //距离顶部 + 本月所有的天数*宽度
    float f =  kVRGCalendarViewTopBarHeight + [self numRows]*(kVRGCalendarViewDayHeight+2)+1;
//    NSLog(@"本月日历高度:%f",f);
    return f;
}

#pragma mark - 显示本月需要多少行
-(int)numRows{
//    NSLog(@"本月共有%d天",[self.currentMonth numDaysInMonth]);//本月多少天
    float lastBlock = [self.currentMonth numDaysInMonth]+([self.currentMonth firstWeekDayInMonth]-1);
//    NSLog(@"本月日历显示%0.0f行",ceilf(lastBlock/7));
    return ceilf(lastBlock/7);
}

@end
