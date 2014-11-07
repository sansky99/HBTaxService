//
//  DetailInfoModel.h
//  iTAXMC
//
//  Created by zbq on 14-9-5.
//  Copyright (c) 2014年 servyou. All rights reserved.
//

#import "PostModel.h"
#import "HeadMessage.h"
#import "DetailBody.h"

#define DETAILINFO_ACTION      xxcj/infoDetail/get
#define ID                       @"id"
#define REGION_TYPE              @"regionCode"
#define REGION_VALUE             @"xj"

@interface DetailInfoModel : PostModel
@property (nonatomic,strong) HeadMessage *head;
@property (nonatomic,strong) DetailBody  *body;
@end
