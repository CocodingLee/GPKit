//
//  GPNavigationController.h
//  GPUIKit
//
//  Created by Liyanwei on 2019/5/5.
//  Copyright © 2019 Liyanwei. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GPNavigationController : UINavigationController

@property (nonatomic, assign) BOOL enableInnerInactiveGesture;
- (void)resetDelegate;

@end

NS_ASSUME_NONNULL_END
