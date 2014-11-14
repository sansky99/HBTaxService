//
//  CalendarViewController.m
//  XJTaxService
//
//  Created by khuang on 14-9-23.
//  Copyright (c) 2014年 servyou. All rights reserved.
//

#import "CalendarViewController.h"
#import "CalendarView.h"
#import "CompatibleaPrintf.h"
#import "ASIHTTPRequest.h"
#import "JSONKit.h"
#import "ASIFormDataRequest+HBData.h"
#import "NSDate+convenience.h"

NSString *kCalendarDay = @"kCalendarDay";
NSString *kCalendarData = @"kCalendarData";

@implementation CalendarItem
@synthesize month, day, content;

-(void)encodeWithCoder:(NSCoder *)aCoder{
    //encode properties/values
    [aCoder encodeObject:self.month      forKey:@"month"];
    [aCoder encodeObject:self.day  forKey:@"day"];
    [aCoder encodeObject:self.content      forKey:@"content"];
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    if((self = [super init])) {
        //decode properties/values
        self.month       = [aDecoder decodeObjectForKey:@"month"];
        self.day   = [aDecoder decodeObjectForKey:@"day"];
        self.content       = [aDecoder decodeObjectForKey:@"content"];
    }
    
    return self;
}
@end


@interface CalendarViewController () <CalendarViewDelegate>
@property (nonatomic, strong) CalendarView *calendarView;
@property (nonatomic, strong) ASIFormDataRequest *httpRequest;
@property (nonatomic, strong) NSArray *calendarItems;
@property (nonatomic, strong) NSArray *monthItems;
@property (nonatomic, strong) NSMutableArray *contentViews;
@end

@implementation CalendarViewController
@synthesize moduleID, calendarView, contentViews;

+(UIImage*) msgBG
{
    static UIImage *bg=nil;
    if (bg == nil)
    {
        UIEdgeInsets insets = UIEdgeInsetsMake(15, 10, 5, 5);
        bg = [[UIImage imageNamed:@"calendarMsgBG"] resizableImageWithCapInsets:insets];
    }
    return bg;
}

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
    
    self.title = @"办税日历";
    self.view.backgroundColor = [UIColor whiteColor];
    contentViews = [[NSMutableArray alloc] initWithCapacity:20];
    
    calendarView = [[CalendarView alloc] init];
    calendarView.limitOneYear = TRUE;
    [self.view addSubview:calendarView];
    calendarView.delegate = self;
    
    [self updateCalendar];
}

-(void) viewDidLayoutSubViews
{
    double width = self.view.frame.size.width;
    calendarView.frame = CGRectMake(0, 0, width, width);
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

-(void) updateCalendar
{
    BOOL bUpdate = TRUE;
    
    NSDate *date = [NSDate date];

    NSArray *day =  [[NSUserDefaults standardUserDefaults] arrayForKey:kCalendarDay];
    if (day != nil && day.count >= 3)
    {
        if ([day[0] integerValue] == date.year
                && [day[1] integerValue] == date.month
                && [day[2] integerValue] == date.day)
            bUpdate = FALSE;
    }
    
    if (bUpdate)
    {
            [self.httpRequest cancel];
        
            NSString *body = [NSString stringWithFormat:@"{\"year\":\"%ld\"}", (long)date.year];
            self.httpRequest = [ASIFormDataRequest requestWithID:@"APP.BSRL.QUERY" andBody:body];

            self.httpRequest.delegate = self;
            [self.httpRequest startAsynchronous];
    }
    else
    {
        [self reloadCalendar:[NSDate date]];
    }
}

-(void) reloadCalendar
{
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:kCalendarData];
    NSArray *items = (NSArray *)[NSKeyedUnarchiver unarchiveObjectWithData:data];
    if (items)
    {
        @synchronized(self.calendarItems)
        {
            self.calendarItems = items;
        }
    }
}

