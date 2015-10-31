//
//  BDPhoneHeadTabView.h
//  BDPhoneHeadTab
//
//  Created by jam on 15/10/27.
//  Copyright © 2015年 Baidu Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BDPhoneHeadTabViewData.h"
#import "BDPhoneHeadTabViewController.h"

#pragma mark - BDPhoneHeadTabViewDelegate

@class BDPhoneHeadTabView;

@protocol BDPhoneHeadTabViewDelegate <NSObject>

- (void)onTabChanged:(BDPhoneHeadTabView *)sender fromTabIndex:(NSInteger)fromTabIndex;

@end

#pragma mark - Tab View

@interface BDPhoneHeadTabView : UIView

/**
 *  @brief background view in head area
 */
@property (strong, nonatomic) UIView *headBackgroundView;

/**
 *  @brief line indicator for tab
 */
@property (strong, nonatomic) UIView *lineIndicatorView;

/**
 *  @brief content view container
 */
@property (strong, nonatomic) UIScrollView *contentScrollView;
@property (strong, nonatomic) UIView *contentView;      // added to scroll view

@property (weak, nonatomic) id<BDPhoneHeadTabViewDelegate> delegate;

/**
 *  current tab index
 */
@property (readonly, assign, nonatomic) NSInteger currentTabIndex;

/**
 *  @brief initialize with BDPhoneHeadTabViewData
 */
- (instancetype)initWithTabIndex:(NSInteger)tabIndex viewData:(BDPhoneHeadTabViewData *)viewData;

/**
 *  @brief set or modify style
 */
- (void)updateStyle:(BDPhoneHeadTabViewStyle)style;

/**
 *  @brief add tab
 */
- (void)addTabWithTitle:(NSString *)title view:(UIView *)view;

/**
 *  @brief select tab
 */
- (void)selectTabAtIndex:(NSInteger)tabIndex;

@end

#pragma mark - Tab Element

/**
 *  an instance of BDPhoneHeadTabElement contains:
 *  1. a switch button
 *  2. a content view
 */
@interface BDPhoneHeadTabElement : NSObject

@property (strong, nonatomic) UIButton *switchButton;
@property (strong, nonatomic) UIView *contentView;

@property (strong, nonatomic) NSLayoutConstraint *switchButtonWidthConstraint;
@property (strong, nonatomic) NSLayoutConstraint *switchButtonHeightConstraint;
@property (strong, nonatomic) NSLayoutConstraint *switchButtonCenterXConstraint;
@property (strong, nonatomic) NSLayoutConstraint *contentViewTrailingConstraint;

/**
 *  @brief initialize with title and content view
 */
- (instancetype)initWithTitle:(NSString *)title view:(UIView *)view;

@end
