//
//  UIViewController+clsCall.m
//  GCDFetchFeed
//
//  Created by Liyanwei on 2019/5/15.
//  Copyright © 2019 Liyanwei. All rights reserved.
//

#import "UIViewController+ClassTrace.h"
#import "GPHook.h"
#import "GPTrace.h"

#import <objc/runtime.h>

@implementation UIViewController (ClassTrace)

//
//+ (void)load
//{
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        //
//        SEL fromSelectorAppear = @selector(viewWillAppear:);
//        SEL toSelectorAppear = @selector(clsCallHookViewWillAppear:);
//        [GPHook hookClass:self fromSelector:fromSelectorAppear toSelector:toSelectorAppear];
//
//        SEL fromSelectorDisappear = @selector(viewWillDisappear:);
//        SEL toSelectorDisappear = @selector(clsCallHookViewWillDisappear:);
//
//        [GPHook hookClass:self fromSelector:fromSelectorDisappear toSelector:toSelectorDisappear];
//    });
//}
//

#pragma mark - Method Hook
- (void)clsCallHookViewWillAppear:(BOOL)animated
{
    //执行插入代码
    [self clsCallInsertToViewWillAppear];
    [self clsCallHookViewWillAppear:animated];
}

- (void)clsCallHookViewWillDisappear:(BOOL)animated
{
    //执行插入代码
    [self clsCallInsertToViewWillDisappear];
    [self clsCallHookViewWillDisappear:animated];
}

- (void)clsCallInsertToViewWillAppear
{
    //显示
    [GPTrace startWithMaxDepth:0];
}

- (void)clsCallInsertToViewWillDisappear
{
    //消失
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        [GPTrace stopSaveAndClean];
    });
    
}
@end
