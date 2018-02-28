//
//  MAPMessageTableViewCell.m
//  地图
//
//  Created by 崔一鸣 on 2018/2/10.
//  Copyright © 2018年 崔一鸣. All rights reserved.
//

#import "UILabel+LabelHeight.h"
#import "MAPMessageTableViewCell.h"
#import "Masonry.h"

@implementation MAPMessageTableViewCell

+ (CGFloat)cellHeightWithComment:(NSString *)comment size:(CGSize)contextSize {
    CGFloat commentHeigth = [UILabel_LabelHeight getHeightByWidth:contextSize.width - 80 title:comment font:[UIFont systemFontOfSize:15.0]];
    return commentHeigth + 80;
}

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
        
        self.commentBtn = [[UIButton alloc] init];
        [self.contentView addSubview:_commentBtn];
        
        self.likeBtn = [[UIButton alloc] init];
        [self.contentView addSubview:_likeBtn];
        
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(20);
        make.top.equalTo(self.contentView.mas_top).offset(20);
        make.height.and.width.mas_equalTo(30);
    }];
    _headImageView.layer.masksToBounds = YES;
    _headImageView.layer.borderWidth = 1;
    _headImageView.layer.borderColor = [[UIColor whiteColor] CGColor];
    _headImageView.layer.cornerRadius = 15;
    _headImageView.backgroundColor = [UIColor yellowColor];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-10);
        make.top.equalTo(_headImageView.mas_top);
        make.width.equalTo(self.contentView.mas_width).multipliedBy(0.35);
        make.height.mas_equalTo(20);
    }];
    self.timeLabel.font = [UIFont systemFontOfSize:12];
    
    [self.nicknameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_headImageView.mas_right).offset(15);
        make.top.equalTo(_headImageView.mas_top);
        make.right.equalTo(_timeLabel.mas_left).offset(-20);
    }];
    self.nicknameLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightThin];
    self.nicknameLabel.textColor = [UIColor colorWithRed:0.5f green:0.5f blue:0.5f alpha:1.00f];
    
    [self.commentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_headImageView.mas_bottom).offset(15);
        make.left.equalTo(_headImageView.mas_right);
        make.right.equalTo(self.contentView.mas_right).offset(-30);
    }];
    _commentLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightThin];
    _commentLabel.numberOfLines = 0;
    
    
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
