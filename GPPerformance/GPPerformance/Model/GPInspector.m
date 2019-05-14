//
//  VZInspector.m
//  GPPerformance
//
//  Created by Liyanwei on 2019/5/14.
//  Copyright © 2019 Liyanwei. All rights reserved.
//

#import "GPInspector.h"
#import "GPInspectorOverlay.h"
#import "GPInspectorWindow.h"

@implementation GPInspector

+ (void)showOnStatusBar
{
    //dispatch to the next runloop
    dispatch_async(dispatch_get_main_queue(), ^{
        [GPInspectorOverlay show];
    });
    
}

+ (BOOL)isShow
{
    return ![GPInspectorWindow sharedInstance].hidden;
}

+ (void)show
{
    [GPInspectorWindow sharedInstance].hidden = NO;
    [GPInspectorOverlay hide];
}

+ (void)hide
{
    [GPInspectorWindow sharedInstance].hidden = YES;
    [GPInspectorOverlay show];
}

@end
