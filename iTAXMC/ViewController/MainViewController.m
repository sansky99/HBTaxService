//
//  MainViewController.m
//  XJTaxTrain
//
//  Created by khuang on 14-7-7.
//  Copyright (c) 2014年 servyou. All rights reserved.
//

#import "MainViewController.h"
#import "JSBadgeView.h"
#import "LatestNotificationEntity.h"
#import "MessageCenter.h"
#import "SevryouChannelCenter.h"//渠道中心
#import "ChannelCenterDo.h"
#include "CompatibleaPrintf.h"
#import "HBSettingViewController.h"

#import "SVProgressHUD.h"

#import "ChannelDetailsViewController.h"

#import "JSONKit.h"
#import "ChannelCenterData.h"

#import "Login_Setting/HBLoginViewController.h"

@interface MainViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) NSArray *items;
@property (strong, nonatomic) HBSettingViewController *settingVC;

-(BOOL) reloadItems;
@end

@implementation MainViewController
@synthesize items, settingVC;
@synthesize releaseInfo = _releaseInfo;

-(id) init
{
    if (self = [super init])
    {
        items = nil;
    }
    return self;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {}
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    center = [[SevryouChannelCenter alloc] init];
    
    if ([[ServyouDefines sharedUserInfo] isLogin])
    {
        [self kXGPushNotificationCenterAction:nil];
    }
    
     [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackTranslucent];
    
    if (!iPhone5) {
        self.tableView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight-110);
    }

    self.navigationItem.title = @"河北国税";
    NeedOffsetWhenIOS7NavBar
    
    UIButton *loginButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 41, 39)];
    [loginButton addTarget:self action:@selector(onSetting:) forControlEvents:UIControlEventTouchUpInside];
    [loginButton setImage:[UIImage imageNamed:@"user_logout"] forState:UIControlStateNormal];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:loginButton];
    
    if ([[ServyouDefines sharedUserInfo] isLogin])
    {
        [(UIBarButtonItem*)[self.navigationItem.rightBarButtonItems lastObject] setImage:[UIImage imageNamed:@"user_login"]  ];
    }else
    {
        [(UIBarButtonItem*)[self.navigationItem.rightBarButtonItems lastObject] setImage:[UIImage imageNamed:@"user_logout"]  ];
        
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:loginButton];
        
        [self reloadItems];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onNewMessage:) name:kNewMessageNotification object:nil];
        [[MessageCenter sharedMessageCenter] refreshMessages];
        
        
        //渠道中心监听 NSString *const kChannelNotificationCenter =
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(kXGPushNotificationCenterAction:) name:@"kNewXGPushNotification" object:nil];
        
        //渠道中心监听 NSString *const kChannelNotificationCenter =
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(kXGPushNotificationCenterAction:) name:@"kChannelNotificationCenter" object:nil];
        
        //退出登录更改登陆按钮
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(kLogOutNotificationCenterAction:) name:@"kLogOutNotification" object:nil];
    }
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:loginButton];
    
    
    [self reloadItems];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onNewMessage:) name:kNewMessageNotification object:nil];
    [[MessageCenter sharedMessageCenter] refreshMessages];
    
    
    //渠道中心监听 NSString *const kChannelNotificationCenter =
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(kXGPushNotificationCenterAction:) name:@"kNewXGPushNotification" object:nil];
    
    //渠道中心监听 NSString *const kChannelNotificationCenter =
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(kXGPushNotificationCenterAction:) name:@"kChannelNotificationCenter" object:nil];
    
    
    //版本检测
    [self versionDetection];
}

#pragma mark - 版本检测
-(void)versionDetection{
    
    //获取当前的版本信息
    NSString * ver = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSLog(@"ver = %@",ver);
    
    //携带当前版本去匹配版本
    [self onCheckVersion:ver];
}

