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
- (void)popAlertController:(UIAlertController *)alert;
- (void)addPoint:(NSString *)name;

// 添加评论
- (void)pushCommentController:(NSString *)type;

// 录制语音
- (void)recordStart;
// 完成录音
- (void)recordFinish:(int)time;

// 从相册中选择
- (void)chooseFromeAlbum:(int)type;

// 摄像头拍摄
- (void)takePhotoOrVideoWithType:(int)type;


@end

@interface MAPHomeView : UIView

@property (nonatomic, weak) id<MAPHomeViewDelegate> delegate;

@property (nonatomic, strong) BMKMapView *mapView;

@property (nonatomic, strong) UIButton *addPointButton;

@property (nonatomic, strong) UIButton *addContentButton;

@property (nonatomic, strong) UIView *viewBackgroundView;

@property (nonatomic, strong) UIView *messageView;

@property (nonatomic, strong) UIButton *msgButton;

@property (nonatomic, strong) UIButton *imgButton;

@property (nonatomic, strong) UIButton *voiceButton;

@property (nonatomic, strong) UIButton *videoButton;

@property (nonatomic, strong) UIAlertController *alert;

@property (nonatomic, strong) UIAlertController *noneAlert;

// 录制语音view
@property (nonatomic, assign) BOOL isRecord;

@property (nonatomic, strong) UIView *recordView;

@property (nonatomic, strong) UILabel *recordLabel;

@property (nonatomic, strong) UILabel *timeLabel;

@property (nonatomic, strong) UIButton *recordButton;

@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, assign) int count;


- (void)initAddContentButton;

- (void)alertWithoutInformation;

- (void)initRecordVoiceView;

@end
