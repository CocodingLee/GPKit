//
//  GPPagingListContainerView.h
//  GPUIKit
//
//  Created by Liyanwei on 2018/8/27.
//  Copyright © 2018年 Liyanwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GPPageListMainTableView;
@class GPPageListContainerView;

@protocol GPPageListContainerViewDelegate <NSObject>

- (NSInteger)numberOfRowsInListContainerView:(GPPageListContainerView *)listContainerView;

- (UIView *)listContainerView:(GPPageListContainerView *)listContainerView listViewInRow:(NSInteger)row;

- (void)listContainerView:(GPPageListContainerView *)listContainerView willDisplayCellAtRow:(NSInteger)row;

@end


@interface GPPageListContainerView : UIView

@property (nonatomic, strong, readonly) UICollectionView *collectionView;
@property (nonatomic, weak) id<GPPageListContainerViewDelegate> delegate;
@property (nonatomic, weak) GPPageListMainTableView *mainTableView;

- (instancetype)initWithDelegate:(id<GPPageListContainerViewDelegate>)delegate NS_DESIGNATED_INITIALIZER;

- (instancetype)init NS_UNAVAILABLE;

- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;

- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE;

- (void)reloadData;

@end
