//
//  WebViewController.h
//  ZHTaxService
//
//  Created by mac on 14-9-29.
//  Copyright (c) 2014年 servyou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebViewController : UIViewController<UIWebViewDelegate>

@property (nonatomic, strong) IBOutlet UIWebView *webView;

//模块数据
@property (nonatomic, strong) NSArray *moduleItems;


@end
