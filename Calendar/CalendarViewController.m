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
@property (nonatomic, strong) ASIHTTPRequest *httpRequest;
@property (nonatomic, strong) NSArray *calendarItems;
@property (nonatomic, strong) NSArray *monthItems;
@property (nonatomic, strong) NSMutableArray *contentViews;
@end

@implementation CalendarViewController
@synthesize moduleID, calendarView, contentViews;

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
    self.view.backgroundColor = [ServyouDefinesUI ColorGray];
    contentViews = [[NSMutableArray alloc] initWithCapacity:3];
    
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
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *component = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:[NSDate date]];
    NSArray *day =  [[NSUserDefaults standardUserDefaults] arrayForKey:kCalendarDay];
    if (day != nil && day.count >= 3)
    {
        if ([day[0] integerValue] == component.year
                && [day[1] integerValue] == component.month
                && [day[2] integerValue] == component.day)
            bUpdate = FALSE;
    }
    
    if (bUpdate)
    {
        NSArray *module = [ServyouDefines getModule:moduleID];
        if (module)
        {
            [self.httpRequest cancel];
            NSString *url = [NSString stringWithFormat:@"%@%@?year=%d", HB_HTTP_URL, module[Col_URL], component.year];
            self.httpRequest = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
            self.httpRequest.delegate = self;
            [self.httpRequest startAsynchronous];
        }
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
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *component = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];

    @synchronized(self.calendarItems)
    {
        for (CalendarItem* item in self.calendarItems)
        {
            if (component.month == [item.month integerValue])
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
    
    for (UILabel *label in contentViews) {
        [label removeFromSuperview];
    }
    [contentViews removeAllObjects];
    
    CGRect rt = CGRectMake(0, 0, 320,  /*290*/self.calendarView.calendarHeight);
    double leftHeight = 32, span = 6;
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
        
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *component = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:[NSDate date]];
        [[NSUserDefaults standardUserDefaults] setObject:@[
                                                           [NSNumber numberWithInteger:component.year]
                                                           , [NSNumber numberWithInteger:component.month]
                                                           , [NSNumber numberWithInteger:component.day]] forKey:kCalendarDay];
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
//    NSLog(@"%@", theRequest.responseString);
    NSDictionary *result = [theRequest.responseString objectFromJSONString];
    
    if ([ServyouDefines isServerResultSuccessed:result])
    {
        NSMutableArray *calendarItems = [[NSMutableArray alloc] init];
        NSArray *body = [result objectForKey:@"body"];
        if ([body isKindOfClass:[NSArray class]])
        {
            for (NSArray *items in body)
            {
                for (NSDictionary *item in items)
                {
                    CalendarItem *ci = [[CalendarItem alloc] init];
                    ci.month = [NSNumber numberWithInteger: [[item objectForKey:@"month"] integerValue]];
                    ci.day = [NSNumber numberWithInteger: [[item objectForKey:@"day"] integerValue]];
                    ci.content = [item objectForKey:@"content"];
                    [calendarItems addObject:ci];
                }
            }
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
