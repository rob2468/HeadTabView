//
//  BDPhoneHeadTabViewController.h
//  BDPhoneHeadTab
//
//  Created by jam on 15/10/27.
//  Copyright © 2015年 Baidu Inc. All rights reserved.
//
/**
 * HeadTab should have at least two tabs.
 */

#import <UIKit/UIKit.h>
#import "BDPhoneHeadTabViewData.h"

typedef enum
{
    BDPhoneHeadTabViewStyleBlue = 0,
    BDPhoneHeadTabViewStyleWhite,
    BDPhoneHeadTabViewStyleGray,
    BDPhoneHeadTabViewStyleRed,
    BDPhoneHeadTabViewStyleLightGray
} BDPhoneHeadTabViewStyle;

@class BDPhoneHeadTabViewController;

#pragma mark - Head Tab View Controller Delegate

@protocol BDPhoneHeadTabViewControllerDelegate <NSObject>

@optional

- (void)onTabChanged:(BDPhoneHeadTabViewController *)sender;

@end

#pragma mark - Head Tab View Controller

@interface BDPhoneHeadTabViewController : UIViewController

/**
 *  current tab index
 */
@property (readonly, assign, nonatomic) NSInteger currentTabIndex;

/**
 *  style of tab view
 */
@property (readwrite, assign, nonatomic) BDPhoneHeadTabViewStyle tabViewStyle;

/**
 *  bounces enable, default is YES
 */
@property (readwrite, assign, nonatomic) BOOL bouncesEnable;

/**
 *  switch by dragging enable, default is YES
 */
@property (readwrite, assign, nonatomic) BOOL switchByDraggingEnable;

/**
 *  switch animation enable, default is YES
 */
@property (readwrite, assign, nonatomic) BOOL switchAnimationEnable;

/**
 *  show line indicator, default is NO
 */
@property (readwrite, assign, nonatomic) BOOL showLineIndicator;

/**
 *  delegate
 */
@property (weak, nonatomic) id<BDPhoneHeadTabViewControllerDelegate> delegate;

- (instancetype)initWithTabIndex:(NSInteger)tabIndex viewData:(BDPhoneHeadTabViewData *)headTabViewData;

/**
 *  add tab
 */
- (void)addTabWithTitle:(NSString *)title;
- (void)addTabWithView:(UIView *)view;
- (void)addTabWithTitle:(NSString *)title view:(UIView *)view;

/**
 *  select tab
 */
- (void)selectTabAtIndex:(NSInteger)tabIndex;
- (void)selectTabOfView:(UIView *)tabView;  // TO COMPLETE

@end
