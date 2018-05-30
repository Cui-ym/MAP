//
//  MAPAddCommentView.h
//  地图
//
//  Created by 崔一鸣 on 2018/2/28.
//  Copyright © 2018年 崔一鸣. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import "MAPImageCollectionViewCell.h"
#import "MAPAddCollectionViewCell.h"

@protocol MAPAddCommentViewDelegate <NSObject>

@required
- (void)popTextAlertController;
- (void)popTitleAlertController;

// 发表评论
- (void)popPostAlertController;
- (void)postTextComment:(NSString *)content;
- (void)postImageCommentWithArray:(NSArray *)imageArray andTitle:(NSString *)title;
- (void)postVideoCommentWithTitle:(NSString *)title;
- (void)postAudioComment;

// 选择图片
- (void)selectImage;

// 播放录音
- (void)playAudioWithUrl;

@end

@interface MAPAddCommentView : UIView <UITableViewDataSource, UITableViewDelegate, UITextViewDelegate, UITextFieldDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, weak) id <MAPAddCommentViewDelegate> delegate;

@property (nonatomic, strong) UICollectionViewFlowLayout *layout;

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) MAPAddCollectionViewCell *addCollectionViewCell;

@property (nonatomic, strong) MAPImageCollectionViewCell *imageCollectionViewCell;

@property (nonatomic, strong) BMKMapView *mapView;

@property (nonatomic, copy) NSString *type;

@property (nonatomic, copy) NSString *pointName;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UITextView *commentTextView;

@property (nonatomic, strong) UILabel *textNumLab;

@property (nonatomic, copy) NSString *audioTime;

// 视频占位照片
@property (nonatomic, strong) UIImageView *videoCoverImageView;

// 图片数组
@property (nonatomic, copy) NSArray<UIImage *> *imageArray;

// 警告窗口
@property (nonatomic, strong) UIAlertController *textAlert;

@property (nonatomic, strong) UIAlertController *postAlert;

@property (nonatomic, strong) UIAlertController *titleAlert;

- (void)initTableView;

@end
