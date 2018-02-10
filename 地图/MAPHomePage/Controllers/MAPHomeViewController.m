//
//  MAPHomeViewController.m
//  地图
//
//  Created by 崔一鸣 on 2018/2/6.
//  Copyright © 2018年 崔一鸣. All rights reserved.
//

#import "MAPHomeViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <BaiduMapAPI_Base/BMKBaseComponent.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
#import "MAPCommentView.h"
#import "MAPHomeView.h"
#import "MAPAnnotationView.h"
#import "MAPCoordinateManager.h"

#import <math.h>

@interface MAPHomeViewController ()<BMKMapViewDelegate, BMKLocationServiceDelegate, MAPHomeViewDelegate, MAPAnnotationViewDelegate, MAPCommentViewDelegate>

@property (nonatomic, strong) MAPHomeView *homeView;
@property (nonatomic, strong) BMKLocationService *locService;
@property (nonatomic, strong) NSMutableArray *annotationArray;
@property (nonatomic, strong) MAPCommentView *commentView;
@property (nonatomic, assign) double Latitude;
@property (nonatomic, assign) double Longitud;

@end

@implementation MAPHomeViewController
// 视图出现时
// 设置地图代理
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.homeView.mapView viewWillAppear];
    self.homeView.mapView.delegate = self;
    self.navigationController.navigationBar.hidden = YES;
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
    int flag = 0;
    double distance = pow(pow((_Latitude - x), 2) + pow(_Longitud - y, 2), 0.5);
    if (distance > 0.0001) {
        _Longitud = y;
        _Latitude = x;
        flag = 1;
    }
    [self.homeView.mapView updateLocationData:userLocation];
    BMKPointAnnotation *annotation = [[BMKPointAnnotation alloc] init];
    annotation.coordinate = CLLocationCoordinate2DMake(34.3497, 108.7025);
    [self.homeView.mapView addAnnotation:annotation];
    if (flag == 1) {
        [[MAPCoordinateManager sharedManager] fetchPointWithLongitude:108.702505 Latitude:34.349725 Range:100 succeed:^(MAPGetPointModel *pointModel) {
            // 移除所有点标记
            [self.homeView.mapView removeAnnotations:self.annotationArray];
            // 重新初始化
            self.annotationArray = [NSMutableArray array];
            for (id obj in pointModel.data) {
                BMKPointAnnotation *annotation = [[BMKPointAnnotation alloc] init];
                annotation.coordinate = CLLocationCoordinate2DMake([obj latitude], [obj longitude]);
                [self.annotationArray addObject:annotation];
            }
            [self.homeView.mapView addAnnotations:self.annotationArray];
        } error:^(NSError *error) {
            
        }];
    }
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self.homeView.mapView setCenterCoordinate:userLocation.location.coordinate animated:YES];
    });
}

// 显示气泡
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id<BMKAnnotation>)annotation {
    if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
        MAPAnnotationView *annotationView = (MAPAnnotationView *) [mapView dequeueReusableAnnotationViewWithIdentifier:@"identifier"];
        annotationView.delegate = self;
        if (!annotationView) {
            annotationView = [[MAPAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"identifier"];
        }
        return annotationView;
    }
    return nil;
}

// 当选中一个 annotationview 将其 delegate 设置为self
- (void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view
{
    MAPAnnotationView *annotationView = (MAPAnnotationView *)view;
    annotationView.delegate = self;
}

// 当取消选中一个 annotationview 时，将其 delegate 设置为nil
- (void)mapView:(BMKMapView *)mapView didDeselectAnnotationView:(BMKAnnotationView *)view{
    MAPAnnotationView *annotationView = (MAPAnnotationView *)view;
    annotationView.delegate = nil;
}

// 添加评论界面
- (void)addCommentView:(NSString *)style {
    self.commentView = [[MAPCommentView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:_commentView];
    _commentView.delegate = self;
    NSLog(@"--%@--", style);
}

// 移除评论界面
- (void)removeCommentView {
    [self.commentView removeFromSuperview];
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


@end
