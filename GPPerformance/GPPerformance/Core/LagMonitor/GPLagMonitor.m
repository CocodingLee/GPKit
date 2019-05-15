//
//  GPLagMonitor.m
//  GPPerformance
//
//  Created by Liyanwei on 2019/5/13.
//  Copyright © 2019 Liyanwei. All rights reserved.
//

#import "GPLagMonitor.h"
// 记录调用栈
#import "GPCallStack.h"
// 堆栈模型
#import "GPCallStackModel.h"
// CPU
#import "GPCpuMonitor.h"
// DB
#import "GPLagDB.h"

@interface GPLagMonitor ()
{
@private
    // 超时次数
    int timeoutCount;
    // run loop 观察者
    CFRunLoopObserverRef runLoopObserver;
    
@public
    dispatch_semaphore_t dispatchSemaphore;
    CFRunLoopActivity runLoopActivity;
}

// 定时器
@property (nonatomic, strong) NSTimer *cpuMonitorTimer;
// 监控数据写入队列
@property (nonatomic, strong) dispatch_queue_t monitorDataQueue;
// 监控数据Actor
@property (nonatomic, strong) COActor * monitorModelActor;
@end

@implementation GPLagMonitor

/**
 当前单例
 
 @return GPLagMonitor
 */
+ (instancetype)shareInstance
{
    static id instance = nil;
    static dispatch_once_t dispatchOnce;
    dispatch_once(&dispatchOnce, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (instancetype) init
{
    self = [super init];
    if (self) {
        _monitorDataQueue = dispatch_queue_create("com.gp.performance.model.queue", NULL);
        
        //
        // 数据写入 协程
        //
        _monitorModelActor = co_actor_onqueue(_monitorDataQueue, ^(COActorChan *channel) {
            id cls = nil;
            
            for (COActorMessage *message in channel) {
                cls = [message type];
                
                // DSReq 请求解析
                if ([cls isKindOfClass:[NSString class]]) {
                    id tmp = await([self writeToDB]);
                    message.complete(tmp);
                } else{
                    message.complete(nil);
                }
            }
        });
    }
    
    return self;
}

- (COPromise*) writeToDB CO_ASYNC
{
    SURE_ASYNC;
    
    NSString *stackStr = [GPCallStack callStackWithType:GPCallStackTypeMain];
    GPCallStackModel *model = [[GPCallStackModel alloc] init];
    model.stackStr = stackStr;
    model.isStuck = YES;
    return [[GPLagDB shareInstance] increaseWithStackModel:model];
}

/**
 开始监视卡顿
 */
- (void)beginMonitor
{
    self.isMonitoring = YES;
    //监测 CPU 消耗
    self.cpuMonitorTimer = [NSTimer scheduledTimerWithTimeInterval:3
                                                            target:self
                                                          selector:@selector(updateCPUInfo)
                                                          userInfo:nil
                                                           repeats:YES];
    //监测卡顿
    if (runLoopObserver) {
        return;
    }
    
    dispatchSemaphore = dispatch_semaphore_create(0); //Dispatch Semaphore保证同步
    //创建一个观察者
    CFRunLoopObserverContext context = {0,(__bridge void*)self,NULL,NULL};
    runLoopObserver = CFRunLoopObserverCreate(kCFAllocatorDefault,
                                              kCFRunLoopAllActivities,
                                              YES,
                                              0,
                                              &runLoopObserverCallBack,
                                              &context);
    //将观察者添加到主线程runloop的common模式下的观察中
    CFRunLoopAddObserver(CFRunLoopGetMain(), runLoopObserver, kCFRunLoopCommonModes);
    
    //创建子线程监控
    @weakify(self);
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        //子线程开启一个持续的loop用来进行监控
        @strongify(self);
        
        while (YES) {
            long semaphoreWait = dispatch_semaphore_wait(self->dispatchSemaphore
                                                         , dispatch_time(DISPATCH_TIME_NOW, STUCKMONITORRATE * NSEC_PER_MSEC));
            if (semaphoreWait != 0) {
                if (!self->runLoopObserver) {
                    self->timeoutCount = 0;
                    self->dispatchSemaphore = 0;
                    self->runLoopActivity = 0;
                    
                    return;
                }
                
                //
                // 两个runloop的状态，BeforeSources和AfterWaiting这两个状态区间时间能够检测到是否卡顿
                // https://www.jianshu.com/p/6c10ca55d343
                //
                if (self->runLoopActivity == kCFRunLoopBeforeSources
                    || self->runLoopActivity == kCFRunLoopAfterWaiting) {
                    //出现三次出结果
                    if (++ self->timeoutCount < 3) {
                        continue;
                    }
                    
                    // 触发获取主线程堆栈
                    co_launch_now(^{
                        id tmp = await([self.monitorModelActor sendMessage:@""]);
                        if (!co_getError()) {
                            NSLog(@"%@" , tmp);
                        }
                    });
                    
                    
                } //end activity
            }// end semaphore wait
            
            self->timeoutCount = 0;
        }// end while
    });
}

/**
 停止监视卡顿
 */
- (void)endMonitor
{
    self.isMonitoring = NO;
    [self.cpuMonitorTimer invalidate];
    if (!self->runLoopObserver) {
        return;
    }
    
    CFRunLoopRemoveObserver(CFRunLoopGetMain(), self->runLoopObserver, kCFRunLoopCommonModes);
    CFRelease(self->runLoopObserver);
    self->runLoopObserver = NULL;
}

- (void)updateCPUInfo
{
    [GPCpuMonitor updateData];
}

static void runLoopObserverCallBack(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info)
{
    GPLagMonitor *lagMonitor = (__bridge GPLagMonitor*)info;
    lagMonitor->runLoopActivity = activity;
    
    dispatch_semaphore_t semaphore = lagMonitor->dispatchSemaphore;
    dispatch_semaphore_signal(semaphore);
}

@end
