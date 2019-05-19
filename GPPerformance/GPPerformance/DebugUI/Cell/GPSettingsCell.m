//
//  GPSettingsCell.m
//  GPPerformance
//
//  Created by Liyanwei on 2019/5/15.
//  Copyright © 2019 Liyanwei. All rights reserved.
//

#import "GPSettingsCell.h"
#import <GPUIKit/GPUIKit.h>
#import <FrameAccessor/FrameAccessor.h>
#import "GPInspector.h"

@interface GPSettingsCell ()
@property (nonatomic , strong) UISwitch* hookExceptionBtn;
@end

@implementation GPSettingsCell

- (void) prepareForReuse
{
    [super prepareForReuse];
    self.hookExceptionBtn.on = NO;
}

- (UISwitch*) hookExceptionBtn
{
    if (!_hookExceptionBtn) {
        UISwitch* sw = [[UISwitch alloc] init];
        [sw setTintColor:HEXCOLORA(0xc4cbdc , 0.5)];
        [sw setOnTintColor:HEXCOLORA(0x5280ff , 1.0)];
        [sw setThumbTintColor:HEXCOLORA(0xFFFFFF, 1.0)];
        sw.backgroundColor = HEXCOLORA(0xc4cbdc , 1.0);
        
        sw.layer.cornerRadius = 15.5f;
        sw.layer.masksToBounds = YES;
        sw.on = NO;
        
        [sw addTarget:self action:@selector(exceptionAction) forControlEvents:UIControlEventValueChanged];
        
        _hookExceptionBtn = sw;
    }
    
    return _hookExceptionBtn;
}

- (void) exceptionAction
{
    [GPInspector setShouldHookException:self.hookExceptionBtn.on];
}

- (void) update
{
    if (!self.hookExceptionBtn.superview) {
        self.hookExceptionBtn.left = 15;
        
        UIEdgeInsets safeArea = gpSafeArea();
        UILabel *label = [[UILabel alloc] init];
        label.text = @"Hook异常:";
        label.frame = CGRectMake(0, 0, 20, 20);
        label.textAlignment = NSTextAlignmentRight;
        [label sizeToFit];
        
        label.left = 10;
        label.top = safeArea.top + 44;
        [self.contentView addSubview:label];
        
        self.hookExceptionBtn.left = label.right + 5;
        self.hookExceptionBtn.centerY = label.centerY;
        [self.contentView addSubview:self.hookExceptionBtn];
    }
    
    self.hookExceptionBtn.on = [GPInspector isHookException];
}
@end
