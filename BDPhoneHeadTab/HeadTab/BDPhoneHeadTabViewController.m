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

@interface BDPhoneHeadTabViewController ()

@property (strong, nonatomic) BDPhoneHeadTabViewData *headTabViewData;
@property (strong, nonatomic) BDPhoneHeadTabView *headTabView;

@end

@implementation BDPhoneHeadTabViewController

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _headTabViewData = [[BDPhoneHeadTabViewData alloc] init];
        _headTabView = [[BDPhoneHeadTabView alloc] initWithViewData:_headTabViewData];

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

- (void)updateStyle:(BDPhoneHeadTabViewStyle)style
{
    if (self.style != style)
    {
        self.style = style;
        [self.headTabView updateStyle:self.style];
    }
}

#pragma mark - add tab

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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
