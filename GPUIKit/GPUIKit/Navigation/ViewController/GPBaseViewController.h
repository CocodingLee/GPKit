//
//  NGCBaseViewController.h
//  NineGameCommunity
//
//  Created by Liyanwei on 2019/5/5.
//  Copyright © 2019 Liyanwei. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GPBaseViewController : UIViewController
- (instancetype)initWithParams:(NSDictionary *)params;
- (UIViewController*)topViewController;
@end

NS_ASSUME_NONNULL_END
