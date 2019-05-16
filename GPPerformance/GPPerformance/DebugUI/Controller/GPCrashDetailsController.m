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
@property (nonatomic , copy) NSString* path;

@property(nonatomic,strong) UITextView* crashLogs;
@property(nonatomic,strong) UILabel* textLabel;
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
        self.path = params[@"p"];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self createNavigationBar];
    [self setupUserViews];
    [self showCrashLog];
    
    self.gp_navigationItem.title = @"Crash详情";
}

- (void) setupUserViews
{
    self.textLabel = [[UILabel alloc]initWithFrame:CGRectMake(40, 0, self.view.width-80, 44)];
    self.textLabel.text = @"CrashLogs";
    self.textLabel.textAlignment = NSTextAlignmentCenter;
    self.textLabel.textColor = [UIColor whiteColor];
    self.textLabel.backgroundColor = [UIColor clearColor];
    self.textLabel.font = [UIFont systemFontOfSize:18.0f];
    [self.view addSubview:self.textLabel];
    
    // Initialization code
    _crashLogs = [[UITextView alloc] initWithFrame:CGRectMake(0, self.gp_navigationBar.height , self.view.width, self.view.height-self.gp_navigationBar.height)];
    _crashLogs.font = [UIFont fontWithName:@"Courier-Bold" size:14];
    _crashLogs.textColor = [UIColor orangeColor];
    _crashLogs.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6f];;
    _crashLogs.indicatorStyle = 0;
    _crashLogs.editable = NO;
    _crashLogs.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    _crashLogs.layer.borderColor = [UIColor colorWithWhite:0.5f alpha:1.0f].CGColor;
    _crashLogs.layer.borderWidth = 2.0f;
    
    [self.view addSubview:_crashLogs];
}

- (void) showCrashLog
{
    NSDictionary* logs = [[GPCrashInspector sharedInstance] crashForKey:self.path];
    
    NSString* header = @"crashes comes from => GPCrashInspector";
    header = [header stringByAppendingString:@"\n--------------------------------------\n"];
    _crashLogs.text = header;
    
    if (logs) {
        
        NSString* date = logs[@"date"];
        if (date.length > 0) {
            _crashLogs.text = [_crashLogs.text stringByAppendingString:[[@"> date :"stringByAppendingString:date] stringByAppendingString:@"\n"]];
        }
        
        NSDictionary* info = logs[@"info"];
        if (info.allKeys.count > 0) {
            //reason
            NSString* reason = info[@"reason"];
            if (reason.length > 0) {
                _crashLogs.text = [[[_crashLogs.text stringByAppendingString:@"> reason: "] stringByAppendingString:reason] stringByAppendingString:@"\n"];
            }
            
            //name
            NSString* name = info[@"name"];
            if (name.length > 0) {
                _crashLogs.text = [[[_crashLogs.text stringByAppendingString:@"> name: "] stringByAppendingString:name] stringByAppendingString:@"\n"];
            }
            
            //call stack
            NSArray* callStack  = info[@"callStack"];
            if (callStack.count > 0) {
                _crashLogs.text = [[[_crashLogs.text stringByAppendingString:@"> callStack: \n"] stringByAppendingString:[NSString stringWithFormat:@"%@",callStack]] stringByAppendingString:@"\n"];
            }
        } // if (info.allKeys.count > 0)
        
    } // if (logs)
}

@end
