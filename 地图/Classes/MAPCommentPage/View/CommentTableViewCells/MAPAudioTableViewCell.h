//
//  MAPAudioTableViewCell.h
//  地图
//
//  Created by 崔一鸣 on 2018/5/6.
//  Copyright © 2018年 崔一鸣. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MAPAudioButton.h"

@protocol MAPAudioTableViewCellDelegate<NSObject>

- (void)audioPlayWithButton:(UIButton *)sender Row:(NSInteger)row;

@end


@interface MAPAudioTableViewCell : UITableViewCell

@property (nonatomic, weak) id<MAPAudioTableViewCellDelegate> delegate;

@property (nonatomic, strong) UIImageView *headImageView;

@property (nonatomic, strong) UILabel *nicknameLabel;

@property (nonatomic, strong) MAPAudioButton *audioButton;

@property (nonatomic, assign) NSInteger row;

@property (nonatomic, assign) long commentCount;

@property (nonatomic, assign) long likeCount;

@property (nonatomic, strong) UILabel *timeLabel;

@property (nonatomic, strong) UIButton *likeBtn;

@property (nonatomic, strong) UIButton *commentBtn;

@end
