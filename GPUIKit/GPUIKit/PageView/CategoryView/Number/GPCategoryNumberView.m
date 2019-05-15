//
//  GPCategoryNumberView.m
//  GPUIKit
//
//  Created by Liyanwei on 2018/4/9.
//  Copyright © 2018年 Liyanwei. All rights reserved.
//

#import "GPCategoryNumberView.h"

@implementation GPCategoryNumberView

- (void)dealloc
{
    self.numberStringFormatterBlock = nil;
}

- (void)initializeData {
    [super initializeData];

    self.cellSpacing = 25;
    _numberTitleColor = [UIColor whiteColor];
    _numberBackgroundColor = [UIColor colorWithRed:241/255.0 green:147/255.0 blue:95/255.0 alpha:1];
    _numberLabelHeight = 14;
    _numberLabelWidthIncrement = 10;
    _numberLabelFont = [UIFont systemFontOfSize:11];
}

- (Class)preferredCellClass {
    return [GPCategoryNumberCell class];
}

- (void)refreshDataSource {
    NSMutableArray *tempArray = [NSMutableArray array];
    for (int i = 0; i < self.titles.count; i++) {
        GPCategoryNumberCellModel *cellModel = [[GPCategoryNumberCellModel alloc] init];
        [tempArray addObject:cellModel];
    }
    self.dataSource = tempArray;
}

- (void)refreshCellModel:(GPCategoryBaseCellModel *)cellModel index:(NSInteger)index {
    [super refreshCellModel:cellModel index:index];

    GPCategoryNumberCellModel *myCellModel = (GPCategoryNumberCellModel *)cellModel;
    myCellModel.count = [self.counts[index] integerValue];
    if (self.numberStringFormatterBlock != nil) {
        myCellModel.numberString = self.numberStringFormatterBlock(myCellModel.count);
    }else {
        myCellModel.numberString = [NSString stringWithFormat:@"%ld", (long)myCellModel.count];
    }
    myCellModel.numberBackgroundColor = self.numberBackgroundColor;
    myCellModel.numberTitleColor = self.numberTitleColor;
    myCellModel.numberLabelHeight = self.numberLabelHeight;
    myCellModel.numberLabelWidthIncrement = self.numberLabelWidthIncrement;
    myCellModel.numberLabelFont = self.numberLabelFont;
}

@end
