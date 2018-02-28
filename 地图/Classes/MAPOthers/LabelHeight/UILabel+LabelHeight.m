//
//  UILabel+LabelHeight.m
//  ONE
//
//  Created by 崔一鸣 on 2017/10/6.
//  Copyright © 2017年 崔一鸣. All rights reserved.
//

#import "UILabel+LabelHeight.h"

@implementation UILabel_LabelHeight

+ (CGFloat)getHeightByWidth:(CGFloat)width title:(NSString *)title font:(UIFont *)font {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, 0)];
    label.text = title;
    label.font = font;
    label.numberOfLines = 0;
    [label sizeToFit];
    CGFloat height = label.frame.size.height;
    return height;
}

@end
