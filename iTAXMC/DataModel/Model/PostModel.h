//
//  PostModel.h
//  iTAXMC
//
//  Created by hellen.zhou on 14-8-22.
//  Copyright (c) 2014年 servyou. All rights reserved.
//

#import "JSONModel.h"

// to do ?
// ......
@interface PostModel : JSONModel

-(void)postJSONFromURLWithString:(NSString*)urlString params:(NSDictionary *)params completion:(void (^)(id model))completeBlock  andErrorCompelete:(void(^)(int code))errorBlock;

@end
