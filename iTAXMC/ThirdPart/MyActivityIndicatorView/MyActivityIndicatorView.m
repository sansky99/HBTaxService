//
//  MyActivityIndicatorView.m
//  qiyetong
//
//  Created by khuang on 14-5-21.
//  Copyright (c) 2014年 servyou. All rights reserved.
//

#import "MyActivityIndicatorView.h"

@implementation MyActivityIndicatorView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


- (id)initWithParentView:(UIView*)parentView
{
    self = [super initWithFrame:parentView.bounds];
    if (self) {
        // Initialization code
		self.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
		self.backgroundColor = [UIColor grayColor];
		self.alpha = 0.5;
		self.hidesWhenStopped = TRUE;
		[parentView addSubview:self];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
