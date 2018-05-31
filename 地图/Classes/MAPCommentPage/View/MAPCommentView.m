//
//  MAPCommentView.m
//  地图
//
//  Created by 崔一鸣 on 2018/2/10.
//  Copyright © 2018年 崔一鸣. All rights reserved.
//

#import "MAPCommentView.h"
#import "MAPCoordinateModel.h"
#import "UIImageView+WebCache.h"
#import "MAPMessageTableViewCell.h"
#import "Masonry.h"

#define videoCell @"videoCell"
#define audioCell @"audioCell"
#define commentCell @"commentCell"
#define OneimageCell @"OneimageCell"
#define TwoimageCell @"TwoimageCell"
#define ThreeimageCell @"ThreeimageCell"

#define kWidth self.frame.size.width
#define kHeight self.frame.size.height

@interface MAPCommentView ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *viewPictureScrollView;

@property (nonatomic, strong) UIPageControl *pageControl;

@property (nonatomic, strong) UIView *backgroundView;

@end

@implementation MAPCommentView

{
    NSString *title;
    UIImageView *imageView;
    NSMutableArray *cellHeightArray;
    NSMutableArray *imageMutableArray;
    NSMutableArray *imageNumberArray;
    NSMutableDictionary *oneImageCellHeightDictionary;
    NSMutableDictionary *btnStatusDictionary;
    
    NSMutableArray *isCoverImage;
    NSMutableDictionary *coverImageDictionary;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.blurryView = [[UIView alloc] initWithFrame:frame];
        [self addSubview:_blurryView];
        
        self.cancelButton = [[UIButton alloc] init];
        [self addSubview:_cancelButton];
        
        btnStatusDictionary = [NSMutableDictionary dictionary];
        oneImageCellHeightDictionary = [NSMutableDictionary dictionary];
        imageNumberArray = [NSMutableArray array];
        imageMutableArray = [NSMutableArray array];
    }
    return self;
}

// 点赞与评论
- (void)clickButton:(UIButton *)sender type:(NSString *)type timeLabel:(UILabel *)timeLabel{
    if ([type isEqual:@"like"]) {
        if ([btnStatusDictionary valueForKey:timeLabel.text] == NULL) {
            [btnStatusDictionary setObject:@"1" forKey:timeLabel.text];
        } else {
            [btnStatusDictionary setObject:[[btnStatusDictionary valueForKey:timeLabel.text]  isEqual: @"0"] ? @"1" : @"0" forKey:timeLabel.text];
        }
    }
    
    if (sender.selected == YES) {
        [sender setSelected:NO];
    } else {
        [sender setSelected:YES];
    }
}

