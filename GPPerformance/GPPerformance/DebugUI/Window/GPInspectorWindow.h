//
//  GPInspectorWindow.h
//  GPPerformance
//
//  Created by Liyanwei on 2019/5/14.
//  Copyright © 2019 Liyanwei. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class GPInspectController;

@interface GPInspectorWindow : UIWindow
+(instancetype)sharedInstance;
+(GPInspectController *)sharedController;
@end

NS_ASSUME_NONNULL_END
