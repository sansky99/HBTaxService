//
//  HBSettingViewController.m
//  XJTaxTrain
//
//  Created by khuang on 14-7-7.
//  Copyright (c) 2014年 servyou. All rights reserved.
//

#import "HBSettingViewController.h"
#import "UserInfo.h"
#import "HBLoginViewController.h"
#import "CompatibleaPrintf.h"
#import "AboutNavigationController.h"
#import "FontSizeViewController.h"
#import "MRCircularProgressView.h"
#import "ClearCacheViewController.h"


//43,152,236

@interface HBSettingViewController ()
@property (weak, nonatomic) IBOutlet UIView *viewContainer;

@end

@implementation HBSettingViewController

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
    
    NeedOffsetWhenIOS7NavBar
    // Do any additional setup after loading the view.
//    items = @[@"", @"设置字体", @"清除缓存", @"关于"];
    
    self.view.backgroundColor = [UIColor colorWithRed:255 green:255 blue:255 alpha:0.5];
//    self.view.alpha = 0.3;
    self.btnExit.layer.cornerRadius = 5;
    
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
        self.labName.hidden =
        self.labID.hidden =
        self.labOrgName.hidden = FALSE;
        self.labOrgName.text = [NSString stringWithFormat:@"主管税务机关: \n%@", userInfo.orgName];
        self.labName.text = userInfo.userName;
        self.labID.text = [NSString stringWithFormat:@"纳税人识别号: \n%@", userInfo.userID];
        [self.btnExit setTitle:@"退出" forState:(UIControlStateNormal)];
    }
    else
    {
        [self.btnIcon setImage:[UIImage imageNamed:@"notLogin"] forState:UIControlStateNormal];
        [self.btnIcon setImage:[UIImage imageNamed:@"notLogin"] forState:UIControlStateHighlighted];
        self.labNotLogin.hidden = FALSE;
        self.labNotLogin.text = @"未登录";
        self.labName.hidden =
        self.labID.hidden =
        self.labOrgName.hidden = TRUE;
        [self.btnExit setTitle:@"登录" forState:(UIControlStateNormal)];
    }
}


- (IBAction)onDismiss:(id)sender {
    [self dismissViewControllerAnimated:TRUE completion:nil];
}


- (IBAction)onExit:(id)sender {

    UserInfo *userInfo = [ServyouDefines sharedUserInfo];
    
    if (userInfo.isLogin)
    {
        [userInfo clear];
        
        [self updateCtrl];
//        UIViewController *ccc =self.presentingViewController;
//        if ([self.presentingViewController respondsToSelector:@selector(updateLoginStatus)])
//            [self.presentingViewController performSelector:@selector(updateLoginStatus)];
        
        [[NSNotificationCenter defaultCenter]
         postNotificationName:@"kLogOutNotification" object:self];
    }
    else
    {
        [self onLogin:nil];
    }
}

- (IBAction)onLogin:(id)sender {
    UserInfo *userInfo = [ServyouDefines sharedUserInfo];
    if (!userInfo.isLogin)
    {
        UIStoryboard *storyboard = self.storyboard;
        HBLoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([HBLoginViewController class])];
        UINavigationController *loginVC = [[UINavigationController alloc] initWithRootViewController:loginViewController];
        [self presentViewController:loginVC animated:TRUE completion:nil];
    }
}


- (IBAction)onAbout:(id)sender {
    AboutNavigationController *about = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([AboutNavigationController class])];
    about.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:about animated:TRUE completion:nil];
}
- (IBAction)onFontSize:(id)sender {
    FontSizeViewController *fs = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([FontSizeViewController class])];
    fs.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    self.modalPresentationStyle = UIModalPresentationCurrentContext;
    fs.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [self presentViewController:fs animated:FALSE completion:nil];
}
- (IBAction)onCheckUpdate:(id)sender {
    ClearCacheViewController *cc = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([ClearCacheViewController class])];
    cc.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    self.modalPresentationStyle = UIModalPresentationCurrentContext;
    cc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [self presentViewController:cc animated:FALSE completion:nil];
}


@end
