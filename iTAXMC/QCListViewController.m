//
//  QCListViewController.m
//  QCSliderTableView
//
//  Created by “ 邵鹏 on 14-4-16.
//  Copyright (c) 2014年 Scasy. All rights reserved.
//

#import "QCListViewController.h"

#import "HBLoginViewController.h"
#define Duration 0.2

//模块ViewController
#import "ChannelDetailsViewController.h"//办税提醒详情
#import "WebViewController.h"

@interface QCListViewController ()

@end

@implementation QCListViewController
@synthesize rootViewController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {}
    return self;
}

-(void)NotificationCenterAction{
    [self switchModuleView:[NSNumber numberWithInt:30107]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    NSLog(@"~~~moduleID = %@",self.moduleID);
    
    //记录长按按钮信息
    dication = [[NSMutableDictionary alloc] init];
    
    self.view.backgroundColor = [UIColor clearColor];
    
    self.itemArray = [NSMutableArray array];
    
    NSUInteger outWidth = 90, inWidth = 70, span = (self.view.bounds.size.width - 3*outWidth) / 4;
    
    if (IOS_7) {
        
        bgView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
        if ([self.moduleID intValue]== 10000)  bgView.contentSize = CGSizeMake(ScreenWidth,600);
        
        [self.view addSubview:bgView];
    }
    
    for (NSInteger i  = 0; i<[self.tabNumber count]; i++) {
        
        UIView * btnView = [[UIView alloc] init];
        btnView.backgroundColor = [UIColor clearColor];
        btnView.frame = CGRectMake((i%3 + 1)*span +(i%3)*outWidth, (i/3+1)*span+(i/3)*outWidth, outWidth, outWidth);
        btnView.tag = i;
        
        if (IOS_7) [bgView addSubview:btnView]; else [self.view addSubview:btnView];
        
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.backgroundColor = [UIColor clearColor];
        btn.frame = CGRectMake((outWidth-inWidth)/2, 0, inWidth, inWidth);
        btn.tag = [[self.tabNumber objectForKey:[NSString stringWithFormat:@"%d",i]][Col_ID]intValue];
        
        NSString * name = [NSString stringWithFormat:@"%@",[self.tabNumber objectForKey:[NSString stringWithFormat:@"%d",i]][Col_Name]];
        btn.titleLabel.font = [UIFont boldSystemFontOfSize:20];
        [btn setTitle:[NSString stringWithFormat:@"%@",[self.tabNumber objectForKey:[NSString stringWithFormat:@"%d",i]][Col_Name]] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",name]] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(tabBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [btnView addSubview:btn];
        
        UILabel * btnLaber = [[UILabel alloc] initWithFrame:CGRectMake(0,inWidth+5, outWidth, 25)];
        btnLaber.font = [UIFont systemFontOfSize:10];
        btnLaber.text = [NSString stringWithFormat:@"%@",[self.tabNumber objectForKey:[NSString stringWithFormat:@"%d",i]][Col_Name]];
        btnLaber.backgroundColor = [UIColor clearColor];
        btnLaber.numberOfLines = 0;
        btnLaber.textAlignment = NSTextAlignmentCenter;
        [btnView addSubview:btnLaber];
        
        UILongPressGestureRecognizer *longGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(buttonLongPressed:)];
        [btnView addGestureRecognizer:longGesture];
        
        [self.itemArray addObject:btnView];
    }
}

- (void)viewDidCurrentView
{
    NSLog(@"加载为当前视图 = %@",self.title);
}

- (void)showLogin:(NSNumber *)moduleID
{
    UIStoryboard *storyboard = self.rootViewController.storyboard;
    HBLoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([HBLoginViewController class])];
    loginViewController.moduleViewC = self;
    loginViewController.moduleID = moduleID;
    UINavigationController *loginVC = [[UINavigationController alloc] initWithRootViewController:loginViewController];
    [self.rootViewController presentViewController:loginVC animated:TRUE completion:nil];
}

