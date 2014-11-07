//
//  UIScrollView+PullToFetchMore.h
//  XJTaxService
//
//  Created by hellen.zhou on 14-9-17.
//  Copyright (c) 2014年 servyou. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^PullFetchMoreStartBlock)(void);
typedef void (^PullFetchMoreEndBlock)(BOOL can_fetch_more);

typedef NS_ENUM(NSInteger, PullToFetchMoreState)
{
    
	PullToFetchMoreNone = 0,     //没有状态
    
	PullToFetchMoreNormal,       //上拉加载
    
    PullToFetchMorePulling ,     //松开加载
    
	PullToFetchMoreLoading,      //刷新中
    
};

#pragma mark -
#pragma mark - SYPullToFetchMoreView

@interface SYPullToFetchMoreView : UIView


/*
 *void 设置上拉加载
 *
 *@param a_pull_to_fetch_more_state :  上拉加载 的状态
 *
 */
- (void)setPullToFetchMoreState: (PullToFetchMoreState) a_pull_to_fetch_more_state;


/*
 *void 开始上拉动画
 *
 */
- (void)startAnimation;

/*
 *void 结束上拉动画
 *
 */
- (void)stopAnimation;

@end


#pragma mark -
#pragma mark - UIScrollView fetch

@interface UITableView (PullToFetchMore)

@property (readonly,strong,nonatomic) SYPullToFetchMoreView *pull_to_fetch_more_view; //加载更多
@property (nonatomic,assign         ) BOOL                   show_infinite_scrolling;


/*
 *void 设置上可以刷新的block
 *
 *@param  fetch_more_end_block : 上拉刷新的block
 *
 */
- (void)setPullToFetchMoreEndBlock: (PullFetchMoreEndBlock) fetch_more_end_block;

/*
 *void 开始下拉加载更多的动画
 *
 */
- (void)startPullToFetchMoreAnimating;

/*
 *void 结束下拉加载更多的动画
 *
 */
- (void)stopPullToFetchMoreAnimating;

/*
 *void 移除获取更多的观察者
 *
 */
- (void)removeFetchMoreObserver;

@end


