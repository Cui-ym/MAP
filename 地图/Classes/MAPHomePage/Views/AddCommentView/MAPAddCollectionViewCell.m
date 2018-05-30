//
//  MAPAddCollectionViewCell.m
//  地图
//
//  Created by 崔一鸣 on 2018/3/7.
//  Copyright © 2018年 崔一鸣. All rights reserved.
//

#import "MAPAddCollectionViewCell.h"

@implementation MAPAddCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [self.contentView addSubview:_button];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [_button setBackgroundColor:[UIColor blackColor]];
    _button.imageView.image = [UIImage imageNamed:@"add"];
}

@end
