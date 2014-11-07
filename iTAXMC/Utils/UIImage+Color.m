//
//  UIImage+Color.m
//  iTAXMC
//
//  Created by hellen.zhou on 14-8-29.
//  Copyright (c) 2014年 servyou. All rights reserved.
//

#import "UIImage+Color.h"

@implementation UIImage (Color)
+ (UIImage *)imageWithRect:(CGRect)rect color:(UIColor *)color
{
 
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end
