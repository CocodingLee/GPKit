//
//  GPCallTraceTimeCostModel.m
//  GPPerformance
//
//  Created by Liyanwei on 2019/5/13.
//  Copyright © 2019 Liyanwei. All rights reserved.
//

#import "GPCallTraceTimeCostModel.h"

@implementation GPCallTraceTimeCostModel

- (NSString *)des
{
    NSMutableString *str = [NSMutableString new];
    [str appendFormat:@"%2d| ",(int)_callDepth];
    [str appendFormat:@"%6.2f|",_timeCost * 1000.0];
    for (NSUInteger i = 0; i < _callDepth; i++) {
        [str appendString:@"  "];
    }

    [str appendFormat:@"%s[%@ %@]", (_isClassMethod ? "+" : "-"), _className, _methodName];
    return str;
}

@end
