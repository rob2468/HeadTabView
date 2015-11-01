//
//  BDPhoneHeadTabView.m
//  BDPhoneHeadTab
//
//  Created by jam on 15/10/27.
//  Copyright © 2015年 Baidu Inc. All rights reserved.
//

#import "BDPhoneHeadTabView.h"
#import "BDPhoneHeadTabViewData.h"

#pragma mark - Tab View

@interface BDPhoneHeadTabView () <UIScrollViewDelegate>

// redeclaration
@property (readwrite, assign, nonatomic) NSInteger currentTabIndex;

@property (strong, nonatomic) BDPhoneHeadTabViewData *viewData; // view data

@property (strong, nonatomic) UIColor *switchButtonNormalColor;
@property (strong, nonatomic) UIColor *switchButtonHighlightColor;
@property (strong, nonatomic) UIColor *switchButtonSelectedColor;

@property (strong, nonatomic) NSLayoutConstraint *headBackgroundViewHeightConstraint;
@property (strong, nonatomic) NSLayoutConstraint *lineIndicatorViewWidthConstraint;
@property (strong, nonatomic) NSLayoutConstraint *lineIndicatorViewLeadingConstraint;

@property (strong, nonatomic) NSMutableArray *tabElements;      // tab elements

@end

@implementation BDPhoneHeadTabView

- (instancetype)initWithTabIndex:(NSInteger)tabIndex viewData:(BDPhoneHeadTabViewData *)viewData;
{
    self = [super init];
    if (self)
    {
        _currentTabIndex = tabIndex;
        
        // view data
        _viewData = viewData;
        
        _switchButtonNormalColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5f];
        _switchButtonHighlightColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1.0f];
        _switchButtonSelectedColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1.0f];
        
        // create instances and add subviews
        _headBackgroundView = [[UIView alloc] init];
        _headBackgroundView.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:_headBackgroundView];
        
        _lineIndicatorView = [[UIView alloc] init]; // will be added to view when the first tab added
        _lineIndicatorView.translatesAutoresizingMaskIntoConstraints = NO;
        _lineIndicatorView.hidden = YES;
        
        _contentScrollView = [[UIScrollView alloc] init];
        _contentScrollView.translatesAutoresizingMaskIntoConstraints = NO;
        _contentScrollView.pagingEnabled = YES;
        _contentScrollView.bounces = YES;
        _contentScrollView.scrollEnabled = YES;
        _contentScrollView.showsHorizontalScrollIndicator = NO;
        _contentScrollView.delegate = self;
        [self addSubview:_contentScrollView];
        
        _contentView = [[UIView alloc] init];
        _contentView.translatesAutoresizingMaskIntoConstraints = NO;
        [_contentScrollView addSubview:_contentView];
        
        _tabElements = [[NSMutableArray alloc] init];
        
        // KVO
        [_contentScrollView addObserver:self forKeyPath:@"contentOffset" options:(NSKeyValueObservingOptionNew) context:nil];
        
        // add constraints
        NSDictionary *viewsDict = NSDictionaryOfVariableBindings(_headBackgroundView, _contentScrollView, _contentView);
        
        // headBackgroundView
        [self addConstraints:
         [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_headBackgroundView]|"
                                                 options:0
                                                 metrics:nil
                                                   views:viewsDict]];
        [self addConstraint:
         [NSLayoutConstraint constraintWithItem:_headBackgroundView
                                      attribute:(NSLayoutAttributeTop)
                                      relatedBy:(NSLayoutRelationEqual)
                                         toItem:self
                                      attribute:(NSLayoutAttributeTop)
                                     multiplier:1
                                       constant:0]];
        CGFloat headBackgroundViewHeight;
        if ([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationPortrait)
        {
            headBackgroundViewHeight = viewData.headBackgroundViewPortraitHeight;
        }
        else
        {
            headBackgroundViewHeight = viewData.headBackgroundViewLandscapeHeight;
        }
        _headBackgroundViewHeightConstraint =
        [NSLayoutConstraint constraintWithItem:_headBackgroundView
                                     attribute:(NSLayoutAttributeHeight)
                                     relatedBy:(NSLayoutRelationEqual)
                                        toItem:self
                                     attribute:(NSLayoutAttributeHeight)
                                    multiplier:0
                                      constant:headBackgroundViewHeight];
        [self addConstraint:_headBackgroundViewHeightConstraint];
        
        // contentScrollView
        [self addConstraints:
         [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_contentScrollView]|"
                                                 options:0
                                                 metrics:nil
                                                   views:viewsDict]];
        [self addConstraints:
         [NSLayoutConstraint constraintsWithVisualFormat:@"V:[_headBackgroundView][_contentScrollView]|"
                                                 options:0
                                                 metrics:nil
                                                   views:viewsDict]];
        
        // contentView
        [self addConstraints:
         [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_contentView]|"
                                                 options:0
                                                 metrics:nil
                                                   views:viewsDict]];
        [self addConstraints:
         [NSLayoutConstraint constraintsWithVisualFormat:@"V:[_contentView]|"
                                                 options:0
                                                 metrics:nil
                                                   views:viewsDict]];
        
        // contentView
        [self addConstraint:
         [NSLayoutConstraint constraintWithItem:_contentView
                                      attribute:(NSLayoutAttributeTop)
                                      relatedBy:(NSLayoutRelationEqual)
                                         toItem:_headBackgroundView
                                      attribute:(NSLayoutAttributeBottom)
                                     multiplier:1
                                       constant:0]];
        [self addConstraint:
         [NSLayoutConstraint constraintWithItem:_contentView
                                      attribute:(NSLayoutAttributeBottom)
                                      relatedBy:(NSLayoutRelationEqual)
                                         toItem:self
                                      attribute:(NSLayoutAttributeBottom)
                                     multiplier:1
                                       constant:0]];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [_contentScrollView removeObserver:self forKeyPath:@"contentOffset"];
}

