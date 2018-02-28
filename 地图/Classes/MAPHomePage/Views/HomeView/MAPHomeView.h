//
//  MAPHomeView.h
//  地图
//
//  Created by 崔一鸣 on 2018/2/6.
//  Copyright © 2018年 崔一鸣. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>

@protocol MAPHomeViewDelegate <NSObject>

@required
// 添加点
- (void)popAlertController;
- (void)addPoint:(NSString *)name;

// 添加评论
- (void)pushCommentController:(NSString *)type;

@end

@interface MAPHomeView : UIView

@property (nonatomic, weak) id<MAPHomeViewDelegate> delegate;

@property (nonatomic, strong) BMKMapView *mapView;

@property (nonatomic, strong) UIButton *addPointButton;

@property (nonatomic, strong) UIButton *addContentButton;

@property (nonatomic, strong) UIView *messageBackgroundView;

@property (nonatomic, strong) UIView *messageView;

@property (nonatomic, strong) UIButton *msgButton;

@property (nonatomic, strong) UIButton *imgButton;

@property (nonatomic, strong) UIButton *voiceButton;

@property (nonatomic, strong) UIButton *videoButton;

@property (nonatomic, strong) UIAlertController *alert;

- (void)initAddContentButton;

@end
