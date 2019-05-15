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
#import "GPSegInfo.h"

#import <FrameAccessor/FrameAccessor.h>
#import <GPUIKit/GPUIKit.h>

// 圈子类目列表高度
static CGFloat const HOME_CONTENT_SECTION_HEIGHT = 45;

@interface GPInspectController () <GPPageListViewDelegate , UITableViewDataSource, UITableViewDelegate>
@property(nonatomic,strong) UIButton* closeButton;
// 添加视图
@property (nonatomic, strong) GPPageListView *pageListView;
// 数据
@property (nonatomic, strong) NSArray <GPInspectFrameLossView *> *listViewArray;
// 测试数据
@property (nonatomic, strong) NSArray<GPSegInfo*>* segmentHeaderData;
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
    
    GPSegInfo* seg2 = [[GPSegInfo alloc] init];
    seg2.segmentTitle = @"执行时间监控";
    seg2.segmentType = GPSegType_ExecutionTime;
    
    GPSegInfo* seg3 = [[GPSegInfo alloc] init];
    seg3.segmentTitle = @"Crash监控";
    seg3.segmentType = GPSegType_ExecutionTime;
    
    //self.segmentHeaderData = @[seg2, seg1 , seg3];
    self.segmentHeaderData = @[seg2, seg1 , seg3 , seg3 , seg2, seg1 , seg3 , seg3];
    
    NSMutableArray* tmp = [[NSMutableArray alloc] init];
    NSMutableArray* titles = [[NSMutableArray alloc] init];
    for (GPSegInfo* info in self.segmentHeaderData) {
        GPInspectFrameLossView* view = [[GPInspectFrameLossView alloc] initWithSegmentInfo:info viewController:self];
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
    
    // 管理视图
    [self setupSubViews];
    
    // 关闭按钮
    self.closeButton.left = 15;
    UIEdgeInsets safeArea = gpSafeArea();
    self.closeButton.top = safeArea.top;
    [self.view addSubview:self.closeButton];
}


- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    // 重新计算当前视图大小
    UIEdgeInsets insets = gpSafeArea();
    CGFloat height = self.view.height - insets.top - 5;
    CGRect frame = CGRectMake(0, insets.top - 5, self.view.width, height);
    self.pageListView.frame = frame;
}

#pragma mark - NGCPageListViewDelegate
//Tips:实现代理方法
- (NSArray<UIView<GPPageListViewListDelegate> *> *)listViewsInPageListView:(GPPageListView *)pageListView
{
    return self.listViewArray;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.pageListView getListContainerCellHeight];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Tips:最后一个section（即listContainerCell所在的section）配置listContainerCell
    return [self.pageListView configListContainerCellAtIndexPath:indexPath];
}
@end
