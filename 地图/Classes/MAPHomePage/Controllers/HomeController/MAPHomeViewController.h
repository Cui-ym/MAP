//
//  MAPHomeViewController.h
//  地图
//
//  Created by 崔一鸣 on 2018/2/6.
//  Copyright © 2018年 崔一鸣. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <BaiduMapAPI_Base/BMKBaseComponent.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Search/BMKGeocodeSearch.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
#import <Photos/Photos.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <MobileCoreServices/MobileCoreServices.h>

#import "MAPAddCommentViewController.h"
#import "MAPCommentViewController.h"

#import "MAPCommentView.h"
#import "MAPHomeView.h"
#import "MAPAnnotationView.h"

#import "MAPCoordinateManager.h"
#import "MAPAddPointManager.h"

@interface MAPHomeViewController : UIViewController <BMKMapViewDelegate, BMKLocationServiceDelegate, MAPHomeViewDelegate, MAPAnnotationViewDelegate, MAPCommentViewDelegate, BMKGeoCodeSearchDelegate, MAPAddCommentViewControllerDelegate, MAPMessageTableViewCellDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, AVAudioRecorderDelegate, AVAudioPlayerDelegate>

@property (nonatomic, strong) BMKGeoCodeSearch *searcher;

@property (nonatomic, strong) MAPHomeView *homeView;

@property (nonatomic, strong) BMKLocationService *locService;

@property (nonatomic, strong) NSMutableArray *annotationArray;

@property (nonatomic, strong) MAPAddCommentViewController *addCommentViewController;

@property (nonatomic, strong) MAPCommentViewController *commentViewController;

@property (nonatomic, strong) AVAudioRecorder *audioRecorder;

@property (nonatomic, strong) AVAudioPlayer *audioPlayer;

@property (nonatomic, copy) NSString *pointName;

@property (nonatomic, assign) double Latitude;

@property (nonatomic, assign) double Longitud;

@property (nonatomic, assign) int pointId;

@property (nonatomic, assign) BOOL addPoint;
@end
