//
//  MAPMessageReplyTableViewCell.m
//  地图
//
//  Created by 崔一鸣 on 2018/5/18.
//  Copyright © 2018年 崔一鸣. All rights reserved.
//

#import "MAPMessageReplyTableViewCell.h"
#import "Masonry.h"

@implementation MAPMessageReplyTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.headImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:_headImageView];
        
        self.nicknameLabel = [[UILabel alloc] init];
        [self.contentView addSubview:_nicknameLabel];
        
        self.timeLabel = [[UILabel alloc] init];
        [self.contentView addSubview:_timeLabel];
        
        self.commentLabel = [[UILabel alloc] init];
        [self.contentView addSubview:_commentLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(5);
        make.left.equalTo(self.contentView.mas_left).offset(5);
        make.height.and.width.equalTo(self.contentView.mas_width).multipliedBy(0.12);
    }];
    self.headImageView.layer.masksToBounds = YES;
    self.headImageView.layer.cornerRadius = self.contentView.frame.size.width * 0.06;
    self.headImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.headImageView.layer.borderWidth = 1;
    
    [self.nicknameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.headImageView.mas_centerY).offset(-5);
        make.left.equalTo(self.headImageView.mas_right).offset(5);
        make.right.equalTo(self.contentView.mas_right).offset(-10);
    }];
    self.nicknameLabel.textColor = [UIColor orangeColor];
    self.nicknameLabel.font = [UIFont systemFontOfSize:12];
    self.nicknameLabel.textAlignment = NSTextAlignmentLeft;
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headImageView.mas_centerY).offset(5);
        make.left.and.right.equalTo(self.nicknameLabel);
    }];
    self.timeLabel.font = [UIFont systemFontOfSize:12];
    self.timeLabel.textColor = [UIColor lightGrayColor];
    self.timeLabel.textAlignment = NSTextAlignmentLeft;
    
    [self.commentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.nicknameLabel);
        make.top.equalTo(self.headImageView.mas_bottom).offset(5);
    }];
    self.commentLabel.textColor = [UIColor blackColor];
    self.commentLabel.textAlignment = NSTextAlignmentLeft;
    self.commentLabel.font = [UIFont systemFontOfSize:15];
    
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
