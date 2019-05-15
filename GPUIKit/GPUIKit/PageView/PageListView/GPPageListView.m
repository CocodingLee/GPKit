//
//  GPPageView.m
//
//  Created by Liyanwei on 2018/9/13.
//  Copyright © 2018年 Liyanwei. All rights reserved.
//

#import "GPPageListView.h"
#import "GPPageListContainerView.h"
#import <FrameAccessor/FrameAccessor.h>

#ifdef DEBUG
#define _DEBUG_SCROLL_LOG_ 0
#endif

#if _DEBUG_SCROLL_LOG_
static CGFloat gsLastContentOffsetY = 0.0;
#endif

static NSString *const kListContainerCellIdentifier = @"kGPListContainerCellIdentifier";

///< 将 16bit 的颜色值转为 UIColor，例如 RGB(0xffffff, 0.5) -> 透明度为 0.5 的白色
#define GPRGB(c,a) [UIColor colorWithRed:((c>>16)&0xFF)/256.0  green:((c>>8)&0xFF)/256.0   blue:((c)&0xFF)/256.0 alpha:a]

@interface GPPageListView () <GPPageListContainerViewDelegate, GPCategoryViewDelegate>

@property (nonatomic, strong) GPCategoryTitleView *pinCategoryView;
@property (nonatomic, weak) id<GPPageListViewDelegate> delegate;
@property (nonatomic, strong) GPPageListMainTableView *mainTableView;
@property (nonatomic, strong) GPPageListContainerView *listContainerView;
@property (nonatomic, strong) UIScrollView *currentScrollingListView;
@property (nonatomic, strong) UITableViewCell *listContainerCell;
@property (nonatomic, strong) NSArray *originalListViews;

// 记录一下 父子view的位置
@property (nonatomic, strong) NSNumber* mainViewOffsetY;
@property (nonatomic, strong) NSNumber* listViewOffsetY;

@property (nonatomic, strong) NSNumber* offsetMainInitY;
@property (nonatomic, strong) NSNumber* offsetListInitY;

// 记录上一次移动的方向
@property (nonatomic, assign) CGPoint lastPoint;
@end

@implementation GPPageListView

- (instancetype)initWithDelegate:(id<GPPageListViewDelegate>)delegate {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        _delegate = delegate;
        [self initializeViews];
    }
    return self;
}

