//
//  GPInspectorResource.h
//  VZInspector
//
//  Created by Liyanwei on 2019/5/13.
//  Copyright © 2019 Liyanwei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define VZ_IMAGE(BYTE_ARRAY)                [GPInspectorResource imageWithBytes:BYTE_ARRAY length:sizeof(BYTE_ARRAY)]
#define VZ_IMAGE_SCALE(BYTE_ARRAY, SCALE)   [GPInspectorResource imageWithBytes:BYTE_ARRAY length:sizeof(BYTE_ARRAY) scale:SCALE]

@interface GPInspectorResource : NSObject

+ (UIImage *)imageWithBytes:(const uint8_t *)bytes length:(size_t)length;
+ (UIImage *)imageWithBytes:(const uint8_t *)bytes length:(size_t)length scale:(CGFloat)scale;

+ (UIImage *)logo;

+ (UIImage *)eye;

+ (UIImage *)grid;

+ (UIImage *)sandbox;

+ (UIImage *)network_logs;

+ (UIImage *)crash;

+ (UIImage *)memoryWarning;

+ (UIImage *)border;

+ (UIImage *)viewClass;

+ (UIImage *)image;

+ (UIImage *)location;

+ (UIImage *)frameRate;

+ (UIImage *)behaviorLog;

+ (UIImage *)asyncIcon;

+ (UIImage *)colorPickerIcon;

+ (UIImage *)tipIcon;

+ (UIImage *)schemeManagerIcon;

+ (UIImage *)scanIcon;

+ (UIImage *)pluginIcon;

+ (UIImage *)searchBarIcon;


@end
