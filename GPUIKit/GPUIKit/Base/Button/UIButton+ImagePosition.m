//
//  UIButton+ImagePosition.m
//  GPUIKit
//
//  Created by Liyanwei on 2019/4/28.
//  Copyright © 2019 Liyanwei. All rights reserved.
//

#import "UIButton+ImagePosition.h"

////////////////////////////////////////////////////////////////////
// 位置缓存

@interface GPButtonPosCacheManager : NSObject
@property (nonatomic, strong) NSCache *cache;
@end

@implementation GPButtonPosCacheManager

+ (instancetype)sharedInstance
{
    static GPButtonPosCacheManager * _s_ = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _s_ = [[[self class] alloc] init];
    });
    return _s_;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _cache = [[NSCache alloc] init];
    }
    
    return self;
}

@end

////////////////////////////////////////////////////////////////////

/**
 缓存用数据结构
 */
@interface GPButtonPosItem : NSObject
@property (nonatomic, assign) UIEdgeInsets imageEdgeInsets;
@property (nonatomic, assign) UIEdgeInsets titleEdgeInsets;
@property (nonatomic, assign) UIEdgeInsets contentEdgeInsets;
@end

@implementation GPButtonPosItem
@end

////////////////////////////////////////////////////////////////////

@implementation UIButton (ImagePosition)

- (void)setImageTextPosition:(GPImagePosition)postion space:(CGFloat)spacing
{
    NSCache *cache = [GPButtonPosCacheManager sharedInstance].cache;
    NSString *cacheKey = [NSString stringWithFormat:@"%@_%@_%@", self.currentTitle, @(self.titleLabel.font.hash),@(postion)];
    GPButtonPosItem *savedModel = [cache objectForKey:cacheKey];
    if (savedModel != nil) {
        self.imageEdgeInsets = savedModel.imageEdgeInsets;
        self.titleEdgeInsets = savedModel.titleEdgeInsets;
        self.contentEdgeInsets = savedModel.contentEdgeInsets;
        return;
    }
    
    CGFloat imageWidth = self.currentImage.size.width;
    CGFloat imageHeight = self.currentImage.size.height;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    // Single line, no wrapping. Truncation based on the NSLineBreakMode.
    CGSize size = [self.currentTitle sizeWithFont:self.titleLabel.font];
    CGFloat labelWidth = size.width;
    CGFloat labelHeight = size.height;
#pragma clang diagnostic pop
    
    CGFloat imageOffsetX = (imageWidth + labelWidth) / 2 - imageWidth / 2;//image中心移动的x距离
    CGFloat imageOffsetY = imageHeight / 2 + spacing / 2;//image中心移动的y距离
    CGFloat labelOffsetX = (imageWidth + labelWidth / 2) - (imageWidth + labelWidth) / 2;//label中心移动的x距离
    CGFloat labelOffsetY = labelHeight / 2 + spacing / 2;//label中心移动的y距离
    
    CGFloat tempWidth = MAX(labelWidth, imageWidth);
    CGFloat changedWidth = labelWidth + imageWidth - tempWidth;
    CGFloat tempHeight = MAX(labelHeight, imageHeight);
    CGFloat changedHeight = labelHeight + imageHeight + spacing - tempHeight;
    
    UIEdgeInsets imageEdgeInsets = UIEdgeInsetsZero;
    UIEdgeInsets titleEdgeInsets = UIEdgeInsetsZero;
    UIEdgeInsets contentEdgeInsets = UIEdgeInsetsZero;
    
    switch (postion) {
        case GPImagePositionLeft:
            imageEdgeInsets = UIEdgeInsetsMake(0, -spacing/2, 0, spacing/2);
            titleEdgeInsets = UIEdgeInsetsMake(0, spacing/2, 0, -spacing/2);
            contentEdgeInsets = UIEdgeInsetsMake(0, spacing/2, 0, spacing/2);
            break;
            
        case GPImagePositionRight:
            imageEdgeInsets = UIEdgeInsetsMake(0, labelWidth + spacing/2, 0, -(labelWidth + spacing/2));
            titleEdgeInsets = UIEdgeInsetsMake(0, -(imageWidth + spacing/2), 0, imageWidth + spacing/2);
            contentEdgeInsets = UIEdgeInsetsMake(0, spacing/2, 0, spacing/2);
            break;
            
        case GPImagePositionTop:
            imageEdgeInsets = UIEdgeInsetsMake(-imageOffsetY, imageOffsetX, imageOffsetY, -imageOffsetX);
            titleEdgeInsets = UIEdgeInsetsMake(labelOffsetY, -labelOffsetX, -labelOffsetY, labelOffsetX);
            contentEdgeInsets = UIEdgeInsetsMake(imageOffsetY, -changedWidth/2, changedHeight-imageOffsetY, -changedWidth/2);
            break;
            
        case GPImagePositionBottom:
            imageEdgeInsets = UIEdgeInsetsMake(imageOffsetY, imageOffsetX, -imageOffsetY, -imageOffsetX);
            titleEdgeInsets = UIEdgeInsetsMake(-labelOffsetY, -labelOffsetX, labelOffsetY, labelOffsetX);
            contentEdgeInsets = UIEdgeInsetsMake(changedHeight-imageOffsetY, -changedWidth/2, imageOffsetY, -changedWidth/2);
            break;
        default:
            break;
    }
    
    GPButtonPosItem *model = [[GPButtonPosItem alloc] init];
    model.imageEdgeInsets = imageEdgeInsets;
    model.titleEdgeInsets = titleEdgeInsets;
    model.contentEdgeInsets = contentEdgeInsets;
    [cache setObject:model forKey:cacheKey];
    
    self.imageEdgeInsets = imageEdgeInsets;
    self.titleEdgeInsets = titleEdgeInsets;
    self.contentEdgeInsets = contentEdgeInsets;
    
}


@end
