//
//  MAPGetCommentButton.m
//  地图
//
//  Created by 崔一鸣 on 2018/3/9.
//  Copyright © 2018年 崔一鸣. All rights reserved.
//

#import "MAPGetCommentButton.h"

@implementation MAPGetCommentButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.countLabel = [[UILabel alloc] init];
        [self addSubview:_countLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.countLabel.backgroundColor = [UIColor colorWithRed:0.76f green:0.22f blue:0.15f alpha:1.00f];
    self.countLabel.textColor = [UIColor whiteColor];
    self.countLabel.layer.masksToBounds = YES;
    self.countLabel.layer.cornerRadius = 13;
    self.countLabel.textAlignment = NSTextAlignmentCenter;
    self.countLabel.frame = CGRectMake(32, -13, 26, 26);
}

@end
