//
//  GPInspectController.m
//  GPPerformance
//
//  Created by Liyanwei on 2019/5/14.
//  Copyright © 2019 Liyanwei. All rights reserved.
//

#import "GPInspectController.h"

@interface GPInspectController ()

@end

@implementation GPInspectController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

//
- (void)start
{    
}

- (void)stop
{

}

- (BOOL)canTouchPassThrough:(CGPoint)pt
{
//    int h = self.view.bounds.size.height;
//
//    if ([_currentView isKindOfClass:[VZInspectorView class]]) {
//        return [(VZInspectorView *)_currentView canTouchPassThrough:pt];
//    }
//    else {
//        return pt.y < h-kVZInspectorTabBarHeight;
//    }
    
    return NO;
}
@end
