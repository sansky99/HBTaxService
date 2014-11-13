//
//  MainTabBarController.m
//  XJTaxTrain
//
//  Created by khuang on 14-7-7.
//  Copyright (c) 2014年 servyou. All rights reserved.
//

// modifyed by hellen,zhou 8.28

#import "MainTabBarController.h"

#import  "CRNavigationController.h"
//#import "Squared9ViewController.h"
//#import "MainViewController.h"
//#import "FindViewController.h"
#import "HBMainViewController.h"
#import "ServiceViewController.h"

@interface MainTabBarController ()

@end

@implementation MainTabBarController

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
    if (IOS_7)
        self.tabBar.barTintColor = [UIColor colorWithWhite:250 alpha:1];
    
    HBMainViewController * firstViewController = [self.storyboard instantiateViewControllerWithIdentifier: NSStringFromClass( [HBMainViewController class])];
    firstViewController.title = @"办税服务";
    firstViewController.tabBarItem.image = [UIImage imageNamed:@"涉税服务"];
    firstViewController.tabBarItem.selectedImage = [UIImage imageNamed:@"涉税服务p"];
    CRNavigationController *firstNavController = [[CRNavigationController alloc] initWithRootViewController:firstViewController];
    
    ServiceViewController * thirdViewController = [self.storyboard instantiateViewControllerWithIdentifier: NSStringFromClass( [ServiceViewController class])];
    thirdViewController.title = @"公众服务";
    thirdViewController.tabBarItem.image = [UIImage imageNamed:@"公众服务"];
    thirdViewController.tabBarItem.selectedImage = [UIImage imageNamed:@"公众服务p"];
    CRNavigationController *thirdNavController = [[CRNavigationController alloc] initWithRootViewController:thirdViewController];
    
    [self setViewControllers:@[firstNavController, thirdNavController]];

    // modifyed by hellen.zhou  8.28
   
//    MainViewController * firstViewController = [self.storyboard instantiateViewControllerWithIdentifier: NSStringFromClass( [MainViewController class])];
//    
//    firstViewController.title = @"消息";
//    firstViewController.tabBarItem.image = [UIImage imageNamed:@"消息"];
//    firstViewController.tabBarItem.selectedImage = [UIImage imageNamed:@"消息p"];
//
//    Squared9ViewController *  secondViewController = [self.storyboard instantiateViewControllerWithIdentifier: NSStringFromClass([Squared9ViewController  class])];
//    secondViewController.moduleID = @20000;
//    secondViewController.title = @"涉税服务";
//    secondViewController.tabBarItem.image = [UIImage imageNamed:@"涉税服务"];
//    secondViewController.tabBarItem.selectedImage = [UIImage imageNamed:@"涉税服务p"];
    
//    Squared9ViewController  *thirdViewController = [self.storyboard instantiateViewControllerWithIdentifier: NSStringFromClass([Squared9ViewController  class])];    
//    thirdViewController.moduleID = @30000;
//    thirdViewController.title = @"公众服务";
//    thirdViewController.tabBarItem.image = [UIImage imageNamed:@"公众服务"];
//    thirdViewController.tabBarItem.selectedImage = [UIImage imageNamed:@"公众服务p"];
//    
//    
//    FindViewController *fourthViewController =[self.storyboard instantiateViewControllerWithIdentifier: NSStringFromClass([FindViewController class])];
//    fourthViewController.title = @"发现";
//    fourthViewController.tabBarItem.image = [UIImage imageNamed:@"发现"];
//    fourthViewController.tabBarItem.selectedImage = [UIImage imageNamed:@"发现p"];
//   
//    CRNavigationController *firstNavController = [[CRNavigationController alloc] initWithRootViewController:firstViewController];
//    
//    CRNavigationController *secondNavController = [[CRNavigationController alloc] initWithRootViewController:secondViewController];
//    
//    CRNavigationController *thirdNavController = [[CRNavigationController alloc] initWithRootViewController:thirdViewController];
//    
//    CRNavigationController *fourthNavController = [[CRNavigationController alloc] initWithRootViewController:fourthViewController];
//
//    
//    [self setViewControllers:@[firstNavController,
//                               secondNavController,
//                               thirdNavController,
//                               fourthNavController
//                               ]];
//    
    ServyouAppDelegate *delegate = (ServyouAppDelegate *)[[UIApplication sharedApplication] delegate];
    delegate.vc = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