-(void)onCheckVersion:(NSString *)currentVersion{
    
    //http://itunes.apple.com/cn/lookup?id=918411012
    NSString * URL = @"http://itunes.apple.com/cn/lookup?id=932730597";
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:URL]];
    [request setHTTPMethod:@"POST"];
    
    NSHTTPURLResponse *urlResponse = nil;
    NSError * error = nil;
    
    NSData  * recervedData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
    
    NSString *results = [[NSString alloc] initWithBytes:[recervedData bytes] length:[recervedData length] encoding:NSUTF8StringEncoding];
    
    //    SBJsonParser *jsonParser = [[SBJsonParser alloc] init];
    NSDictionary *dic =  [results objectFromJSONString];
    //    NSDictionary *dic = [[jsonParser objectWithString:results] copy];
    
    if (dic.count == 0) {}else{
        NSArray * infoArray = [dic objectForKey:@"results"];
        
        if ([infoArray count]) {//932730597
            _releaseInfo = [infoArray objectAtIndex:0];
            NSString * lastVersion     = [_releaseInfo objectForKey:@"version"];//获取到AppStore上的版本信息
            
            //            newVerUrl = [_releaseInfo objectForKey:@"trackViewUrl"];//获取到更新链接，跳转到AppStore中
            if (![lastVersion isEqualToString:currentVersion]) {//如果版本信息不一致
                newVerUrl = [_releaseInfo objectForKey:@"trackViewUrl"];//获取到更新链接，跳转到AppStore中
                NSLog(@"~~~~~~~~~~newVerUrl = %@",newVerUrl);
                //[RunTimeShare setVersionUrl:newVerUrl];
                NSString * stringUpdate = [_releaseInfo objectForKey:@"releaseNotes"];
                if (!stringUpdate.length == 0) {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"发现新版本" message:stringUpdate delegate:self cancelButtonTitle:@"更新" otherButtonTitles:@"下次", nil];
                    [alert show];
                }else{
                    NSLog(@"为0");
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"更新" message:@"发现新版本" delegate:self cancelButtonTitle:@"更新" otherButtonTitles:@"下次", nil];
                    [alert show];
                }
            }
        }
    }
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex==0) {
        
        //处理去下载新版本的事情
        
        
        [self version];
    }
}

-(void)version{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:newVerUrl]];
}

-(void)kLogOutNotificationCenterAction:(NSNotification *)notification{
    UIButton *login = (UIButton*)self.navigationItem.rightBarButtonItem.customView;
    [login setImage:[UIImage imageNamed:@"user_logout"]  forState:UIControlStateNormal];
    
}

#pragma mark - 渠道中心刷新数据
-(void)kXGPushNotificationCenterAction:(NSNotification *)notification{
    
    NSLog(@"~~~~~~渠道中心刷新数据~~~~~~");
    
    
    ChannelCenterData *centerData = [[ChannelCenterData alloc] init];
    
    //读取数据
    [centerData loadData];
    
    //最新项
    tableArray = centerData.newestItems;
    [self.tableView reloadData];
    
    //未读数
    tableArrayNumber = centerData.unReadItems;
//    
//<<<<<<< HEAD
//    //
//    NSArray *d = [centerData getChannelCenterItemsWithType:EChannelCenterEntityType_TaxMeind];
//    NSLog(@"!!!");
//=======
//    
//    //    NSArray *d = [a getChannelCenterItemsWithType:EChannelCenterEntityType_TaxMeind];
//>>>>>>> ad2442a514eb7c8885e434b7af72f714b373d26c
    //    NSArray *e = [a getChannelCenterItemsWithType:EChannelCenterEntityType_PolicyNewest];
    //    NSArray *f = [a getChannelCenterItemsWithType:EChannelCenterEntityType_TaxNotice];
    //    NSArray *g = [a getChannelCenterItemsWithType:EChannelCenterEntityType_Announcement];
    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self updateLoginStatus];
    //add by zgp  刷新列表
    if ([[ServyouDefines sharedUserInfo] isLogin])
    {
        ChannelCenterData *centerData = [[ChannelCenterData alloc] init];
        //读取数据
        [centerData loadData];
        
        tableArrayNumber = centerData.unReadItems;
        [self.tableView reloadData];
    }
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

