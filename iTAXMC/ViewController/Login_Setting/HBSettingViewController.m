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


- (IBAction)onDismiss:(id)sender {
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
        HBLoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([HBLoginViewController class])];
        UINavigationController *loginVC = [[UINavigationController alloc] initWithRootViewController:loginViewController];
        [self presentViewController:loginVC animated:TRUE completion:nil];
    }
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
                HBLoginViewController * login = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([HBLoginViewController class])];
                
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

- (IBAction)onAbout:(id)sender {
}
- (IBAction)onFontSize:(id)sender {
}
- (IBAction)onCheckUpdate:(id)sender {
}


@end
