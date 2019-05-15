//
//  GPCategoryIndicatorLineView.h
//  GPCategoryView
//
//  Created by Liyanwei on 2018/8/17.
//  Copyright © 2018年 Liyanwei. All rights reserved.
//

#import "GPCategoryIndicatorComponentView.h"

typedef NS_ENUM(NSUInteger, GPCategoryIndicatorLineStyle) {
    GPCategoryIndicatorLineStyle_Normal = 0,
    GPCategoryIndicatorLineStyle_JD,
    GPCategoryIndicatorLineStyle_IQIYI,
};

@interface GPCategoryIndicatorLineView : GPCategoryIndicatorComponentView

@property (nonatomic, assign) GPCategoryIndicatorLineStyle lineStyle;

/**
 line滚动时x的偏移量，默认为10；
 lineStyle为GPCategoryLineStyle_IQIYI有用；
 */
@property (nonatomic, assign) CGFloat lineScrollOffsetX;

@property (nonatomic, assign) CGFloat indicatorLineViewHeight;  //默认：3

@property (nonatomic, assign) CGFloat indicatorLineWidth;    //默认GPCategoryViewAutomaticDimension（与cellWidth相等）

@property (nonatomic, assign) CGFloat indicatorLineViewCornerRadius;    //默认GPCategoryViewAutomaticDimension （等于self.indicatorLineViewHeight/2）

@property (nonatomic, strong) UIColor *indicatorLineViewColor;   //默认为[UIColor redColor]

@end
