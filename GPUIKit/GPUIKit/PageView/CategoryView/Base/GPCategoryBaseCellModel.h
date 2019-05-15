//
//  GPCategoryBaseCellModel.h
//  GPUIKit
//
//  Created by Liyanwei on 2018/3/15.
//  Copyright © 2018年 Liyanwei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface GPCategoryBaseCellModel : NSObject

@property (nonatomic, assign) NSUInteger index;

@property (nonatomic, assign) BOOL selected;

@property (nonatomic, assign) CGFloat cellWidth;

@property (nonatomic, assign) CGFloat cellSpacing;

@property (nonatomic, assign) BOOL cellWidthZoomEnabled;

@property (nonatomic, assign) CGFloat cellWidthZoomScale;

@end
