//
//  GPInspectController.m
//  GPPerformance
//
//  Created by Liyanwei on 2019/5/14.
//  Copyright © 2019 Liyanwei. All rights reserved.
//

#import "GPInspectController.h"
#import "GPInspectorResource.h"
#import "GPInspector.h"

#import "GPInspectFrameLossView.h"
#import "GPInspectCrashView.h"
#import "GPInspectStackView.h"
#import "GPExceptionView.h"

#import "GPSegInfo.h"
#import "GPSettingsCell.h"

#import <FrameAccessor/FrameAccessor.h>
#import <GPUIKit/GPUIKit.h>

// 圈子类目列表高度
static CGFloat const HOME_CONTENT_SECTION_HEIGHT = 45;
// 头部高度
static CGFloat const HOME_LAB_HEADER_HEIGHT = 300;

@interface GPInspectController () <GPPageListViewDelegate , UITableViewDataSource, UITableViewDelegate>
@property(nonatomic,strong) UIButton* closeButton;
// 添加视图
@property (nonatomic, strong) GPPageListView *pageListView;
// 数据
@property (nonatomic, strong) NSArray <GPInspectFrameLossView *> *listViewArray;
// 测试数据
@property (nonatomic, strong) NSArray<GPSegInfo*>* segmentHeaderData;
// 记录导航栏原始高度
@property (nonatomic, assign) CGFloat navInitBottom;
@end

@implementation GPInspectController

- (instancetype) init
{
    self = [super init];
    if (self) {
        self.gp_notAutoCreateBackButtonItem = YES;
    }
    
    return self;
}

- (UIButton*) closeButton
{
    if (!_closeButton) {
        UIButton* button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        button.gp_expandInsets = UIEdgeInsetsMake(20, 20, 20, 20);
        
        UIImage* img = [GPInspectorResource logo];
        [button setImage:img forState:UIControlStateNormal];
        [button addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];
        
        _closeButton = button;
    }
    
    return _closeButton;
}

- (void) closeAction
{
    [GPInspector hide];
}

- (void)setupSubViews
{
    //
    // 第一步 ，准备数据
    //
    GPSegInfo* seg1 = [[GPSegInfo alloc] init];
    seg1.segmentTitle = @"卡顿监控";
    seg1.segmentType = GPSegType_FrameDropping;
    seg1.cls = GPInspectFrameLossView.class;
    
    GPSegInfo* seg2 = [[GPSegInfo alloc] init];
    seg2.segmentTitle = @"执行时间监控";
    seg2.segmentType = GPSegType_ExecutionTime;
    seg2.cls = GPInspectStackView.class;
    
    GPSegInfo* seg3 = [[GPSegInfo alloc] init];
    seg3.segmentTitle = @"Crash监控";
    seg3.segmentType = GPSegType_ExecutionTime;
    seg3.cls = GPInspectCrashView.class;
    
    GPSegInfo* seg4 = [[GPSegInfo alloc] init];
    seg4.segmentTitle = @"Exception Hook";
    seg4.segmentType = GPSegType_Exception;
    seg4.cls = GPExceptionView.class;
    
    self.segmentHeaderData = @[seg1 , seg3 , seg4 , seg2];
    
    NSMutableArray* tmp = [[NSMutableArray alloc] init];
    NSMutableArray* titles = [[NSMutableArray alloc] init];
    for (GPSegInfo* info in self.segmentHeaderData) {
        UIView* view = [[info.cls alloc] initWithSegmentInfo:info viewController:self];
        view.backgroundColor = [UIColor whiteColor];
        [tmp addObject:view];
        [titles addObject:info.segmentTitle];
    }
    
    _listViewArray = [tmp copy];
    
    
    //
    // 第二步，创建视图
    //
    self.pageListView = [[GPPageListView alloc] initWithDelegate:self];
    self.pageListView.frame = self.view.bounds;
    
    UITableView* table = self.pageListView.mainTableView;
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    table.dataSource = self;
    table.delegate = self;
    table.bounces = YES;
    [table bindEmptyView];
    
    //
    // 标题
    //
    self.pageListView.pinCategoryViewHeight = HOME_CONTENT_SECTION_HEIGHT;
    
    GPCategoryTitleView* categoryView = self.pageListView.pinCategoryView;
    categoryView.titles = titles;
    categoryView.titleColor = HEXCOLORA(0x333333, 1.0);
    categoryView.titleSelectedColor = HEXCOLORA(0xF97219, 1.0);
    categoryView.titleFont = [UIFont systemFontOfSize:14];
    categoryView.titleSelectedFont = [UIFont boldSystemFontOfSize:14];
    categoryView.titleLabelZoomEnabled = NO;
    
    UIView* sepLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, GP_SCREEN_WIDTH, SINGLE_LINE_WIDTH)];
    sepLine.backgroundColor = HEXCOLORA(0xEBEBEB, 1.0);
    sepLine.bottom = HOME_CONTENT_SECTION_HEIGHT;
    [categoryView addSubview:sepLine];
    
    // 添加到父view
    [self.view addSubview:self.pageListView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self createNavigationBar];
    self.gp_navigationItem.title = @"GP实验室";
    // 管理视图
    [self setupSubViews];
    
    // 关闭按钮
    self.closeButton.left = 15;
    UIEdgeInsets safeArea = gpSafeArea();
    self.closeButton.top = safeArea.top;
    [self.view addSubview:self.closeButton];
    // 原始高度
    self.navInitBottom = self.gp_navigationBar.height;
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    // 重新计算当前视图大小
    UIEdgeInsets insets = gpSafeArea();
    CGFloat height = self.view.height - insets.top;
    CGRect frame = CGRectMake(0, insets.top, self.view.width, height);
    self.pageListView.frame = frame;
}

