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
        _headBackgroundViewPortraitHeight = 64.0f;
        _headSwitchButtonPortraitWidth = 60.0f;
        _headSwitchButtonPortraitHeight = 44.0f;
        
        _headBackgroundViewLandscapeHeight = 32.0f;
        _headSwitchButtonLandscapeWidth = 100.0f;
        _headSwitchButtonLandscapeHeight = 32.0f;
    }
    return self;
}

@end
