//
//  VZInspectorOverlay.h
//  VZInspector
//
//  Created by Tao Xu on 14-9-23.
//  Copyright (c) 2014年 VizLab. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VZInspectorOverlay : UIWindow

+(instancetype)sharedInstance;
+(void)show;
+(void)hide;

@end
