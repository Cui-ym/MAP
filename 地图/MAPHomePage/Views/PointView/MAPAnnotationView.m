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
        self.image = [UIImage imageNamed:@"info.png"];
        // 设置泡泡的偏移量
        self.calloutOffset = CGPointMake(60, 30);
        [self initPaoPaoView];
    }
    return self;
}

- (void)initPaoPaoView {
    self.paoView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 140, 140)];
    self.paoView.backgroundColor = [UIColor clearColor];
    
    self.msgButton.tag = 10001;
    self.msgButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.msgButton.frame = CGRectMake(0, 0, 45, 45);
    [self.msgButton setImage:[UIImage imageNamed:@"comment"] forState:UIControlStateNormal];
    [self.msgButton addTarget:self action:@selector(addCommentView:) forControlEvents:UIControlEventTouchUpInside];
    [self.paoView addSubview:self.msgButton];
    
    self.imgButton.tag = 10002;
    self.imgButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.imgButton.frame = CGRectMake(45, 20, 45, 45);
    [self.imgButton setImage:[UIImage imageNamed:@"image"] forState:UIControlStateNormal];
    [self.imgButton addTarget:self action:@selector(addCommentView:) forControlEvents:UIControlEventTouchUpInside];
    [self.paoView addSubview:self.imgButton];
    
    self.voiceButton.tag = 10003;
    self.voiceButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.voiceButton.frame = CGRectMake(80, 55, 45, 45);
    [self.voiceButton setImage:[UIImage imageNamed:@"voice"] forState:UIControlStateNormal];
    [self.voiceButton addTarget:self action:@selector(addCommentView:) forControlEvents:UIControlEventTouchUpInside];
    [self.paoView addSubview:self.voiceButton];
    
    self.videoButton.tag = 10004;
    self.videoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.videoButton.frame = CGRectMake(100, 100, 45, 45);
    [self.videoButton setImage:[UIImage imageNamed:@"video"] forState:UIControlStateNormal];
    [self.videoButton addTarget:self action:@selector(addCommentView:) forControlEvents:UIControlEventTouchUpInside];
    [self.paoView addSubview:self.videoButton];
    
    self.paopaoView = [[BMKActionPaopaoView alloc]initWithCustomView:self.paoView];
    self.paopaoView.frame = CGRectMake(0, 0, 200, 140);
    
}

- (void)addCommentView:(UIButton *)button {
    NSString *str = @"";
    if (button.tag == 10001) {
        str = @"message";
    } else if (button.tag == 10002) {
        str = @"image";
    } else if (button.tag == 10003) {
        str = @"voice";
    } else {
        str = @"video";
    }
    NSLog(@"--点击按钮%@", str);
    if ([_delegate respondsToSelector:@selector(addCommentView:)]) {
        [_delegate addCommentView:str];
    }
}

@end
