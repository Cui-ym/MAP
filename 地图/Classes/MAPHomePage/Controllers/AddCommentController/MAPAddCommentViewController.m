//
//  MAPAddCommentViewController.m
//  地图
//
//  Created by 崔一鸣 on 2018/2/28.
//  Copyright © 2018年 崔一鸣. All rights reserved.
//
#import "MAPAddCommentViewController.h"
#import "MAPAddPointManager.h"
#import "MAPAnnotationView.h"
#import "Masonry.h"
#import "lame.h"

@interface MAPAddCommentViewController ()

@end

@implementation MAPAddCommentViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.mainView.mapView viewWillAppear];
    self.mainView.mapView.delegate = self;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.mainView.mapView viewWillDisappear];
    self.mainView.mapView.delegate = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mainView = [[MAPAddCommentView alloc] initWithFrame:self.view.frame];
    self.mainView.imageArray = [NSArray<UIImage *> arrayWithArray:_imageArray];
    self.mainView.type = _type;
    [self.mainView initTableView];
    self.mainView.pointName = _pointName;
    self.mainView.audioTime = _audioTime;
    self.mainView.delegate = self;
    [self movePointToCenter];
    [self.view addSubview:_mainView];
    
    self.imagePickerController = [[TZImagePickerController alloc] initWithMaxImagesCount:9 delegate:self];
    self.imagePickerController.allowPickingImage = _chooseImage;
    
    [self initBackButton];
    if (([_type isEqual:@"图片"] || [_type isEqual:@"视频"]) && _isSelect == YES) {
        [self selectFromoAlbum];
    }
    
    if ([_type isEqual:@"语音"]) {
        [self audio_lpcmToMp3];
    }
    
}

- (void)initBackButton {
    self.backButton = [[UIButton alloc] init];
    [_backButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [_backButton addTarget:self action:@selector(clickBackButton:) forControlEvents:UIControlEventTouchUpInside];
    _backButton.frame = CGRectMake(10, 20, 40, 40);
    [self.view addSubview:_backButton];
}

- (void)clickBackButton:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

// 将点标记移值地图中心点
- (void)movePointToCenter {
    BMKPointAnnotation *annotation = [[BMKPointAnnotation alloc] init];
    annotation.coordinate = CLLocationCoordinate2DMake(_Latitude, _Longitud);
    // 添加点
    [_mainView.mapView addAnnotation:annotation];
    // 移动到中心点
    _mainView.mapView.centerCoordinate = annotation.coordinate;
}

// 显示气泡
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id<BMKAnnotation>)annotation {
    NSLog(@"显示气泡");
    if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
        MAPAnnotationView *annotationView = (MAPAnnotationView *) [mapView dequeueReusableAnnotationViewWithIdentifier:@"mapIdentifier"];
        if (!annotationView) {
            NSLog(@"显示气泡");
            annotationView = [[MAPAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"mapIdentifier"];
        }
        return annotationView;
    }
    return nil;
}

// 代理方法 选择照片
- (void)selectImage {
    [self selectFromoAlbum];
}

// 选择照片
- (void)selectFromoAlbum {
    [self.mainView.tableView removeFromSuperview];
    [self presentViewController:_imagePickerController animated:YES completion:nil];
}

// 选择图片时点击取消按钮
- (void)tz_imagePickerControllerDidCancel:(TZImagePickerController *)picker {
    NSLog(@"cancle");
    [self.mainView.collectionView reloadData];
    [self.mainView initTableView];
}

// 完成选择图片
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto {
    NSLog(@"photos %lu", (unsigned long)photos.count);
    self.mainView.imageArray = [NSArray<UIImage *> arrayWithArray:photos];
    [self.mainView.collectionView reloadData];
    [self.mainView initTableView];
}

// 完成选择视频
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingVideo:(UIImage *)coverImage sourceAssets:(id)asset {
    NSString *tmp = NSTemporaryDirectory();
    NSLog(@"asset:%@ tmp:%@ fileName:%@", asset, tmp, [asset filename]);
    _videoPath = [NSString stringWithFormat:@"%@%@", tmp, [asset filename]];
    self.mainView.imageArray = [NSArray arrayWithObject:coverImage];
    [self.mainView.collectionView reloadData];
    [self.mainView initTableView];
}

// 播放视频
- (void)playVideoWithUrl:(NSURL *)videoUrl {
    NSLog(@"播放视频 %@", videoUrl);
    // 初始化播放单元
    self.videoItem = [AVPlayerItem playerItemWithURL:videoUrl];
    // 初始化一个播放器对象
    self.videoPlayer = [AVPlayer playerWithPlayerItem:_videoItem];
    // 初始化一个播放器的Layer
    self.videoPlayerLayer = [AVPlayerLayer playerLayerWithPlayer:_videoPlayer];
    self.videoPlayerLayer.frame = CGRectMake(0, 0, self.view.bounds.size.width, 500);
    [[PHImageManager defaultManager] requestPlayerItemForVideo:_videoAsset options:nil resultHandler:^(AVPlayerItem * _Nullable playerItem, NSDictionary * _Nullable info) {
        self.videoItem = playerItem;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.view.layer addSublayer:self.videoPlayerLayer];
            [self.videoPlayer play];
        });
    }];
}

- (void)popTextAlertController {
    [self presentViewController:self.mainView.textAlert animated:YES completion:nil];
}

- (void)popPostAlertController {
    [self presentViewController:self.mainView.postAlert animated:YES completion:nil];
}

