//
//  MAPAnnotationView.h
//  地图
//
//  Created by 崔一鸣 on 2018/2/6.
//  Copyright © 2018年 崔一鸣. All rights reserved.
//

#import <BaiduMapAPI_Map/BMKAnnotationView.h>

@protocol MAPAnnotationViewDelegate <NSObject>

@required
- (void)addCommentView:(NSString *)style;

@end

@interface MAPAnnotationView : BMKAnnotationView

@property (nonatomic, weak) id<MAPAnnotationViewDelegate> delegate;

@property (nonatomic, strong) UIView *paoView;

@property (nonatomic, strong) UIButton *msgButton;

@property (nonatomic, strong) UIButton *imgButton;

@property (nonatomic, strong) UIButton *voiceButton;

@property (nonatomic, strong) UIButton *videoButton;

@end
