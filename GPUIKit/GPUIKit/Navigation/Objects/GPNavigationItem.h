//
//  GPNavigationItem.h
//  GPUIKit
//
//  Created by Liyanwei on 2019/5/5.
//  Copyright © 2019 Liyanwei. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class GPBarButtonItem;

@interface GPNavigationItem : NSObject

@property (nonatomic, strong  ) GPBarButtonItem *leftBarButtonItem;
@property (nonatomic, strong  ) GPBarButtonItem *rightBarButtonItem;
@property (nonatomic, copy    ) NSString        *title;

@property (nonatomic, readonly) UIView          *titleView;
@property (nonatomic, readonly) UILabel         *titleLabel;

//从返回按钮MaxX开始计算的Inset
@property (nonatomic, assign) CGFloat titleInsetLeft;
@property (nonatomic, assign) CGFloat titleInsetRight;

@property (nonatomic, copy) UIColor *tintColor;

@end

NS_ASSUME_NONNULL_END
