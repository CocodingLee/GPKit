//
//  VZInspectorWindow.m
//  GPPerformance
//
//  Created by Liyanwei on 2019/5/14.
//  Copyright © 2019 Liyanwei. All rights reserved.
//

#import "GPInspectorWindow.h"
#import "GPInspectController.h"

@interface GPInspectorWindow()
@property(nonatomic,strong) GPInspectController* debuggerVC;
@end

@implementation GPInspectorWindow

+ (instancetype)sharedInstance
{
    static GPInspectorWindow* instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[GPInspectorWindow alloc]init];
    });
    return instance;
    
}

+ (GPInspectController *)sharedController
{
    return [[self sharedInstance] debuggerVC];
}

- (id)init
{
    CGRect screenBound = [UIScreen mainScreen].bounds;
    self = [super initWithFrame:screenBound];
    if (self)
    {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6f];
        self.hidden = YES;
        self.windowLevel = UIWindowLevelStatusBar + 200;
        self.userInteractionEnabled = NO;
        
        self.debuggerVC = [GPInspectController new];
        self.rootViewController = self.debuggerVC;
        [self addSubview:self.debuggerVC.view];
        
    }
    return self;
}

- (void)setHidden:(BOOL)hidden
{
    [super setHidden:hidden];
    
    if ( self.hidden )
    {
        [self.debuggerVC stop];
    }
    else
    {
        [self.debuggerVC start];
    }
}

- (UIView* )hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    CGPoint pt = [self convertPoint:point toView:self.debuggerVC.view];
    
    if (self.debuggerVC.presentedViewController) {
        for (long i = self.subviews.count - 1; i >= 0; i --) {
            UIView *subview = self.subviews[i];
            CGPoint convertedPoint = [subview convertPoint:point fromView:self];
            UIView *hited = [subview hitTest:convertedPoint withEvent:event];
            if (hited) {
                return hited;
            }
        }
    }
    
    if ([self.debuggerVC canTouchPassThrough:pt]) {
        return [super hitTest:point withEvent:event];
    } else {
        return [self.debuggerVC.view hitTest:point withEvent:event];
    }
}


@end
