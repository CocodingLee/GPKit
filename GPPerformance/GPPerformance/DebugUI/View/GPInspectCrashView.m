//
//  GPInspectCrashView.m
//  GPPerformance
//
//  Created by Liyanwei on 2019/5/16.
//  Copyright © 2019 Liyanwei. All rights reserved.
//

#import "GPInspectCrashView.h"
#import "GPLagDB.h"
#import "GPCrashInspector.h"
#import "GPFrameLossCell.h"
#import "GPDebugRouteDomain.h"

#import <FrameAccessor/FrameAccessor.h>
#import <MJRefresh/MJRefresh.h>
#import <GPRoute/GPRoute.h>

@interface GPInspectCrashView () < UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, copy) void(^scrollCallback)(UIScrollView *scrollView);
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) GPSegInfo* segmentInfo;
@property (nonatomic, weak) UIViewController* vc;

// 业务数据
@property(nonatomic,strong)NSArray* crashData;
@end

@implementation GPInspectCrashView

- (instancetype)initWithSegmentInfo:(GPSegInfo *)segmentInfo
                     viewController:(UIViewController*)viewController
{
    self = [super init];
    if (self) {
        self.segmentInfo = segmentInfo;
        self.vc = viewController;
        
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
    // 崩溃日志
    self.crashData = [GPCrashInspector sharedInstance].crashPlist;
    if (self.crashData.count > 0) {
        [self.tableView loadingSuccess];
    } else {
        [self.tableView loadingWithNoContent];
    }
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return self.crashData.count;
}

- (CGFloat)     tableView:(UITableView *)tableView
  heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* sandCellId = @"crashIdentifier";
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:sandCellId];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:sandCellId];
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.textColor = [UIColor orangeColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.textLabel.text = self.crashData[indexPath.row];
    cell.tag = indexPath.row;
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    if (indexPath.row < self.crashData.count) {
        NSString* path = self.crashData[indexPath.row];
        [[GPRouteManager sharedInstance] openDomain:kRouteCrashDomain
                                               path:kRouteCrashPath
                                             params:@{@"p":path}
                                         completion:^(NSDictionary * _Nonnull params, NSError * _Nonnull error) {
                                             id vc = params[GPRouteTargetKey];
                                             if ([vc isKindOfClass:UIViewController.class] && !error) {
                                                 [self.vc.navigationController pushViewController:vc animated:YES];
                                             }
                                         }];
    }
}
@end
