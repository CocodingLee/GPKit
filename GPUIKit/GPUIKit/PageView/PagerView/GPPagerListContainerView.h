//
//  GPPagerListContainerView.h
//  GPUIKit
//
//  Created by Liyanwei on 2018/8/27.
//  Copyright © 2018年 Liyanwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GPPageListMainTableView;
@class GPPagerListContainerView;
@class GPPagerListContainerCollectionView;

@protocol GPPagerListContainerCollectionViewGestureDelegate <NSObject>
- (BOOL)pagerListContainerCollectionViewGestureRecognizerShouldBegin:(GPPagerListContainerCollectionView *)collectionView gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer;
@end

@interface GPPagerListContainerCollectionView: UICollectionView<UIGestureRecognizerDelegate>
@property (nonatomic, assign) BOOL isNestEnabled;
@property (nonatomic, weak) id<GPPagerListContainerCollectionViewGestureDelegate> gestureDelegate;
@end

@protocol GPPagerListContainerViewDelegate <NSObject>

- (NSInteger)numberOfRowsInListContainerView:(GPPagerListContainerView *)listContainerView;

- (UIView *)listContainerView:(GPPagerListContainerView *)listContainerView listViewInRow:(NSInteger)row;

- (void)listContainerView:(GPPagerListContainerView *)listContainerView willDisplayCellAtRow:(NSInteger)row;

@end


@interface GPPagerListContainerView : UIView

@property (nonatomic, strong, readonly) GPPagerListContainerCollectionView *collectionView;
@property (nonatomic, weak) id<GPPagerListContainerViewDelegate> delegate;
@property (nonatomic, weak) GPPageListMainTableView *mainTableView;

- (instancetype)initWithDelegate:(id<GPPagerListContainerViewDelegate>)delegate NS_DESIGNATED_INITIALIZER;

- (instancetype)init NS_UNAVAILABLE;

- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;

- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE;

- (void)reloadData;

@end


