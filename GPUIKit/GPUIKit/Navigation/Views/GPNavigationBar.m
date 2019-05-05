//
//  GPNavigationBar.m
//  GPUIKit
//
//  Created by Liyanwei on 2019/5/5.
//  Copyright © 2019 Liyanwei. All rights reserved.
//

#import "GPNavigationBar.h"
#import "UIView+SafeArea.h"
#import "GPNavigationDefine.h"

@interface GPNavigationBar ()
@property (nonatomic, strong, readwrite) UIView *lineView;
@end

@implementation GPNavigationBar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        UIEdgeInsets safeArea = UIApplication.sharedApplication.keyWindow.gp_safeAreaInsets;
        self.frame = (CGRect){0, 0, GP_SCREEN_WIDTH, 44 + safeArea.top};
        self.backgroundColor = [UIColor whiteColor];
        
        CGRect frame = (CGRect){0, [GPNavigationBar barHeight], GP_SCREEN_WIDTH, GP_ONE_PIX};
        self.lineView = [[UIView alloc] initWithFrame:frame];
        self.lineView.backgroundColor = HEXCOLOR(0xE7EAF2);
        [self addSubview:self.lineView];
        
    }
    
    return self;
}

- (instancetype)init
{
    return [self initWithFrame:CGRectZero];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)clearBG
{
    self.backgroundColor = [UIColor clearColor];
    self.lineView.backgroundColor = [UIColor clearColor];
}

+ (CGFloat)barHeight
{
    return 44 + UIApplication.sharedApplication.keyWindow.gp_safeAreaInsets.top;
}

+ (CGFloat)barContentHeight
{
    return 44;
}
@end
