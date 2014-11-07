//
//  CompatibleaPrintf.h
//  iTAXMC
//
//  Created by hellen.zhou on 14-8-26.
//  Copyright (c) 2014年 servyou. All rights reserved.
//

#ifndef iTAXMC_CompatibleaPrintf_h
#define iTAXMC_CompatibleaPrintf_h

#ifdef __IPHONE_5_0
#define SYLineBreakModeWordWrap     NSLineBreakByWordWrapping
#else
#define SYLineBreakModeWordWrap     UILineBreakModeWordWrap
#endif

#ifdef __IPHONE_6_0
#define SYTextAlignmentCenter       NSTextAlignmentCenter
#define SYTextAlignmentRight        NSTextAlignmentRight
#else
#define SYTextAlignmentCenter       UITextAlignmentCenter
#define SYTextAlignmentRight        UITextAlignmentRight
#endif

#define IOS7_Compate_IOS6_NavBar_Offset \
if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1){ \
self.edgesForExtendedLayout = UIRectEdgeNone; \
self.extendedLayoutIncludesOpaqueBars = NO; \
self.modalPresentationCapturesStatusBarAppearance = NO; \
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
#define NeedOffsetWhenIOS7NavBar IOS7_Compate_IOS6_NavBar_Offset
#else
#define NeedOffsetWhenIOS7NavBar
#endif

#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)


CG_INLINE BOOL OSVersionIsAtLeastiOS7()
{
    return (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1);
}

CG_INLINE CGFloat heightForCompatibleIos7(CGFloat height)
{
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1) {
        return  (height - 64.f);
    }
    
    return height;
}

#define SYNavBackButton { \
if(floor(NSFoundationVersionNumber)<= NSFoundationVersionNumber_iOS_6_1){ \
UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom]; \
btn.frame = CGRectMake(0, 0, 20, 20); \
btn.contentMode = UIViewContentModeCenter; \
[btn setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal]; \
[btn addTarget:self action:@selector(doBack:) forControlEvents:UIControlEventTouchUpInside]; \
UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:btn]; \
[self.navigationItem setLeftBarButtonItem:backButton animated:YES];}}

#define SYNeedNavBarDoback  \
- (void)doBack:(id)sender \
{ \
    [self.navigationController popViewControllerAnimated:YES]; \
}


#endif
