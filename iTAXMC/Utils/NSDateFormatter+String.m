//
//  NSDateFormatter+String.m
//  iTAXMC
//
//  Created by hellen.zhou on 14-9-9.
//  Copyright (c) 2014年 servyou. All rights reserved.
//

#import "NSDateFormatter+String.h"

@implementation NSDateFormatter (String)
+(NSString *) distanceNowWithTime:(NSString*)timeString {
   
    if (timeString == nil) {
        return  nil;
    }
    
    NSString *localtimeString = nil;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init] ;
   [dateFormatter setDateFormat:@"yy-M-d HH:mm:ss"];
    NSDate *date=[dateFormatter dateFromString:timeString];
    
   /* if (nil == date)
    {
        [dateFormatter setDateFormat:@"yyyy-MM-DD"];
        date=[dateFormatter dateFromString:timeString];
    }
    */
    
    if (nil == date)
    {
        return timeString;
    }
 
    int secondsDifference = (int) [date timeIntervalSinceNow] *(-1);
	int minutes = secondsDifference/60; // Seconds over the fill hour
	int hours = secondsDifference/3600;
	int days = secondsDifference/86400;
    
    if(days>0)
    {
		NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
		[dateFormatter setDateFormat:@"yyyy-M-d"];
		NSString *strDate = [dateFormatter stringFromDate:date];
		localtimeString = [[NSString alloc] initWithString:strDate];
    }
	else if(hours>0)
    {
        localtimeString = [[NSString alloc] initWithFormat:@"%d小时前",hours];
    }
	else if(minutes>0)
    {
        localtimeString = [[NSString alloc] initWithFormat:@"%d分钟前",minutes];
    }
	else
    {
        localtimeString = @"刚刚";
		//retString=[[NSString alloc] initWithFormat:@"%d秒前",secondsDifference];
    }
    
    return localtimeString;
}


@end
