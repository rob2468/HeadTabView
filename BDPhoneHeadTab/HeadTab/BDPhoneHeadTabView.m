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

@interface BDPhoneHeadTabView ()

@property (strong, nonatomic) BDPhoneHeadTabViewData *viewData; // view data

// constraints
@property (strong, nonatomic) NSLayoutConstraint *headBackgroundViewHeightConstraint;

@property (strong, nonatomic) NSLayoutConstraint *lineIndicatorViewWidthConstraint;
@property (strong, nonatomic) NSLayoutConstraint *lineIndicatorViewHeightConstraint;
@property (strong, nonatomic) NSLayoutConstraint *lineIndicatorViewCenterXConstraint;

@property (strong, nonatomic) NSMutableArray *tabElements;      // tab elements

@end

@implementation BDPhoneHeadTabView

- (instancetype)initWithViewData:(BDPhoneHeadTabViewData *)viewData
{
    self = [super init];
    if (self)
    {
        // view data
        self.viewData = viewData;
        
        // create instances and add subviews
        _headBackgroundView = [[UIView alloc] init];
        _headBackgroundView.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:_headBackgroundView];
        
        _lineIndicatorView = [[UIView alloc] init];
        _lineIndicatorView.translatesAutoresizingMaskIntoConstraints = NO;
        [_headBackgroundView addSubview:_lineIndicatorView];
        _lineIndicatorView.hidden = YES;
        
        _contentScrollView = [[UIScrollView alloc] init];
        _contentScrollView.translatesAutoresizingMaskIntoConstraints = NO;
        _contentScrollView.pagingEnabled = YES;
        _contentScrollView.showsHorizontalScrollIndicator = NO;
        [self addSubview:_contentScrollView];
        
        _contentView = [[UIView alloc] init];
        _contentView.translatesAutoresizingMaskIntoConstraints = NO;
        [_contentScrollView addSubview:_contentView];
        
        _tabElements = [[NSMutableArray alloc] init];
        
        // add constraints
        id viewsDict = @{
                         @"_headBackgroundView": _headBackgroundView,
                         @"_contentScrollView": _contentScrollView,
                         @"_contentView": _contentView
                         };
        
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
        _headBackgroundViewHeightConstraint =
        [NSLayoutConstraint constraintWithItem:_headBackgroundView
                                     attribute:(NSLayoutAttributeHeight)
                                     relatedBy:(NSLayoutRelationEqual)
                                        toItem:self
                                     attribute:(NSLayoutAttributeHeight)
                                    multiplier:0
                                      constant:viewData.headBackgroundViewHeight];
        [self addConstraint:_headBackgroundViewHeightConstraint];
        
        // lineIndicatorView
        _lineIndicatorViewWidthConstraint =
        [NSLayoutConstraint constraintWithItem:_lineIndicatorView
                                     attribute:(NSLayoutAttributeWidth)
                                     relatedBy:(NSLayoutRelationEqual)
                                        toItem:self
                                     attribute:(NSLayoutAttributeWidth)
                                    multiplier:0
                                      constant:0];
        [self addConstraint:_lineIndicatorViewWidthConstraint];
        _lineIndicatorViewHeightConstraint =
        [NSLayoutConstraint constraintWithItem:_lineIndicatorView
                                     attribute:(NSLayoutAttributeHeight)
                                     relatedBy:(NSLayoutRelationEqual)
                                        toItem:self
                                     attribute:(NSLayoutAttributeHeight)
                                    multiplier:0
                                      constant:0];
        [self addConstraint:_lineIndicatorViewHeightConstraint];
        _lineIndicatorViewCenterXConstraint =
        [NSLayoutConstraint constraintWithItem:_lineIndicatorView
                                     attribute:(NSLayoutAttributeCenterX)
                                     relatedBy:(NSLayoutRelationEqual)
                                        toItem:self
                                     attribute:(NSLayoutAttributeCenterX)
                                    multiplier:1
                                      constant:0];
        [self addConstraint:_lineIndicatorViewCenterXConstraint];
        [self addConstraint:
         [NSLayoutConstraint constraintWithItem:_lineIndicatorView
                                      attribute:(NSLayoutAttributeBottom)
                                      relatedBy:(NSLayoutRelationEqual)
                                         toItem:_headBackgroundView
                                      attribute:(NSLayoutAttributeBottom)
                                     multiplier:1
                                       constant:0]];
        
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

- (void)updateStyle:(BDPhoneHeadTabViewStyle)style
{
    switch (style)
    {
        case BDPhoneHeadTabViewStyleBlue:
            
            break;
            
        default:
        {
            self.headBackgroundView.backgroundColor = [UIColor colorWithRed:248/255.f green:248/255.f blue:248/255.f alpha:1];
            break;
        }
    }
}

- (void)addTabWithTitle:(NSString *)title view:(UIView *)view
{
    // initialization
    BDPhoneHeadTabElement *tabElement = [[BDPhoneHeadTabElement alloc] initWithTitle:title view:view];
    tabElement.switchButtonCenterXConstraint =
     [NSLayoutConstraint constraintWithItem:tabElement.switchButton
                                  attribute:(NSLayoutAttributeCenterX)
                                  relatedBy:(NSLayoutRelationEqual)
                                     toItem:self.headBackgroundView
                                  attribute:(NSLayoutAttributeCenterX)
                                 multiplier:1
                                   constant:0];
    [self.tabElements addObject:tabElement];
    
    // add to view hierachy
    [self.headBackgroundView addSubview:tabElement.switchButton];
    [self.contentView addSubview:tabElement.contentView];
    
    // layout
    [self layoutAfterAddTabElement:tabElement];
}

- (void)layoutAfterAddTabElement:(BDPhoneHeadTabElement *)tabElement
{
    // setup the added tab element
    // switch button
    [self addConstraint:
     [NSLayoutConstraint constraintWithItem:tabElement.switchButton
                                  attribute:(NSLayoutAttributeHeight)
                                  relatedBy:(NSLayoutRelationEqual)
                                     toItem:self
                                  attribute:(NSLayoutAttributeHeight)
                                 multiplier:0
                                   constant:self.viewData.headTabButtonHeight]];
    [self addConstraint:
     [NSLayoutConstraint constraintWithItem:tabElement.switchButton
                                  attribute:(NSLayoutAttributeBottom)
                                  relatedBy:(NSLayoutRelationEqual)
                                     toItem:self.headBackgroundView
                                  attribute:(NSLayoutAttributeBottom)
                                 multiplier:1
                                   constant:0]];
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
        // tab element before last
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
    
    // update all tab elements
    CGFloat unitWidth = 0;
    for (BDPhoneHeadTabElement *tempTabElement in self.tabElements)
    {
        UIButton *tempSwitchButton = tempTabElement.switchButton;
        [tempSwitchButton sizeToFit];
        CGFloat tempUnitWidth = tempSwitchButton.bounds.size.width / 2.0;
        if (tempUnitWidth > unitWidth)
        {
            unitWidth = tempUnitWidth;
        }
    }
    CGFloat centerXPos = - unitWidth * ([self.tabElements count] -1);
    for (NSInteger i=0; i<[self.tabElements count]; i++)
    {
        BDPhoneHeadTabElement *tempTabElement = [self.tabElements objectAtIndex:i];
        tempTabElement.switchButtonCenterXConstraint.constant = centerXPos;
        centerXPos += unitWidth * 2;
    }
    
    [self setNeedsUpdateConstraints];
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
        _switchButton.translatesAutoresizingMaskIntoConstraints = NO;
        [_switchButton setTitle:title forState:(UIControlStateNormal)];
        
        _contentView = view;
        _contentView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return self;
}

@end

