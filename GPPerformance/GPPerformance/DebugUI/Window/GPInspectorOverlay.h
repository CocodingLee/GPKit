//
//  GPInspectorOverlay.h
//  GPInspector
//
//  Created by Liyanwei on 2019/5/13.
//  Copyright © 2019 Liyanwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GPInspectorOverlay : UIWindow

+(instancetype)sharedInstance;
+(void)show;
+(void)hide;

@end
