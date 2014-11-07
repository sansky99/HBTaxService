//
//  WebMethodFactory.m
//  iTAXMC
//
//  Created by hellen.zhou on 14-8-22.
//  Copyright (c) 2014年 servyou. All rights reserved.
//

#import "RemoteMethodFactory.h"

@implementation RemoteMethodFactory

//+(void)postInformationWithAction:(NSString*)action Complete:(void (^)(id))completeBlock
//                   andErrorCompelete:(void(^)(int))errorBlock {
//    NSString *urlString = [NSString stringWithUTF8String:(const char*)&FULLPATH_FOR_ACTION(INFORMATION_ACTION)];
// 
//    NSDictionary *params = @{REGION_TYPE:REGION_VALUE,ACTION_TYPE:action,OFFSET:@"0",NEEDPIC:@"0",NEEDREMARK:@"0"};
// 
//    [[InformationModel alloc]postJSONFromURLWithString:urlString params:params completion:completeBlock andErrorCompelete:errorBlock];
//}

+(void)postInformationWithAction:(NSString*)action  offset:(NSString *)offset needPicture:(NSString *)picture needRemark:(NSString *)remark Complete:(void (^)(id))completeBlock
               andErrorCompelete:(void(^)(int))errorBlock {
   
    const char *urlUTF8 = (const char*)&FULLPATH_FOR_ACTION(INFORMATION_ACTION);
    
    NSString *urlString = [NSString stringWithUTF8String:urlUTF8];
    
    NSDictionary *params = @{REGION_TYPE:REGION_VALUE,ACTION_TYPE:action,OFFSET:offset,NEEDPIC:picture,NEEDREMARK:remark};
    
    [[InformationModel alloc]postJSONFromURLWithString:urlString params:params completion:completeBlock andErrorCompelete:errorBlock];
}

+(void)postInformationWithAction:(NSString*)action  title:(NSString*)title offset:(NSString *)offset needPicture:(NSString *)picture needRemark:(NSString *)remark Complete:(void (^)(id))completeBlock
               andErrorCompelete:(void(^)(int))errorBlock {
    
    const char *urlUTF8 = (const char*)&FULLPATH_FOR_ACTION(INFORMATION_ACTION);
    
    NSString *urlString = [NSString stringWithUTF8String:urlUTF8];
    
    if (title) {
        NSDictionary *params = @{REGION_TYPE:REGION_VALUE,ACTION_TYPE:action,OFFSET:offset,NEEDPIC:picture,NEEDREMARK:remark,TITILE:title};
        
        [[InformationModel alloc]postJSONFromURLWithString:urlString params:params completion:completeBlock andErrorCompelete:errorBlock];
    } else {
        NSDictionary *params = @{REGION_TYPE:REGION_VALUE,ACTION_TYPE:action,OFFSET:offset,NEEDPIC:picture,NEEDREMARK:remark};
        
        [[InformationModel alloc]postJSONFromURLWithString:urlString params:params completion:completeBlock andErrorCompelete:errorBlock];
    }
   
}



+(void)postDetailInfoWithId:(NSString *)aId  Complete:(void (^)(id))completeBlock
          andErrorCompelete:(void(^)(int))errorBlock {
    
    NSString *url = [NSString stringWithUTF8String:(const char*) &FULLPATH_FOR_ACTION(DETAILINFO_ACTION)];
    NSDictionary *params = @{REGION_TYPE: REGION_VALUE,ID:aId};
    
    [[DetailInfoModel alloc] postJSONFromURLWithString:url params:params completion:completeBlock andErrorCompelete:errorBlock];
    
    
}

+(void)postInformationWithparams:(NSDictionary *)params
                        Complete:(void (^)(id))completeBlock
               andErrorCompelete:(void(^)(int))errorBlock
{
    const char *urlUTF8 = (const char*)&FULLPATH_FOR_ACTION(INFORMATION_ACTION);
    
    NSString *urlString = [NSString stringWithUTF8String:urlUTF8];
    
    [[InformationModel alloc]postJSONFromURLWithString:urlString params:params completion:completeBlock andErrorCompelete:errorBlock];
}

@end
