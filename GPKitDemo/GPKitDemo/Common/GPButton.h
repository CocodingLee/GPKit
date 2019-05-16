//
//  GPButton.h
//  GPKitDemo
//
//  Created by Liyanwei on 2019/5/14.
//  Copyright © 2019 Liyanwei. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, GPKitButtonType) {
    GPKitButtonTypeDefault,
    GPKitButtonTypeVote,
    GPKitButtonTypeOrange,
    GPKitButtonTypeOrangeSmall,
    
    // 正式
    GPKitButtonType_main_s,
    GPKitButtonType_main_line_s,
    GPKitButtonType_main_line_s_round, // 全圆角
    GPKitButtonType_black_line_s,
};

@interface GPButton : GPBaseButton
+ (instancetype)buttonWithType:(GPKitButtonType)buttonType;
+ (void)configButtonType;
@end

NS_ASSUME_NONNULL_END
