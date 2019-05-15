//
//  GPCategoryIndicatorBackgroundView.m
//  GPCategoryView
//
//  Created by Liyanwei on 2018/8/17.
//  Copyright © 2018年 Liyanwei. All rights reserved.
//

#import "GPCategoryIndicatorBackgroundView.h"
#import "GPCategoryFactory.h"

@implementation GPCategoryIndicatorBackgroundView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _backgroundViewWidth = GPCategoryViewAutomaticDimension;
        _backgroundViewHeight = GPCategoryViewAutomaticDimension;
        _backgroundViewCornerRadius = GPCategoryViewAutomaticDimension;
        _backgroundViewColor = [UIColor lightGrayColor];
        _backgroundViewWidthIncrement = 10;
    }
    return self;
}

#pragma mark - GPCategoryIndicatorProtocol

- (void)jx_refreshState:(GPCategoryIndicatorParamsModel *)model {
    self.layer.cornerRadius = [self getBackgroundViewCornerRadius:model.selectedCellFrame];
    self.backgroundColor = self.backgroundViewColor;

    CGFloat width = [self getBackgroundViewWidth:model.selectedCellFrame];
    CGFloat height = [self getBackgroundViewHeight:model.selectedCellFrame];
    CGFloat x = model.selectedCellFrame.origin.x + (model.selectedCellFrame.size.width - width)/2;
    CGFloat y = (model.selectedCellFrame.size.height - height)/2;
    self.frame = CGRectMake(x, y, width, height);
}

- (void)jx_contentScrollViewDidScroll:(GPCategoryIndicatorParamsModel *)model {
    CGRect rightCellFrame = model.rightCellFrame;
    CGRect leftCellFrame = model.leftCellFrame;
    CGFloat percent = model.percent;
    CGFloat targetX = 0;
    CGFloat targetWidth = [self getBackgroundViewWidth:leftCellFrame];

    if (percent == 0) {
        targetX = leftCellFrame.origin.x + (leftCellFrame.size.width - targetWidth)/2.0;
    }else {
        CGFloat leftWidth = targetWidth;
        CGFloat rightWidth = [self getBackgroundViewWidth:rightCellFrame];

        CGFloat leftX = leftCellFrame.origin.x + (leftCellFrame.size.width - leftWidth)/2;
        CGFloat rightX = rightCellFrame.origin.x + (rightCellFrame.size.width - rightWidth)/2;

        targetX = [GPCategoryFactory interpolationFrom:leftX to:rightX percent:percent];

        if (self.backgroundViewWidth == GPCategoryViewAutomaticDimension) {
            targetWidth = [GPCategoryFactory interpolationFrom:leftWidth to:rightWidth percent:percent];
        }
    }

    //允许变动frame的情况：1、允许滚动；2、不允许滚动，但是已经通过手势滚动切换一页内容了；
    if (self.scrollEnabled == YES || (self.scrollEnabled == NO && percent == 0)) {
        CGFloat height = [self getBackgroundViewHeight:leftCellFrame];
        CGFloat y = (leftCellFrame.size.height - height)/2;
        self.frame = CGRectMake(targetX, y, targetWidth, height);
    }
}

- (void)jx_selectedCell:(GPCategoryIndicatorParamsModel *)model {
    CGFloat width = [self getBackgroundViewWidth:model.selectedCellFrame];
    CGFloat height = [self getBackgroundViewHeight:model.selectedCellFrame];
    CGFloat x = model.selectedCellFrame.origin.x + (model.selectedCellFrame.size.width - width)/2;
    CGFloat y = (model.selectedCellFrame.size.height - height)/2;
    CGRect toFrame = CGRectMake(x, y, width, height);

    if (self.scrollEnabled) {
        [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
            self.frame = toFrame;
        } completion:^(BOOL finished) {
        }];
    }else {
        self.frame = toFrame;
    }
}

#pragma mark - Private

- (CGFloat)getBackgroundViewWidth:(CGRect)cellFrame
{
    if (self.backgroundViewWidth == GPCategoryViewAutomaticDimension) {
        return cellFrame.size.width  + self.backgroundViewWidthIncrement;
    }
    return self.backgroundViewWidth + self.backgroundViewWidthIncrement;
}

- (CGFloat)getBackgroundViewHeight:(CGRect)cellFrame
{
    if (self.backgroundViewHeight == GPCategoryViewAutomaticDimension) {
        return cellFrame.size.height;
    }
    return self.backgroundViewHeight;
}

- (CGFloat)getBackgroundViewCornerRadius:(CGRect)cellFrame {
    if (self.backgroundViewCornerRadius == GPCategoryViewAutomaticDimension) {
        return [self getBackgroundViewHeight:cellFrame]/2;
    }
    return self.backgroundViewCornerRadius;
}

@end
