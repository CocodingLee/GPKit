//
//  GPButton.m
//  AGSUIKit
//
//  Created by Liyanwei on 2019/4/28.
//  Copyright © 2019 Liyanwei. All rights reserved.
//

#import "GPBaseButton.h"
#import "UIImage+GPColor.h"
#import "GPNavigationDefine.h"
#import <FrameAccessor/ViewFrameAccessor.h>


static GPButtonTypeBlock aGPButtonTypeBlock = nil;

@implementation GPButtonItem

- (instancetype)init
{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _cornerRadius = -1;
    
    return self;
}

@end

@interface GPBaseButton ()

@property (nonatomic, assign) GPButtonType gp_buttonType;

@property (nonatomic, strong) GPButtonItem *typeItem;

@property (nonatomic, assign) BOOL shouldUpdateItem;

@end

@implementation GPBaseButton

@dynamic typeItemConfigBlock;

+ (instancetype)buttonWithType:(GPButtonType)buttonType
{
    GPBaseButton *button = [[GPBaseButton alloc] init];
    [button updateButtonType:buttonType];
    return button;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) {
        return nil;
    }
    
    self.shouldUpdateItem = YES;
    _gp_buttonType = 0;
        
    return self;
}

#pragma mark - Layout

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (self.shouldUpdateItem)
    {
        self.shouldUpdateItem = NO;
        [self updateButton];
    }

}

#pragma mark - Public

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    self.shouldUpdateItem = YES;
}

+ (void)setTypeItemConfigBlock:(GPButtonTypeBlock)typeItemConfigBlock
{
    aGPButtonTypeBlock = typeItemConfigBlock;
}

+ (GPButtonTypeBlock)typeItemConfigBlock
{
    return aGPButtonTypeBlock;
}

#pragma mark - Update

- (void)updateButton
{
    if (nil == self.typeItem)
    {
        self.typeItem = [self typeItemWithType:self.gp_buttonType];
    }
    
    GPButtonItem *typeItem = self.typeItem;
    CGFloat cornerRadius = typeItem.cornerRadius;
    if (cornerRadius < 0)
    {
        cornerRadius = self.viewSize.height / 2;
    }

    // 常规状态
    NSArray* colors = @[typeItem.leftBackgroundColor, typeItem.rightBackgroundColor];
    UIImage *normalImage = [UIImage gp_gradientImageFromColors:colors
                                                        imgSize:self.viewSize
                                                   cornerRadius:cornerRadius
                                                    borderWidth:typeItem.borderWidth
                                                    borderColor:typeItem.borderColor];
    
    [self setBackgroundImage:normalImage forState:UIControlStateNormal];
    
    // 高亮状态
    NSArray* hColors = @[typeItem.leftBackgroundColor_pre, typeItem.rightBackgroundColor_pre];
    UIImage *highlightedImage = [UIImage gp_gradientImageFromColors:hColors
                                                             imgSize:self.viewSize
                                                        cornerRadius:cornerRadius
                                                         borderWidth:typeItem.borderWidth
                                                         borderColor:typeItem.borderColor_pre];
    
    [self setBackgroundImage:highlightedImage forState:UIControlStateHighlighted];
    [self setBackgroundImage:highlightedImage forState:UIControlStateSelected];
    
    // 无效状态
    NSArray* dColors = @[typeItem.leftBackgroundColor_dis, typeItem.rightBackgroundColor_dis];
    UIImage *disableImage = [UIImage gp_gradientImageFromColors:dColors
                                                         imgSize:self.viewSize
                                                    cornerRadius:cornerRadius
                                                     borderWidth:typeItem.borderWidth
                                                     borderColor:typeItem.borderColor_dis];
    [self setBackgroundImage:disableImage forState:UIControlStateDisabled];
    
    self.titleLabel.font = typeItem.font;
    [self setTitleColor:typeItem.textColor forState:UIControlStateNormal];
    [self setTitleColor:typeItem.textColor_pre forState:UIControlStateHighlighted];
    [self setTitleColor:typeItem.textColor_pre forState:UIControlStateSelected];
    [self setTitleColor:typeItem.textColor_dis forState:UIControlStateDisabled];
}

- (void)updateButtonType:(GPButtonType)buttonType
{
    if (buttonType == self.typeItem.type)
    {
        return;
    }
    
    self.gp_buttonType = buttonType;
    self.typeItem = [self typeItemWithType:buttonType];
    
    [self updateButton];
}

- (GPButtonItem *)typeItemWithType:(GPButtonType)type
{
    if (GPBaseButton.typeItemConfigBlock)
    {
        return GPBaseButton.typeItemConfigBlock(type);
    }
    else
    {
        GPButtonItem *typeItem = [[GPButtonItem alloc] init];
        
        typeItem.type = type;
        typeItem.font = [UIFont boldSystemFontOfSize:16];
        typeItem.cornerRadius = -1;
        
#undef mainColor
#define mainColor 0x222222
        
        typeItem.leftBackgroundColor = HEXCOLORA(0xFFFFFF, 1.0);
        typeItem.rightBackgroundColor = HEXCOLORA(0xFFFFFF, 1.0);
        typeItem.borderColor = HEXCOLORA(mainColor, 1);
        typeItem.textColor = HEXCOLORA(mainColor, 1);
        
        typeItem.leftBackgroundColor_pre = HEXCOLORA(0xFFFFFF, 0.8);
        typeItem.rightBackgroundColor_pre = HEXCOLORA(0xFFFFFF, 0.8);
        typeItem.borderColor_pre = HEXCOLORA(mainColor, 1);
        typeItem.textColor_pre = HEXCOLORA(mainColor, 1);
        
        typeItem.leftBackgroundColor_dis = HEXCOLORA(0xFFFFFF, 1.0);
        typeItem.rightBackgroundColor_dis = HEXCOLORA(0xFFFFFF, 1.0);
        typeItem.borderColor_dis = HEXCOLORA(mainColor, 0.3);
        typeItem.textColor_dis = HEXCOLORA(mainColor, 0.3);

        return typeItem;
    }
}

@end
