//
//  ViewController.m
//  BDPhoneHeadTab
//
//  Created by jam on 15/10/27.
//  Copyright © 2015年 Baidu Inc. All rights reserved.
//

#import "ViewController.h"
#import "BDPhoneHeadTabViewController.h"
#import "BDRedViewController.h"
#import "BDGreenViewController.h"
#import "BDBlueViewController.h"

@interface ViewController () <BDPhoneHeadTabViewControllerDelegate>

@property (strong, nonatomic) BDPhoneHeadTabViewController *headTabViewController;

@property (strong, nonatomic) BDRedViewController *redViewController;
@property (strong, nonatomic) BDGreenViewController *greenViewController;
@property (strong, nonatomic) BDBlueViewController *blueViewController;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.headTabViewController = [[BDPhoneHeadTabViewController alloc] initWithTabIndex:1 viewData:nil];
    self.headTabViewController.delegate = self;
    self.headTabViewController.bouncesEnable = YES;
    self.headTabViewController.switchByDraggingEnable = YES;
    self.headTabViewController.switchAnimationEnable = NO;
    self.headTabViewController.tabViewStyle = BDPhoneHeadTabViewStyleLightGray;
    self.headTabViewController.showLineIndicator = YES;
    [self.view addSubview:self.headTabViewController.view];
    [self addChildViewController:self.headTabViewController];
    [self.headTabViewController didMoveToParentViewController:self];
    
    // layout
    UIView *headTabView = self.headTabViewController.view;
    headTabView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addConstraint:
     [NSLayoutConstraint constraintWithItem:headTabView
                                  attribute:(NSLayoutAttributeLeading)
                                  relatedBy:(NSLayoutRelationEqual)
                                     toItem:self.view
                                  attribute:(NSLayoutAttributeTop)
                                 multiplier:1
                                   constant:0]];
    [self.view addConstraint:
     [NSLayoutConstraint constraintWithItem:headTabView
                                  attribute:(NSLayoutAttributeTop)
                                  relatedBy:(NSLayoutRelationEqual)
                                     toItem:self.view
                                  attribute:(NSLayoutAttributeTop)
                                 multiplier:1
                                   constant:0]];
    [self.view addConstraint:
     [NSLayoutConstraint constraintWithItem:headTabView
                                  attribute:(NSLayoutAttributeTrailing)
                                  relatedBy:(NSLayoutRelationEqual)
                                     toItem:self.view
                                  attribute:(NSLayoutAttributeTrailing)
                                 multiplier:1
                                   constant:0]];
    [self.view addConstraint:
     [NSLayoutConstraint constraintWithItem:headTabView
                                  attribute:(NSLayoutAttributeBottom)
                                  relatedBy:(NSLayoutRelationEqual)
                                     toItem:self.view
                                  attribute:(NSLayoutAttributeBottom)
                                 multiplier:1
                                   constant:0]];
    
    // add tabs
    self.redViewController = [[BDRedViewController alloc] init];
    [self.headTabViewController addTabWithTitle:@"Red" view:self.redViewController.view];
    
    self.greenViewController = [[BDGreenViewController alloc] init];
    [self.headTabViewController addTabWithTitle:@"Green" view:self.greenViewController.view];
    
    self.blueViewController = [[BDBlueViewController alloc] init];
    [self.headTabViewController addTabWithTitle:@"Blue" view:self.blueViewController.view];
}

#pragma mark - BDPhoneHeadTabViewControllerDelegate

- (void)onTabChanged:(BDPhoneHeadTabViewController *)sender
{
//    NSLog(@"onTabChanged to index: %ld", (long)sender.currentTabIndex);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
