//
//  ChannelDetailsViewController.m
//  iTAXMC
//
//  Created by 张乐 on 14-9-12.
//  Copyright (c) 2014年 servyou. All rights reserved.
//

#import "ChannelDetailsViewController.h"

#import "ChannelCenterDo.h"

#import "WebViewDetailsViewController.h"

#import "JSONKit.h"
#import "ChannelShowDetailViewController.h"

@interface ChannelDetailsViewController ()

@end

@implementation ChannelDetailsViewController
@synthesize opCode = _opCode;
@synthesize tableArray;

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
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSLog(@"self.opcode = %@",self.opCode);
    
    NSLog(@"   tableArray count = %d",[tableArray count]);
    
    if ([tableArray count] == 0) {
        self.tableView.hidden = YES;
    }else{
        self.tableView.hidden = NO;
    }
}

- (void)setTableViewItemsWithDict:(NSDictionary *)aDict
{
    NSMutableArray *items = [[NSMutableArray alloc] initWithCapacity:[self.tableArray count]];
    NSMutableDictionary *tempDict = (NSMutableDictionary *)aDict;
    [tempDict setObject:@"YES" forKey:@"isRead"];
    for (NSDictionary *dict in self.tableArray)
    {
        if ([[dict objectForKey:@"activityId"] isEqualToString:[tempDict objectForKey:@"activityId"]]) {
            [items addObject:tempDict];
        }
        else
        {
            [items addObject:dict];
        }
        
    }
    
    self.tableArray = items;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [tableArray count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ChannelDetailTableViewCellID" forIndexPath:indexPath];

    UILabel * contentlaber = (UILabel *) [cell viewWithTag:301];
    UILabel * timeLaber = (UILabel *)[cell viewWithTag:302];
    
    contentlaber.text = @"sss";
    timeLaber.text = @"ddd";
    
   NSDictionary * cellDication =  [tableArray objectAtIndex:indexPath.row];
    contentlaber.text = [cellDication objectForKey:@"activityName"];
    
    timeLaber.text = [cellDication objectForKey:@"publishTime"];

    NSString *checkRead = [cellDication objectForKey:@"isRead"];
    
    if ([checkRead isEqualToString:@"YES"])
    {
        cell.backgroundColor = [UIColor lightGrayColor];
    }
    else
    {
        cell.backgroundColor = [UIColor whiteColor] ;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    ChannelCenterDo * cellData =  [tableArray objectAtIndex:indexPath.row];
    
    //    WebViewDetailsViewController * webView = [[WebViewDetailsViewController alloc] init];
    
    NSInteger row = [indexPath row];
    NSDictionary *channelDict = [tableArray objectAtIndex:row];
    NSString *opCode = [channelDict objectForKey:@"opCode"];
    NSString *title = [channelDict objectForKey:@"activityName"];
    NSString *activityID = [channelDict objectForKey:@"activityId"];
    
    //刷新列表数据
    ChannelCenterData *centerData = [[ChannelCenterData alloc] init];
    //读取数据
    [centerData loadData];
    
    [centerData cleanChannelCenterReadWithCenterType:self.channelType activityId:activityID];
    
    [self setTableViewItemsWithDict:channelDict];
    //取消选中状态
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.backgroundColor = [UIColor lightGrayColor];
    
    if ([opCode isEqualToString:@"wsdc"])
    {
        NSString *appointMentStr = [channelDict objectForKey:@"appointment"];
        NSDictionary *appointMentDict = [appointMentStr objectFromJSONString];
        NSString *url = [appointMentDict objectForKey:@"url"];
        WebViewDetailsViewController * webVc = [self.storyboard instantiateViewControllerWithIdentifier:@"WebViewDetailsViewController"];
        webVc.requestURL = url;
        webVc.vcTitle = title;
        [self.navigationController pushViewController:webVc animated:YES];
    }
    else
    {
        ChannelShowDetailViewController *channelDetail = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([ChannelShowDetailViewController class])];
        channelDetail.title = self.title;
        channelDetail.channelDetailDict = channelDict;
        [self.navigationController pushViewController:channelDetail animated:YES];
    }
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
