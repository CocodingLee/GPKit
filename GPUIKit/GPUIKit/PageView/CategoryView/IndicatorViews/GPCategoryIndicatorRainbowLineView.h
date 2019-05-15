//
//  GPCategoryIndicatorRainbowLineView.h
//  GPCategoryView
//
//  Created by Liyanwei on 2018/12/13.
//  Copyright © 2018 Liyanwei. All rights reserved.
//

#import "GPCategoryIndicatorLineView.h"

NS_ASSUME_NONNULL_BEGIN

/**
 会无视GPCategoryIndicatorLineView的indicatorLineViewColor属性，以indicatorColors为准
 */
@interface GPCategoryIndicatorRainbowLineView : GPCategoryIndicatorLineView

@property (nonatomic, strong) NSArray <UIColor *> *indicatorColors; //数量需要与cell的数量相等。没有提供默认值，必须要赋值该属性。categoryView在reloadData的时候，也要一并更新该属性，不然会出现数组越界。

@end

NS_ASSUME_NONNULL_END
