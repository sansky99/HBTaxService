//
//  FontSizeViewController.m
//  iTAXMC
//
//  Created by khuang on 14-7-16.
//  Copyright (c) 2014年 servyou. All rights reserved.
//

#import "FontSizeViewController.h"
#import "UserInfo.h"


@interface FontSizeViewController ()<UITableViewDataSource, UITableViewDelegate>

@end

@implementation FontSizeViewController

@synthesize fontsize;

static NSArray *items;

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
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        items = @[@"大号字体", @"中号字体", @"小号字体"];
        //[FontSize_Big, FontSize_Normal, FontSize_Small]
    });
    
    UserInfo *userInfo = [ServyouDefines sharedUserInfo];
    [userInfo loadFontSize];
    self.fontsize = userInfo.fontSize;
    
    self.containerView.layer.masksToBounds = TRUE;
    self.containerView.layer.cornerRadius = 5;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onCancel:(id)sender {
    [self dismissViewControllerAnimated:FALSE completion:nil];
}

- (IBAction)onOK:(id)sender {
    UserInfo *userInfo = [ServyouDefines sharedUserInfo];
    userInfo.fontSize = self.fontsize;
    [userInfo saveFontSize];
    
    [self dismissViewControllerAnimated:FALSE completion:nil];
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

#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"FontSizeViewTableCellID" forIndexPath:indexPath];
    cell.textLabel.text = items[indexPath.row];
    if (indexPath.row == fontsize)
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    else
        cell.accessoryType = UITableViewCellAccessoryNone;
   
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.fontsize = indexPath.row;
    [self.tableView reloadData];
 }
@end
