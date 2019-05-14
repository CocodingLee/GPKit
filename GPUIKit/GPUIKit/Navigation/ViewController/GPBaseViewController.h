//
//  NGCBaseViewController.h
//  NineGameCommunity
//
//  Created by Singro on 2019/1/5.
//  Copyright © 2019 Aligames. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GPBaseViewController : UIViewController
- (instancetype)initWithParams:(NSDictionary *)params;
- (UIViewController*)topViewController;
@end

NS_ASSUME_NONNULL_END
