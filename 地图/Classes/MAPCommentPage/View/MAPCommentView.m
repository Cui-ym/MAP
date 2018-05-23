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
#define Width self.frame.size.width
#define Height self.frame.size.height

@implementation MAPCommentView

{
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
            CGFloat cellHeight = [MAPImageTableViewCell cellHeightWithImageArray:imageMutableArray size:CGSizeMake(self.frame.size.width, 0)];
            [cellHeightArray addObject:[NSNumber numberWithFloat:cellHeight]];
        }
        
    } else if (_type == 3) {            // 视频评论
        // 初始化视频占位图字典
        coverImageDictionary = [NSMutableDictionary dictionary];
        [_commentTableView registerClass:[MAPVideoTableViewCell class] forCellReuseIdentifier:videoCell];
        for (id obj in _commentArray) {
            CGFloat height = [MAPVideoTableViewCell cellHeightWithComment:[obj content] size:CGSizeMake(self.frame.size.width * 0.9, 0)];
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
            imageCommentCell.imageCollectionView.frame = CGRectMake(Width * 0.24, 40, Width * 0.6 + 10, (Width * 0.2 + 5) * num);
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
        videoTableCell.indexRow = (int)indexPath.row;
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
    NSString *string = [NSString stringWithFormat:@"http://47.95.207.40/markMapFile%@", [_commentArray[indexPath.row] content]];
    NSURL *url = [NSURL URLWithString:string];
    UIImage *coverImage;
    if ([_delegate respondsToSelector:@selector(getVideoCoverImagesWithURL:)]) {
        coverImage = [self.delegate getVideoCoverImagesWithURL:url];
        [coverImageDictionary setObject:coverImage forKey:[NSNumber numberWithInteger:indexPath.row]];
        return coverImage;
    }
    return nil;
}

// 获得图片数组
- (void)initImageMutableArrayWithCommentNumber:(int)number {
    NSString *imageString = [_commentArray[number] content];
    NSInteger location = 1;
    imageMutableArray = [NSMutableArray array];
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
}

// 播放视频
- (void)videoPlayWithButton:(UIButton *)sender Row:(int)row {
    NSLog(@"%@", [_commentArray[row] content]);
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://47.95.207.40/markMapFile%@", [_commentArray[row] content]]] ;
    if ([_delegate respondsToSelector:@selector(videoPlayWithUrl:)]) {
        [_delegate videoPlayWithUrl:url];
    }
}

// 播放语音
- (void)audioPlayWithButton:(UIButton *)sender Row:(NSInteger)row {
    NSLog(@"%@", [_commentArray[row] content]);
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://47.95.207.40/markMapFile%@", [_commentArray[row] content]]];
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
