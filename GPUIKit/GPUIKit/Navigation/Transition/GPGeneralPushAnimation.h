//
//  GPGeneralPushAnimation.h
//
//  Created by Liyanwei on 2019/5/5.
//  Copyright © 2019 Liyanwei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface GPGeneralPushAnimation : NSObject <UIViewControllerAnimatedTransitioning>
- (instancetype)initWithContentFrame:(CGRect)contentFrame;
@end
