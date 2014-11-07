//
//  MessageCenter.h
//  iTAXMC
//
//  Created by khuang on 14-7-10.
//  Copyright (c) 2014年 servyou. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const kNewMessageNotification;
extern NSString *const kNewMessageNotification_Type;


@interface MessageCenter : NSObject

+(MessageCenter*) sharedMessageCenter;

-(void) refreshMessages;
-(void) refreshMessages:(NSArray*) moduleIDs;
-(void) refreshMessage:(NSNumber*) moduleID;

@end
