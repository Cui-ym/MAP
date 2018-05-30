//
//  MAPHomeView.m
//  地图
//
//  Created by 崔一鸣 on 2018/2/6.
//  Copyright © 2018年 崔一鸣. All rights reserved.
//

#import "MAPHomeView.h"
#import "Masonry.h"

@implementation MAPHomeView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.mapView = [[BMKMapView alloc] init];
        [self addSubview:_mapView];
        
        self.addPointButton = [[UIButton alloc] init];
        [self addSubview:_addPointButton];
        
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.backgroundColor = [UIColor whiteColor];
    self.mapView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height * 0.9);
    BMKLocationViewDisplayParam *displayParam = [[BMKLocationViewDisplayParam alloc] init];
    // 隐藏精度圈
    displayParam.isAccuracyCircleShow = NO;
    // 设置定位图标样式
    displayParam.locationViewImgName = @"icon_center_point";
    // 地图开始定位
    [self.mapView updateLocationViewWithParam:displayParam];
    // 设置定位模式
    self.mapView.userTrackingMode = BMKUserTrackingModeHeading;
    // 显示定位图层
    self.mapView.showsUserLocation = YES;
    
    [self.addPointButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom);
        make.right.and.left.equalTo(self);
        make.height.equalTo(self.mas_height).multipliedBy(0.1);
    }];
    [self.addPointButton setImage:[UIImage imageNamed:@"add"] forState:!UIControlStateSelected];
    [self.addPointButton setBackgroundColor:[UIColor colorWithRed:0.95f green:0.54f blue:0.54f alpha:1.00f]];
    [self.addPointButton addTarget:self action:@selector(clickAddPointButton:) forControlEvents:UIControlEventTouchUpInside];
    
}

// 添加 Alert
- (void)clickAddPointButton:(UIButton *)sender {
    __weak MAPHomeView *weakSelf = self;
    
    self.alert = [UIAlertController alertControllerWithTitle:@"输入点的名称" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [_alert addAction:cancleAction];
    UIAlertAction *addAction = [UIAlertAction actionWithTitle:@"添加" style:UIAlertActionStyleDefault handler:^(UIAlertAction* action) {
        if ([_delegate respondsToSelector:@selector(addPoint:)]) {
            [_delegate addPoint:weakSelf.alert.textFields.firstObject.text];
        }
    }];
    
    [_alert addAction:addAction];
    addAction.enabled = NO;
    [_alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"name";
        textField.secureTextEntry = NO;
        [[NSNotificationCenter defaultCenter] addObserver:weakSelf selector:@selector(alertTextFieldDidChange:) name:UITextFieldTextDidChangeNotification object:textField];
    }];
    
    if ([_delegate respondsToSelector:@selector(popAlertController:)]) {
        [_delegate popAlertController:_alert];
    }
}

// 没有信息的警告
- (void)alertWithoutInformation {
    self.noneAlert = [UIAlertController alertControllerWithTitle:@"这里什么信息都没有哦" message:@"我要做第一个添加内容的人" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancleAlert = [UIAlertAction actionWithTitle:@"不要" style:UIAlertActionStyleCancel handler:nil];
    [_noneAlert addAction:cancleAlert];
    UIAlertAction *postAlert = [UIAlertAction actionWithTitle:@"发布" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self initMessageView];
    }];
    [_noneAlert addAction:postAlert];
}

- (void)alertTextFieldDidChange:(NSNotification *)notification {
    UIAlertController *alertController = (UIAlertController *)self.alert;
    if (alertController) {
        UITextField *name = alertController.textFields.firstObject;
        UIAlertAction *okAction = alertController.actions.lastObject;
        okAction.enabled = name.text.length > 0;
    }
}

