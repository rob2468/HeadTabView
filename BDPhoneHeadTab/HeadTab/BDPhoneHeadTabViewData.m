//
//  BDPhoneHeadTabViewData.m
//  BDPhoneHeadTab
//
//  Created by jam on 15/10/27.
//  Copyright © 2015年 Baidu Inc. All rights reserved.
//

#import "BDPhoneHeadTabViewData.h"

@implementation BDPhoneHeadTabViewData

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _headBackgroundViewHeight = 64.0f;
        _headTabButtonHeight = 44.0f;
        _lineIndicatorViewWidth = 0.0f;
        _lineIndicatorViewHeight = 2.0f;
    }
    return self;
}

@end