- (void)calculateHeight {
    cellHeightArray = [NSMutableArray array];
    // 设置 tableView
    self.commentTableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStylePlain];
    [self addSubview:_commentTableView];
    
    if (_type == 1) {                   // 图片评论
        [_commentTableView registerClass:[MAPImageTableViewCell class] forCellReuseIdentifier:OneimageCell];
        [_commentTableView registerClass:[MAPImageTableViewCell class] forCellReuseIdentifier:TwoimageCell];
        [_commentTableView registerClass:[MAPImageTableViewCell class] forCellReuseIdentifier:ThreeimageCell];
        for (int i = 0; i < _commentArray.count; i++) {
            [self initImageMutableArrayWithCommentNumber:i];
            
            [imageNumberArray addObject:[NSNumber numberWithInteger:imageMutableArray.count]];
            CGFloat cellHeight = [MAPImageTableViewCell cellHeightWithImageArray:imageMutableArray size:CGSizeMake(kWidth, 0)];
            [cellHeightArray addObject:[NSNumber numberWithFloat:cellHeight]];
        }
        
    } else if (_type == 3) {            // 视频评论
        // 初始化视频占位图字典
        coverImageDictionary = [NSMutableDictionary dictionary];
        [_commentTableView registerClass:[MAPVideoTableViewCell class] forCellReuseIdentifier:videoCell];
        for (id obj in _commentArray) {
            NSDictionary *dictionary = [NSDictionary dictionaryWithDictionary:(NSDictionary *)[obj content]];
            CGFloat height = [MAPVideoTableViewCell cellHeightWithComment:dictionary[@"title"] size:CGSizeMake(kWidth, 0)];
            [cellHeightArray addObject:[NSNumber numberWithFloat:height]];
        }
    } else if (_type == 2) {            // 语音评论
        [_commentTableView registerClass:[MAPAudioTableViewCell class] forCellReuseIdentifier:audioCell];
    }
    self.commentTableView.delegate = self;
    self.commentTableView.dataSource = self;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_type == 2) {           // 语音评论
        return 110.0;
    }
    if (indexPath.row >= cellHeightArray.count) {
        return 200.0;
    }
    return [cellHeightArray[indexPath.row] floatValue];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _commentArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.type == 1) {
        MAPImageTableViewCell *imageCommentCell = nil;
        if ([imageNumberArray[indexPath.row] intValue] == 1) {
            imageCommentCell = [tableView dequeueReusableCellWithIdentifier:OneimageCell forIndexPath:indexPath];
        } else if ([imageNumberArray[indexPath.row] intValue] == 2 || [imageNumberArray[indexPath.row] intValue] == 4) {
            imageCommentCell = [tableView dequeueReusableCellWithIdentifier:TwoimageCell forIndexPath:indexPath];
        } else {
            imageCommentCell = [tableView dequeueReusableCellWithIdentifier:ThreeimageCell forIndexPath:indexPath];
        }
        
        if (imageCommentCell.imageCollectionView == nil && imageCommentCell.photoCommentImageView == nil) {
            imageCommentCell.flag = 0;
        }
        [self initImageMutableArrayWithCommentNumber:(int)indexPath.row];
        
        imageCommentCell.delegate = self;
        imageCommentCell.titleLabel.text = title;
        imageCommentCell.imageCount = [imageNumberArray[indexPath.row] intValue];
        imageCommentCell.imageArray = [NSArray arrayWithArray:imageMutableArray];
        imageCommentCell.nicknameLabel.text = [_commentArray[indexPath.row] username];
        imageCommentCell.timeLabel.text = [_commentArray[indexPath.row] createAt];
        imageCommentCell.likeCount = [_commentArray[indexPath.row] clickCount];
        imageCommentCell.commentCount = [_commentArray[indexPath.row] remarkCount];
        imageCommentCell.likeBtn.selected = [[btnStatusDictionary valueForKey:[NSString stringWithFormat:@"%@", imageCommentCell.timeLabel.text]] boolValue];
        // 设置瀑布流的 frame
        if (imageMutableArray.count != 1 && imageMutableArray.count != 2 && imageMutableArray.count != 4) {
            unsigned long num = [imageNumberArray[indexPath.row] intValue] % 3;
            if (num != 0) {
                num = [imageNumberArray[indexPath.row] intValue] / 3 + 1;
            } else {
                num = [imageNumberArray[indexPath.row] intValue] / 3;
            }
            imageCommentCell.imageCollectionView.frame = CGRectMake(kWidth * 0.25, 10 + kWidth * 0.14, kWidth * 0.6 + 10, (kWidth * 0.2 + 5) * num);
        }
        if (imageMutableArray.count == 1) {        // 如果只有一张照片更新高度
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://47.95.207.40/markMapFile%@", imageMutableArray[0]]];
            [imageCommentCell.photoCommentImageView sd_setImageWithURL:url completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                NSLog(@"图片加载成功");
            }];
        } else {                                   // 瀑布流 reloaData
            [imageCommentCell.imageCollectionView reloadData];
        }
        return imageCommentCell;
        
    } else if (_type == 3) {                       // 视频
        MAPVideoTableViewCell *videoTableCell = nil;
        videoTableCell = [tableView dequeueReusableCellWithIdentifier:videoCell forIndexPath:indexPath];
        videoTableCell.delegate = self;
        NSDictionary *dictionary = [NSDictionary dictionaryWithDictionary:(NSDictionary *)[_commentArray[indexPath.row] content]];
        title = dictionary[@"title"];
        videoTableCell.indexRow = (int)indexPath.row;
        videoTableCell.titleLabel.text = title;
        videoTableCell.likeCount = [_commentArray[indexPath.row] clickCount];
        videoTableCell.timeLabel.text = [_commentArray[indexPath.row] createAt];
        videoTableCell.commentCount = [_commentArray[indexPath.row] remarkCount];
        videoTableCell.nicknameLabel.text = [_commentArray[indexPath.row] username];
        videoTableCell.likeBtn.selected = [[btnStatusDictionary valueForKey:[NSString stringWithFormat:@"%@", videoTableCell.timeLabel.text]] boolValue];
        // 设置视频占位图
        if ([coverImageDictionary objectForKey:[NSNumber numberWithInteger:indexPath.row]] == nil) {
            [videoTableCell.videoCoverImageView setImage:[self reloadVideoCoverImageView:indexPath]];
        }
        [self reloadVideoCoverImageView:indexPath];
        return videoTableCell;
    } else {                                        // 语音评论
        MAPAudioTableViewCell *audioTableCell = nil;
        audioTableCell = [tableView dequeueReusableCellWithIdentifier:audioCell forIndexPath:indexPath];
        audioTableCell.delegate = self;
        audioTableCell.row = indexPath.row;
        audioTableCell.nicknameLabel.text = [_commentArray[indexPath.row] username];
        audioTableCell.timeLabel.text = [_commentArray[indexPath.row] createAt];
        audioTableCell.likeCount = [_commentArray[indexPath.row] clickCount];
        audioTableCell.commentCount = [_commentArray[indexPath.row] remarkCount];
        audioTableCell.likeBtn.selected = [[btnStatusDictionary valueForKey:[NSString stringWithFormat:@"%@", audioTableCell.timeLabel.text]] boolValue];
        return audioTableCell;
    }
    
}

