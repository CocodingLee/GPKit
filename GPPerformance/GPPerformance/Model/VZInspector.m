//
//  VZInspector.m
//  GPPerformance
//
//  Created by Liyanwei on 2019/5/14.
//  Copyright © 2019 Liyanwei. All rights reserved.
//

#import "VZInspector.h"
#import "VZInspectorOverlay.h"
#import "VZInspectorWindow.h"

@implementation VZInspector

+ (void)showOnStatusBar
{
    //dispatch to the next runloop
    dispatch_async(dispatch_get_main_queue(), ^{
        [VZInspectorOverlay show];
    });
    
}

+ (BOOL)isShow
{
    return ![VZInspectorWindow sharedInstance].hidden;
}

+ (void)show
{
    [VZInspectorWindow sharedInstance].hidden = NO;
    [VZInspectorOverlay hide];
}

+ (void)hide
{
    [VZInspectorWindow sharedInstance].hidden = YES;
    [VZInspectorOverlay show];
}

@end
