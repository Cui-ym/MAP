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
    BOOL flag = 0;
    // 计算移动距离
    // 如果超过10米 则发送请求
    double distance = pow(pow((_Latitude - x), 2) + pow(_Longitud - y, 2), 0.5);
    if (distance > 0.0001) {
        _Longitud = y;
        _Latitude = x;
        flag = 1;
    }
//    NSLog(@"x:%lf, y:%lf", x, y);
    [self.homeView.mapView updateLocationData:userLocation];
    if (flag == 1) {
        [[MAPCoordinateManager sharedManager] fetchPointWithLongitude:_Longitud Latitude:_Latitude Range:100 succeed:^(MAPGetPointModel *pointModel) {
            // 移除所有点标记
            [self.homeView.mapView removeAnnotations:self.annotationArray];
            // 重新初始化
            self.annotationArray = [NSMutableArray array];
            // 遍历请求数据化，并给数组赋值
            for (id obj in pointModel.data) {
                BMKPointAnnotation *annotation = [[BMKPointAnnotation alloc] init];
                annotation.title = [NSString stringWithFormat:@"%d", [obj ID]];
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
    
}

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

// 显示气泡
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id<BMKAnnotation>)annotation {
    if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
        MAPAnnotationView *annotationView = (MAPAnnotationView *) [mapView dequeueReusableAnnotationViewWithIdentifier:@"identifier"];
        annotationView.delegate = self;
        if (!annotationView) {
            annotationView = [[MAPAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"identifier"];
            annotationView.pointId = [annotation.title intValue];
        }
        return annotationView;
    }
    return nil;
}

// 当选中一个 annotationview 将其 delegate 设置为self
- (void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view
{
    MAPAnnotationView *annotationView = (MAPAnnotationView *)view;
    [self.homeView initAddContentButton];
//    _pointName = annotationView
    NSLog(@"该点的ID是%d", annotationView.pointId);
    annotationView.delegate = self;
}

// 当取消选中一个 annotationview 时，将其 delegate 设置为nil
- (void)mapView:(BMKMapView *)mapView didDeselectAnnotationView:(BMKAnnotationView *)view{
    MAPAnnotationView *annotationView = (MAPAnnotationView *)view;
    [self.homeView.addContentButton removeFromSuperview];
    annotationView.delegate = nil;
}

// 弹出 alertController 填写点的名称
- (void)popAlertController {
    [self presentViewController:self.homeView.alert animated:YES completion:nil];
}

// 添加点
- (void)addPoint:(NSString *)name {
    [[MAPAddPointManager sharedManager] addPointWithName:name Latitude:_Latitude Longitude:_Longitud success:^(MAPResultModel *resultModel) {
        NSLog(@"添加成功");
    } error:^(NSError *error) {
        NSLog(@"添加失败");
    }];
}

// push到 添加评论的界面
- (void)pushCommentController:(NSString *)type {
    self.addCommentViewController = [[MAPAddCommentViewController alloc] init];
    _addCommentViewController.pointName = @"崔一鸣他家";
    [self.navigationController pushViewController:_addCommentViewController animated:YES];
}

// 评论界面
- (void)addCommentViewWithStyle:(int)style pointID:(int)pointId {
    [[MAPCoordinateManager sharedManager] fetchCoordinateDataWithPointID:pointId type:style succeed:^(MAPCoordinateModel *resultModel) {
        self.commentView = [[MAPCommentView alloc] initWithFrame:self.view.bounds];
        self.commentView.commentArray = [NSArray arrayWithArray:resultModel.data];
        
        [self.commentView calculateHeight];
        [self.view addSubview:_commentView];
        _commentView.delegate = self;
    } error:^(NSError *error) {
        
    }];
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
