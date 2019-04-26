//
//  UIView+SafeArea.h
//  GPUIKit
//
//  Created by Liyanwei on 2019/4/26.
//  Copyright © 2019 Liyanwei. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (SafeArea)
@property (nonatomic , readonly) UIEdgeInsets gp_safeAreaInsets;
@end

NS_ASSUME_NONNULL_END

//
// 安全区域
//
UIEdgeInsets gpSafeArea(void);
