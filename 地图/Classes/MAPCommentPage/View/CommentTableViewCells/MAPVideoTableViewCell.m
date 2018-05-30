//
//  MAPVideoTableViewCell.m
//  地图
//
//  Created by 崔一鸣 on 2018/4/22.
//  Copyright © 2018年 崔一鸣. All rights reserved.
//

#import "MAPVideoTableViewCell.h"
#import "UILabel+LabelHeight.h"
#import "Masonry.h"

#define Height self.frame.size.height
#define Width self.frame.size.width

@implementation MAPVideoTableViewCell

+ (CGFloat)cellHeightWithComment:(NSString *)comment size:(CGSize)contextSize {
    NSLog(@"计算高度");
    CGFloat height = contextSize.width * 0.14 + 10 + 5 + 100 + 30 + 5;
//    CGFloat commentHeigth = [UILabel_LabelHeight getHeightByWidth:contextSize.width - 50 title:comment font:[UIFont systemFontOfSize:15.0]];
    return height;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.headImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:_headImageView];
        
        self.nicknameLabel = [[UILabel alloc] init];
        [self.contentView addSubview:_nicknameLabel];
        
        self.titleLabel = [[UILabel alloc] init];
        [self.contentView addSubview:_titleLabel];
        
        self.videoCoverImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:_videoCoverImageView];
        
        self.videoPlayBtn = [[UIButton alloc] init];
        [self.videoCoverImageView addSubview:_videoPlayBtn];
        
        self.timeLabel = [[UILabel alloc] init];
        [self.contentView addSubview:_timeLabel];
        
        self.likeBtn = [[UIButton alloc] init];
        [self.contentView addSubview:_likeBtn];
        
        self.commentBtn = [[UIButton alloc] init];
        [self.contentView addSubview:_commentBtn];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(20);
        make.top.equalTo(self.contentView.mas_top).offset(10);
        make.height.and.width.equalTo(self.contentView.mas_width).multipliedBy(0.14);
    }];
    _headImageView.layer.masksToBounds = YES;
    _headImageView.layer.borderWidth = 1;
    _headImageView.layer.borderColor = [[UIColor whiteColor] CGColor];
    _headImageView.layer.cornerRadius = self.contentView.frame.size.width * 0.07;
    _headImageView.backgroundColor = [UIColor yellowColor];
    
    [self.nicknameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_headImageView.mas_right).offset(15);
        make.bottom.equalTo(_headImageView.mas_centerY).offset(-5);
        make.right.equalTo(self.contentView.mas_right).offset(-20);
    }];
    self.nicknameLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightThin];
    self.nicknameLabel.textColor = [UIColor colorWithRed:0.5f green:0.5f blue:0.5f alpha:1.00f];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_headImageView.mas_right).offset(15);
        make.top.equalTo(_headImageView.mas_centerY).offset(5);
        make.right.equalTo(self.contentView.mas_right).offset(-20);
    }];
    self.titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightThin];
    self.titleLabel.textColor = [UIColor blackColor];
    
    
    [self.videoCoverImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headImageView.mas_bottom).offset(5);
        make.left.equalTo(self.contentView.mas_left).offset(Width * 0.25);
        make.width.equalTo(self.contentView.mas_width).multipliedBy(0.4);
        make.height.mas_equalTo(100.0);
    }];
    self.videoCoverImageView.backgroundColor = [UIColor lightGrayColor];
    self.videoCoverImageView.userInteractionEnabled = YES;
    
    [self.videoPlayBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.videoCoverImageView);
        make.height.and.width.mas_equalTo(50);
    }];
    [self.videoPlayBtn setBackgroundImage:[UIImage imageNamed:@"播放"] forState:UIControlStateNormal];
    [self.videoPlayBtn addTarget:self action:@selector(clickVideoPlayButton:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_nicknameLabel.mas_left);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-10);
        make.width.equalTo(self.contentView.mas_width).multipliedBy(0.35);
        make.height.mas_equalTo(20);
    }];
    self.timeLabel.font = [UIFont systemFontOfSize:12];
    
    [self.commentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-5);
        make.bottom.equalTo(_timeLabel.mas_bottom);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(60);
    }];
    [self.commentBtn setImage:[UIImage imageNamed:@"comt"] forState:UIControlStateNormal];
    [self.commentBtn setTitle:[NSString stringWithFormat:@"（%ld）", _commentCount] forState:UIControlStateNormal];
    self.commentBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.commentBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.commentBtn addTarget:self action:@selector(clickCommentButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.likeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_commentBtn.mas_left);
        make.bottom.equalTo(_timeLabel.mas_bottom);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(60);
    }];
    [self.likeBtn setImage:[UIImage imageNamed:@"like"] forState:UIControlStateNormal];
    [self.likeBtn setImage:[UIImage imageNamed:@"定位"] forState:UIControlStateSelected];
    self.likeBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.likeBtn setTitle:[NSString stringWithFormat:@"（%ld）", _likeCount] forState:UIControlStateNormal];
    [self.likeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.likeBtn addTarget:self action:@selector(clickLikeButton:) forControlEvents:UIControlEventTouchUpInside];
}

// 点赞
- (void)clickLikeButton:(UIButton *)sender {
    if ([_delegate respondsToSelector:@selector(clickButton: type: timeLabel:)]) {
        [_delegate clickButton:sender type:@"like" timeLabel:_timeLabel];
    }
}

// 评论
- (void)clickCommentButton:(UIButton *)sender {
    if ([_delegate respondsToSelector:@selector(clickButton: type: timeLabel:)]) {
        [_delegate clickButton:sender type:@"comment" timeLabel:_timeLabel];
    }
}

// 播放视频
- (void)clickVideoPlayButton:(UIButton *)sender {
    if ([_delegate respondsToSelector:@selector(videoPlayWithButton:Row:)]) {
        [_delegate videoPlayWithButton:sender Row:_indexRow];
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
