//
//  MAPMessageFooterView.m
//  地图
//
//  Created by 崔一鸣 on 2018/5/15.
//  Copyright © 2018年 崔一鸣. All rights reserved.
//

#import "MAPMessageFooterView.h"
#import "Masonry.h"

@implementation MAPMessageFooterView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(frame.size.width * 0.12 + 20, 5, frame.size.width * 0.5, 20)];
        [self addSubview:_timeLabel];
        
        self.likeButton = [[UIButton alloc] init];
        [self addSubview:_likeButton];
        
        self.commentButton = [[UIButton alloc] init];
        [self addSubview:_commentButton];
        
        self.bottomLine = [[UIView alloc] init];
        [self addSubview:_bottomLine];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.timeLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightThin];
    self.timeLabel.textColor = [UIColor blackColor];
    self.timeLabel.textAlignment = NSTextAlignmentLeft;
    
    [self.commentButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-10);
        make.bottom.equalTo(self.mas_bottom).offset(-3);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(30);
    }];
    [self.commentButton setImage:[UIImage imageNamed:@"comt"] forState:UIControlStateNormal];
    [self.commentButton setTitle:[NSString stringWithFormat:@" %ld", _commentCount] forState:UIControlStateNormal];
    self.commentButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.commentButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.commentButton addTarget:self action:@selector(clickCommentButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.likeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_commentButton.mas_left);
        make.bottom.equalTo(self.mas_bottom).offset(-3);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(60);
    }];
    [self.likeButton setImage:[UIImage imageNamed:@"like"] forState:UIControlStateNormal];
    [self.likeButton setImage:[UIImage imageNamed:@"定位"] forState:UIControlStateSelected];
    self.likeButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.likeButton setTitle:[NSString stringWithFormat:@" %ld", _likeCount] forState:UIControlStateNormal];
    [self.likeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.likeButton addTarget:self action:@selector(clickLikeButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self);
        make.bottom.equalTo(self);
        make.height.mas_equalTo(1);
    }];
    _bottomLine.backgroundColor = [UIColor lightGrayColor];
}

- (void)clickCommentButton:(UIButton *)sender {
    if([_delegate respondsToSelector:@selector(clickButton:type:timeLabel:)]) {
        [_delegate clickButton:sender type:@"comment" timeLabel:_timeLabel];
    }
}

- (void)clickLikeButton:(UIButton *)sender {
    if (sender.selected == NO) {
        sender.selected = YES;
    } else {
        sender.selected = NO;
    }
    
    if ([_delegate respondsToSelector:@selector(clickButton:type:timeLabel:)]) {
        [_delegate clickButton:sender type:@"like" timeLabel:_timeLabel];
    }
    
}

@end
