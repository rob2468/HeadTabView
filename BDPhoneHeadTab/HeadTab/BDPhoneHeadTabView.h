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

@protocol BDPhoneHeadTabViewDelegate <NSObject>

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

/**
 *  @brief initialize with BDPhoneHeadTabViewData
 */
- (instancetype)initWithViewData:(BDPhoneHeadTabViewData *)viewData;

/**
 *  @brief set or modify style
 */
- (void)updateStyle:(BDPhoneHeadTabViewStyle)style;

/**
 *  @brief add tab
 */
- (void)addTabWithTitle:(NSString *)title view:(UIView *)view currentTabIndex:(NSInteger)currentTabIndex;

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

@property (strong, nonatomic) NSLayoutConstraint *switchButtonCenterXConstraint;
@property (strong, nonatomic) NSLayoutConstraint *contentViewTrailingConstraint;

/**
 *  @brief initialize with title and content view
 */
- (instancetype)initWithTitle:(NSString *)title view:(UIView *)view;

@end
