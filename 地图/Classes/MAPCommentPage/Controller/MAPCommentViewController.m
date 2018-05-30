//
//  MAPCommentViewController.m
//  地图
//
//  Created by 崔一鸣 on 2018/4/18.
//  Copyright © 2018年 崔一鸣. All rights reserved.
//

#import "MAPCommentViewController.h"
#import "MAPVideoBottomView.h"
#import "MAPCommentView.h"

// 文字评论盖楼效果
#import "MAPMessageTableViewCell.h"
#import "MAPMessageCommentView.h"
#import "MAPMessageFooterView.h"
#import "MAPMessageHeaderView.h"

// 回复界面
#import "MAPReplyViewController.h"

#import <AVFoundation/AVFoundation.h>
#import <CoreMedia/CoreMedia.h>

#define kHEIGHT self.view.frame.size.height
#define kWIDTH self.view.frame.size.width

@interface MAPCommentViewController () <MAPCommentViewDelegate, MAPVideoBottmViewDelegate, MAPMessageFooterViewDelegate, MAPMessageCommentViewDelegate>

typedef NS_ENUM(NSInteger, PlayerStatus) {
    None,
    End,
    Play,
    Pause
};

// 评论界面
@property (nonatomic, strong) MAPCommentView *commentView;
@property (nonatomic, strong) MAPMessageCommentView *messageCommentView;

// 评论回复
@property (nonatomic, strong) MAPReplyViewController *replyViewController;

// 视频播放
@property (nonatomic, strong) AVPlayer *videoPlayer;
@property (nonatomic, strong) AVPlayerItem *videoPlayerItem;
@property (nonatomic, strong) AVPlayerLayer *videoPlayerLayer;
@property (nonatomic, assign) PlayerStatus playerStatu;

// 视频进度条
@property (nonatomic, strong) UITapGestureRecognizer *tap;
@property (nonatomic, strong) MAPVideoBottomView *videoBottomView;
@property (nonatomic, assign) BOOL isSliding;
@property (nonatomic, assign) CGFloat duration;
@property (nonatomic, assign) CGFloat fps;

// 语音播放
@property (nonatomic, strong) AVPlayer *audioPlayer;
@property (nonatomic, strong) AVPlayerItem *audioPlayerItem;
@property (nonatomic, strong) AVPlayerLayer *audioPlayerLayer;

@end

@implementation MAPCommentViewController

- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationTitleArray = [NSArray arrayWithObjects:@"文字评论", @"图片评论", @"语音评论", @"视频评论", nil];
    self.navigationItem.title = _navigationTitleArray[_type];
    self.navigationController.navigationBar.backgroundColor = [UIColor whiteColor];
    NSLog(@"type : %d", _type);
    if (_type == 0) {
        self.messageCommentView = [[MAPMessageCommentView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        self.messageCommentView.delegate = self;
        self.messageCommentView.commentArray = [NSArray arrayWithArray:_commentArray];
        [self.messageCommentView calculateHeight];
        [self.view addSubview:_messageCommentView];
    } else {
        NSLog(@"点击了非文字评论");
        self.commentView = [[MAPCommentView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        self.commentView.type = _type;
        self.commentView.delegate = self;
        self.commentView.commentArray = self.commentArray;
        [self.commentView calculateHeight];
        [self.view addSubview:_commentView];
        // 初始化音频播放器
        self.audioPlayer = [[AVPlayer alloc] init];
        self.playerStatu = Pause;
    }
    
    // Do any additional setup after loading the view.
}

// 播放语音
-(void)audioPlayWithUrl:(NSURL *)audioUrl {
    if (_playerStatu == Play) {
        [_audioPlayer pause];
    }
    _audioPlayer = [[AVPlayer alloc] initWithURL:audioUrl];
    [_audioPlayer play];
    _playerStatu = Play;
}

- (UIImage *)getVideoCoverImagesWithURL:(NSURL *)url {
    UIImage *coverImage;
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:url options:nil];
    NSLog(@"%@", url);
    AVAssetImageGenerator *generator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    generator.appliesPreferredTrackTransform = YES;
    CMTime time = CMTimeMake(1, 100);
    NSError *error = nil;
    CMTime actualTime;
    CGImageRef image = [generator copyCGImageAtTime:time actualTime:&actualTime error:&error];
    coverImage = [[UIImage alloc] initWithCGImage:image];
    CGImageRelease(image);
    return coverImage;
}

- (void)videoPlayWithUrl:(NSURL *)videoUrl {
    // 视频背景图
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWIDTH, kHEIGHT)];
    view.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:view];
    // 设置视频播放所需控件
    // 初始化照片信息
    self.videoPlayerItem = [AVPlayerItem playerItemWithURL:videoUrl];
    // 获取视频时间 fps
    _duration = CMTimeGetSeconds(_videoPlayerItem.asset.duration);
    _fps = [[[_videoPlayerItem.asset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0] nominalFrameRate];
    self.videoPlayer = [AVPlayer playerWithPlayerItem:_videoPlayerItem];
    self.videoPlayerLayer = [AVPlayerLayer playerLayerWithPlayer:_videoPlayer];
    self.videoPlayerLayer.frame = view.bounds;
    self.videoPlayerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
    [view.layer addSublayer:_videoPlayerLayer];
    
    // 初始化底部视图
    [self initVideoBottomView];
    
    // KVO 观察 videoPlayerItem 的 status 视频是否准备成功
    [self.videoPlayerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    
    // 监听 videoPlayer 是否播放完成
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(videoPlayerDidFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:_videoPlayerItem];
    
    // 设置代理方法
    __weak MAPCommentViewController *weakSelf = self;
    CMTime interval = _duration > 60.0 ? CMTimeMake(1, 1) : CMTimeMake(1, 30);
    
    // 这个方法可以实现每隔多长时间执行一次 block
    [_videoPlayer addPeriodicTimeObserverForInterval:interval queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        NSLog(@"--更新Slider--");
        if (weakSelf.isSliding) {
            NSLog(@"更新Slider");
            CGFloat currentTime = CMTimeGetSeconds(time);
            NSString *timeText = [NSString stringWithFormat:@"%@/%@", [weakSelf convert:currentTime], [weakSelf convert:weakSelf.duration]];
            weakSelf.videoBottomView.timeLabel.text = timeText;
            weakSelf.videoBottomView.videoSlider.value = currentTime / weakSelf.duration;
        }
    }];
    
//    [_videoPlayer play];
}

- (void)initVideoBottomView {
    self.videoBottomView = [[MAPVideoBottomView alloc] initWithFrame:CGRectMake(0, kHEIGHT - 100, kWIDTH, 100)];
    [self.view addSubview:_videoBottomView];
    self.videoBottomView.delegate = self;
    
    [_videoBottomView.videoSlider addTarget:self action:@selector(handleTouchDown:) forControlEvents:UIControlEventTouchDown];
    [_videoBottomView.videoSlider addTarget:self action:@selector(handleSlide:) forControlEvents:UIControlEventValueChanged];
    [_videoBottomView.videoSlider addTarget:self action:@selector(handleTouchUp:) forControlEvents:UIControlEventTouchUpInside];
    [_videoBottomView.videoSlider addTarget:self action:@selector(handleTouchUp:) forControlEvents:UIControlEventTouchUpOutside];

    self.tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [self.tap setNumberOfTapsRequired:1];
    [self.videoBottomView.videoSlider addGestureRecognizer:_tap];
}

// 时间字符格式规范
- (NSString *)convert:(CGFloat)time{
    int minute = time / 60;
    int second = time - minute * 60;
    NSString *minuteString;
    NSString *secondString;
    if (minute < 10) {
        minuteString = [NSString stringWithFormat:@"0%d", minute];
    } else {
        minuteString = [NSString stringWithFormat:@"%d", minute];
    }
    if (second < 10) {
        secondString = [NSString stringWithFormat:@"0%d", second];
    } else {
        secondString = [NSString stringWithFormat:@"%d", second];
    }
    return [NSString stringWithFormat:@"%@:%@", minuteString, secondString];
}

