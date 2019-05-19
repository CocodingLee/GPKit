//
//  GPExceptionView.m
//  GPPerformance
//
//  Created by Liyanwei on 2019/5/19.
//  Copyright © 2019 Liyanwei. All rights reserved.
//

#import "GPExceptionView.h"

#import "GPLagDB.h"
#import "GPOCExceptionModel.h"
#import "GPFrameLossCell.h"

#import <GPFoundation/GPFoundation.h>
#import <FrameAccessor/FrameAccessor.h>
#import <MJRefresh/MJRefresh.h>
#import <coobjc/coobjc.h>

@interface GPExceptionView () < UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, copy) void(^scrollCallback)(UIScrollView *scrollView);
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) GPSegInfo* segmentInfo;

@property (nonatomic, weak) UIViewController* vc;

// 业务数据
@property (nonatomic, assign) NSUInteger page;
@property (nonatomic, strong) NSMutableArray *exceptionData;
@end

@implementation GPExceptionView

- (instancetype)initWithSegmentInfo:(GPSegInfo *)segmentInfo
                     viewController:(UIViewController*)viewController
{
    self = [super init];
    if (self) {
        self.segmentInfo = segmentInfo;
        self.vc = viewController;
        
        // 从第0页开始查看卡顿数据
        self.page = 0;
        self.exceptionData = @[].mutableCopy;
        
        UITableView *tableView = [[GPBaseTableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.separatorInset = UIEdgeInsetsMake(0, 16, 0, 0);
        tableView.separatorColor = HEXCOLORA(0xE7EAF2, 1);
        tableView.tableFooterView = [UIView new];
        tableView.tableHeaderView = [UIView new];
        tableView.backgroundColor = [UIColor clearColor];
        
        [tableView bindEmptyView];
        
        // 刷新
        tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self
                                                                   refreshingAction:@selector(listViewLoadDataIfNeeded)];
        
        [self addSubview:tableView];
        self.tableView = tableView;
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.tableView.frame = self.bounds;
    
    UIEdgeInsets insets = gpSafeArea();
    self.tableView.contentInsetBottom = insets.bottom;
}

- (void)listViewDidScrollCallback:(void (^)(UIScrollView *))callback
{
    self.scrollCallback = callback;
}

- (void) scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.scrollCallback) {
        self.scrollCallback(scrollView);
    }
}

#pragma mark - GPPageListViewListDelegate

- (UIScrollView *)listScrollView
{
    return self.tableView;
}

- (void) listViewLoadDataIfNeeded
{
    // 加载数据
    co_launch(^{
        NSMutableArray* frameData = await([[GPLagDB shareInstance] selectOCExceptionWithPage:self.page]);
        
        NSError* err = co_getError();
        if (!err && frameData.count > 0) {
            // 显示数据
            [self.exceptionData addObjectsFromArray:frameData];
            [self.tableView reloadData];
            
            // 加载下一页
            ++self.page;
            
            [self.tableView loadingSuccess];
        } else {
            if (frameData.count <= 0 && !err) {
                [self.tableView loadingWithNoContent];
            } else {
                [self.tableView loadingWithNetError:err];
            }
        }
    });
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return self.exceptionData.count;
}

- (CGFloat)     tableView:(UITableView *)tableView
  heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* kFlag = @"GPExceptionCell";
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:kFlag];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:kFlag];
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.textColor = [UIColor orangeColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    GPOCExceptionModel* item = self.exceptionData[indexPath.row];
    NSDate* d = [NSDate dateWithTimeIntervalSinceReferenceDate:item.dateInterval];
    cell.textLabel.text = [NSTimer date2String:d];
    cell.detailTextLabel.text = @(item.exceptionType).stringValue;
    cell.tag = indexPath.row;
    
    return cell;
}
@end
