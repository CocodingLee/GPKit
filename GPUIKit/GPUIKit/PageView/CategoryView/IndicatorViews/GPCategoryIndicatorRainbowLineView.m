//
//  GPCategoryIndicatorRainbowLineView.m
//  GPCategoryView
//
//  Created by Liyanwei on 2018/12/13.
//  Copyright © 2018 Liyanwei. All rights reserved.
//

#import "GPCategoryIndicatorRainbowLineView.h"
#import "GPCategoryFactory.h"

@implementation GPCategoryIndicatorRainbowLineView

- (void)jx_refreshState:(GPCategoryIndicatorParamsModel *)model {
    [super jx_refreshState:model];

    UIColor *color = self.indicatorColors[model.selectedIndex];
    self.backgroundColor = color;
}

- (void)jx_contentScrollViewDidScroll:(GPCategoryIndicatorParamsModel *)model {
    [super jx_contentScrollViewDidScroll:model];

    UIColor *leftColor = self.indicatorColors[model.leftIndex];
    UIColor *rightColor = self.indicatorColors[model.rightIndex];
    UIColor *color = [GPCategoryFactory interpolationColorFrom:leftColor to:rightColor percent:model.percent];
    self.backgroundColor = color;
}

- (void)jx_selectedCell:(GPCategoryIndicatorParamsModel *)model {
    [super jx_selectedCell:model];

    UIColor *color = self.indicatorColors[model.selectedIndex];
    self.backgroundColor = color;
}


@end
