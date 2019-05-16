//
//  GPCrashInspector.h
//  GPPerformance
//
//  Created by Liyanwei on 2019/5/15.
//  Copyright © 2019 Liyanwei. All rights reserved.
//

#import <Foundation/Foundation.h>
@class KSCrashInstallation;

@interface GPCrashInspector : NSObject
@property (strong, nonatomic) KSCrashInstallation* crashInstallation;

+ (instancetype)sharedInstance;
- (void)install;

- (NSDictionary* )crashForKey:(NSString* )key;
- (NSArray* )crashPlist;
- (NSArray* )crashLogs;


@end