-(void) onNewMessage: (NSDictionary*) userInfo
{
    [self reloadItems];
}

-(BOOL) reloadItems
{
    LatestNotificationEntity *entity = [[LatestNotificationEntity alloc] initWithFMDB: [ServyouDefines sharedDatabase]];
    
    NSString *orderBy = [NSString stringWithFormat: @" ORDER BY %@ DESC", [LatestNotificationEntity timestamp_Col]];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.items = [entity findAllWithOrderBy: orderBy];
        [self.tableView reloadData];
    });
    
    return (self.items != nil);
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    
    if ([tableArray count] == 0) {
        return 4;//最后一项登陆后查看
    }else{
        return [tableArray count];
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MainViewTableViewCellID" forIndexPath:indexPath];
    
    UIImageView *imageView = (UIImageView *)[cell viewWithTag:101];
    UILabel *labLeftTop = (UILabel *)[cell viewWithTag:102];
    UILabel *labBottom = (UILabel *)[cell viewWithTag:103];
    UIButton * numberButton = (UIButton *)[cell viewWithTag:110];
    
    //#if 0
    
    if ([[ServyouDefines sharedUserInfo] isLogin])
    {
        if ([tableArray count] > 0) {
            
            ChannelCenterDo * centerDo  =   [tableArray objectAtIndex:indexPath.row];
            
            [self cellImageView:imageView andIndexRow:indexPath andLaber:labLeftTop];
            labBottom.text = centerDo.activityName;
            
            NSLog(@"~~~~ [tableArrayNumber objectAtIndex:indexPath.row] = %@",[tableArrayNumber objectAtIndex:indexPath.row]);
            
            NSString *  numberString  =  [tableArrayNumber objectAtIndex:indexPath.row];
            int numbeerInt = [numberString intValue];
            if (numbeerInt > 0 || !numbeerInt == 0) {

            
//            if (![indexPathStringNumber isEqualToString:@"0"]) {
            
                numberButton.hidden = NO;
                NSLog(@"~~~~~~~weidu  = %@",[tableArrayNumber objectAtIndex:indexPath.row]);
                [numberButton setTitle:[NSString stringWithFormat:@"%@",[tableArrayNumber objectAtIndex:indexPath.row]] forState:UIControlStateNormal];
            }else{
                numberButton.hidden = YES;
            }
            
            if (indexPath.row == 5) {
                //权限
                
            }
        }else{
            
            [self cellImageView:imageView andIndexRow:indexPath andLaber:labLeftTop];
        }
    }else{
//        [SVProgressHUD showErrorWithStatus:@"未登陆"];
        
        [self cellImageView:imageView andIndexRow:indexPath andLaber:labLeftTop];
        
    }
    
    return cell;
}

