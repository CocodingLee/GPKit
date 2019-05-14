//
//  VZInspectController.h
//  GPPerformance
//
//  Created by Liyanwei on 2019/5/14.
//  Copyright © 2019 Liyanwei. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface VZInspectController : UIViewController

@property(nonatomic,strong,readonly) UIView* currentView;
@property(nonatomic,assign,readonly) NSString* currentTab;

//@property(nonatomic,strong) VZInspectorToolboxView* toolboxView;
//@property(nonatomic,strong) VZInspectorToolboxView* pluginView;

- (void)start;
- (void)stop;
- (BOOL)canTouchPassThrough:(CGPoint)pt;
- (void)onClose;
- (void)transitionToView:(UIView *)view;

@end

NS_ASSUME_NONNULL_END
