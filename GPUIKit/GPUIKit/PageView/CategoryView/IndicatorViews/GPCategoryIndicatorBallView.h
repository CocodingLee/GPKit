//
//  GPCategoryIndicatorBallView.h
//  GPCategoryView
//
//  Created by Liyanwei on 2018/8/21.
//  Copyright © 2018年 Liyanwei. All rights reserved.
//

#import "GPCategoryIndicatorComponentView.h"

@interface GPCategoryIndicatorBallView : GPCategoryIndicatorComponentView

@property (nonatomic, assign) CGSize ballViewSize;  //默认：CGSizeMake(15, 15)

@property (nonatomic, assign) CGFloat ballScrollOffsetX;    //小红点的偏移量 默认：20

@property (nonatomic, strong) UIColor *ballViewColor;   //默认为[UIColor redColor]

@end