- (void)layoutSubviews
{
    // modify constraints
    if ([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationPortrait)
    {
        self.headBackgroundViewHeightConstraint.constant = self.viewData.headBackgroundViewPortraitHeight;
    }
    else
    {
        self.headBackgroundViewHeightConstraint.constant = self.viewData.headBackgroundViewLandscapeHeight;
    }
    if (self.tabElements != nil && [self.tabElements count] > 0)
    {
        [self regulateSwitchButtonsConstraints];
    }
    
    [self setNeedsUpdateConstraints];
    [self layoutIfNeeded];
    
    // regulate views
    if (!self.contentScrollView.isDecelerating)
    {
        if (self.tabElements != nil && [self.tabElements count] > 0 && self.currentTabIndex < [self.tabElements count])
        {
            BDPhoneHeadTabElement *currentTabElement = [self.tabElements objectAtIndex:self.currentTabIndex];
            
            CGPoint contentOffset = currentTabElement.contentView.frame.origin;
            [self.contentScrollView setContentOffset:contentOffset animated:NO];
        }
    }
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"contentOffset"])
    {
        if (self.tabElements != nil && [self.tabElements count] > 1)
        {
            CGFloat viewTotalWidth = self.contentScrollView.bounds.size.width * ([self.tabElements count] -1);
            CGFloat offsetRatio = self.contentScrollView.contentOffset.x / viewTotalWidth;
            
            CGFloat gapWidth;
            if ([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationPortrait)
            {
                gapWidth = self.viewData.headSwitchButtonPortraitWidth;
            }
            else
            {
                gapWidth = self.viewData.headSwitchButtonLandscapeWidth;
            }
            CGFloat switchButtonTotalWidth = gapWidth * ([self.tabElements count] -1);
            
            self.lineIndicatorViewLeadingConstraint.constant = switchButtonTotalWidth * offsetRatio;
            
            [self setNeedsUpdateConstraints];
        }
    }
}

