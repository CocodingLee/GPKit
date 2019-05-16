//
//  GPCrashDetailsController.m
//  GPPerformance
//
//  Created by Liyanwei on 2019/5/16.
//  Copyright © 2019 Liyanwei. All rights reserved.
//

#import "GPCrashDetailsController.h"
#import "GPDebugRouteDomain.h"
#import "GPCrashInspector.h"

#import <FrameAccessor/FrameAccessor.h>

@interface GPCrashDetailsController ()
@property (nonatomic , copy) NSString* crashLogDetail;
@property(nonatomic,strong) UITextView* crashLogsView;
@end

@implementation GPCrashDetailsController

/**
 业务域
 
 @return 当前名称
 */
+ (NSString *)supportedDomain
{
    return kRouteCrashDomain;
}

/**
 如果不实现这个方法，则默认添加一个Path为*的插件，
 当某个跳转的path未能命中该domain下的任一个插件时，会寻找*插件
 
 @return 当前支持的路径，业务分支
 */
+ (NSArray *)supportedPath
{
    return @[kRouteCrashPath];
}

/**
 初始化
 
 @param params 参数
 @return 当前实例
 */
- (instancetype)initWithParams:(NSDictionary *)params
{
    self = [super init];
    if (self) {
        self.crashLogDetail = params[@"p"];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self createNavigationBar];
    [self setupUserViews];
    self.gp_navigationItem.title = @"Crash详情";
}

- (void) setupUserViews
{
    _crashLogsView = [[UITextView alloc] initWithFrame:CGRectMake(0, self.gp_navigationBar.height , self.view.width, self.view.height-self.gp_navigationBar.height)];
    _crashLogsView.font = [UIFont fontWithName:@"Courier-Bold" size:14];
    _crashLogsView.textColor = [UIColor orangeColor];
    _crashLogsView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6f];;
    _crashLogsView.indicatorStyle = 0;
    _crashLogsView.editable = NO;
    _crashLogsView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    _crashLogsView.layer.borderColor = [UIColor colorWithWhite:0.5f alpha:1.0f].CGColor;
    _crashLogsView.layer.borderWidth = 2.0f;
    _crashLogsView.text = self.crashLogDetail;
    
    [self.view addSubview:_crashLogsView];
}

@end
