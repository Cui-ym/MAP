//
//  MAPMessageReplyHeaderView.m
//  地图
//
//  Created by 崔一鸣 on 2018/5/17.
//  Copyright © 2018年 崔一鸣. All rights reserved.
//

#import "MAPMessageReplyHeaderView.h"
#import "Masonry.h"

@implementation MAPMessageReplyHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.headImageView = [[UIImageView alloc] init];
        [self addSubview:_headImageView];
        
        self.nicknameLabel = [[UILabel alloc] init];
        [self addSubview:_nicknameLabel];
        
        self.commentLabel = [[UILabel alloc] init];
        [self addSubview:_commentLabel];
        
        self.timeLabel = [[UILabel alloc] init];
        [self addSubview:_timeLabel];
        
        self.likeButton = [[UIButton alloc] init];
        [self addSubview:_likeButton];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(10);
        make.width.and.height.equalTo(self.mas_width).multipliedBy(0.12);
        make.top.equalTo(self.mas_top).offset(5);
    }];
    self.headImageView.layer.masksToBounds = YES;
    self.headImageView.layer.cornerRadius = self.frame.size.width * 0.06;
    self.headImageView.layer.borderWidth = 1;
    self.headImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.headImageView.image = [UIImage imageNamed:@"头像.jpg"];
    
    [self.likeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-10);
        make.top.equalTo(self.headImageView.mas_height);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(30);
    }];
    
    [self.nicknameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(30);
        make.right.equalTo(self.likeButton.mas_left);
        make.left.equalTo(self.headImageView.mas_right).offset(10);
        make.bottom.equalTo(self.headImageView.mas_centerY).offset(-5);
    }];
    self.nicknameLabel.font = [UIFont systemFontOfSize:15];
    self.nicknameLabel.textColor = [UIColor whiteColor];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.and.left.equalTo(self.nicknameLabel.mas_left);
        make.top.equalTo(self.headImageView.mas_centerY).offset(5);
        make.height.mas_equalTo(30);
    }];
    self.timeLabel.textColor = [UIColor lightGrayColor];
    self.timeLabel.font = [UIFont systemFontOfSize:12];
    
    [self.commentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nicknameLabel.mas_left);
        make.top.equalTo(self.headImageView.mas_bottom).offset(5);
        make.right.equalTo(self.mas_right).offset(-10);
    }];
    self.commentLabel.font = [UIFont systemFontOfSize:15];
    self.commentLabel.textAlignment = NSTextAlignmentLeft;
    self.commentLabel.textColor = [UIColor blackColor];
    
    
}

@end