- (void)popTitleAlertController {
    [self presentViewController:self.mainView.titleAlert animated:YES completion:nil];
}

// 上传文字评论
- (void)postTextComment:(NSString *)content {
    __weak MAPAddCommentViewController *weakSelf = self;
    [[MAPAddPointManager sharedManager] addMessageWithPointId:_pointId Content:content success:^(MAPResultModel *resultModel) {
        [weakSelf.navigationController popViewControllerAnimated:YES];
        if ([self.delegate respondsToSelector:@selector(removeMessageView)]) {
            [_delegate removeMessageView];
        }
        NSLog(@"添加成功");
    } error:^(NSError *error) {
        NSLog(@"添加失败");
    }];
}

// 上传图片评论
- (void)postImageCommentWithArray:(NSArray *)imageArray andTitle:(NSString *)title {
    NSMutableArray *dataArray = [NSMutableArray array];
    for (id image in imageArray) {
        NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
        [dataArray addObject:imageData];
    }
    __weak MAPAddCommentViewController *weakSelf = self;
//    [[MAPAddPointManager sharedManager] uploadWithPointId:_pointId Data:dataArray[0] Type:1 success:^(MAPResultModel *resultModel) {
//        NSLog(@"上传成功");
//    } error:^(NSError *error) {
//        NSLog(@"上传失败");
//    }];
//    __weak MAPAddCommentViewController *weakSelf = self;
    [[MAPAddPointManager sharedManager] uploadPhotosWithPointId:_pointId Title:title Data:dataArray success:^(MAPResultModel *resultModel) {
//        [weakSelf.navigationController popViewControllerAnimated:YES];
        NSLog(@"上传成功");
        [weakSelf.navigationController popViewControllerAnimated:YES];
    } error:^(NSError *error) {
        NSLog(@"上传失败");
    }];
}

// 上传音频评论
- (void)postAudioComment {
    NSLog(@"audioUrl---%@", _audioUrl);
    self.audioData = [NSData dataWithContentsOfURL:_audioUrl];
    NSLog(@"%@", _audioData);
    __weak MAPAddCommentViewController *weakSelf = self;
    [[MAPAddPointManager sharedManager] uploadWithPointId:_pointId Data:_audioData Type:2 Title:nil success:^(MAPResultModel *resultModel) {
        NSLog(@"上传成功");
        [weakSelf.navigationController popViewControllerAnimated:YES];
    } error:^(NSError *error) {
        NSLog(@"上传失败");
    }];
}

// 上传视频评论
- (void)postVideoCommentWithTitle:(NSString *)title {
    NSLog(@"%@", title);
    NSString *tmp = NSTemporaryDirectory();
    NSLog(@"videoPath---%@   tmp::%@", _videoPath, tmp);
    NSData *fileData = [NSData dataWithContentsOfFile:_videoPath];
    NSLog(@"%@", fileData);
    __weak MAPAddCommentViewController *weakSelf = self;
    [[MAPAddPointManager sharedManager] uploadWithPointId:_pointId Data:fileData Type:3 Title:title success:^(MAPResultModel *resultModel) {
        NSLog(@"上传成功");
        [weakSelf.navigationController popViewControllerAnimated:YES];
    } error:^(NSError *error) {
        NSLog(@"上传失败");
    }];
}

// 播放录音
- (void)playAudioWithUrl {
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    NSError * error;
    self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:_audioUrl error:&error];
    self.audioPlayer.delegate = self;
    BOOL success = [self.audioPlayer play];
    if (success) {
        NSLog(@"播放成功");
    } else {
        NSLog(@"播放失败");
    }
}

- (void)audio_lpcmToMp3 {
    NSString *savePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *lpcmFilePath = [savePath stringByAppendingPathComponent:@"test.lpcm"];
    NSString *mp3FilePath = [savePath stringByAppendingPathComponent:@"test.mp3"];
    @try {
        int read, write;
        
        FILE *pcm = fopen([lpcmFilePath cStringUsingEncoding:1], "rb");
        fseek(pcm, 4 * 1024, SEEK_CUR);
        FILE *mp3 = fopen([mp3FilePath cStringUsingEncoding:1], "wb");
        const int PCM_SIZE = 8192;
        const int MP3_SIZE = 8192;
        short int pcm_buffer[PCM_SIZE * 2];
        unsigned char mp3_buffer[MP3_SIZE];
        
        lame_t lame = lame_init();
        lame_set_in_samplerate(lame, 8000.0);
        lame_set_VBR(lame, vbr_default);
        lame_set_num_channels(lame, 2);
        lame_set_quality(lame, 2);
        lame_set_brate(lame, 16);
        lame_init_params(lame);
        
        do {
            read = (int)fread(pcm_buffer, 2 * sizeof(short int), PCM_SIZE, pcm);
            if (read == 0) {
                write = lame_encode_flush(lame, mp3_buffer, MP3_SIZE);
            } else {
                write = lame_encode_buffer_interleaved(lame, pcm_buffer, read, mp3_buffer, MP3_SIZE);
            }
            fwrite(mp3_buffer, write, 1, mp3);
            
        } while (read != 0);
        
        lame_close(lame);
        fclose(mp3);
        fclose(pcm);
    }
    @catch (NSException *exception) {
        NSLog(@"%@",[exception description]);
    }
    @finally {
        NSLog(@"MP3生成成功: %@",mp3FilePath);
        self.audioUrl = [NSURL fileURLWithPath:mp3FilePath];
    }
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
