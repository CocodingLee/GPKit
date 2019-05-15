//
//  GPCategoryComponentBaseView.m
//  GPCategoryView
//
//  Created by Liyanwei on 2018/8/17.
//  Copyright © 2018年 Liyanwei. All rights reserved.
//

#import "GPCategoryIndicatorComponentView.h"

@implementation GPCategoryIndicatorComponentView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _componentPosition = GPCategoryComponentPosition_Bottom;
        _scrollEnabled = YES;
        _verticalMargin = 0;
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        NSAssert(NO, @"Use initWithFrame");
    }
    return self;
}

#pragma mark - GPCategoryIndicatorProtocol

- (void)jx_refreshState:(GPCategoryIndicatorParamsModel *)model {

}

- (void)jx_contentScrollViewDidScroll:(GPCategoryIndicatorParamsModel *)model {

}

- (void)jx_selectedCell:(GPCategoryIndicatorParamsModel *)model {
    
}

@end
