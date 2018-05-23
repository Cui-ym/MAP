//
//  MAPMessageTableViewCell.m
//  地图
//
//  Created by 崔一鸣 on 2018/2/10.
//  Copyright © 2018年 崔一鸣. All rights reserved.
//

#import "UILabel+LabelHeight.h"
#import "MAPMessageTableViewCell.h"
#import "MAPReplyModel.h"
#import "Masonry.h"
#import "YYLabel.h"

@interface MAPMessageTableViewCell()

@property (nonatomic, strong) YYLabel *commentLabel;

@property (nonatomic, strong) MAPReplyModel *replyModel;

@end

@implementation MAPMessageTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.replyModel = [[MAPReplyModel alloc] init];
        self.replyModel.type = @"reply";
        
        self.commentLabel = [[YYLabel alloc] init];
        [self.contentView addSubview:_commentLabel];
    }
    return self;
}

- (void)setFrame:(CGRect)frame {
    self.backgroundColor = [UIColor colorWithRed:0.93f green:0.93f blue:0.93f alpha:1.00f];
    frame.origin.x += frame.size.width * 0.12 + 20;
    frame.size.width -= (frame.size.width * 0.12 + 20 + 20);
    [super setFrame:frame];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.replyModel.fromUser = _fromUser;
    self.replyModel.toUser = _toUser;
    self.replyModel.text = _comment;
    _commentLabel.attributedText = [_replyModel getAttributedReplyString];
    [_commentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(10);
        make.right.equalTo(self.mas_right).offset(-10);
        make.top.equalTo(self.mas_top);
        make.height.mas_equalTo(30.0);
    }];
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
