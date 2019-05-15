//
//  GPPagerMainTableView.m
//
//  Created by Liyanwei on 2018/8/27.
//  Copyright © 2018年 Liyanwei. All rights reserved.
//

#import "GPPageListMainTableView.h"
#import "GPBaseCollectionView.h"

@interface GPPageListMainTableView ()<UIGestureRecognizerDelegate>

@end

@implementation GPPageListMainTableView

- (BOOL)                            gestureRecognizer:(UIPanGestureRecognizer *)gestureRecognizer
   shouldRecognizeSimultaneouslyWithGestureRecognizer:(UISwipeGestureRecognizer *)otherGestureRecognizer
{
    if ([otherGestureRecognizer.view isKindOfClass:[GPHomeHeaderCollectionView class]]) {
        return NO;
    }
    
    return self.isDecelerating
    || self.isTracking
    || self.contentOffset.y < 0
    || self.contentOffset.y > MAX(0, self.contentSize.height - self.bounds.size.height);
}

- (BOOL)                    gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
      shouldRequireFailureOfGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    if ([otherGestureRecognizer.view isKindOfClass:[GPHomeHeaderCollectionView class]]) {
        return YES;
    }
    
    // 首先判断otherGestureRecognizer是不是系统pop手势
    if ([otherGestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]
        && [otherGestureRecognizer.view isKindOfClass:NSClassFromString(@"UILayoutContainerView")]) {
        // 再判断系统手势的state是began还是fail
        return YES;
    }
    
    return NO;
}
@end
