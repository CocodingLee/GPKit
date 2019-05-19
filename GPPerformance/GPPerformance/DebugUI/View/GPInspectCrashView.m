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
#import <GPUIKit/GPUIKit.h>
#import <KSCrash/KSCrash.h>
#import <KSCrash/KSCrashInstallation.h>
#import <KSCrash/KSCrashReportFilterAppleFmt.h>

#import <YYModel/YYModel.h>
#import <coobjc/coobjc.h>
#import <fmdb/FMDB.h>
#import <libextobjc/EXTScope.h>

/////////////////////////////////////////////////

@interface GPCrashItem : NSObject
@property (nonatomic , strong) NSString* content;
@property (nonatomic , strong) NSString* id;
@property (nonatomic , strong) NSString* process_name;
@property (nonatomic , strong) NSString* timestamp;
@property (nonatomic , strong) NSString* type;
@property (nonatomic , strong) NSString* version;
@end

@implementation GPCrashItem
@end
/////////////////////////////////////////////////

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
    co_launch(^{
        NSArray* crashLogs = await([self getAllCrashLog]);
        NSError* error = co_getError();
        if (!error) {
            if (crashLogs.count > 0) {
                self.crashData = crashLogs;
                [self.tableView reloadData];
            }
            
            [self.tableView loadingWithNoContent];
        } else {
            [self.tableView loadingWithNetError:error];
        }
    });
    
}

- (COPromise*) getAllCrashLog
{
    return [COPromise promise:^(COPromiseFulfill  _Nonnull fullfill, COPromiseReject  _Nonnull reject) {
        
        KSCrashInstallation* installation = [GPCrashInspector sharedInstance].crashInstallation;
        [installation sendAllReportsWithCompletion:^(NSArray* reports, BOOL completed, NSError* error)
         {
             if (reports.count > 0) {
                 
                 NSArray* tmp = [self convertSystem:reports];
                 fullfill(tmp);
             } else {
                 fullfill(nil);
             }
         }];
    }];
}

- (NSArray*) convertSystem:(NSArray*) jsonArray CO_ASYNC
{
    SURE_ASYNC;
    
    NSMutableArray* sysArray = [[NSMutableArray alloc] init];
    
    for (NSString * json in jsonArray) {
        @autoreleasepool {
            NSDictionary*  parsedJSON = @{};
            NSData* jsonData = [json dataUsingEncoding:NSUTF8StringEncoding];
            if (jsonData) {
                NSError* error = nil;
                parsedJSON = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&error];
                if(error) {
                    continue;
                }
            }
            
            GPCrashItem* item = [[GPCrashItem alloc] init];
            if ([parsedJSON.allKeys containsObject:@"report"]) {
                item = [GPCrashItem yy_modelWithJSON:parsedJSON[@"report"]];
                NSDate* now = [self string2Date:item.timestamp];
                item.timestamp = [self date2String:now];
            }
            
            NSString* content = await([self getCrashDetails:parsedJSON]);
            if (!co_getError()) {
                item.content = content;
                [sysArray addObject:item];
            }
        }
    }
    
    return [sysArray copy];
}

- (COPromise*) getCrashDetails:(NSDictionary*) json
{
    return [COPromise promise:^(COPromiseFulfill  _Nonnull fullfill, COPromiseReject  _Nonnull reject) {
        id filter = [KSCrashReportFilterAppleFmt filterWithReportStyle:KSAppleReportStyleSymbolicatedSideBySide];
        NSArray *reports = @[json];
        [filter filterReports:reports
                 onCompletion:^(NSArray *filteredReports, BOOL completed, NSError *error) {
                     if(error) {
                         reject(error);
                     } else {
                         if(completed) {
                             NSString *contents = [filteredReports objectAtIndex:0];
                             fullfill(contents);
                         }
                     }
                 }];
    }];
    
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
    return 80;
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
    
    GPCrashItem* item = self.crashData[indexPath.row];
    cell.textLabel.text = item.timestamp;
    cell.detailTextLabel.text = item.id;
    cell.tag = indexPath.row;
    
    return cell;
}

- (NSDate *) string2Date:(NSString *)dateStr
{
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];
    NSDate *date = [dateFormatter dateFromString:dateStr];
    
    // 直接初始化的时间, 也是当前时间
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSTimeInterval interval = [zone secondsFromGMTForDate:date];
    NSDate *current = [date dateByAddingTimeInterval:interval];
    
    return current;
}

- (NSString*) date2String:(NSDate*) date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    // NSDate转字符串, 我们需要注意的是因为时区的问题,
    // 会快八个小时, 所以我需要设置成标准时间才行 
    [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    NSString *str = [formatter stringFromDate:date];
    return str;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    if (indexPath.row < self.crashData.count) {
        GPCrashItem* item =  self.crashData[indexPath.row];
        [[GPRouteManager sharedInstance] openDomain:kRouteCrashDomain
                                               path:kRouteCrashPath
                                             params:@{@"p":item.content}
                                         completion:^(NSDictionary * _Nonnull params, NSError * _Nonnull error) {
                                             id vc = params[GPRouteTargetKey];
                                             if ([vc isKindOfClass:UIViewController.class] && !error) {
                                                 [self.vc.navigationController pushViewController:vc animated:YES];
                                             }
                                         }];
    }
}
@end
