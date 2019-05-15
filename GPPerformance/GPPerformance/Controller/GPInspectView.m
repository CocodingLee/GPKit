//
//  GPInspectView.m
//  GPPerformance
//
//  Created by Liyanwei on 2019/5/15.
//  Copyright © 2019 Liyanwei. All rights reserved.
//

#import "GPInspectView.h"
#import <FrameAccessor/FrameAccessor.h>

@interface GPInspectView () < UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, copy) void(^scrollCallback)(UIScrollView *scrollView);
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) GPSegInfo* segmentInfo;

@property (nonatomic, weak) UIViewController* vc;
@property (nonatomic, strong) UILabel* textLabel;

@end

@implementation GPInspectView

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
        
        [self addSubview:self.tableView];
        
        UILabel* textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        textLabel.text = segmentInfo.segmentTitle;
        textLabel.font = [UIFont systemFontOfSize:18];
        textLabel.textColor = [UIColor blackColor];
        [textLabel sizeToFit];
        
        [self addSubview:textLabel];
        self.textLabel = textLabel;
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.tableView.frame = self.bounds;
    
    UIEdgeInsets insets = gpSafeArea();
    self.tableView.contentInsetBottom = insets.bottom;
    
    self.textLabel.centerX = self.width/2;
    self.textLabel.centerY = self.height/2;
    
}

- (void)listViewDidScrollCallback:(void (^)(UIScrollView *))callback
{
    self.scrollCallback = callback;
}

#pragma mark - GPPageListViewListDelegate

- (UIScrollView *)listScrollView
{
    return self.tableView;
}

- (void) listViewLoadDataIfNeeded
{
    // 加载数据
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * const kCellIndentifier = @"NGCHomeChannelListCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIndentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellIndentifier];
    }
    
    cell.textLabel.text = @(indexPath.row).stringValue;
    return cell;
}
@end
