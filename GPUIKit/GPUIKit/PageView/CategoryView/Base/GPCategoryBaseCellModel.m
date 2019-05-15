//
//  GPCategoryBaseCellModel.m
//  GPUIKit
//
//  Created by Liyanwei on 2018/3/15.
//  Copyright © 2018年 Liyanwei. All rights reserved.
//

#import "GPCategoryBaseCellModel.h"

@implementation GPCategoryBaseCellModel

- (CGFloat)cellWidth {
    if (_cellWidthZoomEnabled) {
        return _cellWidth * _cellWidthZoomScale;
    }
    return _cellWidth;
}

@end
