//
//  MAPAnnotationView.m
//  地图
//
//  Created by 崔一鸣 on 2018/2/6.
//  Copyright © 2018年 崔一鸣. All rights reserved.
//

#import "MAPAnnotationView.h"

@interface MAPAnnotationView ()

@end

@implementation MAPAnnotationView

- (id)initWithAnnotation:(id<BMKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self) {
        if (self.commentCount == 0) {
            self.paopaoView = nil;
            self.image = [UIImage imageNamed:@"local"];
        } else {
            self.sumLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 45, 30)];
            self.sumLabel.text = [NSString stringWithFormat:@"%d", _commentCount];
            _sumLabel.textAlignment = NSTextAlignmentCenter;
            self.sumLabel.textColor = [UIColor whiteColor];
            self.image = [UIImage imageNamed:@"info"];
            [self addSubview:_sumLabel];
            // 初始化paopaoView
            [self initPaoPaoView];
            // 设置泡泡的偏移量
            self.calloutOffset = CGPointMake(60, 30);
        }
    }
    return self;
}

- (void)initPaoPaoView {
    self.paoView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 140, 140)];
    self.paoView.backgroundColor = [UIColor clearColor];
    
    self.msgButton = [[MAPGetCommentButton alloc] initWithFrame:CGRectMake(0, 0, 45, 45)];
    self.msgButton.tag = 101;
    self.msgButton.countLabel.text = [NSString stringWithFormat:@"%d", _mesCount];
    [self.msgButton setImage:[UIImage imageNamed:@"comment"] forState:UIControlStateNormal];
    [self.msgButton addTarget:self action:@selector(addCommentView:) forControlEvents:UIControlEventTouchUpInside];
    [self.paoView addSubview:self.msgButton];
    
    self.imgButton = [[MAPGetCommentButton alloc] initWithFrame:CGRectMake(45, 20, 45, 45)];
    self.imgButton.tag = 102;
    self.imgButton.countLabel.text = [NSString stringWithFormat:@"%d", _phoCount];
    [self.imgButton setImage:[UIImage imageNamed:@"image"] forState:UIControlStateNormal];
    [self.imgButton addTarget:self action:@selector(addCommentView:) forControlEvents:UIControlEventTouchUpInside];
    [self.paoView addSubview:self.imgButton];
    
    self.voiceButton = [[MAPGetCommentButton alloc] initWithFrame:CGRectMake(80, 55, 45, 45)];
    self.voiceButton.tag = 103;
    self.voiceButton.countLabel.text = [NSString stringWithFormat:@"%d", _audCount];
    [self.voiceButton setImage:[UIImage imageNamed:@"voice"] forState:UIControlStateNormal];
    [self.voiceButton addTarget:self action:@selector(addCommentView:) forControlEvents:UIControlEventTouchUpInside];
    [self.paoView addSubview:self.voiceButton];
    
    self.videoButton = [[MAPGetCommentButton alloc] initWithFrame:CGRectMake(100, 100, 45, 45)];
    self.videoButton.tag = 104;
    self.videoButton.countLabel.text = [NSString stringWithFormat:@"%d", _vidCount];
    [self.videoButton setImage:[UIImage imageNamed:@"video"] forState:UIControlStateNormal];
    [self.videoButton addTarget:self action:@selector(addCommentView:) forControlEvents:UIControlEventTouchUpInside];
    [self.paoView addSubview:self.videoButton];
    
    self.paopaoView = [[BMKActionPaopaoView alloc]initWithCustomView:self.paoView];
    self.paopaoView.frame = CGRectMake(0, 0, 200, 140);
    
}

- (void)addCommentView:(UIButton *)sender {
    int type;
    if (sender.tag == 101) {
        type = 0;
    } else if (sender.tag == 102) {
        type = 1;
    } else if (sender.tag == 103) {
        type = 2;
    } else {
        type = 3;
    }
    NSLog(@"点击了");
    if ([_delegate respondsToSelector:@selector(addCommentViewWithStyle:pointID:)]) {
        [_delegate addCommentViewWithStyle:type pointID:_pointId];
    }
}

@end
