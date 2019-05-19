//
//  NSTimer+Convert.m
//  GPFoundation
//
//  Created by Liyanwei on 2019/5/19.
//  Copyright © 2019 Liyanwei. All rights reserved.
//

#import "NSTimer+Convert.h"

@implementation NSTimer (Convert)

+ (NSDate *) string2Date:(NSString *)dateStr
{
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];
    NSDate *date = [dateFormatter dateFromString:dateStr];
    
    // 直接初始化的时间, 也是当前时间
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSTimeInterval interval = [zone secondsFromGMTForDate:date];
    NSDate *current = [date dateByAddingTimeInterval:interval];
    
    return current;
}

+ (NSString*) date2String:(NSDate*) date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    // NSDate转字符串, 我们需要注意的是因为时区的问题,
    // 会快八个小时, 所以我需要设置成标准时间才行
    [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    NSString *str = [formatter stringFromDate:date];
    return str;
}
@end