#pragma mark - NGCPageListViewDelegate

- (NSArray<UIView<GPPageListViewListDelegate> *> *)listViewsInPageListView:(GPPageListView *)pageListView
{
    return self.listViewArray;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return HOME_LAB_HEADER_HEIGHT;
    } else if (indexPath.section == 1) {
        return [self.pageListView getListContainerCellHeight];
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return [self createHomeTopCellWith:tableView];
        }
    }
    
    else if (indexPath.section == 1) {
        //Tips:最后一个section（即listContainerCell所在的section）配置listContainerCell
        return [self.pageListView configListContainerCellAtIndexPath:indexPath];
        
    }
    
    NSAssert(0, @"数据错误");
    return nil;
}

- (UITableViewCell*) createHomeTopCellWith:(UITableView*) tableView
{
    static NSString *kFlag = @"GPSettingsCellId";
    GPSettingsCell *cell = [tableView dequeueReusableCellWithIdentifier:kFlag];
    if (!cell) {
        cell = [[GPSettingsCell alloc] initWithStyle:UITableViewCellStyleDefault
                                          reuseIdentifier:kFlag];
        
        cell.contentView.backgroundColor = HEXCOLORA(0x222222 , 0.2);
    }
    
    [cell update];
    return cell;
}

#pragma mark - scroll view

- (BOOL) scrollViewShouldScrollToTop:(UIScrollView *)scrollView
{
    [self.pageListView.currentScrollingListView setContentOffset:CGPointZero animated:NO];
    [self.pageListView.mainTableView setContentOffset:CGPointZero animated:YES];
    return NO;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.pageListView mainTableViewDidScroll:scrollView];
    
    // 禁止下拉刷新
    if (scrollView.contentOffsetY <= 0) {
        scrollView.contentOffsetY = 0;
    }
    
    
    UIEdgeInsets insets = gpSafeArea();
    CGFloat seg = HOME_LAB_HEADER_HEIGHT + insets.top - self.gp_navigationBar.height;
    
    if (scrollView.contentOffsetY >= seg) {
        self.gp_navigationBar.bottom = HOME_LAB_HEADER_HEIGHT + insets.top - scrollView.contentOffsetY;
        if (self.gp_navigationBar.bottom <= insets.top) {
            self.gp_navigationBar.bottom = 0.0;
        }
    } else {
        
        // 放回到原始高度
        if (self.gp_navigationBar.bottom < self.navInitBottom) {
            self.gp_navigationBar.bottom = self.navInitBottom;
        }
    }
}

@end
