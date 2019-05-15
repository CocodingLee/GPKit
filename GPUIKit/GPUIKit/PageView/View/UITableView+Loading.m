//
//  UITableView+Loading.m
//  GPUIKit
//
//  Created by Liyanwei on 2019/1/31.
//  Copyright © 2019 Aligames. All rights reserved.
//

#import "UITableView+Loading.h"
#import "UITableView+Private.h"

#import <FrameAccessor/FrameAccessor.h>
#import <MJRefresh/MJRefresh.h>
#import <libextobjc/EXTScope.h>
#import <objc/runtime.h>
#import <GPUIKit/GPUIKit.h>
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>

@interface UIScrollView (EmptyPage) < DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
@end

@implementation UIScrollView (Loading)

- (ErrorRetryLoadBlock) retryBlock
{
    return objc_getAssociatedObject(self, @selector(retryBlock));
}

- (void) setRetryBlock:(ErrorRetryLoadBlock)retryBlock
{
    objc_setAssociatedObject(self, @selector(retryBlock), retryBlock, OBJC_ASSOCIATION_COPY);
}

- (ActionBlock)gp_actionBlock
{
    return objc_getAssociatedObject(self, @selector(gp_actionBlock));
}

- (void)setGp_actionBlock:(ActionBlock)ngc_actionBlock
{
    objc_setAssociatedObject(self, @selector(gp_actionBlock), ngc_actionBlock, OBJC_ASSOCIATION_COPY);
}

- (NSString *)gp_actionButtonTitle
{
    return objc_getAssociatedObject(self, @selector(gp_actionButtonTitle));
}

- (void)setGp_actionButtonTitle:(NSString *)ngc_actionButtonTitle
{
    objc_setAssociatedObject(self, @selector(gp_actionButtonTitle), ngc_actionButtonTitle, OBJC_ASSOCIATION_COPY);
}

// 绑定空白页面
- (void) bindEmptyView
{
    //
    // 解决滑动不流畅问题
    //
    // https://blog.csdn.net/qq_33856381/article/details/78842431
    //
    //
    if ([self isKindOfClass:UITableView.class])
    {
        UITableView *tableView = (UITableView *)self;
        tableView.estimatedRowHeight = 0;
        tableView.estimatedSectionHeaderHeight = 0;
        tableView.estimatedSectionFooterHeight = 0;
    }
    
    self.emptyDataSetSource = self;
    self.emptyDataSetDelegate = self;
    
    self.gp_error = nil;
    self.gp_type = UITableViewErrorType_None;
    
    self.gp_loadingView = [LOTAnimationView animationNamed:@"table_loading"];
    self.gp_loadingView.loopAnimation = YES;
    [self.gp_loadingView play];
    
    self.gp_loadingView.width = 90;
    self.gp_loadingView.height = 90;
    self.gp_loadingView.centerX = self.width/2;
    self.gp_loadingView.centerY = self.height/2;
    [self addSubview:self.gp_loadingView];
    
}

// 加载过程中网络错误
- (void) loadingWithNetError:(NSError*) error
{
    self.gp_type = UITableViewErrorType_NetError;
    self.gp_error = error;
    
    [self ngc_loading_reloadData];
    [self.gp_loadingView stop];
    [self.gp_loadingView removeFromSuperview];
}

// 加载过程中，无法内容
- (void) loadingWithNoContent
{
    self.gp_type = UITableViewErrorType_NoContent;
    
    [self ngc_loading_reloadData];
    [self.gp_loadingView stop];
    [self.gp_loadingView removeFromSuperview];
}

- (void) loadingSuccess
{
    // 停止lottie动画
    [self.gp_loadingView stop];
    [self.gp_loadingView removeFromSuperview];
}

- (void) loadingWithMessage:(NSString*) message action:(ActionBlock)action
{
    self.gp_type = UITableViewErrorType_Action;
    self.gp_actionButtonTitle = message;
    self.gp_actionBlock = action;
    
    [self ngc_loading_reloadData];
    [self.gp_loadingView stop];
    [self.gp_loadingView removeFromSuperview];
}

