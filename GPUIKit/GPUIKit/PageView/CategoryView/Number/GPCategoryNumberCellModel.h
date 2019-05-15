//
//  GPCategoryNumberCellModel.h
//  GPUIKit
//
//  Created by Liyanwei on 2018/4/24.
//  Copyright © 2018年 Liyanwei. All rights reserved.
//

#import "GPCategoryTitleCellModel.h"

@interface GPCategoryNumberCellModel : GPCategoryTitleCellModel

@property (nonatomic, assign) NSInteger count;
@property (nonatomic, copy) NSString *numberString;
@property (nonatomic, copy) void(^numberStringFormatterBlock)(NSInteger number);
@property (nonatomic, strong) UIColor *numberBackgroundColor;
@property (nonatomic, strong) UIColor *numberTitleColor;
@property (nonatomic, assign) CGFloat numberLabelWidthIncrement;
@property (nonatomic, assign) CGFloat numberLabelHeight;
@property (nonatomic, strong) UIFont *numberLabelFont;

@end
