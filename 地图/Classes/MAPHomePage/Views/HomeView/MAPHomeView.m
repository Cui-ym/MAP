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
    [self.addPointButton addTarget:self action:@selector(addPoint:) forControlEvents:UIControlEventTouchUpInside];
    
}

// 添加 Alert
- (void)addPoint:(UIButton *)sender {
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
    
    if ([_delegate respondsToSelector:@selector(popAlertController)]) {
        [_delegate popAlertController];
    }
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
        [self.messageBackgroundView removeFromSuperview];
        sender.selected = NO;
    }
}

- (void)initMessageView {
    self.messageBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height * 0.9)];
    [_messageBackgroundView setBackgroundColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.0]];
    [self addSubview:_messageBackgroundView];
    
    self.messageView = [[UIView alloc] init];
    [_messageBackgroundView addSubview:_messageView];
    
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
    [self.imgButton addTarget:self action:@selector(pushAddCommentView:) forControlEvents:UIControlEventTouchUpInside];
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
    [self.videoButton addTarget:self action:@selector(pushAddCommentView:) forControlEvents:UIControlEventTouchUpInside];
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

- (void)pushAddCommentView:(UIButton *)sender {
    NSArray *arrar = [NSArray arrayWithObjects:@"文字", @"图片", @"语音", @"视频", nil];
    int temp = (int)sender.tag - 1001;
    if ([_delegate respondsToSelector:@selector(pushCommentController:)]) {
        [_delegate pushCommentController:arrar[temp]];
    }
}

@end
