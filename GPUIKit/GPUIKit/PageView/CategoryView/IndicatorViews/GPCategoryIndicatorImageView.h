//
//  GPCategoryIndicatorImageView.h
//  GPCategoryView
//
//  Created by Liyanwei on 2018/8/17.
//  Copyright © 2018年 Liyanwei. All rights reserved.
//

#import "GPCategoryIndicatorComponentView.h"

@interface GPCategoryIndicatorImageView : GPCategoryIndicatorComponentView

@property (nonatomic, strong, readonly) UIImageView *indicatorImageView;

@property (nonatomic, assign) BOOL indicatorImageViewRollEnabled;      //默认NO

@property (nonatomic, assign) CGSize indicatorImageViewSize;    //默认：CGSizeMake(30, 20)

@end
