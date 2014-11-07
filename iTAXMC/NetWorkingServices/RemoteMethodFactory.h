//
//  WebMethodFactory.h
//  iTAXMC
//
//  Created by hellen.zhou on 14-8-22.
//  Copyright (c) 2014年 servyou. All rights reserved.
//

#import <Foundation/Foundation.h>

#define REMOTE_HOST_ADDRESS	"http://mobile.servyou.com.cn/"
#define STRING_JOIN(S1,S2) S1#S2
#define FULLPATH_FOR_ACTION(ACTION) STRING_JOIN(REMOTE_HOST_ADDRESS,ACTION)
 
#import "InformationModel.h"
#import "DetailInfoModel.h"

@interface RemoteMethodFactory : NSObject

//+(void)postInformationWithAction:(NSString*)action   Complete:(void (^)(id))completeBlock
//               andErrorCompelete:(void(^)(int))errorBlock;

+(void)postInformationWithAction:(NSString*)action  offset:(NSString *)offset needPicture:(NSString *)picture needRemark:(NSString *)remark Complete:(void (^)(id))completeBlock
               andErrorCompelete:(void(^)(int))errorBlock;

+(void)postInformationWithAction:(NSString*)action  title:(NSString*)title offset:(NSString *)offset needPicture:(NSString *)picture needRemark:(NSString *)remark Complete:(void (^)(id))completeBlock
               andErrorCompelete:(void(^)(int))errorBlock;

+(void)postDetailInfoWithId:(NSString *)aId  Complete:(void (^)(id))completeBlock
          andErrorCompelete:(void(^)(int))errorBlock;

+(void)postInformationWithparams:(NSDictionary *)params
                        Complete:(void (^)(id))completeBlock
               andErrorCompelete:(void(^)(int))errorBlock;
@end
