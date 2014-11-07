//
//  TestViewController.m
//  SlideView
//
//  Created by Chen Yaoqiang on 13-12-27.
//  Copyright (c) 2013年 Chen Yaoqiang. All rights reserved.
//

#import "TestViewController.h"

@interface TestViewController ()

@end

@implementation TestViewController

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
    UIImageView *topShadowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 200, 320, 5)];
    [topShadowImageView setImage:[UIImage imageNamed:@"top_background_shadow.png"]];
    topShadowImageView.backgroundColor = [UIColor purpleColor];
    [self.view addSubview:topShadowImageView];
    
    SVTopScrollView *topScrollView = [SVTopScrollView shareInstance];
    SVRootScrollView *rootScrollView = [SVRootScrollView shareInstance];
    
    topScrollView.nameArray = @[@"通知提醒", @"政策新闻", @"知识库", @"办税指南",@"营改增专栏"];
    rootScrollView.viewNameArray = @[@"通知提醒", @"政策新闻", @"知识库", @"办税指南",@"营改增专栏"];

    [self.view addSubview:topScrollView];
        [topScrollView initWithNameButtons];
    [self.view addSubview:rootScrollView];
    

    [rootScrollView initWithViews];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
