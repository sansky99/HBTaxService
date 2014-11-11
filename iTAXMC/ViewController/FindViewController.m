//
//  FindViewController.m
//  ZHTaxService
//
//  Created by khuang on 14-9-18.
//  Copyright (c) 2014年 servyou. All rights reserved.
//

#import "FindViewController.h"
#include "CompatibleaPrintf.h"
#import "HBSettingViewController.h"
#import "ServyouAppDelegate.h"
#import "HBLoginViewController.h"
#import "TestWebViewViewController.h"


@interface FindViewController ()
@property (weak, nonatomic) IBOutlet UITableView *consultTableView;
@property (weak, nonatomic) IBOutlet UITableView *toolsTableView;

@end

@implementation FindViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    topTableArray = [[NSArray alloc] initWithObjects:@"税务在线咨询", nil];
    
    footTableArray = [[NSArray alloc] initWithObjects:@"手机拍照发票认证",@"验票通", nil];
    
    [self updateLoginStatus];
}

-(void) updateLoginStatus
{
    UIButton *login = (UIButton*)self.navigationItem.rightBarButtonItem.customView;
    //    [login setImage:[UIImage imageNamed:@"user_logout"]  forState:UIControlStateNormal];
    if ([[ServyouDefines sharedUserInfo] isLogin])
    {
        [login setImage:[UIImage imageNamed:@"user_login"]  forState:UIControlStateNormal];
    }
    else
    {
        [login setImage:[UIImage imageNamed:@"user_logout"]  forState:UIControlStateNormal];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NeedOffsetWhenIOS7NavBar
    
    self.view.backgroundColor = [ServyouDefinesUI ColorGray];
    
    UIButton *loginButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 41, 39)];
    [loginButton addTarget:self action:@selector(onSetting:) forControlEvents:UIControlEventTouchUpInside];
    [loginButton setImage:[UIImage imageNamed:@"user_logout"] forState:UIControlStateNormal];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:loginButton];
    
    
    //退出登录更改登陆按钮
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(kLogOutNotificationCenterAction:) name:@"kLogOutNotification" object:nil];
    
}

-(void)kLogOutNotificationCenterAction:(NSNotification *)notification{
    UIButton *login = (UIButton*)self.navigationItem.rightBarButtonItem.customView;
    [login setImage:[UIImage imageNamed:@"user_logout"]  forState:UIControlStateNormal];
    
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
-(void) onSetting :(id) sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotifySettingTouchUpInside object:self];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - UITableViewDelegate
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.consultTableView)
    {
        return 1;
    }
    else if (tableView == self.toolsTableView)
    {
        return 2;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 60;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *SimpleTableIdentifier = @"SimpleTableIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: SimpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SimpleTableIdentifier];
    }
    
    UIImageView * iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 5, 50, 50)];
    [cell.contentView addSubview:iconImageView];
    iconImageView.backgroundColor = [UIColor clearColor];
    
    UILabel * iconLaber = [[UILabel alloc] initWithFrame:CGRectMake(75, 7, 150, 20)];
    iconLaber.font = [UIFont systemFontOfSize:15];
    [cell.contentView addSubview:iconLaber];
    
    UILabel * xxLaber = [[UILabel alloc] initWithFrame:CGRectMake(75, 35, 130, 20)];
    xxLaber.font = [UIFont systemFontOfSize:13];
    [cell.contentView addSubview:xxLaber];
    
    if (tableView == self.consultTableView) {
        iconImageView.image = [UIImage imageNamed:[topTableArray objectAtIndex:indexPath.row]];
        iconLaber.text = [topTableArray objectAtIndex:indexPath.row];
        
        xxLaber.text = @"税友公司在线咨询";
    }else if (tableView == self.toolsTableView){
        iconImageView.image = [UIImage imageNamed:[footTableArray objectAtIndex:indexPath.row]];
        iconLaber.text = [footTableArray objectAtIndex:indexPath.row];

        xxLaber.text = @"河北国税";
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[ServyouDefines sharedUserInfo] isLogin])
    {
        TestWebViewViewController * testWeb = [[TestWebViewViewController alloc] init];

        testWeb.hidesBottomBarWhenPushed = YES;
        
        [self.navigationController pushViewController:testWeb animated:YES];
        
    }else{
        HBLoginViewController * login = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([HBLoginViewController class])];
        
        UINavigationController *loginVC = [[UINavigationController alloc] initWithRootViewController:login];
        
        [self presentViewController:loginVC animated:YES completion:nil];
    }
}

@end
