//
//  GPRouteRegTree.h
//  GPRoute
//
//  Created by Liyanwei on 2019/5/14.
//  Copyright © 2019 Liyanwei. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol GPRouteRegTreeDelegate;

@interface GPRouteRegTree : NSObject
@property (nonatomic, strong) GPRouteRegTree *fater;
@property (nonatomic, strong) NSDictionary<NSString *, GPRouteRegTree *> *children;
@property (nonatomic, strong) NSArray<id<GPRouteRegTreeDelegate>> *regs;
@end

NS_ASSUME_NONNULL_END
