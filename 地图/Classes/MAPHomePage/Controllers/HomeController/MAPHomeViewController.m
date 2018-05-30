//
//  MAPHomeViewController.m
//  地图
//
//  Created by 崔一鸣 on 2018/2/6.
//  Copyright © 2018年 崔一鸣. All rights reserved.
//

#import "MAPHomeViewController.h"

#import <math.h>

@interface MAPHomeViewController ()

@end

@implementation MAPHomeViewController

{
    NSURL *audioUrl;
}

// 视图出现时
// 设置地图代理
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.homeView.mapView viewWillAppear];
    self.homeView.mapView.delegate = self;
    self.navigationController.navigationBar.hidden = YES;
    if (_annotationArray != nil) {
        [self updateAnnotationArray];
    }
}

// 视图即将消失
// 将地图代理设为nil
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.homeView.mapView viewWillDisappear];
    self.homeView.mapView.delegate = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // 初始化
    self.Latitude = 0.0;
    self.Longitud = 0.0;
    self.homeView = [[MAPHomeView alloc] initWithFrame:self.view.bounds];
    self.homeView.delegate = self;
    self.homeView.mapView.zoomLevel = 17;
    self.annotationArray = [NSMutableArray array];
    [self.view addSubview:self.homeView];
    // 打开定位服务
    [self.locService startUserLocationService];
}

// 处理位置坐标更新
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation {
    double x = userLocation.location.coordinate.latitude;
    double y = userLocation.location.coordinate.longitude;
    BOOL flag = 0;
    // 计算移动距离
    // 如果超过10米 则发送请求
    double distance = pow(pow((_Latitude - x), 2) + pow(_Longitud - y, 2), 0.5);
    if (distance > 0.0001 || _addPoint == 1) {
        _Longitud = y;
        _Latitude = x;
        flag = 1;
    }
//    NSLog(@"x:%lf, y:%lf", x, y);
    [self.homeView.mapView updateLocationData:userLocation];
    if (flag == 1) {
        [self updateAnnotationArray];
    }
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self.homeView.mapView setCenterCoordinate:userLocation.location.coordinate animated:YES];
    });

}

// 更新点标记
- (void)updateAnnotationArray {
    [[MAPCoordinateManager sharedManager] fetchPointWithLongitude:_Longitud Latitude:_Latitude Range:500 succeed:^(MAPGetPointModel *pointModel) {
        // 移除所有点标记
        [self.homeView.mapView removeAnnotations:self.annotationArray];
        // 重新初始化
        self.annotationArray = [NSMutableArray array];
        // 遍历请求数据化，并给数组赋值
        for (id obj in pointModel.data) {
            BMKPointAnnotation *annotation = [[BMKPointAnnotation alloc] init];
            annotation.title = [NSString stringWithFormat:@"%@ ID %d mesCount %d phoCount %d audCount %d vidCount %d",[obj pointName] , [obj ID], [obj mesCount], [obj phoCount], [obj audCount], [obj vidCount]];
            annotation.coordinate = CLLocationCoordinate2DMake([obj latitude], [obj longitude]);
            [self.annotationArray addObject:annotation];
        }
        [self.homeView.mapView addAnnotations:self.annotationArray];
    } error:^(NSError *error) {
        
    }];
}

