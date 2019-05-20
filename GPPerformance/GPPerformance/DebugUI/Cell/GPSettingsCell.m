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
#import "GPLagDB.h"
#import <KSCrash/KSCrashC.h>
#import <coobjc/coobjc.h>

@interface GPSettingsCell ()
@property (nonatomic , strong) UISwitch* hookExceptionBtn;
@property (nonatomic , strong) GPButton* clearFrameBtn;
@property (nonatomic , strong) GPButton* clearCrashBtn;
@property (nonatomic , strong) GPButton* clearHookBtn;
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
    
    if (!self.clearFrameBtn.superview) {
        GPButton* btn = [GPButton buttonWithType:GPKitButtonTypeOrange];
        btn.frame = CGRectMake(0, 0, 100, 40);
        [btn setTitle:@"清空卡顿" forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(clearFrameLoss) forControlEvents:UIControlEventTouchUpInside];
        btn.left = 15;
        btn.top = self.hookExceptionBtn.bottom + 5;
        
        [self.contentView addSubview:btn];
        self.clearFrameBtn = btn;
    }
    
    
    if (!self.clearCrashBtn.superview) {
        GPButton* btn = [GPButton buttonWithType:GPKitButtonTypeOrange];
        btn.frame = CGRectMake(0, 0, 100, 40);
        [btn setTitle:@"清空Crash" forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(clearCrash) forControlEvents:UIControlEventTouchUpInside];
        btn.left = 15;
        btn.top = self.clearFrameBtn.bottom + 10;
        
        [self.contentView addSubview:btn];
        self.clearCrashBtn = btn;
    }
    
    if (!self.clearHookBtn.superview) {
        GPButton* btn = [GPButton buttonWithType:GPKitButtonTypeOrange];
        btn.frame = CGRectMake(0, 0, 100, 40);
        [btn setTitle:@"清空Hook" forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(clearHook) forControlEvents:UIControlEventTouchUpInside];
        btn.left = 15;
        btn.top = self.clearCrashBtn.bottom + 5;
        
        [self.contentView addSubview:btn];
        self.clearHookBtn = btn;
    }
}

- (void) clearFrameLoss
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [GPProgressHUD showSuccess:@"卡顿数据清除完毕！" onView:self.contentView duration:2.0];
    });
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [[GPLagDB shareInstance] clearStackData];
    });
}

- (void) clearCrash
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [GPProgressHUD showSuccess:@"Crash数据清除完毕！" onView:self.contentView duration:2.0];
    });
    
    dispatch_async(dispatch_get_main_queue(), ^{
        kscrash_deleteAllReports();
    });
}

- (void) clearHook
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [GPProgressHUD showSuccess:@"Hook数据清除完毕!" onView:self.contentView duration:2.0];
    });
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [[GPLagDB shareInstance] clearOCExceptionData];
    });
}
@end
