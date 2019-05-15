//
//  GPCategoryComponentBaseView.h
//  GPCategoryView
//
//  Created by Liyanwei on 2018/8/17.
//  Copyright © 2018年 Liyanwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GPCategoryIndicatorProtocol.h"
#import "GPCategoryViewDefines.h"

@interface GPCategoryIndicatorComponentView : UIView <GPCategoryIndicatorProtocol>

@property (nonatomic, assign) GPCategoryComponentPosition componentPosition;

@property (nonatomic, assign) CGFloat verticalMargin;     //垂直方向边距；默认：0

@property (nonatomic, assign) BOOL scrollEnabled;   //手势滚动、点击切换的时候，是否允许滚动，默认YES


@end
