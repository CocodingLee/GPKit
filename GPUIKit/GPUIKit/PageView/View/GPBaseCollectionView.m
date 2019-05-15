//
//  GPBaseCollectionView.m
//  GPUIKit
//
//
//  Created by Liyanwei on 2019/4/26.
//  Copyright © 2019 Liyanwei. All rights reserved.
//

#import "GPBaseCollectionView.h"

@implementation GPBaseCollectionView

- (BOOL) gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        CGPoint velocity = [(UIPanGestureRecognizer *)gestureRecognizer velocityInView:self];
        if (fabs(velocity.y) * 2 < fabs(velocity.x)) {
            return YES;
        }
    }
    
    return NO;
}

- (BOOL)                            gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
   shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    // 首先判断otherGestureRecognizer是不是系统pop手势
    if ([otherGestureRecognizer.view isKindOfClass:NSClassFromString(@"UILayoutContainerView")]) {
        // 再判断系统手势的state是began还是fail
        if (otherGestureRecognizer.state == UIGestureRecognizerStateBegan ) {
            
            if ([otherGestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
                
                UIView* view = otherGestureRecognizer.view;
                UIPanGestureRecognizer *pan = (UIPanGestureRecognizer *)otherGestureRecognizer;
                CGFloat velocity = [pan velocityInView:view].x;
                
                // 当前tableview 无水平偏移
                // 切手势向右移动
                if (velocity > 0 && self.contentOffset.x <= 0) {
                    return YES;
                }
            }
        }
    }

    return NO;
}

- (BOOL)                    gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
      shouldRequireFailureOfGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    // 首先判断otherGestureRecognizer是不是系统pop手势
    if ([otherGestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]
        && [otherGestureRecognizer.view isKindOfClass:NSClassFromString(@"UILayoutContainerView")]) {
        // 再判断系统手势的state是began还是fail
        return YES;
    }
    
    return NO;
}


@end


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

@implementation GPHomeHeaderCollectionView

- (BOOL) gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        CGPoint velocity = [(UIPanGestureRecognizer *)gestureRecognizer velocityInView:self];
        if (fabs(velocity.x) >= fabs(velocity.y)) {
            return YES;
        }
    }
    
    return NO;
}


- (BOOL)                            gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
   shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    if ([otherGestureRecognizer.view isKindOfClass:[UITableView class]]) {
        return YES;
    }
    
    return NO;
}

@end
