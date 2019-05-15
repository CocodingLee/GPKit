//
//  GPPagerView.m
//  GPUIKit
//
//  Created by Liyanwei on 2018/8/27.
//  Copyright © 2018年 Liyanwei. All rights reserved.
//

#import "GPPagerView.h"
#import <FrameAccessor/FrameAccessor.h>
#import <libextobjc/EXTScope.h>

#ifdef DEBUG
#define _DEBUG_SCROLL_LOG_ 0
#endif

#if _DEBUG_SCROLL_LOG_
static CGFloat gsLastContentOffsetY = 0.0;
#endif

@interface GPPagerView () <UITableViewDataSource, UITableViewDelegate, GPPagerListContainerViewDelegate>
@property (nonatomic, strong) GPCategoryTitleView *pinCategoryView;
@property (nonatomic, strong) GPPageListMainTableView *mainTableView;
@property (nonatomic, strong) GPPagerListContainerView *listContainerView;
@property (nonatomic, strong) UIScrollView *currentScrollingListView;
@property (nonatomic, strong) id<GPPagerViewListViewDelegate> currentListView;


// 记录一下 父子view的位置
@property (nonatomic, strong) NSNumber* mainViewOffsetY;
@property (nonatomic, strong) NSNumber* listViewOffsetY;

@property (nonatomic, strong) NSNumber* offsetMainInitY;
@property (nonatomic, strong) NSNumber* offsetListInitY;
@end

@implementation GPPagerView

- (instancetype)initWithDelegate:(id<GPPagerViewDelegate>)delegate {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        _delegate = delegate;
        [self initializeViews];
    }
    return self;
}