-(NSArray*) reloadCalendar:(NSDate*) date
{
    NSMutableArray *items = [[NSMutableArray alloc] init];
    [self reloadCalendar];
    
    @synchronized(self.calendarItems)
    {
        for (CalendarItem* item in self.calendarItems)
        {
            if (date.month == [item.month integerValue])
                [items addObject:item];
        }
        [items sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            CalendarItem* ci1 = (CalendarItem*)obj1;
            CalendarItem* ci2 = (CalendarItem*)obj2;
            if (ci1 && ci2)
            {
                return ([ci1.day integerValue] > [ci2.day integerValue]);
            }
            return NSOrderedSame;
        }];
    }
    
    for (UIControl *label in contentViews) {
        [label removeFromSuperview];
    }
    [contentViews removeAllObjects];
    
    CGRect rt = CGRectMake(0, 0, 320,  /*290*/self.calendarView.calendarHeight);
    double leftHeight = 32, span = 16;
    for (CalendarItem* item in items)
    {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, rt.origin.y + rt.size.height + span, leftHeight, leftHeight)];
        label.text = [NSString stringWithFormat:@"%@", item.day];
        label.backgroundColor = [ServyouDefinesUI ColorOrange];
        label.textColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.layer.cornerRadius = leftHeight / 2;
        label.layer.masksToBounds = TRUE;
        [self.view addSubview:label];
        [self.contentViews addObject:label];

        
         label = [[UILabel alloc] initWithFrame:CGRectMake(15 + leftHeight + span, rt.origin.y + rt.size.height + span, 250, leftHeight )];
        label.text = [NSString stringWithFormat:@"%@", item.content];
        label.adjustsFontSizeToFitWidth = TRUE;
        label.numberOfLines = 0;
        label.minimumScaleFactor = [UIFont smallSystemFontSize] / [label.font pointSize];
        label.backgroundColor = [UIColor clearColor];
        [self.view addSubview:label];
        rt = label.frame;
        [self.contentViews addObject:label];
        
        UIImageView *imageLayer = [[UIImageView alloc] initWithFrame: CGRectMake(rt.origin.x - span, rt.origin.y, rt.size.width, rt.size.height) ];
        imageLayer.image = [CalendarViewController msgBG];
//         imageLayer.contents = (id)[CalendarViewController msgBG].CGImage;
       [self.view insertSubview:imageLayer belowSubview:label];
        [self.contentViews addObject:imageLayer];
    }
    
    self.monthItems = items;
    return items;
}

-(void) saveCalendar : (NSArray*) items
{
    if (items)
    {
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:items];
        [[NSUserDefaults standardUserDefaults] setObject:data forKey:kCalendarData];
        
        NSDate *date = [NSDate date];
        [[NSUserDefaults standardUserDefaults] setObject:@[
                                                           [NSNumber numberWithInteger:date.year]
                                                           , [NSNumber numberWithInteger:date.month]
                                                           , [NSNumber numberWithInteger:date.day]] forKey:kCalendarDay];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - ASIHTTPRequestDelegate
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)requestFailed:(ASIHTTPRequest *)theRequest
{
	NSLog(@"%@", [NSString stringWithFormat:@"Request failed:\r\n%@",[[theRequest error] localizedDescription]]);
}

- (void)requestFinished:(ASIHTTPRequest *)theRequest
{
    theRequest.responseEncoding = NSUTF8StringEncoding;
    NSLog(@"%@", theRequest.responseString);
    NSDictionary *result = [theRequest.responseString objectFromJSONString];
    NSDictionary *context = [[result objectForKey:@"context"] objectFromJSONString];
    NSNumber *success = [context objectForKey:@"success"];
    if ([success boolValue])
    {
        NSMutableArray *calendarItems = [[NSMutableArray alloc] init];
        NSArray *data = [context objectForKey:@"data"];

        for (NSDictionary *item in data)
        {
            NSString *strDate = [item objectForKey:@"sbjkqx"];
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat = @"M月dd日";
            NSDate *date = [formatter dateFromString:strDate];
            
            CalendarItem *ci = [[CalendarItem alloc] init];
            
            ci.month = [NSNumber numberWithInteger:date.month];
            ci.day = [NSNumber numberWithInteger:date.day];
            ci.content = [item objectForKey:@"xm"];
            [calendarItems addObject:ci];
        }

        [self saveCalendar:calendarItems];
        [self reloadCalendar:self.calendarView.currentMonth];
    }
}

#pragma mark - CalendarViewDelegate
-(void) currentMonthWillChange:(CalendarView*) caleView month:(NSDate*) month
{
    for (UILabel *label in contentViews) {
        [label removeFromSuperview];
    }
    [contentViews removeAllObjects];
    caleView.flagDays = nil;
 
}
-(void) currentMonthDidChange:(CalendarView*) caleView month:(NSDate*) month
{
    [self reloadCalendar:month];
    NSMutableArray *days = [[NSMutableArray alloc] initWithCapacity:5];
    for (CalendarItem* item in self.monthItems)
    {
        [days addObject: item.day];
    }
    caleView.flagDays = days;
    [caleView setNeedsDisplay];
}
@end