- (void)ngc_loading_reloadData
{
    if ([self isKindOfClass:UITableView.class])
    {
        UITableView *tableView = (UITableView *)self;
        [tableView reloadData];
    }
    else if ([self isKindOfClass:UICollectionView.class])
    {
        UICollectionView *collectionView = (UICollectionView *)self;
        [collectionView reloadData];
    }
}

#pragma mark - DZNEmptyDataSetSource

- (NSAttributedString *)buttonTitleForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state
{
    NSAttributedString *attrString = nil;
    
    if (UITableViewErrorType_Action == self.gp_type)
    {
        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
        style.lineBreakMode = NSLineBreakByWordWrapping;
        style.lineSpacing = 6;
        attrString = [[NSAttributedString alloc] initWithString:self.gp_actionButtonTitle
                                                                         attributes:@{
                                                                                      NSParagraphStyleAttributeName: style,
                                                                                      NSForegroundColorAttributeName: [UIColor redColor],
                                                                                      NSFontAttributeName: [UIFont systemFontOfSize:16]
                                                                                      }];
    }
    
    return attrString;
}

/**
 *  返回占位图图片
 */
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    
    NSString* imgName = @"";
    switch (self.gp_type) {
        case UITableViewErrorType_None:
        {
            break;
        }
            
        case UITableViewErrorType_NetError:
        {
            imgName = @"ng_default_neterror_img";
        }
            break;
            
        case UITableViewErrorType_NoContent:
        {
            imgName = @"ng_default_blank_img";
        }
            break;
        case UITableViewErrorType_Action:
        {
            imgName = @"ng_default_blank_img";
        }
            break;
        default:
            break;
    }
    
    return [UIImage imageNamed:imgName];
}

/**
 *  返回详情文字
 */
- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString* text = @"";
    switch (self.gp_type) {
        case UITableViewErrorType_NetError:
        {
            // 这里接口返回的 信息过长。
            NSString* msg = @"";//self.ngc_error.userInfo[NSLocalizedDescriptionKey];
            text = [NSString stringWithFormat:@"网络错误：code=%ld , %@ 点我重试." , (long)self.gp_error.code , msg];
            break;
        }
            
            
        case UITableViewErrorType_NoContent:
        {
            text = @"暂时没有内容";
            break;
        }
            
        default:
            break;
    }
    
    
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:text];
    // 设置所有字体大小为 #15
    [attStr addAttribute:NSFontAttributeName
                   value:[UIFont systemFontOfSize:14.0]
                   range:NSMakeRange(0, text.length)];
    // 设置所有字体颜色为浅灰色
    [attStr addAttribute:NSForegroundColorAttributeName
                   value:HEXCOLORA(0x606672, 1.0)
                   range:NSMakeRange(0, text.length)];
    
    return attStr;
}

/**
 *  自定义背景颜色
 */
- (UIColor *)backgroundColorForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIColor whiteColor];
}

/**
 *  设置垂直方向的偏移量 （推荐使用）
 */
- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView {
    return 0.0;
}

#pragma mark - DZNEmptyDataSetDelegate

/**
 *  数据源为空时是否渲染和显示 (默认为 YES)
 */
- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView {
    return YES;
}
/**
 *  是否允许点击 (默认为 YES)
 */
- (BOOL)emptyDataSetShouldAllowTouch:(UIScrollView *)scrollView {
    return YES;
}
/**
 *  是否允许滚动 (默认为 NO)
 */
- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView {
    return NO;
}
/**
 *  处理空白区域的点击事件
 */
- (void)emptyDataSet:(UIScrollView *)scrollView didTapView:(UIView *)view
{
    //[self load];
    if (self.retryBlock) {
        self.retryBlock();
    }
}

- (void)emptyDataSet:(UIScrollView *)scrollView didTapButton:(UIButton *)button
{
    if (self.gp_actionBlock)
    {
        self.gp_actionBlock();
    }
}

@end
