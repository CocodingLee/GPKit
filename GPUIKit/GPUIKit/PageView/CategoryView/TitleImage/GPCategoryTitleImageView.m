//
//  GPCategoryImageView.m
//  GPCategoryView
//
//  Created by Liyanwei on 2018/8/8.
//  Copyright © 2018年 Liyanwei. All rights reserved.
//

#import "GPCategoryTitleImageView.h"
#import "GPCategoryTitleImageCell.h"
#import "GPCategoryTitleImageCellModel.h"
#import "GPCategoryFactory.h"

@implementation GPCategoryTitleImageView

- (void)dealloc
{
    self.loadImageCallback = nil;
}

- (void)initializeData {
    [super initializeData];

    _imageSize = CGSizeMake(20, 20);
    _titleImageSpacing = 5;
    _imageZoomEnabled = NO;
    _imageZoomScale = 1.2;
}

- (Class)preferredCellClass {
    return [GPCategoryTitleImageCell class];
}

- (void)refreshDataSource {
    NSMutableArray *tempArray = [NSMutableArray array];
    for (int i = 0; i < self.titles.count; i++) {
        GPCategoryTitleImageCellModel *cellModel = [[GPCategoryTitleImageCellModel alloc] init];
        [tempArray addObject:cellModel];
    }
    if (self.imageTypes == nil || self.imageTypes.count == 0) {
        NSMutableArray *types = [NSMutableArray array];
        for (int i = 0; i < self.titles.count; i++) {
            [types addObject:@(GPCategoryTitleImageType_LeftImage)];
        }
        self.imageTypes = types;
    }
    self.dataSource = tempArray;
}

- (void)refreshCellModel:(GPCategoryBaseCellModel *)cellModel index:(NSInteger)index {
    [super refreshCellModel:cellModel index:index];

    GPCategoryTitleImageCellModel *myCellModel = (GPCategoryTitleImageCellModel *)cellModel;
    myCellModel.loadImageCallback = self.loadImageCallback;
    myCellModel.imageType = [self.imageTypes[index] integerValue];
    myCellModel.imageSize = self.imageSize;
    myCellModel.titleImageSpacing = self.titleImageSpacing;
    if (self.imageNames != nil) {
        myCellModel.imageName = self.imageNames[index];
    }else if (self.imageURLs != nil) {
        myCellModel.imageURL = self.imageURLs[index];
    }
    if (self.selectedImageNames != nil) {
        myCellModel.selectedImageName = self.selectedImageNames[index];
    }else if (self.selectedImageURLs != nil) {
        myCellModel.selectedImageURL = self.selectedImageURLs[index];
    }
    myCellModel.imageZoomEnabled = self.imageZoomEnabled;
    myCellModel.imageZoomScale = 1.0;
    if (index == self.selectedIndex) {
        myCellModel.imageZoomScale = self.imageZoomScale;
    }
}

- (void)refreshSelectedCellModel:(GPCategoryBaseCellModel *)selectedCellModel unselectedCellModel:(GPCategoryBaseCellModel *)unselectedCellModel {
    [super refreshSelectedCellModel:selectedCellModel unselectedCellModel:unselectedCellModel];

    GPCategoryTitleImageCellModel *myUnselectedCellModel = (GPCategoryTitleImageCellModel *)unselectedCellModel;
    myUnselectedCellModel.imageZoomScale = 1.0;

    GPCategoryTitleImageCellModel *myselectedCellModel = (GPCategoryTitleImageCellModel *)selectedCellModel;
    myselectedCellModel.imageZoomScale = self.imageZoomScale;
}

- (void)refreshLeftCellModel:(GPCategoryBaseCellModel *)leftCellModel rightCellModel:(GPCategoryBaseCellModel *)rightCellModel ratio:(CGFloat)ratio {
    [super refreshLeftCellModel:leftCellModel rightCellModel:rightCellModel ratio:ratio];

    GPCategoryTitleImageCellModel *leftModel = (GPCategoryTitleImageCellModel *)leftCellModel;
    GPCategoryTitleImageCellModel *rightModel = (GPCategoryTitleImageCellModel *)rightCellModel;

    if (self.imageZoomEnabled) {
        leftModel.imageZoomScale = [GPCategoryFactory interpolationFrom:self.imageZoomScale to:1.0 percent:ratio];
        rightModel.imageZoomScale = [GPCategoryFactory interpolationFrom:1.0 to:self.imageZoomScale percent:ratio];
    }
}

- (CGFloat)preferredCellWidthAtIndex:(NSInteger)index {
    CGFloat titleWidth = [super preferredCellWidthAtIndex:index];
    GPCategoryTitleImageType type = [self.imageTypes[index] integerValue];
    CGFloat cellWidth = 0;
    switch (type) {
        case GPCategoryTitleImageType_OnlyTitle:
            cellWidth = titleWidth;
            break;
        case GPCategoryTitleImageType_OnlyImage:
            cellWidth = self.imageSize.width;
            break;
        case GPCategoryTitleImageType_LeftImage:
        case GPCategoryTitleImageType_RightImage:
            cellWidth = titleWidth + self.titleImageSpacing + self.imageSize.width;
            break;
        case GPCategoryTitleImageType_TopImage:
        case GPCategoryTitleImageType_BottomImage:
            cellWidth = MAX(titleWidth, self.imageSize.width);
            break;
    }
    return cellWidth;
}

@end
