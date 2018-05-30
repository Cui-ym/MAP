//
//  MAPAudioButton.m
//  地图
//
//  Created by 崔一鸣 on 2018/5/7.
//  Copyright © 2018年 崔一鸣. All rights reserved.
//

#import "MAPAudioButton.h"
#import "Masonry.h"

@implementation MAPAudioButton

- (instancetype)init {
    self = [super init];
    
    if (self) {
        self.audioImageView = [[UIImageView alloc] init];
        [self addSubview:_audioImageView];
        
        self.timeLabel = [[UILabel alloc] init];
        [self addSubview:_timeLabel];
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.backgroundColor = [UIColor colorWithRed:0.95f green:0.54f blue:0.54f alpha:1.00f];
    
    [_audioImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(10);
        make.top.equalTo(self.mas_top).offset(5);
        make.bottom.equalTo(self.mas_bottom).offset(-5);
        make.width.mas_equalTo(self.frame.size.height - 10);
    }];
    _audioImageView.image = [UIImage imageNamed:@"sound"];
    
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.audioImageView.mas_right).offset(5);
        make.centerY.equalTo(self);
        make.height.equalTo(self.mas_height).multipliedBy(0.6);
    }];
    _timeLabel.textColor = [UIColor whiteColor];
    _timeLabel.textAlignment = NSTextAlignmentLeft;
    
}

@end
