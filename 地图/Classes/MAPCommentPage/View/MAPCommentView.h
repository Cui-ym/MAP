//
//  MAPCommentView.h
//  地图
//
//  Created by 崔一鸣 on 2018/2/10.
//  Copyright © 2018年 崔一鸣. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MAPMessageTableViewCell.h"
#import "MAPImageTableViewCell.h"
#import "MAPVideoTableViewCell.h"
#import "MAPAudioTableViewCell.h"

@protocol MAPCommentViewDelegate <NSObject>

@required
// 隐藏状态栏
- (void)hideNavigationController;

// 显示状态栏
- (void)dishideNavigationController;

// 播放视频
- (void)videoPlayWithUrl:(NSURL *)videoUrl;

// 获取视频缩略图数组
- (UIImage *)getVideoCoverImagesWithURL:(NSURL *)url;

// 播放语音
- (void)audioPlayWithUrl:(NSURL *)audioUrl;

@end

@interface MAPCommentView : UIView <UITableViewDelegate, UITableViewDataSource, MAPMessageTableViewCellDelegate, MAPImageTableViewCellDelegate, MAPVideoTableViewCellDelegate, MAPAudioTableViewCellDelegate, UIScrollViewDelegate>

@property (nonatomic, weak) id<MAPCommentViewDelegate> delegate;

@property (nonatomic, assign) int type;

@property (nonatomic, copy) NSArray *commentArray;

@property (nonatomic, strong) UIView *blurryView;

@property (nonatomic, strong) UIButton *cancelButton;

@property (nonatomic, strong) UIImageView *tempImageView;

@property (nonatomic, strong) UITableView *commentTableView;


- (void)calculateHeight;

@end
