//
//  MAPVideoBottomView.m
//  地图
//
//  Created by 崔一鸣 on 2018/4/24.
//  Copyright © 2018年 崔一鸣. All rights reserved.
//

#import "MAPVideoBottomView.h"
#import "Masonry.h"

@implementation MAPVideoBottomView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:0.54f green:0.54f blue:0.54f alpha:0.50f];
        
        self.playButton = [[UIButton alloc] init];
        [self addSubview:_playButton];
        
        self.videoSlider = [[UISlider alloc] init];
        [self addSubview:_videoSlider];
        
        self.timeLabel = [[UILabel alloc] init];
        [self addSubview:_timeLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom).offset(-10);
        make.right.equalTo(self.mas_right).offset(-20);
        make.width.equalTo(self.mas_width);
        make.height.mas_equalTo(20);
    }];
    self.timeLabel.text = @"00:00";
    self.timeLabel.textColor = [UIColor whiteColor];
    self.timeLabel.textAlignment = NSTextAlignmentRight;
    self.timeLabel.font = [UIFont systemFontOfSize:15];
    
    [self.videoSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.timeLabel.mas_top);
        make.left.equalTo(self.mas_left).offset(10);
        make.right.equalTo(self.mas_right).offset(-10);
        make.height.mas_equalTo(20.0);
        make.centerX.equalTo(self.mas_centerX);
    }];
    [self.videoSlider setThumbImage:[UIImage imageNamed:@"点"] forState:UIControlStateNormal];
    
    [self.playButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-10);
        make.top.equalTo(self.mas_top);
        make.width.and.height.mas_equalTo(50);
    }];
    [self.playButton setImage:[UIImage imageNamed:@"播放"] forState:UIControlStateNormal];
    [self.playButton addTarget:self action:@selector(clickPlayButton:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)clickPlayButton:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(videoPlay)]) {
        [_delegate videoPlay];
    }
}

@end
