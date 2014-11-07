//
//  WebViewDetailsViewController.h
//  XJTaxService
//
//  Created by 张乐 on 14-9-14.
//  Copyright (c) 2014年 servyou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebViewDetailsViewController : UIViewController<UIWebViewDelegate>

{
    UIActivityIndicatorView *activityIndicatorView;
}

@property (nonatomic,retain) NSString * vcTitle;

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@property (nonatomic,retain)NSString * url;

@property (nonatomic, strong) NSString *requestURL;

@end
