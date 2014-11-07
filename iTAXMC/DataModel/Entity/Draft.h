//
//  Draft.h
//  iTAXMC
//
//  Created by hellen.zhou on 14-8-25.
//  Copyright (c) 2014年 servyou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"

@protocol Draft<NSObject>@end

@interface Draft : JSONModel
@property(nonatomic,strong) NSString *id;
@property(nonatomic,strong) NSString  *typeName;
@property(nonatomic,strong) NSString  *title;
@property(nonatomic,strong) NSString  *orginDetailAddress;
@property(nonatomic,strong) NSString<Optional> *picUrl;
@property(nonatomic,strong) NSString  *publishDate;
@property(nonatomic,strong) NSString  *author;
@end
