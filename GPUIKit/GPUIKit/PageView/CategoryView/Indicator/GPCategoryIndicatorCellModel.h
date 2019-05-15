//
//  GPCategoryComponentCellModel.h
//  GPUIKit
//
//  Created by Liyanwei on 2018/7/25.
//  Copyright © 2018年 Liyanwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GPCategoryBaseCellModel.h"

@interface GPCategoryIndicatorCellModel : GPCategoryBaseCellModel

@property (nonatomic, assign) BOOL sepratorLineShowEnabled;

@property (nonatomic, strong) UIColor *separatorLineColor;

@property (nonatomic, assign) CGSize separatorLineSize;

@property (nonatomic, assign) CGRect backgroundViewMaskFrame;

@property (nonatomic, assign) BOOL cellBackgroundColorGradientEnabled;

@property (nonatomic, strong) UIColor *cellBackgroundUnselectedColor;

@property (nonatomic, strong) UIColor *cellBackgroundSelectedColor;

@end
