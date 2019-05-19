//
//  GPSegInfo.h
//  GPPerformance
//
//  Created by Liyanwei on 2019/1/24.
//  Copyright © 2019 Aligames. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, GPSegType) {
    GPSegType_None,
    GPSegType_FrameDropping,
    GPSegType_ExecutionTime,
    GPSegType_Exception
};

@interface GPSegInfo : NSObject
// 类型
@property (nonatomic , assign) GPSegType segmentType;
@property (nonatomic , strong) NSString* segmentTitle;
@property (nonatomic , strong) Class cls;
@end

NS_ASSUME_NONNULL_END
