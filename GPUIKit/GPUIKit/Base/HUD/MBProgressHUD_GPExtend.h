//
//  MBProgressHUD_NHExtend.h
//  GPUIKit
//
//  Created by liyanwei on 2017/6/11.
//  Copyright © 2017年 liyanwei. All rights reserved.
//

#import <MBProgressHUD/MBProgressHUD.h>

typedef NS_ENUM(NSInteger, GPHUDContentStyle) {
    GPHUDContentDefaultStyle = 0,//默认是白底黑字 Default
    GPHUDContentBlackStyle = 1,//黑底白字
    GPHUDContentCustomStyle = 2,//:自定义风格<由自己设置自定义风格的颜色>
};

typedef NS_ENUM(NSInteger, GPHUDPostion) {
    GPHUDPostionTop,//上面
    GPHUDPostionCenten,//中间
    GPHUDPostionBottom,//下面
};

typedef NS_ENUM(NSInteger, GPHUDProgressStyle) {
    GPHUDProgressDeterminate,///双圆环,进度环包在内
    GPHUDProgressDeterminateHorizontalBar,///横向Bar的进度条
    GPHUDProgressAnnularDeterminate,///双圆环，完全重合
    GPHUDProgressCancelationDeterminate,///带取消按钮 - 双圆环 - 完全重合
};

typedef void((^GPCancelation)(MBProgressHUD *hud));
typedef void((^GPCurrentHud)(MBProgressHUD *hud));


@interface MBProgressHUD ()

@property (nonatomic, copy  ) GPCancelation cancelation;
///内容风格
@property (nonatomic, assign, readonly) MBProgressHUD *(^hudContentStyle)(GPHUDContentStyle hudContentStyle);
///显示位置：有导航栏时在导航栏下在，无导航栏在状态栏下面
@property (nonatomic, assign, readonly) MBProgressHUD *(^hudPostion)(GPHUDPostion hudPostion);
///进度条风格
@property (nonatomic, assign, readonly) MBProgressHUD *(^hudProgressStyle)(GPHUDProgressStyle hudProgressStyle);
///标题
@property (nonatomic, copy  , readonly) MBProgressHUD *(^title)(NSString *title);
///详情
@property (nonatomic, copy  , readonly) MBProgressHUD *(^details)(NSString *details);
///自定义图片名
@property (nonatomic, copy  , readonly) MBProgressHUD *(^customIcon)(NSString *customIcon);
///标题颜色
@property (nonatomic, strong, readonly) MBProgressHUD *(^titleColor)(UIColor *titleColor);
///进度条颜色
@property (nonatomic, strong, readonly) MBProgressHUD *(^progressColor)(UIColor *progressColor);
///进度条、标题颜色
@property (nonatomic, strong, readonly) MBProgressHUD *(^allContentColors)(UIColor *allContentColors);
///蒙层背景色
@property (nonatomic, strong, readonly) MBProgressHUD *(^hudBackgroundColor)(UIColor *backgroundColor);
///内容背景色
@property (nonatomic, strong, readonly) MBProgressHUD *(^bezelBackgroundColor)(UIColor *bezelBackgroundColor);


@end
