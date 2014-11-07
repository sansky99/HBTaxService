//
//  TestWebViewViewController.h
//  ZHTaxService
//
//  Created by 张乐 on 14-10-21.
//  Copyright (c) 2014年 servyou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TestWebViewViewController : UIViewController<UIWebViewDelegate>


{
    UIActivityIndicatorView *activityIndicatorView;
}

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end
