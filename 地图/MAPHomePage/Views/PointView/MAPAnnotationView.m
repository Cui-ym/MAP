//
//  MAPAnnotationView.m
//  地图
//
//  Created by 崔一鸣 on 2018/2/6.
//  Copyright © 2018年 崔一鸣. All rights reserved.
//

#import "MAPAnnotationView.h"

@interface MAPAnnotationView ()

@property (nonatomic, strong, readwrite) MAPPaoPaoView *paoView;

@end

@implementation MAPAnnotationView

- (id)initWithAnnotation:(id<BMKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.image = [UIImage imageNamed:@"info.png"];
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected {
    NSLog(@"点击");
    if (self.selected == selected) {
        return;
    }
    
    if (selected) {
        if (self.paoView == nil) {
            
            self.paoView = [[MAPPaoPaoView alloc] initWithFrame:CGRectMake(-80, -80, 140, 140)];
        }
        
        [self addSubview:self.paoView];
    } else {
        [self.paoView removeFromSuperview];
    }
    
    [super setSelected:selected];
}

@end
