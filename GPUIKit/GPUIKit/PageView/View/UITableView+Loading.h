//
//  UITableView+Loading.h
//  GPUIKit
//
//  Created by Liyanwei on 2019/1/31.
//  Copyright © 2019 Aligames. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

// 重试
typedef void(^ErrorRetryLoadBlock)(void);
typedef void(^ActionBlock)(void);

@interface UIScrollView (Loading)
@property (nonatomic , copy) ErrorRetryLoadBlock retryBlock;
@property (nonatomic, copy) NSString *gp_actionButtonTitle;
@property (nonatomic, copy) ActionBlock gp_actionBlock;

// 绑定空白页面
- (void) bindEmptyView;
// 加载过程中网络错误
- (void) loadingWithNetError:(NSError*) error;
// 加载过程中，无法内容
- (void) loadingWithNoContent;
// 加载结果引导
- (void) loadingWithMessage:(NSString*) message action:(ActionBlock)action;
// 加载成功
- (void) loadingSuccess;
@end

NS_ASSUME_NONNULL_END
