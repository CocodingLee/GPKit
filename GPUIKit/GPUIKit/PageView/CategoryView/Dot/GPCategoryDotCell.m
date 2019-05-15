//
//  GPCategoryDotCell.m
//  GPCategoryView
//
//  Created by Liyanwei on 2018/8/20.
//  Copyright © 2018年 Liyanwei. All rights reserved.
//

#import "GPCategoryDotCell.h"
#import "GPCategoryDotCellModel.h"

@interface GPCategoryDotCell ()
@property (nonatomic, strong) CALayer *dotLayer;
@end

@implementation GPCategoryDotCell

- (void)initializeViews {
    [super initializeViews];

    _dotLayer = [CALayer layer];
    [self.contentView.layer addSublayer:self.dotLayer];
}

- (void)layoutSubviews {
    [super layoutSubviews];

    [CATransaction begin];
    [CATransaction setDisableActions:YES];

    GPCategoryDotCellModel *myCellModel = (GPCategoryDotCellModel *)self.cellModel;
    self.dotLayer.bounds = CGRectMake(0, 0, myCellModel.dotSize.width, myCellModel.dotSize.height);
    switch (myCellModel.relativePosition) {
        case GPCategoryDotRelativePosition_TopLeft:
        {
            self.dotLayer.position = CGPointMake(CGRectGetMinX(self.titleLabel.frame), CGRectGetMinY(self.titleLabel.frame));
        }
            break;
        case GPCategoryDotRelativePosition_TopRight:
        {
            self.dotLayer.position = CGPointMake(CGRectGetMaxX(self.titleLabel.frame), CGRectGetMinY(self.titleLabel.frame));
        }
            break;
        case GPCategoryDotRelativePosition_BottomLeft:
        {
            self.dotLayer.position = CGPointMake(CGRectGetMinX(self.titleLabel.frame), CGRectGetMaxY(self.titleLabel.frame));
        }
            break;
        case GPCategoryDotRelativePosition_BottomRight:
        {
            self.dotLayer.position = CGPointMake(CGRectGetMaxX(self.titleLabel.frame), CGRectGetMaxY(self.titleLabel.frame));
        }
            break;

        default:
            break;
    }
    self.dotLayer.position = CGPointMake(CGRectGetMaxX(self.titleLabel.frame), CGRectGetMinY(self.titleLabel.frame));

    [CATransaction commit];
}

- (void)reloadData:(GPCategoryBaseCellModel *)cellModel {
    [super reloadData:cellModel];

    GPCategoryDotCellModel *myCellModel = (GPCategoryDotCellModel *)cellModel;
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    self.dotLayer.hidden = !myCellModel.dotHidden;
    self.dotLayer.backgroundColor = myCellModel.dotColor.CGColor;
    self.dotLayer.cornerRadius = myCellModel.dotCornerRadius;
    [CATransaction commit];

    [self setNeedsLayout];
    [self layoutIfNeeded];
}

@end
