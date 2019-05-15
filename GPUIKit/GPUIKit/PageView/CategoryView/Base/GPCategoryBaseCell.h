//
//  GPCategoryBaseCell.h
//  GPUIKit
//
//  Created by Liyanwei on 2018/3/15.
//  Copyright © 2018年 Liyanwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GPCategoryBaseCellModel.h"

@interface GPCategoryBaseCell : UICollectionViewCell

@property (nonatomic, strong, readonly) GPCategoryBaseCellModel *cellModel;

- (void)initializeViews NS_REQUIRES_SUPER;

- (void)reloadData:(GPCategoryBaseCellModel *)cellModel NS_REQUIRES_SUPER;

@end
