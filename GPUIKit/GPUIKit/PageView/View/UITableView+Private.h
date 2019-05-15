//
//  UITableView+Private.h
//  GPUIKit
//
//  Created by Liyanwei on 2019/1/31.
//  Copyright © 2019 Aligames. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Lottie/Lottie.h>

NS_ASSUME_NONNULL_BEGIN

// 错误类型
typedef NS_ENUM(NSUInteger, UITableViewErrorType) {
    // 默认值
    UITableViewErrorType_None = 0,
    // 网络错误
    UITableViewErrorType_NetError,
    // 无内容
    UITableViewErrorType_NoContent,
    // 操作
    UITableViewErrorType_Action,
};

@interface UIScrollView (Private)
// 错误
@property (nonatomic , strong) NSError* _Nullable gp_error;
// 错误类型
@property (nonatomic , assign) UITableViewErrorType gp_type;
// lottie 加载动画
@property (nonatomic , strong) LOTAnimationView* gp_loadingView;
@end

NS_ASSUME_NONNULL_END
