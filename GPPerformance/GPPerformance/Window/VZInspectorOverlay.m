//
//  VZInspectorOverlay.m
//  VZInspector
//
//  Created by Tao Xu on 14-9-23.
//  Copyright (c) 2014年 VizLab. All rights reserved.
//

#import "VZInspectorOverlay.h"
#import "VZInspector.h"
#import "VZInspectorResource.h"


@implementation VZInspectorOverlay

+ (instancetype)sharedInstance
{
    static VZInspectorOverlay* instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        int x = [UIScreen mainScreen].bounds.size.width > 320 ? 250 :180 ;
        instance = [[VZInspectorOverlay alloc]initWithFrame:CGRectMake(x, 44, 60, 20)];
    });
    return instance;
    
}

+(void)show
{
    VZInspectorOverlay* o = [self sharedInstance];
    o.tag = 100;
    o.windowLevel = UIWindowLevelStatusBar+1;
    o.hidden = NO;
}

+(void)hide
{
    for (UIWindow* window in [UIApplication sharedApplication].windows) {
        if ([window isKindOfClass:[VZInspectorOverlay class]]) {
            window.hidden = YES;
            break;
        }
    }
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if ( self )
    {
        self.backgroundColor = [UIColor clearColor];

        UIImageView* imgv = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        imgv.contentMode = UIViewContentModeScaleAspectFit;
        imgv.image = [VZInspectorResource eye];
        imgv.userInteractionEnabled = true;
        [imgv addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onSelfClicked:)]];
        [self addSubview:imgv];
        
    }
    return self;
}

- (void)onSelfClicked:(UIButton* )sender
{
    if([VZInspector isShow]) {
        [VZInspector hide];
    } else {
        [VZInspector show];
    }
}

- (void)becomeKeyWindow
{
    //fix keywindow problem:
    //UIActionSheet在close后回重置keywindow，防止自己被设成keywindow
    [[[UIApplication sharedApplication].delegate window] makeKeyWindow];
}


@end
