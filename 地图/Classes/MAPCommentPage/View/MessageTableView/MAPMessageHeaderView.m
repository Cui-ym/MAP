//
//  MAPMessageHeaderView.m
//  地图
//
//  Created by 崔一鸣 on 2018/5/15.
//  Copyright © 2018年 崔一鸣. All rights reserved.
//

#import "MAPMessageHeaderView.h"
#import "Masonry.h"

@implementation MAPMessageHeaderView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.headImageView = [[UIImageView alloc] init];
        [self addSubview:_headImageView];
        
        self.nicknameLabel = [[UILabel alloc] init];
        [self addSubview:_nicknameLabel];
        
        self.commentLabel = [[UILabel alloc] init];
        [self addSubview:_commentLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(10);
        make.left.equalTo(self.mas_left).offset(10);
        make.height.and.width.equalTo(self.mas_width).multipliedBy(0.12);
    }];
    self.headImageView.layer.masksToBounds = YES;
    self.headImageView.layer.borderWidth = 1;
    self.headImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.headImageView.layer.cornerRadius = self.frame.size.width * 0.06;
    _headImageView.backgroundColor = [UIColor orangeColor];
    [_headImageView setImage:[UIImage imageNamed:@"头像.jpg"]];
    
    [self.nicknameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.headImageView.mas_centerY).offset(-5);
        make.left.equalTo(self.headImageView.mas_right).offset(10);
        make.right.equalTo(self.mas_right).offset(-10);
    }];
    self.nicknameLabel.font = [UIFont systemFontOfSize:12];
    self.nicknameLabel.textColor = [UIColor colorWithRed:0.5f green:0.5f blue:0.5f alpha:1.00f];
    self.nicknameLabel.textAlignment = NSTextAlignmentLeft;
    
    [self.commentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headImageView.mas_centerY).offset(5);
        make.left.equalTo(self.nicknameLabel.mas_left);
        make.right.equalTo(self.nicknameLabel.mas_right);
    }];
    self.commentLabel.font = [UIFont systemFontOfSize:15];
    self.commentLabel.textColor = [UIColor blackColor];
    self.commentLabel.textAlignment = NSTextAlignmentLeft;
    self.commentLabel.numberOfLines = 0;
}

@end
