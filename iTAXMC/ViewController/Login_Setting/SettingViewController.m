//
//  SettingViewController.m
//  XJTaxTrain
//
//  Created by khuang on 14-7-7.
//  Copyright (c) 2014年 servyou. All rights reserved.
//

#import "SettingViewController.h"
#import "UserInfo.h"
#import "LoginViewController.h"


//43,152,236

@interface SettingViewController ()

@end

@implementation SettingViewController

//static NSArray *items;

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
//    items = @[@"", @"设置字体", @"清除缓存", @"关于"];
    
    self.btnExit.layer.cornerRadius = 5;
    
    self.labID.textColor = self.labNotLogin.textColor = [UIColor colorWithWhite:125./255 alpha:1];
    self.labName.textColor = [UIColor colorWithRed:248./255 green:118./255 blue:20./255 alpha:1];
    
//    self.view.backgroundColor = [ServyouDefinesUI ColorOrange];
    
    
    
    
    
    
    
    
    
}

-(void) viewWillAppear:(BOOL)animated
{
    [self updateCtrl];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) updateCtrl
{
    UserInfo *userInfo = [ServyouDefines sharedUserInfo];
    
    if (userInfo.isLogin)
    {
        [self.btnIcon setImage:[UIImage imageNamed:@"isLogin"] forState:UIControlStateNormal];
        [self.btnIcon setImage:[UIImage imageNamed:@"isLogin"] forState:UIControlStateHighlighted];
        self.labNotLogin.hidden = TRUE;
        self.labName.hidden = FALSE;
        self.labName.text = userInfo.groupName;
        self.labID.hidden = FALSE;
        self.userID.hidden = false;
        self.userID.text = userInfo.nsrsbhStr;
        self.labID.text = userInfo.userID;
        self.btnExit.hidden = FALSE;
    }
    else
    {
        [self.btnIcon setImage:[UIImage imageNamed:@"notLogin"] forState:UIControlStateNormal];
        [self.btnIcon setImage:[UIImage imageNamed:@"notLogin"] forState:UIControlStateHighlighted];
        self.labNotLogin.hidden = FALSE;
        self.labNotLogin.text = @"未登录";
        self.labName.hidden = TRUE;
        self.labID.hidden = TRUE;
        self.userID.hidden = TRUE;
       self.btnExit.hidden = TRUE;
    }
}

- (IBAction)onSwipeDown:(UISwipeGestureRecognizer *)sender {
    [self dismissViewControllerAnimated:TRUE completion:nil];
}

- (IBAction)onExit:(id)sender {
    
    
    
    NSLog(@"~~out put ~~~");
    
    UserInfo *userInfo = [ServyouDefines sharedUserInfo];
    [userInfo clear];
    
    [self updateCtrl];
    
    UIViewController *ccc =self.presentingViewController;
    if ([self.presentingViewController respondsToSelector:@selector(updateLoginStatus)])
        [self.presentingViewController performSelector:@selector(updateLoginStatus)];
    
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"kLogOutNotification" object:self];
    
}

- (IBAction)onLogin:(id)sender {
    UserInfo *userInfo = [ServyouDefines sharedUserInfo];
    if (!userInfo.isLogin)
    {
        UIStoryboard *storyboard = self.storyboard;
        LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([LoginViewController class])];
        UINavigationController *loginVC = [[UINavigationController alloc] initWithRootViewController:loginViewController];
        [self presentViewController:loginVC animated:TRUE completion:nil];
    }
}


@end
