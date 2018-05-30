//
//  MAPReplyButton.m
//  地图
//
//  Created by 崔一鸣 on 2018/5/17.
//  Copyright © 2018年 崔一鸣. All rights reserved.
//

#import "MAPReplyButton.h"
#import "Masonry.h"

@implementation MAPReplyButton

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        self.headImageView = [[UIImageView alloc] init];
        [self addSubview:_headImageView];
        
        self.replyLabel = [[UILabel alloc] init];
        [self addSubview:_replyLabel];
        
        self.topLine = [[UIView alloc] init];
        [self addSubview:_topLine];
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.backgroundColor = [UIColor whiteColor];
    
    [self.topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.left.and.right.equalTo(self);
        make.height.mas_equalTo(2);
    }];
    self.topLine.backgroundColor = [UIColor colorWithRed:0.93f green:0.93f blue:0.93f alpha:1.00f];
    
    [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(10);
        make.height.and.width.equalTo(self.mas_height).multipliedBy(0.6);
        make.centerY.equalTo(self.mas_centerY);
    }];
    self.headImageView.layer.masksToBounds = YES;
    self.headImageView.layer.borderWidth = 1;
    self.headImageView.layer.cornerRadius = self.frame.size.height * 0.3;
    self.headImageView.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.headImageView.image = [UIImage imageNamed:@"头像.JPG"];
    
    [self.replyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headImageView.mas_right).offset(10);
        make.right.equalTo(self.mas_right).offset(-10);
        make.centerY.equalTo(self.mas_centerY);
        make.height.equalTo(self.mas_height).multipliedBy(0.6);
    }];
    self.replyLabel.text = @"  回复";
    self.replyLabel.font = [UIFont systemFontOfSize:15];
    self.replyLabel.textColor = [UIColor colorWithRed:0.79f green:0.79f blue:0.79f alpha:1.00f];
    self.replyLabel.backgroundColor = [UIColor colorWithRed:0.91f green:0.91f blue:0.91f alpha:1.00f];
    
}

@end