- (void)initializeViews
{
    _mainTableView = [[GPPageListMainTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.mainTableView.showsVerticalScrollIndicator = NO;
    self.mainTableView.showsHorizontalScrollIndicator = NO;
    self.mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.mainTableView.scrollsToTop = NO;
    self.mainTableView.dataSource = self;
    self.mainTableView.delegate = self;
    self.mainTableView.tableHeaderView = [self.delegate tableHeaderViewInPagerView:self];
    [self.mainTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    if (@available(iOS 11.0, *)) {
        self.mainTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    [self addSubview:self.mainTableView];
    
    _listContainerView = [[GPPagerListContainerView alloc] initWithDelegate:self];
    self.listContainerView.mainTableView = self.mainTableView;
    
    _pinCategoryView = [[GPCategoryTitleView alloc] init];
    _pinCategoryView.contentScrollView = self.listContainerView.collectionView;
    
    [self configListViewDidScrollCallback];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.mainTableView.frame = self.bounds;
    
    // 悬停位置
    CGFloat navHeight = self.categoryTitlesViewOffsetY;
    self.mainTableView.contentInset = UIEdgeInsetsMake(navHeight, 0, 0, 0);
}

- (void)reloadData {
    self.currentListView = nil;
    self.currentScrollingListView = nil;
    [self configListViewDidScrollCallback];
    [self.mainTableView reloadData];
    [self.listContainerView reloadData];
}

- (void) preferredProcessListViewDidScroll:(UIScrollView *)scrollView
{
    UIScrollView* mainView = self.mainTableView;
    UIScrollView* listView = scrollView;
    
    [self handleScrollMainView:mainView andListView:listView];
}

- (void)preferredProcessMainTableViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffsetY <= 0) {
        scrollView.bounces = YES;
    } else {
        scrollView.bounces = NO;
    }
    
    UIScrollView* mainView = scrollView;
    UIScrollView* listView = self.currentScrollingListView;
    [self handleScrollMainView:mainView andListView:listView];
}


- (void) handleScrollMainView:(UIScrollView*) mainView
                  andListView:(UIScrollView*) listView
{
    CGPoint point = [listView.panGestureRecognizer translationInView:self];
    CGFloat topContentY = [self.delegate tableHeaderViewHeightInPagerView:self];
    
    CGFloat mainInitY = [self.offsetMainInitY floatValue];
    CGFloat listInitY = [self.offsetListInitY floatValue];
    
    BOOL mainViewScroll = mainView.isTracking || mainView.isDecelerating;
    BOOL listViewScroll = listView.isTracking || listView.isDecelerating;
    
    if (mainViewScroll || listViewScroll) {
        
        if (point.y >= 0) {
#if _DEBUG_SCROLL_LOG_
            if (fabs(listView.contentOffsetY - gsLastContentOffsetY) > 5000) {
                NSLog(@"scroll view 突变");
            }
            gsLastContentOffsetY = listView.contentOffsetY;
            
            //
            // 向下滚动，优先处理list
            //
            
            NSLog(@"向下滚动 listView.y = %f" , listView.contentOffset.y);
            NSLog(@"向下滚动 mainView.y = %f" , mainView.contentOffset.y);
            
            // 向上滚动
#endif
            
            if (listView.contentOffsetY > 0) {
                // 子视图位置
                self.listViewOffsetY = @(listView.contentOffsetY);
                self.offsetListInitY = @(listView.contentOffsetY);
                
                // 顶部固定
                if (mainView.contentOffsetY >= topContentY) {
                    self.mainViewOffsetY = @(topContentY);
                }
                
                else if (mainView.contentOffsetY < topContentY) {
                    self.mainViewOffsetY = @(mainInitY);
                }
            } else {
                self.listViewOffsetY = @(0);
                
                // 修改初始化位置
                self.offsetListInitY = @(0);
                
                if (mainView.contentOffsetY >= topContentY) {
                    self.mainViewOffsetY = @(topContentY);
                } else {
                    self.mainViewOffsetY = @(mainView.contentOffsetY);
                    self.offsetMainInitY = @(mainView.contentOffsetY);
                }
            }
            
        } else {
            
#if _DEBUG_SCROLL_LOG_
            if (fabs(listView.contentOffsetY - gsLastContentOffsetY) > 5000) {
                NSLog(@"scroll view 突变");
            }
            gsLastContentOffsetY = listView.contentOffsetY;
            
            // 向上滚动
            NSLog(@"向上滚动 listView.y = %f" , listView.contentOffset.y);
            NSLog(@"向上滚动 mainView.y = %f" , mainView.contentOffset.y);
#endif
            
            if (mainView.contentOffsetY >= topContentY) {
                self.mainViewOffsetY = @(topContentY);
                self.listViewOffsetY = @(listView.contentOffsetY);
                
                // 修改初始化位置
                self.offsetMainInitY = @(topContentY);
                self.offsetListInitY = @(listView.contentOffsetY);
            }
            else {
                self.mainViewOffsetY = @(mainView.contentOffsetY);
                self.listViewOffsetY = @(listInitY);
                
                self.offsetMainInitY = @(mainView.contentOffsetY);
            }
            
        } // if (point.y >= 0)
        
        CGFloat listY = [self.listViewOffsetY floatValue];
        CGFloat mainY = [self.mainViewOffsetY floatValue];
        
#if _DEBUG_SCROLL_LOG_
        // 向上滚动
        NSLog(@"listY = %f" , listY);
        NSLog(@"mainY = %f" , mainY);
#endif
        
        mainView.contentOffset = CGPointMake(0, mainY);
        listView.contentOffset = CGPointMake(0, listY);
    } // if (mainViewScroll || listViewScroll)
}

#pragma mark - Private

- (void)configListViewDidScrollCallback {
    NSArray *listViews = [self.delegate listViewsInPagerView:self];
    for (id<GPPagerViewListViewDelegate> listView in listViews) {
        __weak typeof(self)weakSelf = self;
        @weakify(listView);
        [listView listViewDidScrollCallback:^(UIScrollView *scrollView) {
            @strongify(listView);
            weakSelf.currentListView = listView;
            [weakSelf listViewDidScroll:scrollView];
        }];
    }
}

- (void)listViewDidScroll:(UIScrollView *)scrollView {
    self.currentScrollingListView = scrollView;
    
    [self preferredProcessListViewDidScroll:scrollView];
}

#pragma mark - UITableViewDataSource, UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.bounds.size.height - [self.delegate heightForPinSectionHeaderInPagerView:self];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    self.listContainerView.frame = cell.contentView.bounds;
    [cell.contentView addSubview:self.listContainerView];
    [self.listContainerView setNeedsLayout];
    [self.listContainerView layoutIfNeeded];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return [self.delegate heightForPinSectionHeaderInPagerView:self];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [self.delegate viewForPinSectionHeaderInPagerView:self];
    //return self.pinCategoryView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footer = [[UIView alloc] initWithFrame:CGRectZero];
    footer.backgroundColor = [UIColor clearColor];
    return footer;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if ([self.delegate respondsToSelector:@selector(mainTableViewDidScroll:)]) {
        [self.delegate mainTableViewDidScroll:scrollView];
    }
    
    if (scrollView.isTracking) {
        self.listContainerView.collectionView.scrollEnabled = NO;
    }
    
    [self preferredProcessMainTableViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    self.listContainerView.collectionView.scrollEnabled = YES;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    self.listContainerView.collectionView.scrollEnabled = YES;
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    self.listContainerView.collectionView.scrollEnabled = YES;
}

#pragma mark - GPPageListListContainerViewDelegate

- (NSInteger)numberOfRowsInListContainerView:(GPPagerListContainerView *)listContainerView {
    NSArray *listViews = [self.delegate listViewsInPagerView:self];
    return listViews.count;
}

- (UIView *)listContainerView:(GPPagerListContainerView *)listContainerView listViewInRow:(NSInteger)row {
    NSArray *listViews = [self.delegate listViewsInPagerView:self];
    return [listViews[row] listView];
}

- (void)listContainerView:(GPPagerListContainerView *)listContainerView willDisplayCellAtRow:(NSInteger)row {
    NSArray *listViews = [self.delegate listViewsInPagerView:self];
    self.currentScrollingListView = [listViews[row] listScrollView];
}

@end
