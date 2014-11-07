//
//  BodyMessage.h
//  iTAXMC
//
//  Created by hellen.zhou on 14-8-22.
//  Copyright (c) 2014年 servyou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"
#import "Draft.h"

@interface BodyMessage : JSONModel
@property(nonatomic,strong) NSMutableArray<Draft> *list;
@property(nonatomic,strong) NSString<Optional> *remark;
@end
