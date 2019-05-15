//
//  GPCategoryTitleImageCellModel.h
//  GPCategoryView
//
//  Created by Liyanwei on 2018/8/8.
//  Copyright © 2018年 Liyanwei. All rights reserved.
//

#import "GPCategoryTitleCellModel.h"

typedef NS_ENUM(NSUInteger, GPCategoryTitleImageType) {
    GPCategoryTitleImageType_TopImage = 0,
    GPCategoryTitleImageType_LeftImage,
    GPCategoryTitleImageType_BottomImage,
    GPCategoryTitleImageType_RightImage,
    GPCategoryTitleImageType_OnlyImage,
    GPCategoryTitleImageType_OnlyTitle,
};

@interface GPCategoryTitleImageCellModel : GPCategoryTitleCellModel

@property (nonatomic, assign) GPCategoryTitleImageType imageType;

@property (nonatomic, copy) void(^loadImageCallback)(UIImageView *imageView, NSURL *imageURL);

@property (nonatomic, copy) NSString *imageName;    //加载bundle内的图片

@property (nonatomic, strong) NSURL *imageURL;      //图片URL

@property (nonatomic, copy) NSString *selectedImageName;

@property (nonatomic, strong) NSURL *selectedImageURL;

@property (nonatomic, assign) CGSize imageSize;     //默认CGSizeMake(20, 20)

@property (nonatomic, assign) CGFloat titleImageSpacing;    //titleLabel和ImageView的间距，默认5

@property (nonatomic, assign) BOOL imageZoomEnabled;

@property (nonatomic, assign) CGFloat imageZoomScale;

@end
