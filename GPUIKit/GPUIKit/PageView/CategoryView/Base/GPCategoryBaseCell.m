//
//  GPCategoryBaseCell.m
//  GPUIKit
//
//  Created by Liyanwei on 2018/3/15.
//  Copyright © 2018年 Liyanwei. All rights reserved.
//

#import "GPCategoryBaseCell.h"

@interface GPCategoryBaseCell ()
@property (nonatomic, strong) GPCategoryBaseCellModel *cellModel;
@end

@implementation GPCategoryBaseCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initializeViews];
    }
    return self;
}

- (void)initializeViews {

}

- (void)reloadData:(GPCategoryBaseCellModel *)cellModel {
    self.cellModel = cellModel;
    
}

@end
