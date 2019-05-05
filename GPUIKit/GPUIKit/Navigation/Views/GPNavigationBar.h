//
//  GPNavigationBar.h
//  GPUIKit
//
//  Created by Liyanwei on 2019/5/5.
//  Copyright © 2019 Liyanwei. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GPNavigationBar : UIView

@property (nonatomic, readonly) UIView *lineView;
@property (nonatomic, readonly, class) CGFloat barHeight;
@property (nonatomic, readonly, class) CGFloat barContentHeight;

- (void)clearBG;
@end

NS_ASSUME_NONNULL_END
