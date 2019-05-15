//
//  GPBaseTableView.m
//  GPUIKit
//
//
//  Created by Liyanwei on 2019/4/26.
//  Copyright © 2019 Liyanwei. All rights reserved.
//

#import "GPBaseTableView.h"

@implementation GPBaseTableView

- (BOOL)                            gestureRecognizer:(UIPanGestureRecognizer *)gestureRecognizer
   shouldRecognizeSimultaneouslyWithGestureRecognizer:(UISwipeGestureRecognizer *)otherGestureRecognizer
{
    return self.isDecelerating
    //|| self.isTracking
    || self.contentOffset.y < 0
    || self.contentOffset.y > MAX(0, self.contentSize.height - self.bounds.size.height);
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
