//
//  GPCategoryCollectionView.m
//  GPUIKit
//
//  Created by Liyanwei on 2018/3/21.
//  Copyright © 2018年 Liyanwei. All rights reserved.
//

#import "GPCategoryCollectionView.h"

@implementation GPCategoryCollectionView

- (void)setIndicators:(NSArray<UIView<GPCategoryIndicatorProtocol> *> *)indicators {
    for (UIView *indicator in _indicators) {
        //先移除之前的indicator
        [indicator removeFromSuperview];
    }

    _indicators = indicators;

    for (UIView *indicator in indicators) {
        [self addSubview:indicator];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    for (UIView<GPCategoryIndicatorProtocol> *view in self.indicators) {
        [self sendSubviewToBack:view];
    }
}

@end
