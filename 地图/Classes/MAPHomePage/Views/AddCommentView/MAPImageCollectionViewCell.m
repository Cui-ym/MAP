//
//  MAPImageCollectionViewCell.m
//  地图
//
//  Created by 崔一鸣 on 2018/3/7.
//  Copyright © 2018年 崔一鸣. All rights reserved.
//

#import "MAPImageCollectionViewCell.h"

@implementation MAPImageCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [self.contentView addSubview:_imageView];
    }
    return self;
}

@end
