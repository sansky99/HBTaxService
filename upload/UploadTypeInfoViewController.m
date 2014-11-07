//
//  UploadTypeInfoViewController.m
//  HBTaxService
//
//  Created by khuang on 14-11-7.
//  Copyright (c) 2014年 servyou. All rights reserved.
//

#import "UploadTypeInfoViewController.h"
#include "CompatibleaPrintf.h"

@interface UploadTypeInfoViewController ()
@property (nonatomic, strong) UITextView *labInfo;
@end

@implementation UploadTypeInfoViewController
@synthesize info, labInfo;

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
    
    NeedOffsetWhenIOS7NavBar
    self.hidesBottomBarWhenPushed = TRUE;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    labInfo = [[UITextView alloc] init];
//    labInfo.numberOfLines = 0;
    labInfo.selectable = FALSE;
    labInfo.editable = FALSE;
    labInfo.font = [UIFont systemFontOfSize:[UIFont buttonFontSize]];
//    labInfo.contentMode

    labInfo.text = self.info;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) viewDidLayoutSubviews
{
    CGRect rt =self.view.bounds;
    labInfo.frame =rt;
    [self.view addSubview:labInfo];
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
