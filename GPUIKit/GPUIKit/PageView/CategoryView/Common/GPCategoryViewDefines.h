//
//  GPCategoryViewDefines.h
//  GPCategoryView
//
//  Created by Liyanwei on 2018/8/17.
//  Copyright © 2018年 Liyanwei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

static const CGFloat GPCategoryViewAutomaticDimension = -1;

typedef NS_ENUM(NSUInteger, GPCategoryComponentPosition) {
    GPCategoryComponentPosition_Bottom,
    GPCategoryComponentPosition_Top,
};

// cell被选中的类型
typedef NS_ENUM(NSUInteger, GPCategoryCellSelectedType) {
    GPCategoryCellSelectedTypeUnknown,          //未知，不是选中（cellForRow方法里面、两个cell过渡时）
    GPCategoryCellSelectedTypeClick,            //点击选中
    GPCategoryCellSelectedTypeCode,             //调用方法`- (void)selectItemAtIndex:(NSInteger)index`选中
    GPCategoryCellSelectedTypeScroll            //通过滚动到某个cell选中
};