-(void)cellImageView:(UIImageView *)imageView andIndexRow:(NSIndexPath *)indexPath andLaber:(UILabel *)labLeftTop{
    switch (indexPath.row) {
        case 0:
            imageView.image = [UIImage imageNamed:@"待办事项"];
            labLeftTop.text = @"待办事项";
            break;
        case 1:
            imageView.image = [UIImage imageNamed:@"涉税提醒"];
            labLeftTop.text = @"涉税提醒";
            break;
        case 2:
            imageView.image = [UIImage imageNamed:@"通知公告"];
            labLeftTop.text = @"通知公告";//
            break;
        case 3:
            imageView.image = [UIImage imageNamed:@"最新政策"];
            labLeftTop.text = @"最新政策";
            break;
        case 4:
            imageView.image = [UIImage imageNamed:@"网上调查"];
            labLeftTop.text = @"网上调查";
            
            break;
            
        default:
            break;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ([[ServyouDefines sharedUserInfo] isLogin])
    {
        ChannelCenterEntityType channelType = EChannelCenterEntityType_TaxMeind;
        
        ServyouAppDelegate *servyouDelegate = (ServyouAppDelegate *)[UIApplication sharedApplication].delegate;
        if (servyouDelegate.wtLoginUnable)
        {
//            showSecondLogin(self.navigationController.tabBarController.parentViewController);
        }else{
            
            //清除数字
            NSString *channelTitle = @"待办事项";
            
            switch (indexPath.row) {
                case 0:
                    channelType = EChannelCenterEntityType_TaxMeind;
                    channelTitle = @"待办事项";
                    break;
                case 1:
                    channelType = EChannelCenterEntityType_TaxNotice;
                    channelTitle = @"涉税提醒";
                    break;
                case 2:
                    channelType = EChannelCenterEntityType_Announcement;
                    channelTitle = @"事项通知";
                    break;
                case 3:
                    channelType = EChannelCenterEntityType_PolicyNewest;
                    channelTitle = @"最新政策";
                    break;
                case 4:
                    break;
                case 5:
                    break;
                    
                default:
                    break;
            }
            
            ChannelCenterData *centerData = [[ChannelCenterData alloc] init];
            
            //读取数据
            [centerData loadData];

//            [centerData cleanChannelCenterWithChannelCenterType:channelType];
//            tableArrayNumber = centerData.unReadItems;
            
            
            [self kXGPushNotificationCenterAction:nil];
            [self.tableView reloadData];
            
            NSArray *itemss = [centerData getChannelCenterItemsWithType:channelType];
            
            NSLog(@"~~~items = %@",itemss);
            
            ChannelDetailsViewController * channelVC = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([ChannelDetailsViewController class])];
            channelVC.tableArray = itemss;
            channelVC.title = channelTitle;
            channelVC.channelType = channelType;
            channelVC.hidesBottomBarWhenPushed = YES;
            
            [self.navigationController pushViewController:channelVC animated:YES];
            
            
        }
    }else{
        
        HBLoginViewController * login = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([HBLoginViewController class])];
        
        UINavigationController *loginVC = [[UINavigationController alloc] initWithRootViewController:login];
        [self presentViewController:loginVC animated:YES completion:nil];
    }
    
    
    
//#if 0
//    //获取点击的cell数据
//    ChannelCenterDo * cellData =  [tableArray objectAtIndex:[indexPath row]];
//    NSString * opCode = [[NSString alloc] initWithFormat:@"%@",cellData.opCode];
//    
//    switch ([cellData.opCode intValue]) {
//        case 6201:
//        case 6202:
//            //最新政策
//            [center cleanPolicyNumber];
//            break;
//        case 6203:
//        case 6204:
//            //政策解读
//            [center cleanPolicyReadNumber];
//            break;
//        case 6101:
//        case 6102:
//            //涉税通知
//            [center cleanTaxNoticeNumber];
//            break;
//        case 6301:
//        case 6302:
//            //办税提醒
//            [center cleanTaxRemindNumber];
//            break;
//        default:
//            break;
//    }
//    
//    [self kXGPushNotificationCenterAction:nil];
//    [self.tableView reloadData];
//    
//    ChannelDetailsViewController * channelVC = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([ChannelDetailsViewController class])];
//    if ([tableArray count] == 0) {
//        channelVC.opCode = [NSString stringWithFormat:@"%d",indexPath.row];
//    }else{
//        channelVC.opCode = opCode;
//    }
//    channelVC.hidesBottomBarWhenPushed = YES;
//    
//    [self.navigationController pushViewController:channelVC animated:YES];
//#endif
}


- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    [segue.destinationViewController setHidesBottomBarWhenPushed:YES];
}

-(void) onSetting :(id) sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotifySettingTouchUpInside object:self];
}
@end