- (void)initAddContentButton {
    self.addContentButton = [[UIButton alloc] init];
    [self addSubview:_addContentButton];
    
    [self.addContentButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom);
        make.right.and.left.equalTo(self);
        make.height.equalTo(self.mas_height).multipliedBy(0.1);
    }];
    
    [self.addContentButton setTitle:@"添 加 信 息" forState:UIControlStateNormal];
    [self.addContentButton setTitle:@"取 消" forState:UIControlStateSelected];
    [self.addContentButton setBackgroundColor:[UIColor colorWithRed:0.95f green:0.54f blue:0.54f alpha:1.00f]];
    [self.addContentButton addTarget:self action:@selector(addContent:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)addContent:(UIButton *)sender {
    if (sender.selected == NO) {
        [self initMessageView];
        sender.selected = YES;
    } else {
        sender.selected = NO;
        [self.viewBackgroundView removeFromSuperview];
    }
}

- (void)initMessageView {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture)];
    tap.numberOfTapsRequired = 1;
    self.viewBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height * 0.9)];
    [_viewBackgroundView setBackgroundColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.0]];
    [_viewBackgroundView addGestureRecognizer:tap];
    [self addSubview:_viewBackgroundView];
    
    self.messageView = [[UIView alloc] init];
    [_viewBackgroundView addSubview:_messageView];
    
    self.msgButton = [[UIButton alloc] init];
    [self.messageView addSubview:_msgButton];
    
    self.imgButton = [[UIButton alloc] init];
    [self.messageView addSubview:_imgButton];
    
    self.voiceButton = [[UIButton alloc] init];
    [self.messageView addSubview:_voiceButton];
    
    self.videoButton = [[UIButton alloc] init];
    [self.messageView addSubview:_videoButton];
    
    [_messageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.width.equalTo(self.mas_width).multipliedBy(0.7);
        make.height.equalTo(self.mas_width).multipliedBy(0.7);
    }];
    
    // 添加按钮和点击后的响应事件
    self.msgButton.tag = 1001;
    [self.msgButton addTarget:self action:@selector(pushAddCommentView:) forControlEvents:UIControlEventTouchUpInside];
    [self.msgButton setImage:[UIImage imageNamed:@"comment"] forState:UIControlStateNormal];
    [self.msgButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.messageView.mas_width).multipliedBy(0.25);
        make.height.equalTo(self.messageView.mas_height).multipliedBy(0.25);
        make.left.equalTo(self.messageView.mas_right).multipliedBy(0.175);
        make.top.equalTo(self.messageView.mas_bottom).multipliedBy(0.175);
    }];
   
    self.imgButton.tag = 1002;
    [self.imgButton addTarget:self action:@selector(clickImageOrVideoButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.imgButton setImage:[UIImage imageNamed:@"image"] forState:UIControlStateNormal];
    [self.imgButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.messageView.mas_width).multipliedBy(0.25);
        make.height.equalTo(self.messageView.mas_height).multipliedBy(0.25);
        make.left.equalTo(self.messageView.mas_right).multipliedBy(0.575);
        make.top.equalTo(self.msgButton);
    }];
   
    self.voiceButton.tag = 1003;
    [self.voiceButton addTarget:self action:@selector(pushAddCommentView:) forControlEvents:UIControlEventTouchUpInside];
    [self.voiceButton setImage:[UIImage imageNamed:@"voice"] forState:UIControlStateNormal];
    [self.voiceButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.messageView.mas_width).multipliedBy(0.25);
        make.height.equalTo(self.messageView.mas_height).multipliedBy(0.25);
        make.left.equalTo(_messageView.mas_right).multipliedBy(0.175);
        make.top.equalTo(_messageView.mas_bottom).multipliedBy(0.575);
    }];

    self.videoButton.tag = 1004;
    [self.videoButton addTarget:self action:@selector(clickImageOrVideoButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.videoButton setImage:[UIImage imageNamed:@"video"] forState:UIControlStateNormal];
    [self.videoButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.messageView.mas_width).multipliedBy(0.25);
        make.height.equalTo(self.messageView.mas_height).multipliedBy(0.25);
        make.left.equalTo(_messageView.mas_right).multipliedBy(0.575);
        make.top.equalTo(_messageView.mas_bottom).multipliedBy(0.575);
    }];
    
    
    // 设置圆角和背景颜色
    _messageView.backgroundColor = [UIColor colorWithRed:0.95f green:0.54f blue:0.54f alpha:1.00f];
    _messageView.layer.masksToBounds = YES;
    _messageView.layer.cornerRadius = self.frame.size.width * 0.35;
}