// 显示气泡
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id<BMKAnnotation>)annotation {
    if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
        MAPAnnotationView *annotationView = (MAPAnnotationView *) [mapView dequeueReusableAnnotationViewWithIdentifier:@"identifier"];
        annotationView.delegate = self;
        if (!annotationView) {
            annotationView = [MAPAnnotationView alloc];
            NSRange pos = [annotation.title rangeOfString:@" ID "];
            NSRange pos0 = [annotation.title rangeOfString:@" mesCount "];
            NSRange pos1 = [annotation.title rangeOfString:@" phoCount "];
            NSRange pos2 = [annotation.title rangeOfString:@" audCount "];
            NSRange pos3 = [annotation.title rangeOfString:@" vidCount "];
            annotationView.pointId = [[annotation.title substringWithRange:NSMakeRange(pos.location + 4, pos0.location)] intValue];
            annotationView.pointName = [annotation.title substringToIndex:pos.location];
            annotationView.mesCount = [[annotation.title substringWithRange:NSMakeRange(pos0.location + 10, pos1.location - pos0.location - 10)] intValue];
            annotationView.phoCount = [[annotation.title substringWithRange:NSMakeRange(pos1.location + 10, pos2.location - pos1.location - 10)] intValue];
            annotationView.audCount = [[annotation.title substringWithRange:NSMakeRange(pos2.location + 10, pos3.location - pos2.location - 10)] intValue];
            annotationView.vidCount = [[annotation.title substringFromIndex:pos3.location + 10] intValue];
            annotationView.commentCount = annotationView.mesCount + annotationView.phoCount + annotationView.audCount + annotationView.vidCount;
            if (annotationView.pointId == 20) {
                NSLog(@"%d", annotationView.commentCount);
            }
            [annotationView initWithAnnotation:annotation reuseIdentifier:@"identifier"];
        }
        return annotationView;
    }
    return nil;
}

// 当选中一个 annotationview 将其 delegate 设置为self
- (void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view
{
    MAPAnnotationView *annotationView = (MAPAnnotationView *)view;
    _pointId = annotationView.pointId;
    _pointName = annotationView.pointName;
    if (annotationView.commentCount == 0) {
        NSLog(@"该点没有信息");
        [self.homeView alertWithoutInformation];
        [self presentViewController:self.homeView.noneAlert animated:YES completion:nil];
    } else {
        [self.homeView initAddContentButton];
        NSLog(@"%@ 该点的ID是%d", annotationView.pointName, annotationView.pointId);
    }
    annotationView.delegate = self;
}

// 当取消选中一个 annotationview 时，将其 delegate 设置为nil
- (void)mapView:(BMKMapView *)mapView didDeselectAnnotationView:(BMKAnnotationView *)view{
    MAPAnnotationView *annotationView = (MAPAnnotationView *)view;
    if (self.homeView.addContentButton != nil) {
        [self.homeView.addContentButton removeFromSuperview];
    }
    annotationView.delegate = nil;
}

// 弹出 alertController 填写点的名称
- (void)popAlertController:(UIAlertController *)alert {
    [self presentViewController:alert animated:YES completion:nil];
}

// 添加点
- (void)addPoint:(NSString *)name {
    _addPoint = 1;
    [[MAPAddPointManager sharedManager] addPointWithName:name Latitude:_Latitude Longitude:_Longitud success:^(MAPResultModel *resultModel) {
        // 给点集合增加新添加的点信息
        BMKPointAnnotation *annotation = [[BMKPointAnnotation alloc] init];
        annotation.title = [NSString stringWithFormat:@"%@ ID %d mesCount 0 phoCount 0 audCount 0 vidCount 0", name, [[resultModel data] intValue]];
        annotation.coordinate = CLLocationCoordinate2DMake(_Latitude, _Longitud);
        [self.annotationArray addObject:annotation];
        [self.homeView.mapView addAnnotation:annotation];
        NSLog(@"添加成功");
    } error:^(NSError *error) {
        NSLog(@"添加失败");
    }];
    _addPoint = 0;
}

// 从相册中选择照片
- (void)chooseFromeAlbum:(int)type {
    [self initAddCommentController];
    NSString *style = nil;
    if (type == 1) {
        self.addCommentViewController.chooseImage = YES;
        style = @"图片";
    } else {
        self.addCommentViewController.chooseImage = NO;
        style = @"视频";
    }
    self.addCommentViewController.type = style;
    self.addCommentViewController.isSelect = YES;
    [self.navigationController pushViewController:_addCommentViewController animated:YES];
}

// 拍摄视频或照片
- (void)takePhotoOrVideoWithType:(int)type {
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;               // 设置来源为摄像头
    imagePicker.cameraDevice = UIImagePickerControllerCameraDeviceRear;             // 设置使用的摄像头是后置摄像头
    if (type == 1) {                                                                // 拍摄照片
        imagePicker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
    } else {                                                                        // 录制视频
        //判断是否拥有拍摄权限
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
            NSLog(@"没有权利");
            return;
        }
        imagePicker.mediaTypes = @[(NSString *)kUTTypeMovie];
        imagePicker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModeVideo;
        imagePicker.videoQuality = UIImagePickerControllerQualityTypeHigh;
    }
    [self presentViewController:imagePicker animated:YES completion:^{
        NSLog(@"使用相机");
    }];
}

