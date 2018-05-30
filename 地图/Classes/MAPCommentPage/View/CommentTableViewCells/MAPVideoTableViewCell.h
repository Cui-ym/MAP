//
//  MAPVideoTableViewCell.h
//  地图
//
//  Created by 崔一鸣 on 2018/4/22.
//  Copyright © 2018年 崔一鸣. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MAPVideoTableViewCellDelegate <NSObject>

- (void)clickButton:(UIButton *)sender type:(NSString *)type timeLabel:(UILabel *)timeLabel;

- (void)videoPlayWithButton:(UIButton *)sender Row:(int)row;

@end

@interface MAPVideoTableViewCell : UITableViewCell

@property (nonatomic, weak) id<MAPVideoTableViewCellDelegate> delegate;

@property (nonatomic, strong) UIImageView *headImageView;

@property (nonatomic, strong) UILabel *nicknameLabel;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, assign) long commentCount;

@property (nonatomic, assign) long likeCount;

@property (nonatomic, assign) int indexRow;

@property (nonatomic, strong) UILabel *timeLabel;

@property (nonatomic, strong) UIImageView *videoCoverImageView;

@property (nonatomic, strong) UIButton *videoPlayBtn;

@property (nonatomic, strong) UIButton *likeBtn;

@property (nonatomic, strong) UIButton *commentBtn;

+(CGFloat)cellHeightWithComment:(NSString *)comment size:(CGSize)contextSize;

@end
