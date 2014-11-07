//
//  TestWebViewViewController.m
//  ZHTaxService
//
//  Created by 张乐 on 14-10-21.
//  Copyright (c) 2014年 servyou. All rights reserved.
//

#import "TestWebViewViewController.h"

@interface TestWebViewViewController ()

@end

@implementation TestWebViewViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"税务在线咨询";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    UIWebView * webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    
    if (IOS_7) {
        webView.frame = CGRectMake(0, 70, ScreenWidth, ScreenHeight-70);
    }else{
        webView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight-65);
    }
    webView.scalesPageToFit =YES;
    webView.delegate =self;

    activityIndicatorView = [[UIActivityIndicatorView alloc]
                             initWithFrame : CGRectMake(0.0f, 0.0f, 32.0f, 32.0f)];
    [activityIndicatorView setCenter: self.view.center] ;
    [activityIndicatorView setActivityIndicatorViewStyle: UIActivityIndicatorViewStyleWhite] ;
    [self.view addSubview : activityIndicatorView] ;

    UserInfo *userInfo = [ServyouDefines sharedUserInfo];
    NSString *token = userInfo.token;
    
    
    NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"http://183.57.17.83/web_chat/openMobileChat.do?token=%@",token]];
    NSLog(@"url = %@",url);
    NSURLRequest *request =[NSURLRequest requestWithURL:url];
    
    [webView loadRequest:request];
    
    webView.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:webView];
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [activityIndicatorView startAnimating] ;
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [activityIndicatorView stopAnimating];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    UIAlertView *alterview = [[UIAlertView alloc] initWithTitle:@"" message:[error localizedDescription]  delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    [alterview show];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
