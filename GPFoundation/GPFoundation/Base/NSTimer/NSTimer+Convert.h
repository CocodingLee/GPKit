//
//  NSTimer+Convert.h
//  GPFoundation
//
//  Created by Liyanwei on 2019/5/19.
//  Copyright © 2019 Liyanwei. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSTimer (Convert)
+ (NSDate *) string2Date:(NSString *)dateStr;
+ (NSString*) date2String:(NSDate*) date;
+ (NSString*) timeInterval2String:(NSTimeInterval) interval;
@end

NS_ASSUME_NONNULL_END
