//
//  PostModel.h
//  iTAXMC
//
//  Created by hellen.zhou on 14-8-22.
//  Copyright (c) 2014年 servyou. All rights reserved.
//

#import "JSONModel.h"

@interface PostModel : JSONModel

-(void)postJSONFromURLWithStringBase:(NSString*)urlString params:(NSMutableDictionary *)params completion:(void (^)(id model))completeBlock  andErrorCompelete:(void(^)(int code))errorBlock;

@end
