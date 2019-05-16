//
//  GPCrashDetailsController.m
//  GPPerformance
//
//  Created by Liyanwei on 2019/5/16.
//  Copyright © 2019 Liyanwei. All rights reserved.
//

#import "GPCrashDetailsController.h"
#import "GPDebugRouteDomain.h"

@interface GPCrashDetailsController ()
@property (nonatomic , copy) NSString* path;
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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

@end
