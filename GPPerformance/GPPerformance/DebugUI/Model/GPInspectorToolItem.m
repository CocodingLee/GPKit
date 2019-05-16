//
//  GPInspectorToolItem.m
//  GPPerformance
//
//  Created by Liyanwei on 2019/5/14.
//  Copyright © 2019 Liyanwei. All rights reserved.
//

#import "GPInspectorToolItem.h"

@implementation GPInspectorToolItem

+ (instancetype)statusItemWithName:(NSString *)name icon:(UIImage *)icon callback:(NSString *(^)(NSString *status))callback {
    GPInspectorToolItem *item = [GPInspectorToolItem new];
    item.name = name;
    item.icon = icon;
    item.callback = callback;
    return item;
}

+ (instancetype)itemWithName:(NSString *)name icon:(UIImage *)icon callback:(void (^)(void))callback {
    return [self statusItemWithName:name icon:icon callback:^NSString *(NSString *status) {
        callback();
        return status;
    }];
}

+ (instancetype)switchItemWithName:(NSString *)name icon:(UIImage *)icon callback:(BOOL (^)(BOOL on))callback {
    return [self statusItemWithName:name icon:icon callback:^(NSString *status) {
        return callback(!!status) ? @"ON" : nil;
    }];
}

- (void)performAction {
    if (self.callback) {
        self.status = self.callback(self.status);
    }
}

@end
