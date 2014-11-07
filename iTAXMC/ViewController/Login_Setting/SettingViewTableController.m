//
//  SettingViewTableController.m
//  iTAXMC
//
//  Created by khuang on 14-7-18.
//  Copyright (c) 2014年 servyou. All rights reserved.
//

#import "SettingViewTableController.h"
#import "AboutNavigationController.h"
#import "FontSizeViewController.h"
#import "MRCircularProgressView.h"
#import "ClearCacheViewController.h"
#import "LoginViewController.h"

@interface SettingViewTableController ()

@end

@implementation SettingViewTableController

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
    self.tableView.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)onFontSize:(id)sender {
    [self onAction:1];
}
- (IBAction)onCheckUpdate:(id)sender {
    [self onAction:2];
}
- (IBAction)onAbout:(id)sender {
    [self onAction:3];
}

- (void)didBackItem:(id)sender
{
    
}

- (void) onAction:(NSInteger) action
{
    UIViewController *vc =self.parentViewController;
    UIViewController *vc2 = vc.parentViewController;
    switch (action)
    {
        case 0:
        {
            if (![ServyouDefines sharedUserInfo].isLogin)
            {
                LoginViewController * login = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([LoginViewController class])];
                
                UINavigationController *loginVC = [[UINavigationController alloc] initWithRootViewController:login];
                [self presentViewController:loginVC animated:YES completion:nil];
            }
            else
            {
//                ModifyPasswordViewController *modifyView = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([ModifyPasswordViewController class])];
//                UINavigationController *modifyNav = [[UINavigationController alloc] initWithRootViewController:modifyView];
//                [vc2 presentViewController:modifyNav animated:TRUE completion:nil];
            }
            
        }
            break;
        case 1:     //设置字体
        {
             FontSizeViewController *fs = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([FontSizeViewController class])];
            fs.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
            vc2.modalPresentationStyle = UIModalPresentationCurrentContext;
            [vc2 presentViewController:fs animated:FALSE completion:nil];
        }
            break;
        case 2:     //清除缓存
        {
            ClearCacheViewController *cc = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([ClearCacheViewController class])];
            cc.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
            vc2.modalPresentationStyle = UIModalPresentationCurrentContext;
            [vc2 presentViewController:cc animated:FALSE completion:nil];
        }
            break;
        case 3:     //关于
        {
            AboutNavigationController *about = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([AboutNavigationController class])];
            about.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
//            vc2.modalPresentationStyle = UIModalPresentationFullScreen;
            [vc2 presentViewController:about animated:TRUE completion:nil];
        }
            break;
    }
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
- (void) tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    [self onAction:indexPath.row];
}

@end
