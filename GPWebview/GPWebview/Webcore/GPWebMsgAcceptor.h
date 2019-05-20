//
//  GPWebMsgAcceptor.h
//  GPWebview
//
//  Created by Liyanwei on 2019/5/20.
//  Copyright © 2019 Liyanwei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GPWebMsgDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface GPWebMsgAcceptor : NSObject
+ (id<GPWebMsgDelegate> _Nonnull) acceptMessage:(NSString * _Nullable)message;
+ (id<GPWebMsgDelegate> _Nonnull) acceptMessage:(NSString * _Nullable)message isAync:(BOOL)isAync;
@end

NS_ASSUME_NONNULL_END
