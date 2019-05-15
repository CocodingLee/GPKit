//
//  GPCategoryView.m
//  GPUIKit
//
//  Created by Liyanwei on 2018/3/15.
//  Copyright © 2018年 Liyanwei. All rights reserved.
//

#import "GPCategoryTitleView.h"
#import "GPCategoryFactory.h"

@interface GPCategoryTitleView ()

@end

@implementation GPCategoryTitleView

- (void)initializeData
{
    [super initializeData];

    _titleLabelZoomEnabled = NO;
    _titleLabelZoomScale = 1.2;
    _titleColor = [UIColor blackColor];
    _titleSelectedColor = [UIColor redColor];
    _titleFont = [UIFont systemFontOfSize:15];
    _titleColorGradientEnabled = NO;
    _titleLabelMaskEnabled = NO;
    _titleLabelZoomScrollGradientEnabled = YES;
    _titleLabelStrokeWidthEnabled = NO;
    _titleLabelSelectedStrokeWidth = -3;
}

- (UIFont *)titleSelectedFont {
    if (_titleSelectedFont != nil) {
        return _titleSelectedFont;
    }
    return self.titleFont;
}

#pragma mark - Override

- (Class)preferredCellClass {
    return [GPCategoryTitleCell class];
}

- (void)refreshDataSource {
    NSMutableArray *tempArray = [NSMutableArray array];
    for (int i = 0; i < self.titles.count; i++) {
        GPCategoryTitleCellModel *cellModel = [[GPCategoryTitleCellModel alloc] init];
        [tempArray addObject:cellModel];
    }
    self.dataSource = tempArray;
}

- (void)refreshSelectedCellModel:(GPCategoryBaseCellModel *)selectedCellModel unselectedCellModel:(GPCategoryBaseCellModel *)unselectedCellModel {
    [super refreshSelectedCellModel:selectedCellModel unselectedCellModel:unselectedCellModel];

    GPCategoryTitleCellModel *myUnselectedCellModel = (GPCategoryTitleCellModel *)unselectedCellModel;
    myUnselectedCellModel.titleColor = self.titleColor;
    myUnselectedCellModel.titleSelectedColor = self.titleSelectedColor;
    myUnselectedCellModel.titleLabelZoomScale = 1.0;
    myUnselectedCellModel.titleLabelSelectedStrokeWidth = 0;

    GPCategoryTitleCellModel *myselectedCellModel = (GPCategoryTitleCellModel *)selectedCellModel;
    myselectedCellModel.titleColor = self.titleColor;
    myselectedCellModel.titleSelectedColor = self.titleSelectedColor;
    myselectedCellModel.titleLabelZoomScale = self.titleLabelZoomScale;
    myselectedCellModel.titleLabelSelectedStrokeWidth = self.titleLabelSelectedStrokeWidth;
}

- (void)refreshLeftCellModel:(GPCategoryBaseCellModel *)leftCellModel rightCellModel:(GPCategoryBaseCellModel *)rightCellModel ratio:(CGFloat)ratio {
    [super refreshLeftCellModel:leftCellModel rightCellModel:rightCellModel ratio:ratio];

    GPCategoryTitleCellModel *leftModel = (GPCategoryTitleCellModel *)leftCellModel;
    GPCategoryTitleCellModel *rightModel = (GPCategoryTitleCellModel *)rightCellModel;

    if (self.titleLabelZoomEnabled && self.titleLabelZoomScrollGradientEnabled) {
        leftModel.titleLabelZoomScale = [GPCategoryFactory interpolationFrom:self.titleLabelZoomScale to:1.0 percent:ratio];
        rightModel.titleLabelZoomScale = [GPCategoryFactory interpolationFrom:1.0 to:self.titleLabelZoomScale percent:ratio];
    }

    if (self.titleLabelStrokeWidthEnabled) {
        leftModel.titleLabelSelectedStrokeWidth = [GPCategoryFactory interpolationFrom:self.titleLabelSelectedStrokeWidth to:0 percent:ratio];
        rightModel.titleLabelSelectedStrokeWidth = [GPCategoryFactory interpolationFrom:0 to:self.titleLabelSelectedStrokeWidth percent:ratio];
    }

    if (self.titleColorGradientEnabled) {
        //处理颜色渐变
        if (leftModel.selected) {
            leftModel.titleSelectedColor = [GPCategoryFactory interpolationColorFrom:self.titleSelectedColor to:self.titleColor percent:ratio];
            leftModel.titleColor = self.titleColor;
        }else {
            leftModel.titleColor = [GPCategoryFactory interpolationColorFrom:self.titleSelectedColor to:self.titleColor percent:ratio];
            leftModel.titleSelectedColor = self.titleSelectedColor;
        }
        if (rightModel.selected) {
            rightModel.titleSelectedColor = [GPCategoryFactory interpolationColorFrom:self.titleColor to:self.titleSelectedColor percent:ratio];
            rightModel.titleColor = self.titleColor;
        }else {
            rightModel.titleColor = [GPCategoryFactory interpolationColorFrom:self.titleColor to:self.titleSelectedColor percent:ratio];
            rightModel.titleSelectedColor = self.titleSelectedColor;
        }
    }
}

- (CGFloat)preferredCellWidthAtIndex:(NSInteger)index {
    if (self.cellWidth == GPCategoryViewAutomaticDimension) {
        return ceilf([self.titles[index] boundingRectWithSize:CGSizeMake(MAXFLOAT, self.bounds.size.height) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : self.titleFont} context:nil].size.width);
    }else {
        return self.cellWidth;
    }
}

- (void)refreshCellModel:(GPCategoryBaseCellModel *)cellModel index:(NSInteger)index {
    [super refreshCellModel:cellModel index:index];

    GPCategoryTitleCellModel *model = (GPCategoryTitleCellModel *)cellModel;
    model.titleFont = self.titleFont;
    model.titleSelectedFont = self.titleSelectedFont;
    model.titleColor = self.titleColor;
    model.titleSelectedColor = self.titleSelectedColor;
    model.title = self.titles[index];
    model.titleLabelMaskEnabled = self.titleLabelMaskEnabled;
    model.titleLabelZoomEnabled = self.titleLabelZoomEnabled;
    model.titleLabelStrokeWidthEnabled = self.titleLabelStrokeWidthEnabled;
    model.titleLabelMaxZoomScale = self.titleLabelZoomScale;
    if (index == self.selectedIndex) {
        model.titleLabelZoomScale = self.titleLabelZoomScale;
        model.titleLabelSelectedStrokeWidth = self.titleLabelSelectedStrokeWidth;
    }else {
        model.titleLabelZoomScale = 1.0;
        model.titleLabelSelectedStrokeWidth = 0;
    }
}

@end
