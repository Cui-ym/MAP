//
//  MAPMessageFooterView.h
//  地图
//
//  Created by 崔一鸣 on 2018/5/15.
//  Copyright © 2018年 崔一鸣. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MAPMessageFooterViewDelegate <NSObject>

- (void)clickButton:(UIButton *)sender type:(NSString *)type timeLabel:(UILabel *)timeLabel;

@end

@interface MAPMessageFooterView : UIView

@property (nonatomic, weak) id <MAPMessageFooterViewDelegate> delegate;

@property (nonatomic, strong) UILabel *timeLabel;

@property (nonatomic, strong) UIButton *likeButton;

@property (nonatomic, strong) UIButton *commentButton;

@property (nonatomic, strong) UIView *bottomLine;

@property (nonatomic, assign) long likeCount;

@property (nonatomic, assign) long commentCount;

@end
