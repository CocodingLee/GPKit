//
//  UIViewController+GPTransition.h
//  GPUIKit
//
//  Created by Liyanwei on 2019/5/5.
//  Copyright © 2019 Liyanwei. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (GPTransition)

@property (nonatomic, strong) id<UIViewControllerAnimatedTransitioning> pushAnimation;
@property (nonatomic, strong) id<UIViewControllerAnimatedTransitioning> popAnimation;

@end

NS_ASSUME_NONNULL_END
