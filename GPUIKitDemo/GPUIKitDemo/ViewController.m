//
//  ViewController.m
//  GPUIKitDemo
//
//  Created by Liyanwei on 2019/4/26.
//  Copyright © 2019 Liyanwei. All rights reserved.
//

#import "ViewController.h"
#import <GPUIKit/GPUIKit.h>
#import <FrameAccessor/FrameAccessor.h>
#import <libextobjc/EXTScope.h>

@interface ViewController ()
@property (nonatomic , strong) UIImageView* webImageView;
@end

@implementation ViewController

- (UIImageView*) webImageView
{
    if (!_webImageView) {
        UIImageView* view = [[UIImageView alloc] init];
        view.contentMode = UIViewContentModeScaleAspectFill;
        view.frame = CGRectMake(0, 0, 100, 100);
        
        _webImageView = view;
    }
    
    return _webImageView;
}

- (void) setupNavigationBar
{
    NSString* title = @"测试首页";
    self.gp_navigationItem.title = title;
    self.gp_navigationItem.tintColor = HEXCOLOR(0x222222);
    
    self.gp_navigationItem.titleLabel.textAlignment = NSTextAlignmentLeft;
    self.gp_navigationItem.titleLabel.left = 40;
    self.gp_navigationItem.titleLabel.font = [UIFont systemFontOfSize:17];
    self.gp_navigationBar.backgroundColor = HEXCOLOR(0xFFFFFF);
    
    if (@available(iOS 11.0, *)) {
        [[UIScrollView appearance] setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
    }else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    @weakify(self);
    // 更多
    UIImage* searchImage = [UIImage imageNamed:@"navbar_icon_search"];
    GPBarButtonItem* searchItem = [[GPBarButtonItem alloc] initWithImage:searchImage
                                                                   style:GPBarButtonItemStyleDefault
                                                                 handler:^(id sender) {
                                                                     @strongify(self);
                                                                     ViewController* vc = [ViewController new];
                                                                     [self.navigationController pushViewController:vc animated:YES];
                                                                 }];
    
    
    self.gp_navigationItem.rightBarButtonItem = searchItem;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createNavigationBar];
    [self setupNavigationBar];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 安全区
    UIEdgeInsets safeArea = gpSafeArea();
    NSLog(@"safeArea.top = %f" , safeArea.top);
    
    // 扩大点击去
    UIButton* tBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    tBtn.gp_expandInsets = UIEdgeInsetsMake(10, 10, 10, 10);
    NSLog(@"expand top = %f" , tBtn.gp_expandInsets.top);
    
    // 图标居中
    NSURL* imageUrl = [NSURL URLWithString:@"http://seopic.699pic.com/photo/50055/5642.jpg_wh1200.jpg"];
    
    UIImage* placeHolder = [UIImage imageNamed:@"gp_default"];
    [placeHolder gp_imageWithBackgroundColor:[UIColor whiteColor]
                                    viewSize:placeHolder.size
                                 contentMode:UIViewContentModeScaleAspectFit
                                 cornerRadii:UIEdgeInsetsMake(10, 0, 0, 0)
                                 borderColor:[UIColor whiteColor]
                                 borderWidth:0];
    
    
    [self.webImageView gp_setImageWithURL:imageUrl
                                 viewSize:self.webImageView.viewSize
                              cornerRadii:UIEdgeInsetsMake(30, 5, 10, 1)
                              borderColor:[UIColor whiteColor]
                              borderWidth:0
                         placeholderImage:placeHolder
                                  options:GPWebImageLowPriority
                                completed:^(UIImage * _Nonnull image
                                            , NSError * _Nonnull error
                                            , GPImageCacheType cacheType
                                            , NSURL * _Nonnull imageURL)
     {
         
     }];
    
    self.webImageView.top = 100;
    self.webImageView.left = 15;
    [self.view addSubview:self.webImageView];
}


@end
