//
//  VZInspectorToolItem.h
//  GPPerformance
//
//  Created by Liyanwei on 2019/5/14.
//  Copyright © 2019 Liyanwei. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface VZInspectorToolItem : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) UIImage *icon;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *(^callback)(NSString *status);

+ (instancetype)itemWithName:(NSString *)name icon:(UIImage *)icon callback:(void(^)(void))callback;
+ (instancetype)switchItemWithName:(NSString *)name icon:(UIImage *)icon callback:(BOOL(^)(BOOL on))callback;
+ (instancetype)statusItemWithName:(NSString *)name icon:(UIImage *)icon callback:(NSString *(^)(NSString *status))callback;

- (void)performAction;

@end

NS_ASSUME_NONNULL_END
