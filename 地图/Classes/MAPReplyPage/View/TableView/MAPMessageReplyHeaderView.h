//
//  MAPMessageReplyHeaderView.h
//  地图
//
//  Created by 崔一鸣 on 2018/5/17.
//  Copyright © 2018年 崔一鸣. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MAPMessageReplyHeaderView : UIView

@property (nonatomic, strong) UIImageView *headImageView;

@property (nonatomic, strong) UILabel *nicknameLabel;

@property (nonatomic, strong) UILabel *commentLabel;

@property (nonatomic, strong) UIButton *likeButton;

@property (nonatomic, strong) UILabel *timeLabel;

@property (nonatomic, assign) int likeCount;

@end
