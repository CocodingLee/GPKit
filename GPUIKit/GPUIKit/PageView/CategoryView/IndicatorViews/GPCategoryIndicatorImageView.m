//
//  GPCategoryIndicatorImageView.m
//  GPCategoryView
//
//  Created by Liyanwei on 2018/8/17.
//  Copyright © 2018年 Liyanwei. All rights reserved.
//

#import "GPCategoryIndicatorImageView.h"
#import "GPCategoryFactory.h"

@implementation GPCategoryIndicatorImageView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _indicatorImageViewSize = CGSizeMake(30, 20);
        _indicatorImageViewRollEnabled = NO;

        _indicatorImageView = [[UIImageView alloc] init];
        self.indicatorImageView.frame = CGRectMake(0, 0, self.indicatorImageViewSize.width, self.indicatorImageViewSize.height);
        self.indicatorImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:self.indicatorImageView];
    }
    return self;
}

- (void)setIndicatorImageViewSize:(CGSize)indicatorImageViewSize {
    _indicatorImageViewSize = indicatorImageViewSize;

    self.indicatorImageView.frame = CGRectMake(0, 0, self.indicatorImageViewSize.width, self.indicatorImageViewSize.height);
}

#pragma mark - GPCategoryIndicatorProtocol

- (void)jx_refreshState:(GPCategoryIndicatorParamsModel *)model {
    CGFloat x = model.selectedCellFrame.origin.x + (model.selectedCellFrame.size.width - self.indicatorImageViewSize.width)/2;
    CGFloat y = self.superview.bounds.size.height - self.indicatorImageViewSize.height - self.verticalMargin;
    if (self.componentPosition == GPCategoryComponentPosition_Top) {
        y = self.verticalMargin;
    }
    self.frame = CGRectMake(x, y, self.indicatorImageViewSize.width, self.indicatorImageViewSize.height);
}

- (void)jx_contentScrollViewDidScroll:(GPCategoryIndicatorParamsModel *)model {
    CGRect rightCellFrame = model.rightCellFrame;
    CGRect leftCellFrame = model.leftCellFrame;
    CGFloat percent = model.percent;
    CGFloat targetWidth = self.indicatorImageViewSize.width;
    CGFloat targetX = 0;

    if (percent == 0) {
        targetX = leftCellFrame.origin.x + (leftCellFrame.size.width - targetWidth)/2.0;
    }else {
        CGFloat leftX = leftCellFrame.origin.x + (leftCellFrame.size.width - targetWidth)/2;
        CGFloat rightX = rightCellFrame.origin.x + (rightCellFrame.size.width - targetWidth)/2;
        targetX = [GPCategoryFactory interpolationFrom:leftX to:rightX percent:percent];
    }

    //允许变动frame的情况：1、允许滚动；2、不允许滚动，但是已经通过手势滚动切换一页内容了；
    if (self.scrollEnabled == YES || (self.scrollEnabled == NO && percent == 0)) {
        CGRect frame = self.frame;
        frame.origin.x = targetX;
        self.frame = frame;
        
        if (self.indicatorImageViewRollEnabled) {
            self.indicatorImageView.transform = CGAffineTransformMakeRotation(M_PI*2*percent);
        }
    }
}

- (void)jx_selectedCell:(GPCategoryIndicatorParamsModel *)model {
    CGRect toFrame = self.frame;
    toFrame.origin.x = model.selectedCellFrame.origin.x + (model.selectedCellFrame.size.width - self.indicatorImageViewSize.width)/2;
    if (self.scrollEnabled) {
        [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
            self.frame = toFrame;
        } completion:^(BOOL finished) {
        }];
        if (self.indicatorImageViewRollEnabled && (model.selectedType == GPCategoryCellSelectedTypeCode || model.selectedType == GPCategoryCellSelectedTypeClick)) {
            [self.indicatorImageView.layer removeAnimationForKey:@"rotate"];
            CABasicAnimation *rotateAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
            if (model.selectedIndex > model.lastSelectedIndex) {
                rotateAnimation.fromValue = @(0);
                rotateAnimation.toValue = @(M_PI*2);
            }else {
                rotateAnimation.fromValue = @(M_PI*2);
                rotateAnimation.toValue = @(0);
            }
            rotateAnimation.fillMode = kCAFillModeBackwards;
            rotateAnimation.removedOnCompletion = YES;
            rotateAnimation.duration = 0.25;
            [self.indicatorImageView.layer addAnimation:rotateAnimation forKey:@"rotate"];
        }
    }else {
        self.frame = toFrame;
    }
}


@end