// 发表照片，视频评论
- (void)clickImageOrVideoButton:(UIButton *)sender {
    int temp = (int)sender.tag - 1001;
    UIAlertController *alertSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *takeAction = [UIAlertAction actionWithTitle:@"拍摄" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if ([_delegate respondsToSelector:@selector(takePhotoOrVideoWithType:)]) {
            [_delegate takePhotoOrVideoWithType:temp];
        }
    }];
    [alertSheet addAction:takeAction];
    
    UIAlertAction *albumAction = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"%d", temp);
        if ([_delegate respondsToSelector:@selector(chooseFromeAlbum:)]) {
            [_delegate chooseFromeAlbum:temp];
        }
    }];
    [alertSheet addAction:albumAction];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertSheet addAction:cancelAction];
    
    // 弹出alertSheet
    if ([_delegate respondsToSelector:@selector(popAlertController:)]) {
        [_delegate popAlertController:alertSheet];
    }
}

- (void)initRecordVoiceView {
    self.isRecord = YES;
    
    self.recordView = [[UIView alloc] init];
    [self.viewBackgroundView addSubview:_recordView];
    
    self.recordLabel = [[UILabel alloc] init];
    [self.recordView addSubview:_recordLabel];
    
    self.timeLabel = [[UILabel alloc] init];
    [self.recordView addSubview:_timeLabel];
    
    self.recordButton = [[UIButton alloc] init];
    [self.recordView addSubview:_recordButton];
    
    [self.recordView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.height.and.width.equalTo(self.mas_width).multipliedBy(0.8);
    }];
    self.recordView.backgroundColor = [UIColor whiteColor];
    
    [self.recordLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.recordView);
        make.width.equalTo(self.recordView.mas_width);
        make.top.equalTo(self.recordView.mas_bottom).multipliedBy(0.1);
        make.bottom.equalTo(self.recordView.mas_bottom).multipliedBy(0.2);
    }];
    self.recordLabel.textAlignment = NSTextAlignmentCenter;
    self.recordLabel.textColor = [UIColor blackColor];
    self.recordLabel.text = @"长按录制语音";
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.recordView);
        make.top.equalTo(self.recordView.mas_bottom).multipliedBy(0.25);
        make.bottom.equalTo(self.recordView.mas_bottom).multipliedBy(0.35);
        make.width.equalTo(self.recordView.mas_width);
    }];
    self.timeLabel.textAlignment = NSTextAlignmentCenter;
    self.timeLabel.textColor = [UIColor blackColor];
    self.timeLabel.text = @"00:00";
    
    [self.recordButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.recordView);
        make.top.equalTo(self.recordView.mas_bottom).multipliedBy(0.45);
        make.width.and.height.equalTo(self.recordView.mas_width).multipliedBy(0.4);
    }];
    // 开始
    [self.recordButton addTarget:self action:@selector(touchDownRecordButton:) forControlEvents:UIControlEventTouchDown];
    // 完成
    [self.recordButton addTarget:self action:@selector(releaseRecordButton:) forControlEvents:UIControlEventTouchUpInside];
    self.recordButton.layer.masksToBounds = YES;
    self.recordButton.layer.cornerRadius = self.recordView.frame.size.width * 0.2;
    [self.recordButton setBackgroundImage:[UIImage imageNamed:@"souRed"] forState:UIControlStateNormal];
}

- (void)touchDownRecordButton:(UIButton *)sender {
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    } else {
        self.count = 0;
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(repeatShowTime:) userInfo:@"admin" repeats:YES];
    }
    if ([self.delegate respondsToSelector:@selector(recordStart)]) {
        [_delegate recordStart];
    }
}

- (void)releaseRecordButton:(UIButton *)sender {
    [self.timer invalidate];
    if ([self.delegate respondsToSelector:@selector(recordFinish:)]) {
        [_delegate recordFinish:_count];
    }
}

- (void)repeatShowTime:(NSTimer *)timpTemer {
    self.count++;
    self.timeLabel.text = [NSString stringWithFormat:@"%02d:%02d", self.count / 60, self.count % 60];
}

- (void)tapGesture {
    if (_isRecord == YES) {
        [self.recordView removeFromSuperview];
        _isRecord = NO;
    } else {
        [self.viewBackgroundView removeFromSuperview];
        self.addContentButton.selected = NO;
    }
}

- (void)pushAddCommentView:(UIButton *)sender {
    NSArray *arrar = [NSArray arrayWithObjects:@"文字", @"图片", @"语音", @"视频", nil];
    int temp = (int)sender.tag - 1001;
    if ([_delegate respondsToSelector:@selector(pushCommentController:)]) {
        [_delegate pushCommentController:arrar[temp]];
    }
}

@end
