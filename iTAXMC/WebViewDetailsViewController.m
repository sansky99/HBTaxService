//
//  WebViewDetailsViewController.m
//  XJTaxService
//
//  Created by 张乐 on 14-9-14.
//  Copyright (c) 2014年 servyou. All rights reserved.
//

#import "WebViewDetailsViewController.h"

@interface WebViewDetailsViewController ()

@end

@implementation WebViewDetailsViewController

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
    
    self.title = self.vcTitle;
    
    self.webView.scalesPageToFit =YES;
    self.webView.delegate =self;
    
    activityIndicatorView = [[UIActivityIndicatorView alloc]
                             initWithFrame : CGRectMake(0.0f, 0.0f, 32.0f, 32.0f)] ;
    [activityIndicatorView setCenter: self.view.center] ;
    [activityIndicatorView setActivityIndicatorViewStyle: UIActivityIndicatorViewStyleWhite] ;
    [self.view addSubview : activityIndicatorView] ;

    UserInfo *userInfo = [ServyouDefines sharedUserInfo];
    NSString *token = userInfo.token;
    NSString *urlString = [[NSString alloc] initWithFormat:@"%@&token=%@",self.requestURL,token];
    NSURL * url = [NSURL URLWithString:urlString];

    NSLog(@"url = %@",url);
    NSURLRequest *request =[NSURLRequest requestWithURL:url];
    
    [self.webView loadRequest:request];
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
    // Dispose of any resources that can be recreated.
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
