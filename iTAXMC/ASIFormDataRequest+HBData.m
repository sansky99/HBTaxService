//
//  ASIFormDataRequest+HBData.m
//  HBTaxService
//
//  Created by khuang on 14-11-14.
//  Copyright (c) 2014年 servyou. All rights reserved.
//

#import "ASIFormDataRequest+HBData.h"


static NSString *DES_KEY = @"JDLSJDLS";
static NSString *HB_HTTP_URL = @"http://192.168.29.102:7001/bondegate/bondeServiceServlet";


@implementation ASIFormDataRequest(HBData)

+(ASIFormDataRequest*) requestWithID:(NSString*) tradeID andBody:(NSString*) body
{
    ASIFormDataRequest * request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:HB_HTTP_URL]];
    request.requestMethod = @"POST";
    [request addRequestHeader:@"TradeId" value:tradeID];
    [request addRequestHeader:@"MessageType" value:@"JSON-HTTP"];
    [request addRequestHeader:@"ChannelId" value:@"HB_APP"];
    [request addRequestHeader:@"Controls" value:@"crypt,DES;code,BASE64;"];
    
    NSData *bodyData = [body dataUsingEncoding:NSUTF8StringEncoding];
    NSData *bodyEncode = [UserInfo DESEncrypt:bodyData WithKey:DES_KEY];
    [request appendPostString: [ASIHTTPRequest base64forData:bodyEncode]];
  
    return request;
}

@end
