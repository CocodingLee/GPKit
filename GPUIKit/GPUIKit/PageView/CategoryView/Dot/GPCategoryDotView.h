//
//  GPCategoryDotView.h
//  GPCategoryView
//
//  Created by Liyanwei on 2018/8/20.
//  Copyright © 2018年 Liyanwei. All rights reserved.
//

#import "GPCategoryTitleView.h"
#import "GPCategoryDotCell.h"
#import "GPCategoryDotCellModel.h"

@interface GPCategoryDotView : GPCategoryTitleView

@property (nonatomic, assign) GPCategoryDotRelativePosition relativePosition;   //相对于titleLabel的位置，默认：GPCategoryDotRelativePosition_TopRight

@property (nonatomic, strong) NSArray <NSNumber *> *dotStates;  //@(布尔值)，控制红点是否显示

@property (nonatomic, assign) CGSize dotSize;   //默认：CGSizeMake(10, 10)

@property (nonatomic, assign) CGFloat dotCornerRadius;  //默认：GPCategoryViewAutomaticDimension（self.dotSize.height/2）

@property (nonatomic, strong) UIColor *dotColor;    //默认：[UIColor redColor]

@end
