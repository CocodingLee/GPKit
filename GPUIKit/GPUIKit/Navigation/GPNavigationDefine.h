//
//  GPNavigationDefine.h
//  GPUIKit
//
//  Created by Liyanwei on 2019/4/28.
//  Copyright © 2019 Liyanwei. All rights reserved.
//

#ifndef GPNavigationDefine_h
#define GPNavigationDefine_h

// 导航栏颜色
#define kNavigationBarTintColor             [UIColor blackColor]
#define kNavigationBarColor                 [UIColor whiteColor]
#define kNavigationBarLineColor             [UIColor clearColor]
#define kNavigationBarTintGrayColor         [UIColor grayColor]
#define kNavigationBarTintYellowColor       [UIColor yellowColor]

#define kGPNavigationBarHeight              44

////////////////////////////////////////////////////////

#define GP_SCREEN_WIDTH             [UIScreen mainScreen].bounds.size.width
#define GP_SCREEN_HEIGHT            [UIScreen mainScreen].bounds.size.height

#define SINGLE_LINE_WIDTH           (1 / [UIScreen mainScreen].scale)
#define SINGLE_LINE_ADJUST_OFFSET   ((1 / [UIScreen mainScreen].scale) / 2)

////////////////////////////////////////////////////////

#define HEXCOLORA(c,a)              [UIColor colorWithRed:((c>>16)&0xFF)/256.0  green:((c>>8)&0xFF)/256.0   blue:((c)&0xFF)/256.0   alpha:a]
#define HEXCOLOR(c)                 HEXCOLORA(c, 1.0)
#define GP_ONE_PIX                  SINGLE_LINE_WIDTH

#endif /* GPNavigationDefine_h */
