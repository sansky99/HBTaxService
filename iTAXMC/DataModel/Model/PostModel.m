//
//  PostModel.m
//  iTAXMC
//
//  Created by hellen.zhou on 14-8-22.
//  Copyright (c) 2014年 servyou. All rights reserved.
//

#import "PostModel.h"
#import "JSONModel+networking.h"

@implementation PostModel

-(void)postJSONFromURLWithString:(NSString*)urlString params:(NSDictionary *)params completion:(void (^)(id model))completeBlock  andErrorCompelete:(void(^)(int code))errorBlock
{
    [JSONHTTPClient postJSONFromURLWithString:urlString params:params completion:^(NSDictionary* json, JSONModelError* err)
     {
         
         NSLog(@"urlString = %@   params=%@",urlString ,params);
         
         if (err)
         {
             // NSLog(@"%@",[err localizedDescription]);
             
             //出错处理 将出错的err.code传出去
             if (errorBlock)
             {
                 errorBlock(err.code);
                 return ;
             }
         }
         if(completeBlock)
         {
             id model = [self initWithDictionary:json error:&err];
             completeBlock(model);
         }
     }];
    
}



@end
