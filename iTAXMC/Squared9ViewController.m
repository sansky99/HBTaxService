//
//  Squared9ViewController.m
//  iTAXMC
//
//  Created by 张乐 on 14-7-31.
//  Copyright (c) 2014年 servyou. All rights reserved.
//

#import "Squared9ViewController.h"
#import "SVProgressHUD.h"
#import "SettingViewController.h"
//#import "serachViewController.h"
#include "CompatibleaPrintf.h"
@interface Squared9ViewController ()

@end

@implementation Squared9ViewController

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
    
    self.view.backgroundColor = [UIColor whiteColor];

    
    UIButton *loginButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 41, 39)];
    [loginButton addTarget:self action:@selector(onSetting:) forControlEvents:UIControlEventTouchUpInside];
    [loginButton setImage:[UIImage imageNamed:@"user_logout"] forState:UIControlStateNormal];

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:loginButton];

    NeedOffsetWhenIOS7NavBar
    
    TwoTabName = [[NSArray alloc] init];
    BOOL isShowViewTitle = YES;
    //二级TabNumber
    switch ([self.moduleID intValue]) {
            
        case 20000://税务咨询
            TwoTabnumber = 3;
            TwoTabName = [NSArray arrayWithObjects:@"发票管理",@"查询预约",@"涉税申报",nil];
            break;
        case 30000:
            TwoTabnumber = 1;
            isShowViewTitle = NO;
            TwoTabName = [NSArray arrayWithObjects:@"公众服务",nil];
            break;
        default:
            break;
    }
    
    //获取当前
    [self memoryPlist];
    
    _slideSwitchView = [[QCSlideSwitchView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    _slideSwitchView.tabItemNormalColor   = [UIColor blackColor];
    _slideSwitchView.tabItemSelectedColor = [ServyouDefinesUI ColorBlue];
    _slideSwitchView.shadowImage = [[UIImage imageNamed:@"blue_line_and_shadow"]stretchableImageWithLeftCapWidth:59.0f topCapHeight:0.0f];
    _slideSwitchView.moduleID = self.moduleID;
    _slideSwitchView.showViewTitle = isShowViewTitle;
    _slideSwitchView.slideSwitchViewDelegate = self;
    [self.view addSubview:_slideSwitchView];
    
    //实例化具体tab页面
    
    tabViewArray = [[NSMutableArray alloc] init];
    
    for (int i = 0; i<TwoTabnumber; i++) {
        
        QCListViewController  * qc = [[QCListViewController alloc] init];
        qc.rootViewController = self; // add by Hellen 8.28
        
        qc.title = [TwoTabName objectAtIndex:i];
        qc.moduleID = self.moduleID;
        qc.twoID = i;
        
        //传递当前VC所属的一级Tab/二级Tab
        qc.tabNumber =[[self memoryPlist]objectForKey:[NSString stringWithFormat:@"%d",i]];
        
        //还需指明每个分页的所需的三级Tab数量
        [tabViewArray addObject:qc];
    }
    
    [_slideSwitchView buildUI];
    
    //退出登录更改登陆按钮
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(kLogOutNotificationCenterAction:) name:@"kLogOutNotification" object:nil];
    
}

-(void)kLogOutNotificationCenterAction:(NSNotification *)notification{
    UIButton *login = (UIButton*)self.navigationItem.rightBarButtonItem.customView;
    [login setImage:[UIImage imageNamed:@"user_logout"]  forState:UIControlStateNormal];
    
}


- (void) viewWillAppear:(BOOL)animated
{
    [self updateLoginStatus];
    if (TwoTabnumber>1) {
        [self updateSlideTitleoPsition];
    }
}

-(void) updateLoginStatus
{
    UIButton *login = (UIButton*)self.navigationItem.rightBarButtonItem.customView;
    if ([[ServyouDefines sharedUserInfo] isLogin])
    {
        [login setImage:[UIImage imageNamed:@"user_login"]  forState:UIControlStateNormal];
    }
    else
    {
        [login setImage:[UIImage imageNamed:@"user_logout"]  forState:UIControlStateNormal];
    }
}

- (void)updateSlideTitleoPsition
{
    [_slideSwitchView updateSlideTitleoPsition];
}

#pragma mark- navgationbar events
-(void) onSetting :(id) sender
{
     [[NSNotificationCenter defaultCenter] postNotificationName:kNotifySettingTouchUpInside object:self];
}

-(void) onSearch:(id) sender
{
//    serachViewController * sd = [[serachViewController alloc] init];
//    [self presentViewController:sd animated:YES completion:nil];
}


#pragma mark - plistFile save

-(NSMutableDictionary *)memoryPlist{
    
    NSString *plistPath = NSTemporaryDirectory();
    plistPath = [NSString stringWithFormat:@"%@%d.plist", NSTemporaryDirectory(), [self.moduleID intValue]];
    
    //判断是否以创建文件
    if ([[NSFileManager defaultManager] fileExistsAtPath:plistPath])
    {
        //根据路径获取test.plist的全部内容
        NSMutableDictionary *infolist= [[[NSMutableDictionary alloc]initWithContentsOfFile:plistPath]mutableCopy];
        
        if ([infolist objectForKey:[NSString stringWithFormat:@"%d",[self.moduleID intValue]]]) {
            
            NSMutableDictionary * twoData =  [infolist objectForKey:[NSString stringWithFormat:@"%d",[self.moduleID intValue]]];
            
            return twoData;
        }
        return nil;
    } else {
        NSLog(@"plist文件不存在，创建个");
        
        //如果没有plist文件就自动创建
        NSMutableDictionary *dictplist = [[NSMutableDictionary alloc ] init];
        
        //得到当前Tab的所有数据
        NSArray* item0 = [ServyouDefines getModule:self.moduleID];
        
        NSArray* children1 = [ServyouDefines getModuleChildren:item0[Col_ID]];
        
        //定义显示数据的数组
        NSMutableDictionary * mainTab = [[NSMutableDictionary alloc] init];
        
        //进行迭代
        for (int i = 0; i<[children1 count]; i++) {
            
            NSArray* children2 = [ServyouDefines getModuleChildren:[children1 objectAtIndex:i][Col_ID]];
            
            there = [[NSMutableDictionary alloc] init];
            
            for (int i = 0; i < [children2 count]; i++) {
                [there setObject:[children2 objectAtIndex:i] forKey:[NSString stringWithFormat:@"%d",i]];
            }
            [mainTab setValue:there forKey:[NSString stringWithFormat:@"%d",i]];
        }
        
        [dictplist setObject:mainTab forKey:[NSString stringWithFormat:@"%d",[self.moduleID intValue]]];
        
        [dictplist writeToFile:plistPath atomically:TRUE];
        return dictplist;
    }
}

#pragma mark - 滑动tab视图代理方法
- (NSUInteger)numberOfTab:(QCSlideSwitchView *)view
{
    return TwoTabnumber;
}

- (UIViewController *)slideSwitchView:(QCSlideSwitchView *)view viewOfTab:(NSUInteger)number
{
    
    return [tabViewArray objectAtIndex:number];
}

- (void)slideSwitchView:(QCSlideSwitchView *)view didselectTab:(NSUInteger)number
{
    QCListViewController *vc = nil;
    vc = [tabViewArray objectAtIndex:number];
    [vc viewDidCurrentView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
