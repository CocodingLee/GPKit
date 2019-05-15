//
//  GPFrameLossCell.m
//  GPPerformance
//
//  Created by Liyanwei on 2019/5/15.
//  Copyright © 2019 Liyanwei. All rights reserved.
//

#import "GPFrameLossCell.h"
#import <Masonry/Masonry.h>
#import <GPUIKit/GPUIKit.h>

@interface GPFrameLossCell ()
@property (nonatomic, strong) UILabel *contentLb;
@property (nonatomic, strong) UILabel *dateLb;
@property (nonatomic, strong) UILabel *infoLb;
@end

@implementation GPFrameLossCell

- (UILabel *)contentLb
{
    if (!_contentLb) {
        _contentLb = [[UILabel alloc] init];
        _contentLb.numberOfLines = 0;
        _contentLb.font = [UIFont systemFontOfSize:14];
        _contentLb.textColor = [UIColor grayColor];
    }
    
    return _contentLb;
}

- (UILabel *)dateLb
{
    if (!_dateLb) {
        _dateLb = [[UILabel alloc] init];
        _dateLb.font = [UIFont boldSystemFontOfSize:14];
        _dateLb.textColor = [UIColor grayColor];
    }
    
    return _dateLb;
}

- (UILabel *)infoLb
{
    if (!_infoLb) {
        _infoLb = [[UILabel alloc] init];
        _infoLb.font = [UIFont boldSystemFontOfSize:14];
        _infoLb.textColor = [UIColor redColor];
    }
    return _infoLb;
}

- (void) prepareForReuse
{
    [super prepareForReuse];
    self.dateLb.text = @"";
    self.infoLb.text = @"";
    self.contentLb.text = @"";
}

- (void)buildUI
{
    if (!self.dateLb.superview) {
        [self.contentView addSubview:self.dateLb];
    }
    
    if (!self.infoLb.superview) {
        [self.contentView addSubview:self.infoLb];
    }
    
    if (!self.contentLb.superview) {
        [self.contentView addSubview:self.contentLb];
    }

    [self.dateLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self).offset(10);
    }];
    
    [self.infoLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.dateLb.mas_right).offset(20);
        make.top.equalTo(self.dateLb);
    }];
    
    [self.contentLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.dateLb).offset(10);
        make.top.equalTo(self.dateLb.mas_bottom).offset(10);
        make.right.bottom.equalTo(self).offset(-10);
    }];
}

- (void)updateWithModel:(GPCallStackModel *)model
{
    [self buildUI];
    
    self.contentLb.text = model.stackStr;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss z"];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:model.dateString];
    self.dateLb.text = [formatter stringFromDate:date];
    [self.dateLb sizeToFit];
    
    if (model.isStuck) {
        self.infoLb.text = @"卡顿问题";
        self.infoLb.textColor = [UIColor redColor];
    } else {
        self.infoLb.text = @"CPU负载高";
        self.infoLb.textColor = [UIColor orangeColor];
    }
    
    [self.infoLb sizeToFit];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.contentLb.preferredMaxLayoutWidth = self.contentLb.frame.size.width;
}


@end
