//
//  GPCategoryComponentView.h
//  GPUIKit
//
//  Created by Liyanwei on 2018/7/25.
//  Copyright © 2018年 Liyanwei. All rights reserved.
//

#import "GPCategoryBaseView.h"
#import "GPCategoryIndicatorCell.h"
#import "GPCategoryIndicatorCellModel.h"
#import "GPCategoryIndicatorProtocol.h"

@interface GPCategoryIndicatorView : GPCategoryBaseView

@property (nonatomic, strong) NSArray <UIView<GPCategoryIndicatorProtocol> *> *indicators;

//----------------------ellBackgroundColor-----------------------//
@property (nonatomic, assign) BOOL cellBackgroundColorGradientEnabled;      //默认：NO

@property (nonatomic, strong) UIColor *cellBackgroundUnselectedColor;       //默认：[UIColor clearColor]

@property (nonatomic, strong) UIColor *cellBackgroundSelectedColor;     //默认：[UIColor grayColor]

//----------------------separatorLine-----------------------//
@property (nonatomic, assign) BOOL separatorLineShowEnabled;    //默认为NO

@property (nonatomic, strong) UIColor *separatorLineColor;    //默认为[UIColor lightGrayColor]

@property (nonatomic, assign) CGSize separatorLineSize;    //默认为CGSizeMake(1/[UIScreen mainScreen].scale, 20)

/**
 当contentScrollView滚动时候，处理跟随手势的过渡效果。
 根据cellModel的左右位置、是否选中、ratio进行过滤数据计算。
 
 @param leftCellModel 左边的cellModel
 @param rightCellModel 右边的cellModel
 @param ratio 从左往右方向计算的百分比
 */
- (void)refreshLeftCellModel:(GPCategoryBaseCellModel *)leftCellModel rightCellModel:(GPCategoryBaseCellModel *)rightCellModel ratio:(CGFloat)ratio NS_REQUIRES_SUPER;

@end
