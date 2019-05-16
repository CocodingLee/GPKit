//
//  GPInspectStackView.h
//  GPPerformance
//
//  Created by Liyanwei on 2019/5/16.
//  Copyright © 2019 Liyanwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GPUIKit/GPUIKit.h>
#import "GPSegInfo.h"

NS_ASSUME_NONNULL_BEGIN

// 调用栈执行时长
@interface GPInspectStackView : UIView < GPPageListViewListDelegate>
- (instancetype)initWithSegmentInfo:(GPSegInfo *)segmentInfo
                     viewController:(UIViewController*)viewController;
@end

NS_ASSUME_NONNULL_END
