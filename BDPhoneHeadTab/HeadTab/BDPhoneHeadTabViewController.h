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
 *  switch by dragging enable, default is YES
 */
@property (readwrite, assign, nonatomic) BOOL switchByDraggingEnable;

/**
 *  delegate
 */
@property (weak, nonatomic) id<BDPhoneHeadTabViewControllerDelegate> delegate;

- (instancetype)initWithTabIndex:(NSInteger)tabIndex;

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
