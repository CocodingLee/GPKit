//
//  GPCategoryIndicatorBackgroundView.h
//  GPCategoryView
//
//  Created by Liyanwei on 2018/8/17.
//  Copyright © 2018年 Liyanwei. All rights reserved.
//

#import "GPCategoryIndicatorComponentView.h"

@interface GPCategoryIndicatorBackgroundView : GPCategoryIndicatorComponentView

@property (nonatomic, assign) CGFloat backgroundViewWidth;     //默认GPCategoryViewAutomaticDimension（与cellWidth相等）

@property (nonatomic, assign) CGFloat backgroundViewWidthIncrement;    //宽度增量补偿。默认10

@property (nonatomic, assign) CGFloat backgroundViewHeight;   //默认GPCategoryViewAutomaticDimension（与cell高度相等）

@property (nonatomic, assign) CGFloat backgroundViewCornerRadius;   //默认GPCategoryViewAutomaticDimension(即backgroundViewHeight/2)

@property (nonatomic, strong) UIColor *backgroundViewColor;   //默认为[UIColor redColor]

@end
