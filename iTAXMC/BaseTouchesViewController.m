//
//  BaseTouchesViewController.m
//  iTAXMC
//
//  Created by mac on 14-9-11.
//  Copyright (c) 2014年 servyou. All rights reserved.
//

#import "BaseTouchesViewController.h"
#import "SettingViewController.h"

@interface BaseTouchesViewController ()

@end

@implementation BaseTouchesViewController

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
    //self.view.userInteractionEnabled = YES;
    //[self initSettingView];
    // Do any additional setup after loading the view.
}

- (void)initSettingView
{
    UIStoryboard *storyboard = self.storyboard;
//    SettingViewController *settingViewController = [storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([SettingViewController class])];
    //[self.navigationController.view.window addSubview:settingViewController.view];
    //将子视图移到后面
    //[self.navigationController.view.window sendSubviewToBack:settingViewController.view];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet *) touches withEvent:(UIEvent *) event
{
    
}

- (void)touchesMoved:(NSSet *) touches withEvent:(UIEvent *) event
{
    
}

- (void)touchesEnded:(NSSet *) touches withEvent:(UIEvent *) event
{
    
}

- (void)touchesCancelled:(NSSet *) touches withEvent:(UIEvent *) event
{
    
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
