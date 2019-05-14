//
//  VZInspectorWindow.m
//  GPPerformance
//
//  Created by Liyanwei on 2019/5/14.
//  Copyright © 2019 Liyanwei. All rights reserved.
//

#import "GPInspectorWindow.h"
#import "GPInspectController.h"

@interface GPInspectorWindow()
@property(nonatomic,strong) GPInspectController* debuggerVC;
@end

@implementation GPInspectorWindow

+ (instancetype)sharedInstance
{
    static GPInspectorWindow* instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[GPInspectorWindow alloc]init];
    });
    return instance;
    
}

+ (GPInspectController *)sharedController
{
    return [[self sharedInstance] debuggerVC];
}

- (id)init
{
    CGRect screenBound = [UIScreen mainScreen].bounds;
    self = [super initWithFrame:screenBound];
    
    if (self) {
        self.backgroundColor = HEXCOLORA(0x0, 0.6);
        self.windowLevel = UIWindowLevelStatusBar + 200;
    }
    
    return self;
}

@end
