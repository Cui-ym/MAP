//
//  MAPVideoBottomView.h
//  地图
//
//  Created by 崔一鸣 on 2018/4/24.
//  Copyright © 2018年 崔一鸣. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MAPVideoBottmViewDelegate <NSObject>

- (void)videoPlay;

@end

@interface MAPVideoBottomView : UIView

@property (nonatomic, weak) id<MAPVideoBottmViewDelegate> delegate;

@property (nonatomic, strong) UIButton *playButton;

@property (nonatomic, strong) UILabel *timeLabel;

@property (nonatomic, strong) UISlider *videoSlider;

@end