#pragma mark - General Methods

- (void)updateStyle:(BDPhoneHeadTabViewStyle)style
{
    UIColor *headBackgroundColor;
    UIColor *lineIndicatorViewBackgroundColor;
    
    // set variables
    switch (style)
    {
        case BDPhoneHeadTabViewStyleBlue:
        {
            break;
        }
        case BDPhoneHeadTabViewStyleLightGray:
        {
            headBackgroundColor = [UIColor colorWithRed:248/255.f green:248/255.f blue:248/255.f alpha:1];
            lineIndicatorViewBackgroundColor = [UIColor blackColor];
            
            self.switchButtonNormalColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5f];
            self.switchButtonHighlightColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1.0f];
            self.switchButtonSelectedColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1.0f];
            break;
        }
        default:
        {
            headBackgroundColor = [UIColor colorWithRed:248/255.f green:248/255.f blue:248/255.f alpha:1];
            lineIndicatorViewBackgroundColor = [UIColor blackColor];
            
            self.switchButtonNormalColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5f];
            self.switchButtonHighlightColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1.0f];
            self.switchButtonSelectedColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1.0f];
            break;
        }
    }
    
    // set views
    self.headBackgroundView.backgroundColor = headBackgroundColor;
    self.lineIndicatorView.backgroundColor = lineIndicatorViewBackgroundColor;
    
    for (BDPhoneHeadTabElement *tabElement in self.tabElements)
    {
        [tabElement.switchButton setTitleColor:self.switchButtonNormalColor forState:(UIControlStateNormal)];
        [tabElement.switchButton setTitleColor:self.switchButtonHighlightColor forState:(UIControlStateHighlighted)];
        [tabElement.switchButton setTitleColor:self.switchButtonSelectedColor forState:(UIControlStateSelected)];
    }
}