- (void)showSecondLogin
{
//    showSecondLogin(self.rootViewController.navigationController.tabBarController.parentViewController);
}

-(void) switchModuleView:(NSNumber*) moduleID
{
    NSLog(@"~~~moduleId = %@",moduleID);
    //检测是否需先登录
    NSArray *module = [ServyouDefines getModule:moduleID];
     ServyouAppDelegate *servyouDelegate = (ServyouAppDelegate *)[UIApplication sharedApplication].delegate;
    if (module && [module[Col_NeedLogin] boolValue])
    {
        if (![[ServyouDefines sharedUserInfo] isLogin])
        {
            //没有登录时，进行登录
            [self showLogin:moduleID];
            return;
        }
        else if ([[ServyouDefines sharedUserInfo] isLogin]&&servyouDelegate.wtLoginUnable)
        {
            //登录完成，并且需要进行二次验证时。
            [self showSecondLogin];
            return;
        }
        
    }
    
    
    UIViewController *ctrl = nil;
    switch ([moduleID integerValue]) {

        case 10101://代办事项
        case 10102://涉税提醒
        case 10103://通知公告
        case 10104://最新政策
        {
       ChannelDetailsViewController *   channelDetails = [self.rootViewController.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([ChannelDetailsViewController class])];
            channelDetails.opCode = [NSString stringWithFormat:@"%d",[moduleID integerValue]];
            ctrl = channelDetails;

//            ctrl = [InfoNoticeViewController new];
//            ((InfoNoticeViewController*)ctrl).moduleID = moduleID;

        }
            break;
        case 20101:     //发票查验
        {
            [self showWebViewWithModelItems:module];
        }
            break;
        case 20201:     //预约服务
        //case 20202:     //申报结果查询
        case 20203:     //违法违章信息查询
        case 20204:     //申报情况查询
        case 20205:     //缴款信息查询
        case 20206:     //文书申请信息查询
        {
            [self showWebViewWithModelItems:module];
        }
            break;
        //case 20202:     //申报结果查询
        case 20301:     //企业所得税月(季)度纳税申报(b类)
        case 20302:     //消费税(金银首饰类)申报
        case 20303:     //增值税小规模申报
        case 20304:     //网上缴款
        {
            ServyouAppDelegate *servyouDelegate = (ServyouAppDelegate *)[UIApplication sharedApplication].delegate;
            if (servyouDelegate.wtLoginUnable)
            {
                [self showSecondLogin];
            }
            else
            {
                [self showWebViewWithModelItems:module];
            }
            
        }
            break;
        case 30101:     //办税指南
        case 30102:     //咨询留言
        case 30103:     //办税地图
        case 30104:     //办税日历
        case 30105:     //纳税人学校
        case 30106:     //咨询热点
        case 30107:     //通知公告
        case 30108:     //宣传专栏
        {
            [self showWebViewWithModelItems:module];
        }
            break;
       default:
            break;
    }
    
    if (nil != ctrl)
    {
        if (IOS_7)
            self.navigationItem.title = @" ";
        
        ctrl.hidesBottomBarWhenPushed = YES;
//        // add by hellen.zhou
//        if ([ctrl isMemberOfClass: [InfoNoticeViewController class]])
//        {
            UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleBordered target:nil action:nil];
            
            self.rootViewController.navigationItem.backBarButtonItem = backItem;
//        }
        
        [self.rootViewController.navigationController pushViewController:ctrl animated:TRUE];
    }
}


-(void)tabBtnAction:(UIButton *)button{
    [self switchModuleView:  [NSNumber numberWithInteger:button.tag]];
}




