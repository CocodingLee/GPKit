//
//  GPButton.m
//  NineGameCommunity
//
//  Created by Liyanwei on 2019/5/14.
//  Copyright © 2019 Liyanwei. All rights reserved.
//

#import "GPButton.h"
#import "GPNavigationDefine.h"

@implementation GPButton

+ (instancetype)buttonWithType:(GPKitButtonType)buttonType
{
    GPButton *button = [[GPButton alloc] initWithFrame:(CGRect){0, 0, 10, 10}];
    [button updateButtonType:(GPButtonType)buttonType];
    return button;
}

+ (void)configButtonType
{
    GPBaseButton.typeItemConfigBlock = ^GPButtonItem *(GPKitButtonType type) {
        GPButtonItem *typeItem = [[GPButtonItem alloc] init];
        
        typeItem.type = type;
        
        switch (type) {
            case GPKitButtonType_main_s:
            {
                typeItem.borderWidth = 0;
                typeItem.font = [UIFont systemFontOfSize:12];
                typeItem.cornerRadius = 4;
                
                typeItem.leftBackgroundColor = HEXCOLORA(0xFF7F2A, 1.0);
                typeItem.rightBackgroundColor = HEXCOLORA(0xFF5244, 1.0);
                typeItem.borderColor = [UIColor clearColor];
                typeItem.textColor = [UIColor whiteColor];
                
                typeItem.leftBackgroundColor_pre = HEXCOLORA(0xEB6F1C, 1);
                typeItem.rightBackgroundColor_pre = HEXCOLORA(0xF54336, 1);
                typeItem.borderColor_pre = [UIColor clearColor];
                typeItem.textColor_pre = [UIColor whiteColor];
                
                typeItem.leftBackgroundColor_dis = HEXCOLORA(0xDDDDDD, 1.0);
                typeItem.rightBackgroundColor_dis = HEXCOLORA(0xDDDDDD, 1.0);
                typeItem.borderColor_dis = [UIColor clearColor];
                typeItem.textColor_dis = [UIColor whiteColor];
            }
                break;
            case GPKitButtonTypeOrange:
            {
                typeItem.borderWidth = 0;
                typeItem.font = [UIFont boldSystemFontOfSize:16];
                typeItem.cornerRadius = 6;
                
                typeItem.leftBackgroundColor = HEXCOLORA(0xFF7F2A, 1.0);
                typeItem.rightBackgroundColor = HEXCOLORA(0xFF5244, 1.0);
                typeItem.borderColor = [UIColor clearColor];
                typeItem.textColor = [UIColor whiteColor];
                
                typeItem.leftBackgroundColor_pre = HEXCOLORA(0xFF7F2A, 0.7);
                typeItem.rightBackgroundColor_pre = HEXCOLORA(0xFF5244, 0.7);
                typeItem.borderColor_pre = [UIColor clearColor];
                typeItem.textColor_pre = [UIColor whiteColor];
                
                typeItem.leftBackgroundColor_dis = HEXCOLORA(0xDDDDDD, 1.0);
                typeItem.rightBackgroundColor_dis = HEXCOLORA(0xDDDDDD, 1.0);
                typeItem.borderColor_dis = [UIColor clearColor];
                typeItem.textColor_dis = [UIColor whiteColor];
            }
                break;
            case GPKitButtonTypeOrangeSmall:
            {
                typeItem.borderWidth = 0;
                typeItem.font = [UIFont systemFontOfSize:12];
                typeItem.cornerRadius = 4;
                
                typeItem.leftBackgroundColor = HEXCOLORA(0xFF7F2A, 1.0);
                typeItem.rightBackgroundColor = HEXCOLORA(0xFF5244, 1.0);
                typeItem.borderColor = [UIColor clearColor];
                typeItem.textColor = [UIColor whiteColor];
                
                typeItem.leftBackgroundColor_pre = HEXCOLORA(0xFF7F2A, 0.7);
                typeItem.rightBackgroundColor_pre = HEXCOLORA(0xFF5244, 0.7);
                typeItem.borderColor_pre = [UIColor clearColor];
                typeItem.textColor_pre = [UIColor whiteColor];
                
                typeItem.leftBackgroundColor_dis = HEXCOLORA(0xDDDDDD, 1.0);
                typeItem.rightBackgroundColor_dis = HEXCOLORA(0xDDDDDD, 1.0);
                typeItem.borderColor_dis = [UIColor clearColor];
                typeItem.textColor_dis = [UIColor whiteColor];
            }
                break;
            case GPKitButtonTypeVote:
            {
                typeItem.borderWidth = 1;
                typeItem.font = [UIFont systemFontOfSize:14];
                typeItem.cornerRadius = 5;
                
                typeItem.leftBackgroundColor = UIColor.whiteColor;
                typeItem.rightBackgroundColor = UIColor.whiteColor;
                typeItem.borderColor = HEXCOLORA(0xE4E5E7, 1);
                typeItem.textColor = HEXCOLORA(0x242529, 1);
                
                typeItem.leftBackgroundColor_pre = UIColor.whiteColor;
                typeItem.rightBackgroundColor_pre = UIColor.whiteColor;
                typeItem.borderColor_pre = HEXCOLORA(0xF97219, 1);
                typeItem.textColor_pre = HEXCOLORA(0xF97219, 1);
                
                typeItem.leftBackgroundColor_dis = UIColor.whiteColor;
                typeItem.rightBackgroundColor_dis = UIColor.whiteColor;
                typeItem.borderColor_dis = HEXCOLORA(0xE4E5E7, 1);
                typeItem.textColor_dis = HEXCOLORA(0x242529, 1);
            }
                break;
            case GPKitButtonType_main_line_s:
            {
                typeItem.borderWidth = 1;
                typeItem.font = [UIFont systemFontOfSize:12];
                typeItem.cornerRadius = 4;
                
                typeItem.leftBackgroundColor = HEXCOLORA(0xFFFFFF, 1.0);
                typeItem.rightBackgroundColor = HEXCOLORA(0xFFFFFF, 1.0);
                typeItem.borderColor = HEXCOLORA(0xF97219, 1);
                typeItem.textColor = HEXCOLORA(0xF97219, 1);
                
                typeItem.leftBackgroundColor_pre = HEXCOLORA(0xFFF2EA, 1);
                typeItem.rightBackgroundColor_pre = HEXCOLORA(0xFFF2EA, 1);
                typeItem.borderColor_pre = HEXCOLORA(0xF97219, 1);
                typeItem.textColor_pre = HEXCOLORA(0xF97219, 1);
                
                typeItem.leftBackgroundColor_dis = HEXCOLORA(0xFFFFFF, 1.0);
                typeItem.rightBackgroundColor_dis = HEXCOLORA(0xFFFFFF, 1.0);
                typeItem.borderColor_dis = HEXCOLORA(0xF97219, 1);
                typeItem.textColor_dis = HEXCOLORA(0xF97219, 1);
            }
                break;
            case GPKitButtonType_main_line_s_round:
            {
                typeItem.borderWidth = 1;
                typeItem.font = [UIFont systemFontOfSize:12];
                typeItem.cornerRadius = -1;
                
                typeItem.leftBackgroundColor = HEXCOLORA(0xFFFFFF, 1.0);
                typeItem.rightBackgroundColor = HEXCOLORA(0xFFFFFF, 1.0);
                typeItem.borderColor = HEXCOLORA(0xF97219, 1);
                typeItem.textColor = HEXCOLORA(0xF97219, 1);
                
                typeItem.leftBackgroundColor_pre = HEXCOLORA(0xFFF2EA, 1);
                typeItem.rightBackgroundColor_pre = HEXCOLORA(0xFFF2EA, 1);
                typeItem.borderColor_pre = HEXCOLORA(0xF97219, 1);
                typeItem.textColor_pre = HEXCOLORA(0xF97219, 1);
                
                typeItem.leftBackgroundColor_dis = HEXCOLORA(0xFFFFFF, 1.0);
                typeItem.rightBackgroundColor_dis = HEXCOLORA(0xFFFFFF, 1.0);
                typeItem.borderColor_dis = HEXCOLORA(0xF97219, 1);
                typeItem.textColor_dis = HEXCOLORA(0xF97219, 1);
            }
                break;
            case GPKitButtonType_black_line_s:
            {
                typeItem.borderWidth = 1;
                typeItem.font = [UIFont systemFontOfSize:12];
                typeItem.cornerRadius = 4;
                
                typeItem.leftBackgroundColor = UIColor.clearColor;
                typeItem.rightBackgroundColor = UIColor.clearColor;
                typeItem.borderColor = HEXCOLORA(0xDDDDDD, 1);
                typeItem.textColor = HEXCOLORA(0x999999, 1);
                
                typeItem.leftBackgroundColor_pre = HEXCOLORA(0xEFEFEF, 1);
                typeItem.rightBackgroundColor_pre = HEXCOLORA(0xEFEFEF, 1);
                typeItem.borderColor_pre = HEXCOLORA(0xDDDDDD, 1);
                typeItem.textColor_pre = HEXCOLORA(0x999999, 1);
                
                typeItem.leftBackgroundColor_dis = UIColor.clearColor;
                typeItem.rightBackgroundColor_dis = UIColor.clearColor;
                typeItem.borderColor_dis = HEXCOLORA(0xDDDDDD, 1);
                typeItem.textColor_dis = HEXCOLORA(0x999999, 1);
            }
                break;
            default:
                break;
        }
        
        return typeItem;
    };
}


@end
