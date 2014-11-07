//
//  ClearCacheViewController.m
//  iTAXMC
//
//  Created by khuang on 14-7-17.
//  Copyright (c) 2014年 servyou. All rights reserved.
//

#import "ClearCacheViewController.h"


@interface ClearCacheViewController ()

@end

@implementation ClearCacheViewController

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
//    MRCircularProgressView *progressView = [[MRCircularProgressView alloc] initWithFrame:CGRectMake(20, 100, 200, 100)];
//    [self.view addSubview:progressView];
//    progressView.backgroundColor = [UIColor whiteColor];
    //                progressView.tintColor = [UIColor blueColor];
    [self.progressView setText:@"正在清理缓存..."];
    __block BOOL bClear = TRUE;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //刷新progress
        while (bClear)
        {
            for (int i=1; i<=6; i++)
            {
                dispatch_async(dispatch_get_main_queue(),^{
                    [self.progressView setProgress:i*0.2 animated:YES];
                });
                if (!bClear)
                    break;
                [NSThread sleepForTimeInterval:0.2];
            }
            if (!bClear)
                break;
            dispatch_async(dispatch_get_main_queue(),^{
                [self.progressView setProgress:0];
            });
        }
        
        dispatch_async(dispatch_get_main_queue(),^{
            [self.progressView setProgress:1 animated:YES];
            [self.progressView setText:@"缓存清理完毕"];
        });
        
        dispatch_time_t popTime1 = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC));
        dispatch_after(popTime1, dispatch_get_main_queue(), ^{
            [self.progressView setProgress:0];
        });
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^{
           [self dismissViewControllerAnimated:FALSE completion:nil];
        });
    });
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
       //清理缓存
        [NSThread sleepForTimeInterval:5];
        bClear = FALSE;
    });
//    [self simulateProgressView:self.progressView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)onTapCancel:(id)sender {
}


- (void)simulateProgressView:(MRCircularProgressView *)progressView
{
    static int i=0;
//    [self.progressView show:YES];
    [self performBlock:^{
        [progressView setProgress:0.2 animated:YES];
        [self performBlock:^{
            [progressView setProgress:0.3 animated:YES];
            [self performBlock:^{
                [progressView setProgress:0.5 animated:YES];
                [self performBlock:^{
                    [progressView setProgress:0.4 animated:YES];
                    [self performBlock:^{
                        [progressView setProgress:0.8 animated:YES];
                        [self performBlock:^{
                            [progressView setProgress:1.0 animated:YES];
                            [self performBlock:^{
                                if (++i%2==1) {
                                    //                                    progressView.mode = MRProgressOverlayViewModeCheckmark;
                                    //                                    progressView.titleLabelText = @"Succeed";
                                } else {
                                    //                                    progressView.mode = MRProgressOverlayViewModeCross;
                                    //                                    progressView.titleLabelText = @"Failed";
                                }
                                [self performBlock:^{
                                    [self dismissViewControllerAnimated:FALSE completion:nil];
                                } afterDelay:0.5];
                            } afterDelay:1.0];
                        } afterDelay:0.33];
                    } afterDelay:0.2];
                } afterDelay:0.1];
            } afterDelay:0.1];
        } afterDelay:0.5];
    } afterDelay:0.33];
}

- (void)performBlock:(void(^)())block afterDelay:(NSTimeInterval)delay {
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), block);
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
