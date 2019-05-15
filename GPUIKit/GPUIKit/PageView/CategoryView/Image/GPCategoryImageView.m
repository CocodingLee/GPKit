//
//  GPCategoryImageView.m
//  GPCategoryView
//
//  Created by Liyanwei on 2018/8/20.
//  Copyright © 2018年 Liyanwei. All rights reserved.
//

#import "GPCategoryImageView.h"
#import "GPCategoryFactory.h"

@implementation GPCategoryImageView

- (void)dealloc
{
    self.loadImageCallback = nil;
}

- (void)initializeData {
    [super initializeData];

    _imageSize = CGSizeMake(20, 20);
    _imageZoomEnabled = NO;
    _imageZoomScale = 1.2;
    _imageCornerRadius = 0;
}

- (Class)preferredCellClass {
    return [GPCategoryImageCell class];
}

- (void)refreshDataSource {
    NSMutableArray *tempArray = [NSMutableArray array];
    NSUInteger count = (self.imageNames.count > 0) ? self.imageNames.count : (self.imageURLs.count > 0 ? self.imageURLs.count : 0);
    for (int i = 0; i < count; i++) {
        GPCategoryImageCellModel *cellModel = [[GPCategoryImageCellModel alloc] init];
        [tempArray addObject:cellModel];
    }
    self.dataSource = tempArray;
}

- (void)refreshSelectedCellModel:(GPCategoryBaseCellModel *)selectedCellModel unselectedCellModel:(GPCategoryBaseCellModel *)unselectedCellModel {
    [super refreshSelectedCellModel:selectedCellModel unselectedCellModel:unselectedCellModel];

    GPCategoryImageCellModel *myUnselectedCellModel = (GPCategoryImageCellModel *)unselectedCellModel;
    myUnselectedCellModel.imageZoomScale = 1.0;

    GPCategoryImageCellModel *myselectedCellModel = (GPCategoryImageCellModel *)selectedCellModel;
    myselectedCellModel.imageZoomScale = self.imageZoomScale;
}

- (void)refreshCellModel:(GPCategoryBaseCellModel *)cellModel index:(NSInteger)index {
    [super refreshCellModel:cellModel index:index];

    GPCategoryImageCellModel *myCellModel = (GPCategoryImageCellModel *)cellModel;
    myCellModel.loadImageCallback = self.loadImageCallback;
    myCellModel.imageSize = self.imageSize;
    myCellModel.imageCornerRadius = self.imageCornerRadius;
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

- (void)refreshLeftCellModel:(GPCategoryBaseCellModel *)leftCellModel rightCellModel:(GPCategoryBaseCellModel *)rightCellModel ratio:(CGFloat)ratio {
    [super refreshLeftCellModel:leftCellModel rightCellModel:rightCellModel ratio:ratio];

    GPCategoryImageCellModel *leftModel = (GPCategoryImageCellModel *)leftCellModel;
    GPCategoryImageCellModel *rightModel = (GPCategoryImageCellModel *)rightCellModel;

    if (self.imageZoomEnabled) {
        leftModel.imageZoomScale = [GPCategoryFactory interpolationFrom:self.imageZoomScale to:1.0 percent:ratio];
        rightModel.imageZoomScale = [GPCategoryFactory interpolationFrom:1.0 to:self.imageZoomScale percent:ratio];
    }
}

- (CGFloat)preferredCellWidthAtIndex:(NSInteger)index {
    return self.imageSize.width;
}

@end