// 完成文件选取之后的调用的方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    NSLog(@"拍摄视频");
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    NSString *videoUrlPath;
    NSURL *videoUrl;
    NSMutableArray *imageMutableArray = [NSMutableArray array];
    [self initAddCommentController];
    if ([type isEqualToString:(NSString *)kUTTypeImage]) {
        // 图片保存和展示
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];  // 不允许编辑，获取原图片
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);                       // 保存图片
        self.addCommentViewController.chooseImage = YES;
        self.addCommentViewController.type = @"图片";
        [imageMutableArray addObject:image];
    } else if ([type isEqualToString:(NSString *)kUTTypeMovie]) {                   // 保存视频
        videoUrl = [info objectForKey:UIImagePickerControllerMediaURL];
        UIImage *image = [self getVideoCoverImagesWithURL:videoUrl];
        [imageMutableArray addObject:image];
        videoUrlPath = [videoUrl path];
        if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(videoUrlPath)) {
            UISaveVideoAtPathToSavedPhotosAlbum(videoUrlPath, self, @selector(video:didFinishSavingWithError:contextInfo:), nil);
        }
        self.addCommentViewController.type = @"视频";
    }
    [self dismissViewControllerAnimated:YES completion:nil];
    _addCommentViewController.videoPath = videoUrlPath;
    _addCommentViewController.videoUrl = videoUrl;
    NSLog(@"%@", videoUrlPath);
    _addCommentViewController.imageArray = [NSArray arrayWithArray:imageMutableArray];
    [self.navigationController pushViewController:_addCommentViewController animated:YES];
}

- (UIImage *)getVideoCoverImagesWithURL:(NSURL *)url {
    UIImage *coverImage;
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:url options:nil];
    NSLog(@"%@", url);
    AVAssetImageGenerator *generator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    generator.appliesPreferredTrackTransform = YES;
    CMTime time = CMTimeMake(1, 10);
    NSError *error = nil;
    CMTime actualTime;
    CGImageRef image = [generator copyCGImageAtTime:time actualTime:&actualTime error:&error];
    coverImage = [[UIImage alloc] initWithCGImage:image];
    CGImageRelease(image);
    return coverImage;
}

- (void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo:(void *)info {
    if (error) {
        NSLog(@"保存视频时出现错误，错误信息：%@", error.localizedDescription);
    } else {
        NSLog(@"视频保存成功.");
    }
}

// push到 添加评论的界面
- (void)pushCommentController:(NSString *)type {
    NSLog(@"type::%@", type);
    if ([type  isEqual: @"语音"]) {
        [self.homeView initRecordVoiceView];
    } else {
        [self initAddCommentController];
        self.addCommentViewController.type = type;
        [self.navigationController pushViewController:_addCommentViewController animated:YES];
    }
}

// 初始化添加评论界面
- (void)initAddCommentController {
    self.addCommentViewController = [[MAPAddCommentViewController alloc] init];
    self.addCommentViewController.Latitude = _Latitude;
    self.addCommentViewController.Longitud = _Longitud;
    _addCommentViewController.pointName = _pointName;
    _addCommentViewController.pointId = _pointId;
    _addCommentViewController.delegate = self;
}

// 评论界面
- (void)addCommentViewWithStyle:(int)style pointID:(int)pointId {
    NSLog(@"进入评论界面");
    [[MAPCoordinateManager sharedManager] fetchCoordinateDataWithPointID:pointId type:style succeed:^(MAPCoordinateModel *resultModel) {
        self.commentViewController = [[MAPCommentViewController alloc] init];
        self.commentViewController.type = style;
        self.commentViewController.commentArray = [NSArray arrayWithArray:resultModel.data];
        [self.navigationController pushViewController:_commentViewController animated:YES];
    } error:^(NSError *error) {
        NSLog(@"error:%@", error);
    }];
}

// 开始录音
- (void)recordStart {
    NSMutableDictionary *settings = [NSMutableDictionary dictionary];
    [settings setObject:[NSNumber numberWithFloat:8000.0f] forKey:AVSampleRateKey];
    [settings setObject:[NSNumber numberWithInt:2] forKey:AVNumberOfChannelsKey];
    [settings setValue :[NSNumber numberWithInt:kAudioFormatLinearPCM] forKey: AVFormatIDKey];
    [settings setObject:@16 forKey:AVLinearPCMBitDepthKey];
    NSError *error;
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryRecord error:nil];
    [[AVAudioSession sharedInstance] setActive:YES error:&error];
    self.audioRecorder.meteringEnabled = YES;
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    NSString *savePath = [NSString stringWithFormat:@"%@/test.lpcm", path];
    
    //录制文件路径
    NSURL *fileURL = [NSURL fileURLWithPath:savePath];
    
    //初始化录制信息信息，进行录制。
    self.audioRecorder = [[AVAudioRecorder alloc] initWithURL:fileURL settings:settings error:&error];
    self.audioRecorder.delegate = self;
    BOOL success = [self.audioRecorder record];
    if (success) {
        NSLog(@"录音开始成功");
    } else {
        NSLog(@"录音开始失败");
    }
}

