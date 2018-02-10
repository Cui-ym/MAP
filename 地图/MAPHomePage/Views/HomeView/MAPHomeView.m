//
//  MAPHomeView.m
//  地图
//
//  Created by 崔一鸣 on 2018/2/6.
//  Copyright © 2018年 崔一鸣. All rights reserved.
//

#import "MAPHomeView.h"
#import "Masonry.h"

@implementation MAPHomeView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.mapView = [[BMKMapView alloc] init];
        [self addSubview:_mapView];
        
        self.addButton = [[UIButton alloc] init];
        [self addSubview:_addButton];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.backgroundColor = [UIColor whiteColor];
    self.mapView.frame = self.bounds;
    BMKLocationViewDisplayParam *displayParam = [[BMKLocationViewDisplayParam alloc] init];
    // 隐藏精度圈
    displayParam.isAccuracyCircleShow = NO;
    // 设置定位图标样式
    displayParam.locationViewImgName = @"icon_center_point";
    // 地图开始定位
    [self.mapView updateLocationViewWithParam:displayParam];
    // 设置定位模式
    self.mapView.userTrackingMode = BMKUserTrackingModeHeading;
    // 显示定位图层
    self.mapView.showsUserLocation = YES;
    
    [self.addButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom);
        make.right.and.left.equalTo(self);
        make.height.equalTo(self.mas_height).multipliedBy(0.1);
    }];
    [self.addButton setImage:[UIImage imageNamed:@"add"] forState:!UIControlStateSelected];
    [self.addButton setBackgroundColor:[UIColor colorWithRed:0.95f green:0.54f blue:0.54f alpha:1.00f]];
    [self.addButton addTarget:self action:@selector(addMessage:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)addMessage:(UIButton *)button {
    if (button.selected == NO) {
        [self initMessageView];
        button.selected = YES;
    } else {
        [self.messageView removeFromSuperview];
        button.selected = NO;
    }
}

- (void)initMessageView {
    self.messageView = [[UIView alloc] init];
    [self addSubview:_messageView];
    
    self.msgButton = [[UIButton alloc] init];
    [self.messageView addSubview:_msgButton];
    
    self.imgButton = [[UIButton alloc] init];
    [self.messageView addSubview:_imgButton];
    
    self.voiceButton = [[UIButton alloc] init];
    [self.messageView addSubview:_voiceButton];
    
    self.videoButton = [[UIButton alloc] init];
    [self.messageView addSubview:_videoButton];
    
    [_messageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.width.equalTo(self.mas_width).multipliedBy(0.7);
        make.height.equalTo(self.mas_width).multipliedBy(0.7);
    }];
    
    // 添加按钮和点击后的响应事件
    self.msgButton.tag = 1001;
    [self.msgButton setTitle:@"评论" forState:UIControlStateNormal];
    [self.msgButton setImage:[UIImage imageNamed:@"comment"] forState:UIControlStateNormal];
    [self.msgButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.messageView.mas_width).multipliedBy(0.25);
        make.height.equalTo(self.messageView.mas_height).multipliedBy(0.25);
        make.left.equalTo(self.messageView.mas_right).multipliedBy(0.175);
        make.top.equalTo(self.messageView.mas_bottom).multipliedBy(0.175);
    }];
   
    self.imgButton.tag = 1002;
    [self.imgButton setImage:[UIImage imageNamed:@"image"] forState:UIControlStateNormal];
    [self.imgButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.messageView.mas_width).multipliedBy(0.25);
        make.height.equalTo(self.messageView.mas_height).multipliedBy(0.25);
        make.left.equalTo(self.messageView.mas_right).multipliedBy(0.575);
        make.top.equalTo(self.msgButton);
    }];
   
    self.voiceButton.tag = 1003;
    [self.voiceButton setImage:[UIImage imageNamed:@"voice"] forState:UIControlStateNormal];
    [self.voiceButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.messageView.mas_width).multipliedBy(0.25);
        make.height.equalTo(self.messageView.mas_height).multipliedBy(0.25);
        make.left.equalTo(_messageView.mas_right).multipliedBy(0.175);
        make.top.equalTo(_messageView.mas_bottom).multipliedBy(0.575);
    }];

    self.videoButton.tag = 1004;
    [self.videoButton setImage:[UIImage imageNamed:@"video"] forState:UIControlStateNormal];
    [self.videoButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.messageView.mas_width).multipliedBy(0.25);
        make.height.equalTo(self.messageView.mas_height).multipliedBy(0.25);
        make.left.equalTo(_messageView.mas_right).multipliedBy(0.575);
        make.top.equalTo(_messageView.mas_bottom).multipliedBy(0.575);
    }];
    
    
    // 设置圆角和背景颜色
    _messageView.backgroundColor = [UIColor colorWithRed:0.95f green:0.54f blue:0.54f alpha:1.00f];
    _messageView.layer.masksToBounds = YES;
    _messageView.layer.cornerRadius = self.frame.size.width * 0.35;
}

@end