// 更新视频图片
- (UIImage *)reloadVideoCoverImageView:(NSIndexPath *)indexPath {
    NSDictionary *dictionary = [NSDictionary dictionaryWithDictionary:(NSDictionary *)[_commentArray[indexPath.row] content]];
    NSString *string = dictionary[@"url"];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://47.95.207.40/markMapFile%@", string]];
    UIImage *coverImage;
    if ([_delegate respondsToSelector:@selector(getVideoCoverImagesWithURL:)]) {
        coverImage = [self.delegate getVideoCoverImagesWithURL:url];
        if (coverImage != nil) {
            [coverImageDictionary setObject:coverImage forKey:[NSNumber numberWithInteger:indexPath.row]];
        }
        return coverImage;
    }
    return nil;
}

// 获得图片数组
- (void)initImageMutableArrayWithCommentNumber:(int)number {
    NSDictionary *dictionary = [NSDictionary dictionaryWithDictionary:(NSDictionary *)[_commentArray[number] content]];
    imageMutableArray = [NSMutableArray arrayWithArray:dictionary[@"urls"]];
    title = dictionary[@"title"];
    NSLog(@"number:%d----%@", number, imageMutableArray);
}

// 浏览图片
- (void)viewPicturesWithImageArray:(NSArray *)imageArray andNumber:(NSInteger)number {
    if ([_delegate respondsToSelector:@selector(hideNavigationController)]) {
        [self.delegate hideNavigationController];
    }
    // 设置背景颜色为黑色
    NSInteger count = imageArray.count;
    self.backgroundView = [[UIView alloc] initWithFrame:self.frame];
    _backgroundView.backgroundColor = [UIColor blackColor];
    [self addSubview:_backgroundView];
    // 设置 scrollView 基本属性
    self.viewPictureScrollView = [[UIScrollView alloc] initWithFrame:self.frame];
    _viewPictureScrollView.contentSize = CGSizeMake(kWidth * count, kHeight);
    _viewPictureScrollView.pagingEnabled = YES;
    _viewPictureScrollView.delegate = self;
    // 给 scrollView 添加照片
    for (int i = 0; i < count; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(kWidth * i, 0, kWidth, kHeight)];
        NSString *imageString = [NSString stringWithFormat:@"http://47.95.207.40/markMapFile%@", imageArray[i]];
        NSURL *imageURL = [NSURL URLWithString:imageString];
        [imageView sd_setImageWithURL:imageURL];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [_viewPictureScrollView addSubview:imageView];
    }
    _viewPictureScrollView.contentOffset = CGPointMake(kWidth * number, 0);
    [_backgroundView addSubview:_viewPictureScrollView];
    // 设置 pageContrl
    self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, kHeight - 20, kWidth, 20)];
    self.pageControl.numberOfPages = imageArray.count;
    self.pageControl.currentPage = number;
    [self.pageControl addTarget:self action:@selector(pageTurn:) forControlEvents:UIControlEventValueChanged];
    [self.backgroundView addSubview:_pageControl];
    // 添加手势 点击结束浏览
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapViewPictureScrollView)];
    tapGestureRecognizer.numberOfTapsRequired = 1;
    [_backgroundView addGestureRecognizer:tapGestureRecognizer];
}

