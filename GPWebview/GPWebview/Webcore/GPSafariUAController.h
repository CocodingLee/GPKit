//
//  GPSafariUAController.h
//  GPWebview
//
//  Created by Liyanwei on 2019/5/20.
//  Copyright © 2019 Liyanwei. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol GPSafariUAControllerDelegate
- (void)didReceivedSafariUA:(NSString *)uaString;
@end

@interface GPSafariUAController : NSObject

@property (nonatomic, weak) id <GPSafariUAControllerDelegate> delegate;
// 已获取到的SafariUA
@property (atomic, strong) NSString * safariUAString;
+ (instancetype)sharedInstance;
@end

NS_ASSUME_NONNULL_END
