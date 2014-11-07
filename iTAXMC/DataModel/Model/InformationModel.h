//
//  TaxInformationModel.h
//  iTAXMC
//
//  Created by hellen.zhou on 14-8-25.
//  Copyright (c) 2014年 servyou. All rights reserved.
//

#import "PostModel.h"
#import "HeadMessage.h"
#import "BodyMessage.h"

//typedef NS_ENUM(NSUInteger,actionType)
//{
//    taxNotice,  //涉税公告
//    news,       //新闻
//};
//
//typedef NS_ENUM(NSUInteger, regionCode)
//{
//    xj
//};

#define INFORMATION_ACTION       xxcj/information/get
#define STEP_SIZE                50
#define REGION_TYPE              @"regionCode"
#define REGION_VALUE             @"xj"
#define ACTION_TYPE              @"type"
#define OFFSET                   @"offset"
#define NEEDPIC                  @"needPic"
#define NEEDREMARK               @"needRemark"
#define TITILE                   @"title"

#define ktaxNotice               @"taxNotice"
#define kNews                    @"news"

@interface InformationModel : PostModel
@property(nonatomic,strong) HeadMessage *head;
@property(nonatomic,strong) BodyMessage *body;
@end