- (void)initializeViews {
    _isSaveListViewScrollState = NO;
    _mainViewOffsetY = nil;
    _listViewOffsetY = nil;
    
    self.pinCategoryView = [[GPCategoryTitleView alloc] initWithFrame:CGRectZero];
    self.pinCategoryView.backgroundColor = [UIColor whiteColor];
    self.pinCategoryView.delegate = self;
    
    self.pinCategoryView.titleSelectedColor = GPRGB(0xF97219, 1.0);
    self.pinCategoryView.titleColor = GPRGB(0x333333, 1.0);
    self.pinCategoryView.titleColorGradientEnabled = YES;
    self.pinCategoryView.titleLabelZoomEnabled = NO;
    
    GPCategoryIndicatorLineView *lineView = [[GPCategoryIndicatorLineView alloc] init];
    lineView.indicatorLineViewColor = self.pinCategoryView.titleSelectedColor;
    lineView.indicatorLineWidth = 16;
    lineView.indicatorLineViewHeight = 4;
    self.pinCategoryView.indicators = @[lineView];
    
    _mainTableView = [[GPPageListMainTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.mainTableView.showsVerticalScrollIndicator = NO;
    self.mainTableView.tableFooterView = [UIView new];
    [self.mainTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kListContainerCellIdentifier];
    if (@available(iOS 11.0, *)) {
        self.mainTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    [self addSubview:self.mainTableView];
    
    _listContainerView = [[GPPageListContainerView alloc] initWithDelegate:self];
    self.listContainerView.mainTableView = self.mainTableView;
    
    self.pinCategoryView.contentScrollView = self.listContainerView.collectionView;
    
    [self configListViewDidScrollCallback];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.mainTableView.frame = self.bounds;
}

- (void)reloadData {
    //先移除以前的listView
    for (UIView *listView in self.originalListViews) {
        [listView removeFromSuperview];
    }
    [self configListViewDidScrollCallback];
    [self.mainTableView reloadData];
    [self.listContainerView reloadData];
    [self.pinCategoryView reloadData];
}

- (CGFloat)getListContainerCellHeight {
    return self.bounds.size.height;
}

- (UITableViewCell *)configListContainerCellAtIndexPath:(NSIndexPath *)indexPath {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //触发第一个列表的下拉刷新
        NSArray *listViews = [self.delegate listViewsInPageListView:self];
        if (listViews.count > 0) {
            [listViews[self.pinCategoryView.selectedIndex] listViewLoadDataIfNeeded];
        }
    });
    
    UITableViewCell *cell = [self.mainTableView dequeueReusableCellWithIdentifier:kListContainerCellIdentifier forIndexPath:indexPath];
    self.listContainerCell = cell;
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    
    self.pinCategoryView.frame = CGRectMake(0, 0, cell.contentView.bounds.size.width, self.pinCategoryViewHeight);
    if (self.pinCategoryView.superview == nil) {
        //首次使用pinCategoryView的时候，把pinCategoryView添加到它上面。
        [cell.contentView addSubview:self.pinCategoryView];
    }
    
    self.listContainerView.frame = CGRectMake(0, self.pinCategoryViewHeight, cell.contentView.bounds.size.width, cell.contentView.bounds.size.height - self.pinCategoryViewHeight);
    [cell.contentView addSubview:self.listContainerView];
    
    return cell;
}

- (void)mainTableViewDidScroll:(UIScrollView *)scrollView
{
    //处理当页面滚动在最底部pageView的时候，页面需要立即停住，没有回弹效果。给用户一种切换到pageView浏览模式了
    if (scrollView.contentOffset.y > 10) {
        scrollView.bounces = NO;
    }else {
        scrollView.bounces = YES;
    }
    
    //用户滚动的才处理
    UIScrollView* listView = self.currentScrollingListView;
    UIScrollView* mainView = scrollView;
    // 处理手势滚动
    [self handleScrollMainView:mainView andListView:listView];
    
}


#pragma mark - Private

- (void)configListViewDidScrollCallback {
    NSArray *listViews = [self.delegate listViewsInPageListView:self];
    self.originalListViews = listViews;
    for (UIView <GPPageListViewListDelegate>* listView in listViews) {
        __weak typeof(self)weakSelf = self;
        [listView listViewDidScrollCallback:^(UIScrollView *scrollView) {
            [weakSelf listViewDidScroll:scrollView];
        }];
    }
}

- (void)listViewDidSelectedAtIndex:(NSInteger)index {
    UIView<GPPageListViewListDelegate> *listContainerView = [self.delegate listViewsInPageListView:self][index];
    UIScrollView* listView = [listContainerView listScrollView];
    
    self.mainViewOffsetY = nil;
    self.listViewOffsetY = nil;
    self.lastPoint = CGPointZero;
    [self changeMainViewInitPos:self.mainTableView listView:listView];
    
    //当前列表视图已经滚动显示了内容
    //[self showListContainerCell];
    
}

/**
 获取除去底部listContainerCell之外，上面所有内容的高度
 
 @return 高度
 */
- (CGFloat)getTopContentHeight {
    return self.mainTableView.contentSize.height - self.bounds.size.height;
}

- (void)showListContainerCell {
    
    CGFloat maxY = [self getTopContentHeight];
    if (self.mainTableView.contentOffsetY < maxY) {
        [self.mainTableView setContentOffset:CGPointMake(0, maxY) animated:YES];
    }
}

- (void)listViewDidScroll:(UIScrollView *)scrollView
{
    self.currentScrollingListView = scrollView;
    
    UIScrollView* listView = scrollView;
    UIScrollView* mainView = self.mainTableView;
    
    // 处理手势滚动
    [self handleScrollMainView:mainView andListView:listView];
}

- (void) changeMainViewInitPos:(UIScrollView*) mainView
                      listView:(UIScrollView*) listView

{
    CGPoint point = [listView.panGestureRecognizer translationInView:self];
    
    // 滚动改变了方向
    // 上一次向上滚动，这一次向下滚动
    BOOL isChangeDirectionUp = (self.lastPoint.y >= 0 && point.y < 0);
    
    // 上一次向下滚动，这一次向上滚动
    BOOL isChangeDirectionDown = (self.lastPoint.y < 0 && point.y >= 0);
    
    if (!self.offsetMainInitY || isChangeDirectionDown || isChangeDirectionUp) {
        self.offsetMainInitY = @(mainView.contentOffsetY);
    }
    
    if (!self.offsetListInitY || isChangeDirectionDown || isChangeDirectionUp) {
        self.offsetListInitY = @(listView.contentOffsetY);
    }
    
#if _DEBUG_SCROLL_LOG_
    CGFloat mainInitY = [self.offsetMainInitY floatValue];
    CGFloat listInitY = [self.offsetListInitY floatValue];
    
    NSLog(@"mainInitY=%f" , mainInitY);
    NSLog(@"listInitY=%f" , listInitY);
#endif
}

- (void) handleScrollMainView:(UIScrollView*) mainView
                  andListView:(UIScrollView*) listView
{
    CGPoint point = [listView.panGestureRecognizer translationInView:self];
    CGFloat topContentY = [self getTopContentHeight];
    
    //[self changeMainViewInitPos:mainView listView:listView];
    
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
    
    //
    // 记录上一次的滑动
    //
    self.lastPoint = point;
}

#pragma mark - GPPagingListContainerViewDelegate

- (NSInteger)numberOfRowsInListContainerView:(GPPageListContainerView *)listContainerView {
    NSArray *listViews = [self.delegate listViewsInPageListView:self];
    return listViews.count;
}

- (UIView *)listContainerView:(GPPageListContainerView *)listContainerView listViewInRow:(NSInteger)row {
    NSArray *listViews = [self.delegate listViewsInPageListView:self];
    return listViews[row];
}

- (void)listContainerView:(GPPageListContainerView *)listContainerView willDisplayCellAtRow:(NSInteger)row {
    NSArray *listViews = [self.delegate listViewsInPageListView:self];
    self.currentScrollingListView = [listViews[row] listScrollView];
}

#pragma mark - GPCategoryViewDelegate

- (void)categoryView:(GPCategoryBaseView *)categoryView didSelectedItemAtIndex:(NSInteger)index {
    if ([self.delegate respondsToSelector:@selector(pinCategoryView:didSelectedItemAtIndex:)]) {
        [self.delegate pinCategoryView:categoryView didSelectedItemAtIndex:index];
    }
    NSArray *listViews = [self.delegate listViewsInPageListView:self];
    [listViews[index] listViewLoadDataIfNeeded];
}

- (void)categoryView:(GPCategoryBaseView *)categoryView didClickSelectedItemAtIndex:(NSInteger)index {
    //点击选中，会立马回调该方法。但是page还在左右切换。所以延迟0.25秒等左右切换结束再处理。
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self listViewDidSelectedAtIndex:index];
    });
}

- (void)categoryView:(GPCategoryBaseView *)categoryView didScrollSelectedItemAtIndex:(NSInteger)index {
    [self listViewDidSelectedAtIndex:index];
}

@end