// 观察视频是否准备成功
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"status"]) {
        switch (_videoPlayerItem.status) {
            case AVPlayerItemStatusReadyToPlay:
                NSLog(@"视频准备成功");
                self.isSliding = YES;
                self.playerStatu = Play;
                [_videoBottomView.playButton setImage:[UIImage imageNamed:@"暂停"] forState:UIControlStateNormal];
                [self.videoPlayer play];
                break;
                
            case AVPlayerItemStatusUnknown:
                NSLog(@"AVPlayerItemStatusUnknown");
                break;
                
            case AVPlayerItemStatusFailed:
                NSLog(@"AVPlayerItemStatusFailed");
                break;
                
            default:
                NSLog(@"视频准备中");
                break;
        }
        
    }
    [object removeObserver:self forKeyPath:@"status"];
}

// 视频播放结束
- (void)videoPlayerDidFinished:(NSNotification *)notification {
    
    [_videoPlayer pause];
}

#pragma mark - SliederAction

- (void)handleTouchDown:(UISlider *)slider {
    NSLog(@"touchDown");
    _tap.enabled = NO;
    _isSliding = NO;
    if (_playerStatu == Play) {
        [_videoPlayer pause];
    }
}

- (void)handleTouchUp:(UISlider *)slider {
    NSLog(@"touchUP");
    _isSliding = YES;
    _tap.enabled = YES;
    if (_playerStatu == Play) {
        [_videoPlayer play];
    }
}

- (void)handleSlide:(UISlider *)slider {
    CMTime time = CMTimeMakeWithSeconds(_duration * slider.value, _fps);
    NSString *timeText = [NSString stringWithFormat:@"%@/%@", [self convert:_duration * slider.value], [self convert:_duration]];
    _videoBottomView.timeLabel.text = timeText;
    
    [_videoPlayer seekToTime:time toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
}

- (void)handleTap:(UITapGestureRecognizer *)recognizer {
    NSLog(@"Tap");
    CGPoint touchPoint = [recognizer locationInView:_videoBottomView.videoSlider];
    CGFloat value = touchPoint.x / CGRectGetWidth(_videoBottomView.videoSlider.frame);
    [_videoBottomView.videoSlider setValue:value animated:YES];
    
    if(_playerStatu == Play){
        [_videoPlayer pause];
    }
    CMTime time = CMTimeMakeWithSeconds(_duration * value, _fps);
    [_videoPlayer seekToTime:time toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero completionHandler:^(BOOL finished) {
        if(_playerStatu == Play){
            [_videoPlayer play];
        }
    }];
}

- (void)playDidFinished:(NSNotification *)notification{
    [_videoBottomView.playButton setImage:[UIImage imageNamed:@"播放"] forState:UIControlStateNormal];
    [_videoPlayer pause];
    _playerStatu = End;
}

- (void)videoPlay {
//    NSLog(@"点击播放按钮 %@", _playerStatu);
    if (_playerStatu == End) {
        NSLog(@"END");
        [_videoPlayer seekToTime:kCMTimeZero toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero completionHandler:^(BOOL finished) {
            [_videoBottomView.playButton setImage:[UIImage imageNamed:@"暂停"] forState:UIControlStateNormal];
            _isSliding = NO;
            [_videoPlayer play];
            _playerStatu = Play;
        }];
    } else if (_playerStatu == Play) {
        NSLog(@"PAUSE");
        [_videoBottomView.playButton setImage:[UIImage imageNamed:@"播放"] forState:UIControlStateNormal];
        _isSliding = NO;
        [_videoPlayer pause];
        _playerStatu = Pause;
    } else if (_playerStatu == Pause) {
        NSLog(@"PLAY");
        _isSliding = YES;
        [_videoBottomView.playButton setImage:[UIImage imageNamed:@"暂停"] forState:UIControlStateNormal];
        [_videoPlayer play];
        _playerStatu = Play;
    }
}
- (void)clickTableViewCellWithSection:(int)section {
    self.replyViewController = [[MAPReplyViewController alloc] init];
    NSLog(@"%@", _commentArray);
    self.replyViewController.replyCount = 10;
    [self.navigationController pushViewController:_replyViewController animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
