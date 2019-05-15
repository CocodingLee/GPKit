//
//  GPCategoryTitleCellModel.h
//  GPUIKit
//
//  Created by Liyanwei on 2018/3/15.
//  Copyright © 2018年 Liyanwei. All rights reserved.
//

#import "GPCategoryIndicatorCellModel.h"
#import <UIKit/UIKit.h>

@interface GPCategoryTitleCellModel : GPCategoryIndicatorCellModel

@property (nonatomic, copy) NSString *title;

@property (nonatomic, strong) UIColor *titleColor;

@property (nonatomic, strong) UIColor *titleSelectedColor;

@property (nonatomic, strong) UIFont *titleFont;

@property (nonatomic, strong) UIFont *titleSelectedFont;

@property (nonatomic, assign) BOOL titleLabelMaskEnabled;

@property (nonatomic, assign) BOOL titleLabelZoomEnabled;

@property (nonatomic, assign) CGFloat titleLabelZoomScale;  //字号当前的缩放值

@property (nonatomic, assign) CGFloat titleLabelMaxZoomScale;   //字号的最大缩放值

@property (nonatomic, assign) BOOL titleLabelStrokeWidthEnabled;

@property (nonatomic, assign) CGFloat titleLabelSelectedStrokeWidth;

@end
