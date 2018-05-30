//
//  MAPAddCommentViewController.h
//  地图
//
//  Created by 崔一鸣 on 2018/2/28.
//  Copyright © 2018年 崔一鸣. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>
#import <AVFoundation/AVFoundation.h>
#import "MAPAddCommentView.h"
#import <TZImagePickerController.h>
#import <TZVideoPlayerController.h>

@protocol MAPAddCommentViewControllerDelegate <NSObject>

- (void)removeMessageView;

@end

@interface MAPAddCommentViewController : UIViewController <MAPAddCommentViewDelegate, BMKMapViewDelegate, TZImagePickerControllerDelegate, AVAudioPlayerDelegate>

@property (nonatomic, weak) id <MAPAddCommentViewControllerDelegate> delegate;

@property (nonatomic, copy) NSString *type;

@property (nonatomic, assign) BOOL isSelect;

@property (nonatomic, copy) NSString *audioTime;

@property (nonatomic, copy) NSURL *audioUrl;

@property (nonatomic, copy) NSData *audioData;

@property (nonatomic, strong) AVAudioPlayer *audioPlayer;

@property (nonatomic, strong) PHAsset *videoAsset;

@property (nonatomic, strong) NSArray *imageArray;

@property (nonatomic, copy) NSString *videoPath;                // 视频路径

@property (nonatomic, copy) NSURL *videoUrl;                    // 视频 url

@property (nonatomic, strong) AVPlayer *videoPlayer;            // 视频播放器

@property (nonatomic, strong) AVPlayerItem *videoItem;          // 视频播放单元

@property (nonatomic, strong) AVPlayerLayer *videoPlayerLayer;  // 视频播放界面

@property (nonatomic, strong) UIButton *backButton;

@property (nonatomic, copy) NSString *pointName;

@property (nonatomic, assign) int pointId;

@property (nonatomic, assign) BOOL chooseImage;

@property (nonatomic, assign) double Latitude;

@property (nonatomic, assign) double Longitud;

@property (nonatomic, strong) MAPAddCommentView *mainView;

@property (nonatomic, strong) TZImagePickerController *imagePickerController;

@property (nonatomic, strong) TZVideoPlayerController *videoPlayerController;

- (void)selectFromoAlbum;

@end
