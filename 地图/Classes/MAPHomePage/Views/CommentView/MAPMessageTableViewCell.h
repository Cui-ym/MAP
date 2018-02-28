//
//  MAPMessageTableViewCell.h
//  地图
//
//  Created by 崔一鸣 on 2018/2/10.
//  Copyright © 2018年 崔一鸣. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MAPMessageTableViewCell : UITableViewCell

@property (nonatomic, strong) UIImageView *headImageView;

@property (nonatomic, strong) UILabel *nicknameLabel;

@property (nonatomic, strong) UILabel *timeLabel;

@property (nonatomic, strong) UILabel *commentLabel;

@property (nonatomic, strong) UIButton *likeBtn;

@property (nonatomic, strong) UIButton *commentBtn;

+(CGFloat)cellHeightWithComment:(NSString *)comment size:(CGSize)contextSize;

@end
