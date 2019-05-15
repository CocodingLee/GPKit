//
//  GPCategoryIndicatorTriangleView.m
//  GPCategoryView
//
//  Created by Liyanwei on 2018/8/17.
//  Copyright © 2018年 Liyanwei. All rights reserved.
//

#import "GPCategoryIndicatorTriangleView.h"
#import "GPCategoryFactory.h"

@interface GPCategoryIndicatorTriangleView ()
@property (nonatomic, strong) CAShapeLayer *triangleLayer;
@end

@implementation GPCategoryIndicatorTriangleView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _triangleViewSize = CGSizeMake(14, 10);
        _triangleViewColor = [UIColor redColor];

        _triangleLayer = [CAShapeLayer layer];
        [self.layer addSublayer:self.triangleLayer];
    }
    return self;
}

#pragma mark - GPCategoryIndicatorProtocol

- (void)jx_refreshState:(GPCategoryIndicatorParamsModel *)model {
    CGFloat x = model.selectedCellFrame.origin.x + (model.selectedCellFrame.size.width - self.triangleViewSize.width)/2;
    CGFloat y = self.superview.bounds.size.height - self.triangleViewSize.height - self.verticalMargin;
    if (self.componentPosition == GPCategoryComponentPosition_Top) {
        y = self.verticalMargin;
    }
    self.frame = CGRectMake(x, y, self.triangleViewSize.width, self.triangleViewSize.height);

    [CATransaction begin];
    [CATransaction setDisableActions:NO];
    self.triangleLayer.fillColor = self.triangleViewColor.CGColor;
    self.triangleLayer.frame = self.bounds;
    UIBezierPath *path = [UIBezierPath bezierPath];
    if (self.componentPosition == GPCategoryComponentPosition_Bottom) {
        [path moveToPoint:CGPointMake(self.bounds.size.width/2, 0)];
        [path addLineToPoint:CGPointMake(0, self.bounds.size.height)];
        [path addLineToPoint:CGPointMake(self.bounds.size.width, self.bounds.size.height)];
    }else {
        [path moveToPoint:CGPointMake(0, 0)];
        [path addLineToPoint:CGPointMake(self.bounds.size.width, 0)];
        [path addLineToPoint:CGPointMake(self.bounds.size.width/2, self.bounds.size.height)];
    }
    [path closePath];
    self.triangleLayer.path = path.CGPath;
    [CATransaction commit];
}

- (void)jx_contentScrollViewDidScroll:(GPCategoryIndicatorParamsModel *)model {
    CGRect rightCellFrame = model.rightCellFrame;
    CGRect leftCellFrame = model.leftCellFrame;
    CGFloat percent = model.percent;
    CGFloat targetWidth = self.triangleViewSize.width;
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
    }
}

- (void)jx_selectedCell:(GPCategoryIndicatorParamsModel *)model {
    CGRect toFrame = self.frame;
    toFrame.origin.x = model.selectedCellFrame.origin.x + (model.selectedCellFrame.size.width - self.triangleViewSize.width)/2;
    if (self.scrollEnabled) {
        [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
            self.frame = toFrame;
        } completion:^(BOOL finished) {
        }];
    }else {
        self.frame = toFrame;
    }
}

@end
