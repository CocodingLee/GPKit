//
//  VZInspectorOverlay.m
//  VZInspector
//
//  Created by Liyanwei on 2019/5/13.
//  Copyright © 2019 Liyanwei. All rights reserved.
//

#import "GPInspectorOverlay.h"
#import "GPInspector.h"
#import "GPInspectorResource.h"
#import <GPUIKit/GPUIKit.h>

@implementation GPInspectorOverlay

+ (instancetype)sharedInstance
{
    static GPInspectorOverlay* instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        int x = [UIScreen mainScreen].bounds.size.width > 320 ? 250 :180 ;
        UIEdgeInsets safeArea = [[UIApplication sharedApplication].keyWindow gp_safeAreaInsets];
        instance = [[GPInspectorOverlay alloc]initWithFrame:CGRectMake(x, safeArea.top, 60, 20)];
    });
    
    return instance;
    
}

+(void)show
{
    GPInspectorOverlay* o = [self sharedInstance];
    o.tag = 100;
    o.windowLevel = UIWindowLevelStatusBar+1;
    o.hidden = NO;
}

+(void)hide
{
    for (UIWindow* window in [UIApplication sharedApplication].windows) {
        if ([window isKindOfClass:[GPInspectorOverlay class]]) {
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
        imgv.image = [GPInspectorResource eye];
        imgv.userInteractionEnabled = true;
        [imgv addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onSelfClicked:)]];
        [self addSubview:imgv];
        
    }
    return self;
}

- (void)onSelfClicked:(UIButton* )sender
{
    if([GPInspector isShow]) {
        [GPInspector hide];
    } else {
        [GPInspector show];
    }
}

- (void)becomeKeyWindow
{
    //fix keywindow problem:
    //UIActionSheet在close后回重置keywindow，防止自己被设成keywindow
    [[[UIApplication sharedApplication].delegate window] makeKeyWindow];
}


@end
