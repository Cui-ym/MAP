//
//  MAPCommentView.m
//  地图
//
//  Created by 崔一鸣 on 2018/2/10.
//  Copyright © 2018年 崔一鸣. All rights reserved.
//

#import "MAPCommentView.h"
#import "Masonry.h"

@implementation MAPCommentView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.blurryView = [[UIView alloc] initWithFrame:frame];
        [self addSubview:_blurryView];
        
        self.commentTableView = [[UITableView alloc] init];
        [self addSubview:_commentTableView];
        
        self.cancelButton = [[UIButton alloc] init];
        [self addSubview:_cancelButton];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    // 给背景添加毛玻璃效果
    self.blurryView.backgroundColor = [UIColor clearColor];
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:self.frame];
    toolbar.barStyle = UIBarStyleBlackTranslucent;
    [self.blurryView addSubview:toolbar];
    
    // 设置 tableView
    self.commentTableView.layer.masksToBounds = YES;
    self.commentTableView.layer.cornerRadius = 10.0;
    [self.commentTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.width.equalTo(self.mas_width).multipliedBy(0.8);
        make.top.equalTo(self.mas_top).offset(64);
        make.bottom.equalTo(self.mas_bottom).offset(-80);
    }];
    
    // 设置取消按钮
    self.cancelButton.layer.masksToBounds = YES;
    self.cancelButton.layer.cornerRadius = 20;
    self.cancelButton.layer.borderWidth = 1.0;
    self.cancelButton.layer.borderColor = [UIColor whiteColor].CGColor;
    [self.cancelButton setImage:[UIImage imageNamed:@"cancel"] forState:UIControlStateNormal];
    [self.cancelButton addTarget:self action:@selector(removeView) forControlEvents:UIControlEventTouchUpInside];
    [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.commentTableView.mas_bottom).offset(20);
        make.height.and.width.mas_equalTo(40);
    }];
}

- (void)removeView {
    if ([_delegate respondsToSelector:@selector(removeCommentView)]) {
        [self.delegate removeCommentView];
    }
}

@end
