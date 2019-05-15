//
//  UITableView+Private.m
//  GPUIKit
//
//  Created by Liyanwei on 2019/1/31.
//  Copyright © 2019 Aligames. All rights reserved.
//

#import "UITableView+Private.h"
#import <objc/runtime.h>

@implementation UIScrollView (Private)

- (NSError*) gp_error
{
    return objc_getAssociatedObject(self, @selector(gp_error));
}

- (void) setGp_error:(NSError *)ngc_error
{
    objc_setAssociatedObject(self, @selector(gp_error), ngc_error, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (UITableViewErrorType) gp_type
{
    id tmp = objc_getAssociatedObject(self, @selector(gp_type));
    if ([tmp isKindOfClass:[NSNumber class]]) {
        return [tmp longValue];
    }
    
    return UITableViewErrorType_None;
}

- (void) setGp_type:(UITableViewErrorType)ngc_type
{
    objc_setAssociatedObject(self,  @selector(gp_type) , @(ngc_type), OBJC_ASSOCIATION_COPY);
}

- (LOTAnimationView*) gp_loadingView
{
    return objc_getAssociatedObject(self, @selector(gp_loadingView));
}

- (void) setGp_loadingView:(LOTAnimationView *)ngc_loadingView
{
    objc_setAssociatedObject(self,  @selector(gp_loadingView) , ngc_loadingView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
