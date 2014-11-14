//
//  ASIFormDataRequest+HBData.h
//  HBTaxService
//
//  Created by khuang on 14-11-14.
//  Copyright (c) 2014年 servyou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIFormDataRequest.h"

@interface ASIFormDataRequest(HBData)
+(ASIFormDataRequest*) requestWithID:(NSString*) tradeID andBody:(NSString*) body;

@end
