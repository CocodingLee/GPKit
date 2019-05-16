//
//  GPButton.h
//  GPUIKit
//
//  Created by Liyanwei on 2019/4/28.
//  Copyright © 2019 Liyanwei. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NSUInteger GPButtonType;
@class GPButtonItem;

typedef GPButtonItem *(^AGSButtonTypeBlock)(GPButtonType type);

@interface GPButtonItem : NSObject

@property (nonatomic, assign) GPButtonType type;

@property (nonatomic, assign) CGFloat borderWidth;
@property (nonatomic, copy) UIFont *font;
@property (nonatomic, assign) CGFloat cornerRadius; // 按钮圆角，默认 －1，使用 height/2 作为圆角

@property (nonatomic, copy) UIColor *leftBackgroundColor;
@property (nonatomic, copy) UIColor *rightBackgroundColor;
@property (nonatomic, copy) UIColor *borderColor;
@property (nonatomic, copy) UIColor *textColor;

@property (nonatomic, copy) UIColor *leftBackgroundColor_pre;
@property (nonatomic, copy) UIColor *rightBackgroundColor_pre;
@property (nonatomic, copy) UIColor *borderColor_pre;
@property (nonatomic, copy) UIColor *textColor_pre;

@property (nonatomic, copy) UIColor *leftBackgroundColor_dis;
@property (nonatomic, copy) UIColor *rightBackgroundColor_dis;
@property (nonatomic, copy) UIColor *borderColor_dis;
@property (nonatomic, copy) UIColor *textColor_dis;

@end

@interface GPButton : UIButton

@property (nonatomic, copy, class) AGSButtonTypeBlock typeItemConfigBlock;

+ (instancetype)buttonWithType:(GPButtonType)buttonType;
- (void)updateButtonType:(GPButtonType)buttonType;

@end

/*
 Type example
  
 - (GPButtonItem *)typeItemWithType:(AGSButtonType)type
 {
 GPButtonItem *typeItem = [[GPButtonItem alloc] init];
 
 typeItem.type = type;
 
 switch (type) {
 case AGSButtonType_main_l:
 case AGSButtonType_main_s:
 {
 typeItem.borderWidth = 0;
 typeItem.font = (AGSButtonType_main_s == type) ? [UIFont systemFontOfSize:13] : [UIFont boldSystemFontOfSize:16];
 
 typeItem.leftBackgroundColor = RGB(0xFD5E5E, 1.0);
 typeItem.rightBackgroundColor = RGB(0xFC3066, 1.0);
 typeItem.borderColor = [UIColor clearColor];
 typeItem.textColor = [UIColor whiteColor];
 
 typeItem.leftBackgroundColor_pre = RGB(0xE95656, 1.0);
 typeItem.rightBackgroundColor_pre = RGB(0xE93061, 1.0);
 typeItem.borderColor_pre = [UIColor clearColor];
 typeItem.textColor_pre = [UIColor whiteColor];
 
 typeItem.leftBackgroundColor_dis = RGB(0xFD8E8E, 1.0);
 typeItem.rightBackgroundColor_dis = RGB(0xFC6E94, 1.0);
 typeItem.borderColor_dis = [UIColor clearColor];
 typeItem.textColor_dis = [UIColor whiteColor];
 }
 break;
 case AGSButtonType_main_line_l:
 case AGSButtonType_main_line_s:
 {
 typeItem.borderWidth = 0.5;
 typeItem.font = (AGSButtonType_main_line_s == type) ? [UIFont systemFontOfSize:13] : [UIFont boldSystemFontOfSize:16];
 
 #undef mainColor
 #define mainColor 0xFC3066
 
 typeItem.leftBackgroundColor = RGB(0xFFFFFF, 1.0);
 typeItem.rightBackgroundColor = RGB(0xFFFFFF, 1.0);
 typeItem.borderColor = RGB(mainColor, 1);
 typeItem.textColor = RGB(mainColor, 1);
 
 typeItem.leftBackgroundColor_pre = RGB(mainColor, 0.08);
 typeItem.rightBackgroundColor_pre = RGB(mainColor, 0.08);
 typeItem.borderColor_pre = RGB(mainColor, 1);
 typeItem.textColor_pre = RGB(mainColor, 1);
 
 typeItem.leftBackgroundColor_dis = RGB(0xFFFFFF, 1.0);
 typeItem.rightBackgroundColor_dis = RGB(0xFFFFFF, 1.0);
 typeItem.borderColor_dis = RGB(mainColor, 0.3);
 typeItem.textColor_dis = RGB(mainColor, 0.3);
 }
 break;
 case AGSButtonType_balck_line_l:
 case AGSButtonType_balck_line_s:
 {
 typeItem.borderWidth = 0.5;
 typeItem.font = (AGSButtonType_balck_line_s == type) ? [UIFont systemFontOfSize:13] : [UIFont boldSystemFontOfSize:16];
 
 #undef mainColor
 #define mainColor 0x222222
 
 typeItem.leftBackgroundColor = RGB(0xFFFFFF, 1.0);
 typeItem.rightBackgroundColor = RGB(0xFFFFFF, 1.0);
 typeItem.borderColor = RGB(mainColor, 1);
 typeItem.textColor = RGB(mainColor, 1);
 
 typeItem.leftBackgroundColor_pre = RGB(mainColor, 0.08);
 typeItem.rightBackgroundColor_pre = RGB(mainColor, 0.08);
 typeItem.borderColor_pre = RGB(mainColor, 1);
 typeItem.textColor_pre = RGB(mainColor, 1);
 
 typeItem.leftBackgroundColor_dis = RGB(0xFFFFFF, 1.0);
 typeItem.rightBackgroundColor_dis = RGB(0xFFFFFF, 1.0);
 typeItem.borderColor_dis = RGB(mainColor, 0.3);
 typeItem.textColor_dis = RGB(mainColor, 0.3);
 }
 break;
 default:
 break;
 }
 
 return typeItem;
 }
 
 */
