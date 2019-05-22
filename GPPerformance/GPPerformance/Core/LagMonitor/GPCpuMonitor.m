//
//  GPCpuMonitor.m
//  GPPerformance
//
//  Created by Liyanwei on 2019/5/13.
//  Copyright © 2019 Liyanwei. All rights reserved.
//

#import "GPCpuMonitor.h"
#import "GPCallStack.h"
#import "GPCallStackModel.h"
#import "GPLagDB.h"

#import <coobjc/coobjc.h>
#import <fmdb/FMDB.h>
#import <libextobjc/EXTScope.h>


@interface GPCpuMonitor ()
// 监控数据写入队列
@property (nonatomic, strong) dispatch_queue_t monitorDataQueue;
// 监控数据Actor
@property (nonatomic, strong) COActor * monitorModelActor;
@end

@implementation GPCpuMonitor

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
        _monitorDataQueue = dispatch_queue_create("com.gp.performance.cpu.queue", NULL);
        
        //
        // 数据写入 协程
        //
        _monitorModelActor = co_actor_onqueue(_monitorDataQueue, ^(COActorChan *channel) {
            id cls = nil;
            
            for (COActorMessage *message in channel) {
                cls = [message type];
                
                if ([cls isKindOfClass:[NSNumber class]]) {
                    id tmp = await([self writeToDB:cls]);
                    message.complete(tmp);
                } else {
                    message.complete(nil);
                }
                
            }
        });
    }
    
    return self;
}

/**
 更新CPU 数据
 */

- (void)updateData
{
    thread_act_array_t threads;
    mach_msg_type_number_t threadCount = 0;
    const task_t thisTask = mach_task_self();
    kern_return_t kr = task_threads(thisTask, &threads, &threadCount);
    if (kr != KERN_SUCCESS) {
        return;
    }
    
    for (int i = 0; i < threadCount; i++) {
        thread_info_data_t threadInfo;
        thread_basic_info_t threadBaseInfo;
        mach_msg_type_number_t threadInfoCount = THREAD_INFO_MAX;
        if (thread_info((thread_act_t)threads[i], THREAD_BASIC_INFO, (thread_info_t)threadInfo, &threadInfoCount) == KERN_SUCCESS) {
            threadBaseInfo = (thread_basic_info_t)threadInfo;
            if (!(threadBaseInfo->flags & TH_FLAGS_IDLE)) {
                integer_t cpuUsage = threadBaseInfo->cpu_usage / 10;
                if (cpuUsage > CPUMONITORRATE) {
                    
                    // 触发获取主线程堆栈
                    co_launch(^{
                        id tmp = await([self.monitorModelActor sendMessage:@(threads[i])]);
                        if (!co_getError()) {
                            //NSLog(@"cpu monitor = %@" , tmp);
                        }
                    });
                    
                }
            }
        }
    }
}

uint64_t memoryFootprint()
{
    task_vm_info_data_t vmInfo;
    mach_msg_type_number_t count = TASK_VM_INFO_COUNT;
    kern_return_t result = task_info(mach_task_self(), TASK_VM_INFO, (task_info_t) &vmInfo, &count);
    if (result != KERN_SUCCESS) {return 0;}
    return vmInfo.phys_footprint;
}

- (COPromise*) writeToDB:(NSNumber*) thread CO_ASYNC
{
    SURE_ASYNC;
    
    //cup 消耗大于设置值时打印和记录堆栈
    thread_t t = (thread_t)[thread integerValue];
    NSString *callTree = gpStackOfThread(t);
    GPCallStackModel *model = [[GPCallStackModel alloc] init];
    model.stackStr = callTree;
    model.isStuck = NO;
    
    //记录数据库中
    return [[GPLagDB shareInstance] increaseWithStackModel:model];
}
@end
