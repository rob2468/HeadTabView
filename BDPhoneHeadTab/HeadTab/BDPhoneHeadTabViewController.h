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
    BDPhoneHeadTabViewStyleLightGray,
    BDPhoneHeadTabViewStyleAddWebAddress
} BDPhoneHeadTabViewStyle;

@interface BDPhoneHeadTabViewController : UIViewController

@property (assign, nonatomic) BDPhoneHeadTabViewStyle style;

- (void)updateStyle:(BDPhoneHeadTabViewStyle)style;

// add tab
- (void)addTabWithTitle:(NSString *)title;
- (void)addTabWithView:(UIView *)view;
- (void)addTabWithTitle:(NSString *)title view:(UIView *)view;

@end
