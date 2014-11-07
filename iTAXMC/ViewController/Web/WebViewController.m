//
//  WebViewController.m
//  ZHTaxService
//
//  Created by mac on 14-9-29.
//  Copyright (c) 2014年 servyou. All rights reserved.
//

#import "WebViewController.h"
#import "MyActivityIndicatorView.h"
#import "NSData+Encryption.h"

@interface WebViewController ()
{
    //风火轮
    MyActivityIndicatorView *activityIndicatorView;
}
@end

@implementation WebViewController
@synthesize webView = _webView;
@synthesize moduleItems = _moduleItems;


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
    activityIndicatorView = [[MyActivityIndicatorView alloc] initWithParentView:self.view];
    [activityIndicatorView startAnimating] ;
    if (self.moduleItems) {
        
        self.title = self.moduleItems[Col_Name];
        NSString *urlStr = self.moduleItems[Col_URL];
        if ([self.moduleItems[Col_NeedLogin] boolValue])
        {
            //对纳税人识别号加密
            NSString *nsrsbh = [ServyouDefines sharedUserInfo].nsrsbhStr;
            NSString *key = [ServyouDefines sharedUserInfo].key;
            NSData *nsrsbhData = [nsrsbh dataUsingEncoding:NSUTF8StringEncoding];
            NSData *nsrsbhEncry = [nsrsbhData DESEncryptWithKey:key];
            NSString *nsrsbhStr = [ServyouDefines hexStringFromData:nsrsbhEncry];
            nsrsbhStr = nsrsbhStr.uppercaseString;
            NSString *channelID = @"STJRIOS";
            UserInfo *user = [ServyouDefines sharedUserInfo];
            NSString *userID = user.userID;

            NSString *tempUrl = [[NSString alloc] initWithFormat:urlStr,nsrsbhStr,channelID,userID];
            urlStr = tempUrl;
            
            urlStr = [[NSString alloc] initWithFormat:@"%@%@",SERVER_WTPUBLIC,urlStr];
        }
        
        NSURL *url = [[NSURL alloc] initWithString:urlStr];
        NSURLRequest *request =[NSURLRequest requestWithURL:url];
        [self.webView loadRequest:request];
        self.webView.delegate = self;
    }

}

#if 0
- (NSString *)hexStringFromData:(NSData *)aData{
    Byte *bytes = (Byte *)[aData bytes];
    //下面是Byte 转换为16进制。
    NSString *hexStr=@"";
    for(int i=0;i<[aData length];i++)
        
    {
        NSString *newHexStr = [NSString stringWithFormat:@"%x",bytes[i]&0xff];///16进制数
        
        if([newHexStr length]==1)
            
            hexStr = [NSString stringWithFormat:@"%@0%@",hexStr,newHexStr];
        
        else
            
            hexStr = [NSString stringWithFormat:@"%@%@",hexStr,newHexStr];
    }
    return hexStr;
}
#endif

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [activityIndicatorView startAnimating] ;
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [activityIndicatorView stopAnimating];
}


- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    UIAlertView *alterview = [[UIAlertView alloc] initWithTitle:@""
                                                        message:[error localizedDescription]
                                                       delegate:nil
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"OK", nil];
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