- (void)buttonLongPressed:(UILongPressGestureRecognizer *)sender
{
    UIView * btn = (UIView *)sender.view;
    if (sender.state == UIGestureRecognizerStateBegan)
    {
        if (dication) [dication removeAllObjects];
        
        startPoint = [sender locationInView:sender.view];
        originPoint = btn.center;
        
        //记录起始center
        startButtonCenter = btn.center;
        [dication setObject:[NSNumber numberWithInteger:btn.tag] forKey:@"startBtn"];
        
        [UIView animateWithDuration:Duration animations:^{
            
            btn.transform = CGAffineTransformMakeScale(1.1, 1.1);
            btn.alpha = 0.7;
        }];
        
    }
    else if (sender.state == UIGestureRecognizerStateChanged)
    {
        
        CGPoint newPoint = [sender locationInView:sender.view];
        CGFloat deltaX = newPoint.x-startPoint.x;
        CGFloat deltaY = newPoint.y-startPoint.y;
        btn.center = CGPointMake(btn.center.x+deltaX,btn.center.y+deltaY);
        NSInteger index = [self indexOfPoint:btn.center withButton:btn];
        if (index<0)
        {
            contain = NO;
        }
        else
        {
            [UIView animateWithDuration:Duration animations:^{
                
                CGPoint temp = CGPointZero;
                UIButton *endbutton = _itemArray[index];
                [dication setObject:[NSNumber numberWithInteger:endbutton.tag] forKey:@"endBtn"];
                
                temp = endbutton.center;
                endbutton.center = originPoint;
                btn.center = temp;
                originPoint = btn.center;
                contain = YES;
                
            }];
        }
    }else if (sender.state == UIGestureRecognizerStateEnded){
        [UIView animateWithDuration:Duration animations:^{
            
            btn.transform = CGAffineTransformIdentity;
            btn.alpha = 1.0;
            if (!contain)
            {
                btn.center = originPoint;
                
                if (CGPointEqualToPoint(startButtonCenter, btn.center)) {
                    NSLog(@"没有变化");
                    [dication removeAllObjects];
                }else{
                    [self replaceList:[[dication objectForKey:@"startBtn"] intValue] endButton:[[dication objectForKey:@"endBtn"] intValue]];
                }
            }
        }];
    }
}

#pragma mark - 按钮替换
-(void)replaceList:(int)startButtonId endButton:(int)endButtonId{
    
    NSString * plistPath = NSTemporaryDirectory();
    plistPath = [NSString stringWithFormat:@"%@%d.plist", NSTemporaryDirectory(), [self.moduleID intValue]];
    
    
    //判断是否以创建文件
    if ([[NSFileManager defaultManager] fileExistsAtPath:plistPath])
    {
        NSMutableDictionary *infolist= [[[NSMutableDictionary alloc]initWithContentsOfFile:plistPath]mutableCopy];
        
        if ([infolist objectForKey:[NSString stringWithFormat:@"%d",[self.moduleID intValue]]]) {
            
            NSMutableDictionary * thereTabData = [[infolist objectForKey:[NSString stringWithFormat:@"%d",[self.moduleID intValue]]] objectForKey:[NSString stringWithFormat:@"%d",self.twoID]];
            
            //获取开始/结束按钮信息，替换
            NSDictionary * start =  [thereTabData objectForKey:[NSString stringWithFormat:@"%d",startButtonId]];
            NSDictionary * end =  [thereTabData objectForKey:[NSString stringWithFormat:@"%d",endButtonId]];
            
            [thereTabData setObject:start forKey:[NSString stringWithFormat:@"%d",endButtonId]];
            [thereTabData setObject:end forKey:[NSString stringWithFormat:@"%d",startButtonId]];
            
            [infolist writeToFile:plistPath atomically:TRUE];
        }
    }
}


- (NSInteger)indexOfPoint:(CGPoint)point withButton:(UIView *)btn
{
    for (NSInteger i = 0;i<_itemArray.count;i++)
    {
        UIButton *button = _itemArray[i];
        if (button != btn)
        {
            if (CGRectContainsPoint(button.frame, point))
            {
                return i;
            }
        }
    }
    return -1;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - showWebView
- (void)showWebViewWithModelItems:(NSArray *)items
{
    UIStoryboard *storyboard = self.rootViewController.storyboard;
    WebViewController *webView = [storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([WebViewController class])];
    webView.moduleItems = items;
    [self.rootViewController.navigationController pushViewController:webView animated:YES];
}

@end
