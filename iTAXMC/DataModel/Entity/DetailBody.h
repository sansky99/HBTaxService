//
//  DetailBody.h
//  iTAXMC
//
//  Created by zbq on 14-9-5.
//  Copyright (c) 2014年 servyou. All rights reserved.
//

#import "JSONModel.h"

@interface DetailBody : JSONModel
@property(nonatomic,strong) NSString *id;
@property(nonatomic,strong) NSString *content;
@property(nonatomic,strong) NSString *title;
@property(nonatomic,strong) NSString<Optional> *detailUrl;

@end