- (void)addTabWithTitle:(NSString *)title view:(UIView *)view
{
    // initialization
    BDPhoneHeadTabElement *tabElement = [[BDPhoneHeadTabElement alloc] initWithTitle:title view:view];
    [tabElement.switchButton setTitleColor:self.switchButtonNormalColor forState:(UIControlStateNormal)];
    [tabElement.switchButton setTitleColor:self.switchButtonHighlightColor forState:(UIControlStateHighlighted)];
    [tabElement.switchButton setTitleColor:self.switchButtonSelectedColor forState:(UIControlStateSelected)];
    [tabElement.switchButton addTarget:self action:@selector(switchButtonSelected:) forControlEvents:(UIControlEventTouchUpInside)];
    
    [self.tabElements addObject:tabElement];
    
    // add to view hierachy
    [self.headBackgroundView addSubview:tabElement.switchButton];
    [self.contentView addSubview:tabElement.contentView];
    
    // layout after adding a tab element
    // line indicator
    if ([self.tabElements count] == 1)
    {
        [self.headBackgroundView addSubview:self.lineIndicatorView];
        
        self.lineIndicatorViewWidthConstraint =
        [NSLayoutConstraint constraintWithItem:self.lineIndicatorView
                                     attribute:(NSLayoutAttributeWidth)
                                     relatedBy:(NSLayoutRelationEqual)
                                        toItem:tabElement.switchButton
                                     attribute:(NSLayoutAttributeWidth)
                                    multiplier:1
                                      constant:0];
        [self addConstraint:self.lineIndicatorViewWidthConstraint];
        [self addConstraint:
         [NSLayoutConstraint constraintWithItem:self.lineIndicatorView
                                      attribute:(NSLayoutAttributeHeight)
                                      relatedBy:(NSLayoutRelationEqual)
                                         toItem:self.headBackgroundView
                                      attribute:(NSLayoutAttributeHeight)
                                     multiplier:0
                                       constant:2.0f]];
        self.lineIndicatorViewLeadingConstraint =
        [NSLayoutConstraint constraintWithItem:self.lineIndicatorView
                                     attribute:(NSLayoutAttributeLeading)
                                     relatedBy:(NSLayoutRelationEqual)
                                        toItem:tabElement.switchButton
                                     attribute:(NSLayoutAttributeLeading)
                                    multiplier:1
                                      constant:0];
        [self addConstraint:self.lineIndicatorViewLeadingConstraint];
        [self addConstraint:
         [NSLayoutConstraint constraintWithItem:_lineIndicatorView
                                      attribute:(NSLayoutAttributeBottom)
                                      relatedBy:(NSLayoutRelationEqual)
                                         toItem:_headBackgroundView
                                      attribute:(NSLayoutAttributeBottom)
                                     multiplier:1
                                       constant:0]];
    }
    
    // switch button
    CGFloat headSwitchButtonWidth;
    CGFloat headSwitchButtonHeight;
    if ([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationPortrait)
    {
        headSwitchButtonWidth = self.viewData.headSwitchButtonPortraitWidth;
        headSwitchButtonHeight = self.viewData.headSwitchButtonPortraitHeight;
    }
    else
    {
        headSwitchButtonWidth = self.viewData.headSwitchButtonLandscapeWidth;
        headSwitchButtonHeight = self.viewData.headSwitchButtonLandscapeHeight;
    }
    tabElement.switchButtonWidthConstraint =
    [NSLayoutConstraint constraintWithItem:tabElement.switchButton
                                 attribute:(NSLayoutAttributeWidth)
                                 relatedBy:(NSLayoutRelationEqual)
                                    toItem:self.headBackgroundView
                                 attribute:(NSLayoutAttributeWidth)
                                multiplier:0
                                  constant:headSwitchButtonWidth];
    [self addConstraint:tabElement.switchButtonWidthConstraint];
    tabElement.switchButtonHeightConstraint =
    [NSLayoutConstraint constraintWithItem:tabElement.switchButton
                                 attribute:(NSLayoutAttributeHeight)
                                 relatedBy:(NSLayoutRelationEqual)
                                    toItem:self.headBackgroundView
                                 attribute:(NSLayoutAttributeHeight)
                                multiplier:0
                                  constant:headSwitchButtonHeight];
    [self addConstraint:tabElement.switchButtonHeightConstraint];
    [self addConstraint:
     [NSLayoutConstraint constraintWithItem:tabElement.switchButton
                                  attribute:(NSLayoutAttributeBottom)
                                  relatedBy:(NSLayoutRelationEqual)
                                     toItem:self.headBackgroundView
                                  attribute:(NSLayoutAttributeBottom)
                                 multiplier:1
                                   constant:0]];
    tabElement.switchButtonCenterXConstraint =
    [NSLayoutConstraint constraintWithItem:tabElement.switchButton
                                 attribute:(NSLayoutAttributeCenterX)
                                 relatedBy:(NSLayoutRelationEqual)
                                    toItem:self.headBackgroundView
                                 attribute:(NSLayoutAttributeCenterX)
                                multiplier:1
                                  constant:0];
    [self addConstraint:tabElement.switchButtonCenterXConstraint];
    
    // content view
    [self addConstraint:
     [NSLayoutConstraint constraintWithItem:tabElement.contentView
                                  attribute:(NSLayoutAttributeTop)
                                  relatedBy:(NSLayoutRelationEqual)
                                     toItem:self.contentView
                                  attribute:(NSLayoutAttributeTop)
                                 multiplier:1
                                   constant:0]];
    [self addConstraint:
     [NSLayoutConstraint constraintWithItem:tabElement.contentView
                                  attribute:(NSLayoutAttributeBottom)
                                  relatedBy:(NSLayoutRelationEqual)
                                     toItem:self.contentView
                                  attribute:(NSLayoutAttributeBottom)
                                 multiplier:1
                                   constant:0]];
    [self addConstraint:
     [NSLayoutConstraint constraintWithItem:tabElement.contentView
                                  attribute:(NSLayoutAttributeWidth)
                                  relatedBy:(NSLayoutRelationEqual)
                                     toItem:self.headBackgroundView
                                  attribute:(NSLayoutAttributeWidth)
                                 multiplier:1
                                   constant:0]];
    
    tabElement.contentViewTrailingConstraint =
     [NSLayoutConstraint constraintWithItem:tabElement.contentView
                                  attribute:(NSLayoutAttributeTrailing)
                                  relatedBy:(NSLayoutRelationEqual)
                                     toItem:self.contentView
                                  attribute:(NSLayoutAttributeTrailing)
                                 multiplier:1
                                   constant:0];
    [self addConstraint:tabElement.contentViewTrailingConstraint];
    
    if ([self.tabElements count] == 1)
    {
        [self addConstraint:
         [NSLayoutConstraint constraintWithItem:tabElement.contentView
                                      attribute:(NSLayoutAttributeLeading)
                                      relatedBy:(NSLayoutRelationEqual)
                                         toItem:self.contentView
                                      attribute:(NSLayoutAttributeLeading)
                                     multiplier:1
                                       constant:0]];
    }
    else
    {
        // tab leading element
        BDPhoneHeadTabElement *leadingTabElement = [self.tabElements objectAtIndex:[self.tabElements count]-2];
        [self removeConstraint:leadingTabElement.contentViewTrailingConstraint];
        
        [self addConstraint:
         [NSLayoutConstraint constraintWithItem:tabElement.contentView
                                      attribute:(NSLayoutAttributeLeading)
                                      relatedBy:(NSLayoutRelationEqual)
                                         toItem:leadingTabElement.contentView
                                      attribute:(NSLayoutAttributeTrailing)
                                     multiplier:1
                                       constant:0]];
    }
    
    // update all tab elements constraints
    [self regulateSwitchButtonsConstraints];
    
    [self setNeedsUpdateConstraints];
    [self layoutIfNeeded];
    
    // updata status
    // switch button
    if (([self.tabElements count]-1) == self.currentTabIndex)
    {
        tabElement.switchButton.selected = YES;
    }
    
    if (self.currentTabIndex < [self.tabElements count])
    {
        BDPhoneHeadTabElement *currentTabElement = [self.tabElements objectAtIndex:self.currentTabIndex];
        
        // line indicator
        if ([self.tabElements count] > 1 && self.currentTabIndex > 0)
        {
            BDPhoneHeadTabElement *firstTabElement = [self.tabElements objectAtIndex:0];
            BDPhoneHeadTabElement *secondTabElement = [self.tabElements objectAtIndex:1];
            CGFloat gapWidth = secondTabElement.switchButton.frame.origin.x - firstTabElement.switchButton.frame.origin.x;
            
            self.lineIndicatorViewLeadingConstraint.constant = gapWidth * self.currentTabIndex;
            
            [self setNeedsUpdateConstraints];
        }
        
        // content view
        CGPoint contentOffset = currentTabElement.contentView.frame.origin;
        [self.contentScrollView setContentOffset:contentOffset animated:NO];
    }
}

- (void)selectTabAtIndex:(NSInteger)tabIndex
{
    
}

#pragma mark - Helper Methods

- (void)regulateSwitchButtonsConstraints
{
    CGFloat headSwitchButtonWidth;
    CGFloat headSwitchButtonHeight;
    if ([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationPortrait)
    {
        headSwitchButtonWidth = self.viewData.headSwitchButtonPortraitWidth;
        headSwitchButtonHeight = self.viewData.headSwitchButtonPortraitHeight;
    }
    else
    {
        headSwitchButtonWidth = self.viewData.headSwitchButtonLandscapeWidth;
        headSwitchButtonHeight = self.viewData.headSwitchButtonLandscapeHeight;
    }
    
    CGFloat unitWidth = headSwitchButtonWidth / 2.0f;
    CGFloat centerXPos = - unitWidth * ([self.tabElements count] -1);
    for (NSInteger i=0; i<[self.tabElements count]; i++)
    {
        BDPhoneHeadTabElement *tempTabElement = [self.tabElements objectAtIndex:i];
        tempTabElement.switchButtonCenterXConstraint.constant = centerXPos;
        centerXPos += unitWidth * 2;
        
        tempTabElement.switchButtonWidthConstraint.constant = headSwitchButtonWidth;
        tempTabElement.switchButtonHeightConstraint.constant = headSwitchButtonHeight;
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate)
    {
        [self tabSwitchByDragging];
    }
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self tabSwitchByDragging];
}

#pragma mark - Switch Tab

- (void)tabSwitchByDragging
{
    NSInteger oldTabIndex = self.currentTabIndex;
    
    BDPhoneHeadTabElement *oldTabElement = [self.tabElements objectAtIndex:oldTabIndex];
    BDPhoneHeadTabElement *newTabElement;
    
    for (NSInteger i=0; i<[self.tabElements count]; i++)
    {
        BDPhoneHeadTabElement *tabElement = [self.tabElements objectAtIndex:i];

        CGFloat contentOffsetX = self.contentScrollView.contentOffset.x;
        CGFloat contentViewX = tabElement.contentView.frame.origin.x;
        CGFloat contentViewWidth = tabElement.contentView.frame.size.width;
        if (fabs(contentOffsetX - contentViewX) < contentViewWidth/2.0)
        {
            self.currentTabIndex = i;
            newTabElement = tabElement;
        }
    }
    // switch to the same tab
    if (self.currentTabIndex == oldTabIndex)
    {
        return;
    }
    // switch button status
    oldTabElement.switchButton.selected = NO;
    newTabElement.switchButton.selected = YES;
    
    // content view status
    CGPoint contentOffset = newTabElement.contentView.frame.origin;
    [self.contentScrollView setContentOffset:contentOffset animated:YES];
    
    // send tab changed event
    if ([self.delegate respondsToSelector:@selector(onTabChanged:fromTabIndex:)])
    {
        [self.delegate onTabChanged:self fromTabIndex:oldTabIndex];
    }
}

- (void)switchButtonSelected:(UIButton *)sender
{
    // switch to the same tab
    if (sender.selected == YES)
    {
        return;
    }
    
    NSInteger oldTabIndex = self.currentTabIndex;
    
    BDPhoneHeadTabElement *oldTabElement = [self.tabElements objectAtIndex:oldTabIndex];
    BDPhoneHeadTabElement *newTabElement;
    
    for (NSInteger i=0; i<[self.tabElements count]; i++)
    {
        BDPhoneHeadTabElement *tabElement = [self.tabElements objectAtIndex:i];
        if (tabElement.switchButton == sender)
        {
            self.currentTabIndex = i;
            newTabElement = tabElement;
            break;
        }
    }
    // switch button status
    oldTabElement.switchButton.selected = NO;
    newTabElement.switchButton.selected = YES;
    
    // content view status
    CGPoint contentOffset = newTabElement.contentView.frame.origin;
    [self.contentScrollView setContentOffset:contentOffset animated:YES];
    
    // send tab changed event
    if ([self.delegate respondsToSelector:@selector(onTabChanged:fromTabIndex:)])
    {
        [self.delegate onTabChanged:self fromTabIndex:oldTabIndex];
    }
}

@end

#pragma mark - Tab Element

@implementation BDPhoneHeadTabElement

- (instancetype)initWithTitle:(NSString *)title view:(UIView *)view
{
    self = [super init];
    if (self)
    {
        _switchButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_switchButton setBackgroundColor:[UIColor clearColor]];
        _switchButton.translatesAutoresizingMaskIntoConstraints = NO;
        [_switchButton setTitle:title forState:(UIControlStateNormal)];
        
        if (view == nil)
        {
            view = [[UIView alloc] init];
            view.backgroundColor = [UIColor clearColor];
        }
        _contentView = view;
        _contentView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return self;
}

@end

