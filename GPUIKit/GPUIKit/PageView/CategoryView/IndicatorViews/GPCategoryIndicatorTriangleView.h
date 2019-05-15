//
//  GPCategoryIndicatorTriangleView.h
//  GPCategoryView
//
//  Created by Liyanwei on 2018/8/17.
//  Copyright © 2018年 Liyanwei. All rights reserved.
//

#import "GPCategoryIndicatorComponentView.h"

@interface GPCategoryIndicatorTriangleView : GPCategoryIndicatorComponentView

@property (nonatomic, assign) CGSize triangleViewSize;  //默认：CGSizeMake(14, 10)

@property (nonatomic, strong) UIColor *triangleViewColor;   //默认：[UIColor redColor]

@end
