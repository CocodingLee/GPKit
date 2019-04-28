//
//  UIButton+ImagePosition.h
//  GPUIKit
//
//  Created by Liyanwei on 2019/4/28.
//  Copyright © 2019 Liyanwei. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, GPImagePosition)
{
    GPImagePositionLeft = 0,              // 图片在左，文字在右，默认
    GPImagePositionRight = 1,             // 图片在右，文字在左
    GPImagePositionTop = 2,               // 图片在上，文字在下
    GPImagePositionBottom = 3,            // 图片在下，文字在上
};

@interface UIButton (ImagePosition)
- (void) setImageTextPosition:(GPImagePosition) postion space:(CGFloat) spacing;
@end

NS_ASSUME_NONNULL_END
