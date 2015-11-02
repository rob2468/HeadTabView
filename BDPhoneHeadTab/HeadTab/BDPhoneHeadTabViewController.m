//
//  BDPhoneHeadTabViewController.m
//  BDPhoneHeadTab
//
//  Created by jam on 15/10/27.
//  Copyright © 2015年 Baidu Inc. All rights reserved.
//

#import "BDPhoneHeadTabViewController.h"
#import "BDPhoneHeadTabView.h"

@interface BDPhoneHeadTabViewController () <BDPhoneHeadTabViewDelegate>

@property (strong, nonatomic) BDPhoneHeadTabView *headTabView;

@end

@implementation BDPhoneHeadTabViewController

- (instancetype)initWithTabIndex:(NSInteger)tabIndex viewData:(BDPhoneHeadTabViewData *)headTabViewData
{
    self = [super init];
    if (self)
    {
        if (headTabViewData == nil)
        {
            headTabViewData = [[BDPhoneHeadTabViewData alloc] init];
        }
        _headTabView = [[BDPhoneHeadTabView alloc] initWithTabIndex:tabIndex viewData:headTabViewData];
        _headTabView.delegate = self;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view addSubview:self.headTabView];
    
    self.headTabView.translatesAutoresizingMaskIntoConstraints = NO;
    
    // add constraints
    [self.view addConstraint:
     [NSLayoutConstraint constraintWithItem:self.headTabView
                                  attribute:(NSLayoutAttributeLeading)
                                  relatedBy:(NSLayoutRelationEqual)
                                     toItem:self.view
                                  attribute:(NSLayoutAttributeLeading)
                                 multiplier:1
                                   constant:0]];
    [self.view addConstraint:
     [NSLayoutConstraint constraintWithItem:self.headTabView
                                  attribute:(NSLayoutAttributeTop)
                                  relatedBy:(NSLayoutRelationEqual)
                                     toItem:self.view
                                  attribute:(NSLayoutAttributeTop)
                                 multiplier:1
                                   constant:0]];
    [self.view addConstraint:
     [NSLayoutConstraint constraintWithItem:self.headTabView
                                  attribute:(NSLayoutAttributeTrailing)
                                  relatedBy:(NSLayoutRelationEqual)
                                     toItem:self.view
                                  attribute:(NSLayoutAttributeTrailing)
                                 multiplier:1
                                   constant:0]];
    [self.view addConstraint:
     [NSLayoutConstraint constraintWithItem:self.headTabView
                                  attribute:(NSLayoutAttributeBottom)
                                  relatedBy:(NSLayoutRelationEqual)
                                     toItem:self.view
                                  attribute:(NSLayoutAttributeBottom)
                                 multiplier:1
                                   constant:0]];
}

#pragma mark - BDPhoneHeadTabViewDelegate

- (void)onTabChanged:(BDPhoneHeadTabView *)sender fromTabIndex:(NSInteger)fromTabIndex
{
    if ([self.delegate respondsToSelector:@selector(onTabChanged:)])
    {
        [self.delegate onTabChanged:self];
    }
}

#pragma Setter and Getter

- (NSInteger)currentTabIndex
{
    return self.headTabView.currentTabIndex;
}

- (void)setTabViewStyle:(BDPhoneHeadTabViewStyle)tabViewStyle
{
    if (_tabViewStyle != tabViewStyle)
    {
        _tabViewStyle = tabViewStyle;
        [self.headTabView updateStyle:tabViewStyle];
    }
}

- (void)setBouncesEnable:(BOOL)bouncesEnable
{
    self.headTabView.contentScrollView.bounces = bouncesEnable;
}

- (BOOL)bouncesEnable
{
    return self.headTabView.contentScrollView.bounces;
}

- (void)setSwitchByDraggingEnable:(BOOL)switchByDraggingEnable
{
    self.headTabView.contentScrollView.scrollEnabled = switchByDraggingEnable;
}

- (BOOL)switchByDraggingEnable
{
    return self.headTabView.contentScrollView.scrollEnabled;
}

- (void)setSwitchAnimationEnable:(BOOL)switchAnimationEnable
{
    self.headTabView.switchAnimationEnable = switchAnimationEnable;
}

- (BOOL)switchAnimationEnable
{
    return self.headTabView.switchAnimationEnable;
}

- (void)setShowLineIndicator:(BOOL)showLineIndicator
{
    self.headTabView.lineIndicatorView.hidden = !showLineIndicator;
}

- (BOOL)showLineIndicator
{
    return !self.headTabView.lineIndicatorView.hidden;
}

#pragma mark - Add Tab

- (void)addTabWithTitle:(NSString *)title
{
    [self addTabWithTitle:title view:nil];
}

- (void)addTabWithView:(UIView *)view
{
    [self addTabWithTitle:nil view:view];
}

- (void)addTabWithTitle:(NSString *)title view:(UIView *)view
{
    [self.headTabView addTabWithTitle:title view:view];
}

#pragma mark - Select Tab

- (void)selectTabAtIndex:(NSInteger)tabIndex
{
    [self.headTabView selectTabAtIndex:tabIndex];
}

- (void)selectTabOfView:(UIView *)tabView
{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
