//
//  UploadSourceViewController.h
//  HBTaxService
//
//  Created by khuang on 14-11-4.
//  Copyright (c) 2014年 servyou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CachedImageItem : NSObject
@property (nonatomic, strong) NSString *path;
@property (nonatomic, strong) UIImage *image;
@end


@interface UploadSourceViewController : UIViewController

@property (nonatomic, strong) NSNumber *typeID;
@property (nonatomic, strong) NSString *typeName;
@property (nonatomic, strong) NSString *nsrsbh;

@end
