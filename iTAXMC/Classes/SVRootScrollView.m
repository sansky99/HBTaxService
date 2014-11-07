//
//  SVRootScrollView.m
//  SlideView
//
//  Created by Chen Yaoqiang on 13-12-27.
//  Copyright (c) 2013年 Chen Yaoqiang. All rights reserved.
//

#import "SVRootScrollView.h"

#import "SVGloble.h"
#import "SVTopScrollView.h"

#define POSITIONID (int)(scrollView.contentOffset.x/320)
#define Duration 0.2

@implementation SVRootScrollView

@synthesize viewNameArray;



+(SVRootScrollView *)shareInstance{
    
  SVRootScrollView *_instance =[[self alloc] initWithFrame:CGRectMake(0, 44+IOS7_STATUS_BAR_HEGHT, 320, [SVGloble shareInstance].globleHeight-44)];

    return _instance;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.delegate = self;
        self.backgroundColor = [UIColor lightGrayColor];
        self.pagingEnabled = YES;
        self.userInteractionEnabled = YES;
        self.bounces = NO;
        
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        
        userContentOffsetX = 0;
        
        self.itemArray = [NSMutableArray array];
    }
    return self;
}

- (void)initWithViews
{
    for (int i = 0; i < [viewNameArray count]; i++) {
        
        
        NSArray* item0 = [ServyouDefines getModule:@20000];
        NSLog(@"LEVEL 0: %@ %@", item0[Col_ID], item0[Col_Name]);
        NSArray* children1 = [ServyouDefines getModuleChildren:item0[Col_ID]];
        for (NSArray *item1 in children1)
        {
            NSLog(@"\tLEVEL 1: %@ %@", item1[Col_ID], item1[Col_Name]);
            NSArray* children2 = [ServyouDefines getModuleChildren:item1[Col_ID]];
            for (NSArray *item2 in children2)
            {
                NSLog(@"\t\tLEVEL 2: %@ %@", item2[Col_ID], item2[Col_Name]);
            }
        }
        
        int tabNumber;
        switch (i) {
            case 0:
            case 4:
                tabNumber = 3;
                break;
            case 1:
            case 2:
                tabNumber = 4;
                break;
            case 3:
                tabNumber = 8;
                break;
            default:
                break;
        }
        
        CGFloat y = 320 *i;
        for (NSInteger i = 0;i<tabNumber;i++)
        {
            
            UIView * btnView = [[UIView alloc] init];
            btnView.backgroundColor = [UIColor purpleColor];
            btnView.frame = CGRectMake(15+(i%3)*100+y, 20+(i/3)*100, 90, 90);
            btnView.tag = i;
            [self addSubview:btnView];
            
            
            
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.backgroundColor = [UIColor redColor];
            btn.frame = CGRectMake(0, 0, 90, 80);
            btn.tag = i;
            btn.titleLabel.font = [UIFont boldSystemFontOfSize:20];
            [btn setTitle:[NSString stringWithFormat:@"%d",i+1] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
            [btnView addSubview:btn];
            
            
            UILabel * btnLaber = [[UILabel alloc] initWithFrame:CGRectMake(0, 80, 90, 10)];
            btnLaber.font = [UIFont systemFontOfSize:10];
            btnLaber.text = @"hahahaha";
            btnLaber.backgroundColor = [UIColor clearColor];
            [btnView addSubview:btnLaber];
            
            UILongPressGestureRecognizer *longGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(buttonLongPressed:)];
            [btnView addGestureRecognizer:longGesture];
            
            [self.itemArray addObject:btnView];
            
        }
        
    }
    self.contentSize = CGSizeMake(320*[viewNameArray count], [SVGloble shareInstance].globleHeight-44);
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    userContentOffsetX = scrollView.contentOffset.x;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (userContentOffsetX < scrollView.contentOffset.x) {
        isLeftScroll = YES;
    }
    else {
        isLeftScroll = NO;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //调整顶部滑条按钮状态
    [self adjustTopScrollViewButton:scrollView];
    
    [self loadData];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    [self loadData];
}

-(void)loadData
{
    CGFloat pagewidth = self.frame.size.width;
    int page = floor((self.contentOffset.x - pagewidth/viewNameArray.count)/pagewidth)+1;
    UILabel *label = (UILabel *)[self viewWithTag:page+200];
    label.text = [NSString stringWithFormat:@"%@",[viewNameArray objectAtIndex:page]];
}

//滚动后修改顶部滚动条
- (void)adjustTopScrollViewButton:(UIScrollView *)scrollView
{
   //[[SVTopScrollView shareInstance] setButtonUnSelect];
    [SVTopScrollView  shareInstance].scrollViewSelectedChannelID = POSITIONID+100;
    [[SVTopScrollView shareInstance] setButtonSelect];
    [[SVTopScrollView shareInstance] setScrollViewContentOffset];
}


-(void)btnAction:(UIButton *)button{
    
    NSLog(@"~~~~~~~~~button = %d",button.tag);
    NSString * textString =   button.titleLabel.text;
    NSLog(@"~~~~textString = %@",textString);
}


- (void)buttonLongPressed:(UILongPressGestureRecognizer *)sender
{
    UIView * btn = (UIView *)sender.view;
    if (sender.state == UIGestureRecognizerStateBegan)
    {
        startPoint = [sender locationInView:sender.view];
        originPoint = btn.center;
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
        NSLog(@"center = %@",NSStringFromCGPoint(btn.center));
        NSInteger index = [self indexOfPoint:btn.center withButton:btn];
        if (index<0)
        {
            contain = NO;
        }
        else
        {
            [UIView animateWithDuration:Duration animations:^{
                
                CGPoint temp = CGPointZero;
                UIButton *button = _itemArray[index];
                temp = button.center;
                button.center = originPoint;
                btn.center = temp;
                originPoint = btn.center;
                contain = YES;
                
            }];
        }
        
        
    }
    else if (sender.state == UIGestureRecognizerStateEnded)
    {
        [UIView animateWithDuration:Duration animations:^{
            
            btn.transform = CGAffineTransformIdentity;
            btn.alpha = 1.0;
            if (!contain)
            {
                btn.center = originPoint;
            }
        }];
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
                NSLog(@"~~~i = %d",i);
                return i;
            }
        }
    }
    return -1;
}

@end
