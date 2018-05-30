//
//  MAPAnnotationView.h
//  地图
//
//  Created by 崔一鸣 on 2018/2/6.
//  Copyright © 2018年 崔一鸣. All rights reserved.
//

#import <BaiduMapAPI_Map/BMKAnnotationView.h>
#import "MAPGetCommentButton.h"

@protocol MAPAnnotationViewDelegate <NSObject>

@required
- (void)addCommentViewWithStyle:(int)style pointID:(int)pointId;

@end

@interface MAPAnnotationView : BMKAnnotationView

@property (nonatomic, weak) id<MAPAnnotationViewDelegate> delegate;

@property (nonatomic, assign) int pointId;

@property (nonatomic, copy) NSString *pointName;

@property (nonatomic, strong) UIView *paoView;

@property (nonatomic, strong) UILabel *sumLabel;

@property (nonatomic, assign) int commentCount;

@property (nonatomic, assign) int mesCount;

@property (nonatomic, assign) int phoCount;

@property (nonatomic, assign) int vidCount;

@property (nonatomic, assign) int audCount;

@property (nonatomic, strong) MAPGetCommentButton *msgButton;

@property (nonatomic, strong) MAPGetCommentButton *imgButton;

@property (nonatomic, strong) MAPGetCommentButton *voiceButton;

@property (nonatomic, strong) MAPGetCommentButton *videoButton;

@end
