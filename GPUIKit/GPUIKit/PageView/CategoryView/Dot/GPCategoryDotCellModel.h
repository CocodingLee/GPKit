//
//  GPCategoryDotCellModel.h
//  GPCategoryView
//
//  Created by Liyanwei on 2018/8/20.
//  Copyright © 2018年 Liyanwei. All rights reserved.
//

#import "GPCategoryTitleCellModel.h"

typedef NS_ENUM(NSUInteger, GPCategoryDotRelativePosition) {
    GPCategoryDotRelativePosition_TopLeft = 0,
    GPCategoryDotRelativePosition_TopRight,
    GPCategoryDotRelativePosition_BottomLeft,
    GPCategoryDotRelativePosition_BottomRight,
};

@interface GPCategoryDotCellModel : GPCategoryTitleCellModel

@property (nonatomic, assign) BOOL dotHidden;

@property (nonatomic, assign) GPCategoryDotRelativePosition relativePosition;

@property (nonatomic, assign) CGSize dotSize;

@property (nonatomic, assign) CGFloat dotCornerRadius;

@property (nonatomic, strong) UIColor *dotColor;


@end