// 完成录音
- (void)recordFinish:(int)time {
    [self.audioRecorder stop];
}

// 结束录制后调用代理方法
- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag {
    audioUrl = recorder.url;
    self.addCommentViewController = [[MAPAddCommentViewController alloc] init];
    self.addCommentViewController.type = @"语音";
    self.addCommentViewController.Latitude = _Latitude;
    self.addCommentViewController.Longitud = _Longitud;
    self.addCommentViewController.audioUrl = audioUrl;
    _addCommentViewController.audioTime = _homeView.timeLabel.text;
    _addCommentViewController.pointName = _pointName;
    _addCommentViewController.pointId = _pointId;
    _addCommentViewController.delegate = self;
    [self.navigationController pushViewController:_addCommentViewController animated:YES];
}


- (NSMutableArray *)annotationArray {
    if (!_annotationArray) {
        _annotationArray = [NSMutableArray array];
    }
    return _annotationArray;
}

- (BMKLocationService *)locService {
    if (!_locService) {
        _locService = [[BMKLocationService alloc] init];
        _locService.delegate = self;
    }
    return _locService;
}


//    //地理反编码

//    BMKReverseGeoCodeOption *reverseGeocodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
////    reverseGeocodeSearchOption.reverseGeoPoint = CLLocationCoordinate2DMake(34.341642, 108.713139);
//    reverseGeocodeSearchOption.reverseGeoPoint = userLocation.location.coordinate;
//
//    //初始化检索对象
//    _searcher =[[BMKGeoCodeSearch alloc]init];
//    _searcher.delegate = self;
//    flag = [_searcher reverseGeoCode:reverseGeocodeSearchOption];
//
//    if(flag){
//        NSLog(@"反geo检索发送成功");
//        [_locService stopUserLocationService];
//    }else{
//        NSLog(@"反geo检索发送失败");
//    }
/*
 -(void) onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error {
 if (error == BMK_SEARCH_NO_ERROR) {
 
 NSLog(@"address:%@----%lf----%lf",result.sematicDescription, result.location.longitude, result.location.latitude);
 }
 else {
 NSLog(@"抱歉，未找到结果");
 }
 }
 */

//- (void)vedioButtonDidClick {
//    NSURL *vedioURL = [NSURL URLWithString:@"http://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4"];
//    AVPlayer *player = [AVPlayer playerWithURL:vedioURL];
//    AVPlayerViewController *vedioVC = [[AVPlayerViewController alloc] init];
//    vedioVC.player = player;
//    [self presentViewController:vedioVC animated:YES completion:nil];
//    [vedioVC.player play];
//    //    vedioVC.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.width);
//}


@end
