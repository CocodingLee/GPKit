//
//  GPCategoryDotView.m
//  GPCategoryView
//
//  Created by Liyanwei on 2018/8/20.
//  Copyright © 2018年 Liyanwei. All rights reserved.
//

#import "GPCategoryDotView.h"

@implementation GPCategoryDotView

- (void)initializeData {
    [super initializeData];

    _relativePosition = GPCategoryDotRelativePosition_TopRight;
    _dotSize = CGSizeMake(10, 10);
    _dotCornerRadius = GPCategoryViewAutomaticDimension;
    _dotColor = [UIColor redColor];
}

- (Class)preferredCellClass {
    return [GPCategoryDotCell class];
}

- (void)refreshDataSource {
    NSMutableArray *tempArray = [NSMutableArray array];
    for (int i = 0; i < self.titles.count; i++) {
        GPCategoryDotCellModel *cellModel = [[GPCategoryDotCellModel alloc] init];
        [tempArray addObject:cellModel];
    }
    self.dataSource = tempArray;
}

- (void)refreshCellModel:(GPCategoryBaseCellModel *)cellModel index:(NSInteger)index {
    [super refreshCellModel:cellModel index:index];

    GPCategoryDotCellModel *myCellModel = (GPCategoryDotCellModel *)cellModel;
    myCellModel.dotHidden = [self.dotStates[index] boolValue];
    myCellModel.relativePosition = self.relativePosition;
    myCellModel.dotSize = self.dotSize;
    myCellModel.dotColor = self.dotColor;
    if (self.dotCornerRadius == GPCategoryViewAutomaticDimension) {
        myCellModel.dotCornerRadius = self.dotSize.height/2;
    }else {
        myCellModel.dotCornerRadius = self.dotCornerRadius;
    }
}

@end
