//
//  ChannelShowDetailViewController.m
//  ZHTaxService
//
//  Created by mac on 14-10-23.
//  Copyright (c) 2014年 servyou. All rights reserved.
//

#import "ChannelShowDetailViewController.h"

#define Channel_Desc_Font [UIFont systemFontOfSize:14]

#define Channel_Title_Font [UIFont systemFontOfSize:18]

#define MAXHeight 500000

@interface ChannelShowDetailViewController ()
//标题
@property (nonatomic, strong) IBOutlet UILabel *titleLabel;
//详情
@property (nonatomic, strong) IBOutlet UILabel *descLabel;

@property (nonatomic, strong) IBOutlet UIScrollView *mainScrol;
@end

@implementation ChannelShowDetailViewController

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
    [self initViews];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)initViews
{
    //设置可以折行
    [self.titleLabel setNumberOfLines:0];
    [self.descLabel setNumberOfLines:0];
    //设置字体大小
    [self.titleLabel setFont:Channel_Title_Font];
    [self.descLabel setFont:Channel_Desc_Font];
    //获取label的frame
    CGRect titleRect = self.titleLabel.frame;
    CGRect descRect = self.descLabel.frame;
    
    NSString *title = [self.channelDetailDict objectForKey:@"activityName"];
    NSString *desc = [self.channelDetailDict objectForKey:@"activityDesc"];
    
    if ([title isKindOfClass:[NSString class]])
    {
        CGSize titleSize = [title sizeWithFont:Channel_Title_Font
                             constrainedToSize:CGSizeMake(titleRect.size.width, MAXHeight)
                                 lineBreakMode:NSLineBreakByWordWrapping];
        //重新设置标题label的大小
        [self.titleLabel setFrame:CGRectMake(titleRect.origin.x,
                                             titleRect.origin.y+5,
                                             titleSize.width,
                                             titleSize.height)];
        [self.titleLabel setText:title];
    }
    
    if ([desc isKindOfClass:[NSString class]])
    {
        //size
        CGSize descSize = [desc sizeWithFont:Channel_Desc_Font
                           constrainedToSize:CGSizeMake(descRect.size.width, MAXHeight)
                               lineBreakMode:NSLineBreakByWordWrapping];
        //设置frame
        [self.descLabel setFrame:CGRectMake(descRect.origin.x,
                                            self.titleLabel.frame.origin.y+self.titleLabel.frame.size.height+10,
                                            descSize.width,
                                            descSize.height)];
        
        //设置内容
        [self.descLabel setText:desc];
        
        //设置scrolView 滑动范围。
        [self.mainScrol setContentSize:CGSizeMake(320,
                                                  self.descLabel.frame.origin.y+self.descLabel.frame.size.height)];
    }
    
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
