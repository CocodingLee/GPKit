//
//  GPCategoryCollectionView.h
//  GPUIKit
//
//  Created by Liyanwei on 2018/3/21.
//  Copyright © 2018年 Liyanwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GPCategoryIndicatorProtocol.h"

@interface GPCategoryCollectionView : UICollectionView

@property (nonatomic, strong) NSArray <UIView<GPCategoryIndicatorProtocol> *> *indicators;

@end
