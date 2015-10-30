//
//  BDPhoneHeadTabViewController.m
//  BDPhoneHeadTab
//
//  Created by jam on 15/10/27.
//  Copyright © 2015年 Baidu Inc. All rights reserved.
//

#import "BDPhoneHeadTabViewController.h"
#import "BDPhoneHeadTabView.h"
#import "BDPhoneHeadTabViewData.h"

@interface BDPhoneHeadTabViewController () <BDPhoneHeadTabViewDelegate>

@property (strong, nonatomic) BDPhoneHeadTabViewData *headTabViewData;
@property (strong, nonatomic) BDPhoneHeadTabView *headTabView;

@end

@implementation BDPhoneHeadTabViewController

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _currentTabIndex = 0;
        
        _headTabViewData = [[BDPhoneHeadTabViewData alloc] init];
        _headTabView = [[BDPhoneHeadTabView alloc] initWithViewData:_headTabViewData];
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

#pragma mark -

- (void)updateStyle:(BDPhoneHeadTabViewStyle)style
{
    if (self.style != style)
    {
        self.style = style;
        [self.headTabView updateStyle:self.style];
    }
}

#pragma Setter and Getter

- (NSInteger)currentTabIndex
{
    return self.headTabView.currentTabIndex;
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
