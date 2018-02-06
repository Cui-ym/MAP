//
//  MAPHomeViewController.m
//  地图
//
//  Created by 崔一鸣 on 2018/2/6.
//  Copyright © 2018年 崔一鸣. All rights reserved.
//

#import "MAPHomeViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "MAPAnnotationView.h"
#import "MAPCoordinateManager.h"
#import <BaiduMapAPI_Base/BMKBaseComponent.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>

#import <math.h>

@interface MAPHomeViewController ()<BMKMapViewDelegate,BMKLocationServiceDelegate>

@property (nonatomic, strong) BMKMapView *mapView;
@property (nonatomic, strong) BMKLocationService *locService;
@property (nonatomic, strong) NSMutableArray *annotationArray;
@property (nonatomic, assign) double Latitude;
@property (nonatomic, assign) double Longitud;

@end

@implementation MAPHomeViewController
// 视图出现时
// 设置地图代理
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.mapView viewWillAppear];
    self.mapView.delegate = self;
}

// 视图即将消失
// 将地图代理设为nil
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.mapView viewWillDisappear];
    self.mapView.delegate = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // 初始化
    self.Latitude = 0.0;
    self.Longitud = 0.0;
    self.mapView = [[BMKMapView alloc] initWithFrame:self.view.bounds];
    // 设置比例级别
    self.mapView.zoomLevel = 17;
    self.annotationArray = [NSMutableArray array];
    [self.view addSubview:self.mapView];
    [self mapStartLocate];
}

- (void)mapStartLocate {
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
    // 打开定位服务
    [self.locService startUserLocationService];
}

// 处理位置坐标更新
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation {
    //    NSLog(@"位置更新");
    double x = userLocation.location.coordinate.latitude;
    double y = userLocation.location.coordinate.longitude;
    int flag = 0;
    double distance = pow(pow((_Latitude - x), 2) + pow(_Longitud - y, 2), 0.5);
    NSLog(@"%lf", distance);
    if (distance > 0.0001) {
        _Longitud = y;
        _Latitude = x;
        flag = 1;
    }
    [self.mapView updateLocationData:userLocation];
    BMKPointAnnotation *annotation = [[BMKPointAnnotation alloc] init];
    annotation.coordinate = CLLocationCoordinate2DMake(34.3497, 108.7025);
    [self.mapView addAnnotation:annotation];
    if (flag == 1) {
        [[MAPCoordinateManager sharedManager] fetchPointWithLongitude:108.702505 Latitude:34.349725 Range:100 succeed:^(MAPGetPointModel *pointModel) {
            NSLog(@"请求成功");
            // 移除所有点标记
            // 重新初始化数组
            [self.mapView removeAnnotations:self.annotationArray];
            self.annotationArray = [NSMutableArray array];
            for (id obj in pointModel.data) {
                BMKPointAnnotation *annotation = [[BMKPointAnnotation alloc] init];
                annotation.coordinate = CLLocationCoordinate2DMake([obj latitude], [obj longitude]);
                //            NSLog(@"latitude:%f  longitude:%f", [obj latitude], [obj longitude]);
                [self.annotationArray addObject:annotation];
                //            NSLog(@"%lu", self.annotationArray.count);
            }
            NSLog(@"%@", self.annotationArray);
            [self.mapView addAnnotations:self.annotationArray];
        } error:^(NSError *error) {
            
        }];
    }
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self.mapView setCenterCoordinate:userLocation.location.coordinate animated:YES];
    });
}

// 显示气泡
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id<BMKAnnotation>)annotation {
    if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
        MAPAnnotationView *annotationView = (MAPAnnotationView *) [mapView dequeueReusableAnnotationViewWithIdentifier:@"identifier"];
        if (!annotationView) {
            //            NSLog(@"显示气泡 %f  %f", annotation.coordinate.longitude, annotation.coordinate.latitude);
            annotationView = [[MAPAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"identifier"];
        }
        annotationView.canShowCallout = NO;
        return annotationView;
        
    }
    return nil;
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

//- (void)vedioButtonDidClick {
//    NSURL *vedioURL = [NSURL URLWithString:@"http://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4"];
//    AVPlayer *player = [AVPlayer playerWithURL:vedioURL];
//    AVPlayerViewController *vedioVC = [[AVPlayerViewController alloc] init];
//    vedioVC.player = player;
//    [self presentViewController:vedioVC animated:YES completion:nil];
//    [vedioVC.player play];
//    //    vedioVC.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.width);
//}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
