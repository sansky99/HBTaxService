//
//  HeadMessage.h
//  iTAXMC
//
//  Created by hellen.zhou on 14-8-22.
//  Copyright (c) 2014年 servyou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"

@interface HeadMessage : JSONModel
@property(nonatomic,strong) NSString *code;
@property(nonatomic,strong) NSString *msg;
@property(nonatomic,strong) NSString *time;
@end