// 结束浏览
- (void)tapViewPictureScrollView {
    if ([_delegate respondsToSelector:@selector(dishideNavigationController)]) {
        [self.delegate dishideNavigationController];
    }
    [self.backgroundView removeFromSuperview];
}

// scrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGPoint offset = scrollView.contentOffset;
    int number = offset.x / kWidth;
    _pageControl.currentPage = number;
}

// 点击 pageControl 翻页
- (void)pageTurn:(UIPageControl *)pageControl {
    NSInteger number = pageControl.currentPage;
    _viewPictureScrollView.contentOffset = CGPointMake(kWidth * number, 0);
}

// 播放视频
- (void)videoPlayWithButton:(UIButton *)sender Row:(int)row {
    NSDictionary *dictionary = [NSDictionary dictionaryWithDictionary:(NSDictionary *)[_commentArray[row] content]];
    NSString *string = dictionary[@"url"];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://47.95.207.40/markMapFile%@", string]];
    if ([_delegate respondsToSelector:@selector(videoPlayWithUrl:)]) {
        [_delegate videoPlayWithUrl:url];
    }
}

// 播放语音
- (void)audioPlayWithButton:(UIButton *)sender Row:(NSInteger)row {
    NSDictionary *dictionary = [NSDictionary dictionaryWithDictionary:(NSDictionary *)[_commentArray[row] content]];
    NSString *string = dictionary[@"url"];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://47.95.207.40/markMapFile%@", string]];
    if ([_delegate respondsToSelector:@selector(audioPlayWithUrl:)]) {
        [_delegate audioPlayWithUrl:url];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%ld   %f", indexPath.row, [cellHeightArray[indexPath.row] floatValue]);
}

/*
 for (id obj in _commentArray) {
 imageMutableArray = [NSMutableArray array];
 NSString *imageString = [obj content];
 NSInteger location = 1;
 while (1) {
 location = [imageString rangeOfString:@"&"].location;
 if (location < 1000) {
 NSString *tempString = [imageString substringToIndex:location];
 [imageMutableArray addObject:tempString];
 imageString = [imageString substringFromIndex:location + 1];
 } else {
 [imageMutableArray addObject:imageString];
 break;
 }
 }
 
 [imageNumberArray addObject:[NSNumber numberWithInteger:imageMutableArray.count]];
 if (imageMutableArray.count == 1) {
 self.tempImageView = [[UIImageView alloc] initWithFrame:self.frame];
 [self addSubview:_tempImageView];
 NSLog(@"%@  %@", _tempImageView, _tempImageView.image);
 NSString *string = [NSString stringWithFormat:@"http://47.95.207.40/markMapFile%@", imageMutableArray[0]];
 NSLog(@"%@", string);
 NSURL *url = [NSURL URLWithString:string];
 [_tempImageView sd_setImageWithURL:url placeholderImage:nil options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
 
 NSLog(@"下载进度--%f", (double)receivedSize / expectedSize);
 
 } completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
 NSLog(@"加载图片");
 [[SDImageCache sharedImageCache] storeImage:image forKey:string toDisk:YES completion:^{
 CGFloat cellHeight = [MAPImageTableViewCell cellHeightWithImageArray:imageMutableArray size:CGSizeMake(self.frame.size.width, 0)];
 [cellHeightArray addObject:[NSNumber numberWithFloat:cellHeight]];
 
 }];
 [_tempImageView removeFromSuperview];
 }];
 NSLog(@"%@  %@", _tempImageView, _tempImageView.image);
 } else {
 CGFloat cellHeight = [MAPImageTableViewCell cellHeightWithImageArray:imageMutableArray size:CGSizeMake(self.frame.size.width, 0)];
 [cellHeightArray addObject:[NSNumber numberWithFloat:cellHeight]];
 }
 
 }
 */

@end
