//
//  MAPPaoPaoView.m
//  地图
//
//  Created by 崔一鸣 on 2018/2/6.
//  Copyright © 2018年 崔一鸣. All rights reserved.
//

#import "MAPPaoPaoView.h"

@implementation MAPPaoPaoView


- (void)drawRect:(CGRect)rect {
    [self drawInContext:UIGraphicsGetCurrentContext()];
    
    self.layer.shadowColor = [[UIColor blackColor] CGColor];
    self.layer.shadowOpacity = 1.0;
    self.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
}

- (void)drawInContext:(CGContextRef)context {
    CGContextSetLineWidth(context, 2.0);
    CGContextSetFillColorWithColor(context, [UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:0.8].CGColor);
    
    [self getDrawPath:context];
    CGContextFillPath(context);
}

- (void)getDrawPath:(CGContextRef)context {
    CGRect rrect = self.bounds;
    CGFloat minx = CGRectGetMinX(rrect),
    maxx = CGRectGetMaxX(rrect);
    CGFloat miny = CGRectGetMinY(rrect),
    maxy = CGRectGetMaxY(rrect);
    
    CGContextMoveToPoint(context, maxx, maxy);
    CGContextAddLineToPoint(context, maxx, 2 * maxy - miny);
    CGContextAddLineToPoint(context, minx, 2 * maxy - miny);
    CGContextAddLineToPoint(context, minx, maxy);
    
    CGContextClosePath(context);
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    [self initSubViews];
    return self;
}

- (void)initSubViews {
    self.msgButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.msgButton.frame = CGRectMake(60, 5, 30, 30);
    [self.msgButton setImage:[UIImage imageNamed:@"comment"] forState:UIControlStateNormal];
    [self addSubview:self.msgButton];
    self.imgButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.imgButton.frame = CGRectMake(100, 15, 30, 30);
    [self.imgButton setImage:[UIImage imageNamed:@"image"] forState:UIControlStateNormal];
    [self addSubview:self.imgButton];
    self.voiceButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.voiceButton.frame = CGRectMake(130, 45, 30, 30);
    [self.voiceButton setImage:[UIImage imageNamed:@"voice"] forState:UIControlStateNormal];
    [self addSubview:self.voiceButton];
    self.videoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.videoButton.frame = CGRectMake(145, 85, 30, 30);
    [self.videoButton setImage:[UIImage imageNamed:@"video"] forState:UIControlStateNormal];
    [self addSubview:self.videoButton];
}
@end
