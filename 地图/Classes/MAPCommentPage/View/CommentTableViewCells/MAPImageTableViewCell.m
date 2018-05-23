//
//  MAPImageTableViewCell.m
//  地图
//
//  Created by 崔一鸣 on 2018/4/8.
//  Copyright © 2018年 崔一鸣. All rights reserved.
//

#import "MAPImageTableViewCell.h"
#import "MAPImageCollectionViewCell.h"
#import "SDWebImageCompat.h"
#import "UIImageView+WebCache.h"
#import "Masonry.h"

#define Height self.frame.size.height
#define Width self.frame.size.width

@implementation MAPImageTableViewCell

+(CGFloat)cellHeightWithImageArray:(NSArray *)imageArray size:(CGSize)contextSize {
    double imageHeight = 100.0;
    if (imageArray.count == 1) {
        imageHeight = 100.0;
    } else if (imageArray.count == 2 || imageArray.count == 3) {
        imageHeight = contextSize.width * 0.2;
    } else if (imageArray.count >= 4 && imageArray.count <= 6) {
        imageHeight = contextSize.width * 0.4 + 5;
    } else if (imageArray.count >= 7 && imageArray.count <= 9) {
        imageHeight = contextSize.width * 0.6 + 10;
    }
    // 10 nickLibel 距离顶部距离
    // 30 nickLibel 高度
    imageHeight = imageHeight + 10 + 30 + 15 + 30;
    return imageHeight;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _flag = 1;
        
        self.headImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:_headImageView];
        
        self.nicknameLabel = [[UILabel alloc] init];
        [self.contentView addSubview:_nicknameLabel];
        
        self.timeLabel = [[UILabel alloc] init];
        [self.contentView addSubview:_timeLabel];
        
        self.commentBtn = [[UIButton alloc] init];
        [self.contentView addSubview:_commentBtn];
        
        self.likeBtn = [[UIButton alloc] init];
        [self.contentView addSubview:_likeBtn];
        
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(20);
        make.top.equalTo(self.contentView.mas_top).offset(10);
        make.height.and.width.equalTo(self.contentView.mas_width).multipliedBy(0.14);
    }];
    _headImageView.layer.masksToBounds = YES;
    _headImageView.layer.borderWidth = 1;
    _headImageView.layer.borderColor = [[UIColor whiteColor] CGColor];
    _headImageView.layer.cornerRadius = self.contentView.frame.size.width * 0.07;
    _headImageView.backgroundColor = [UIColor yellowColor];
    
    [self.nicknameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_headImageView.mas_right).offset(15);
        make.top.equalTo(_headImageView.mas_top);
        make.right.equalTo(self.contentView.mas_right).offset(-20);
    }];
    self.nicknameLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightThin];
    self.nicknameLabel.textColor = [UIColor colorWithRed:0.5f green:0.5f blue:0.5f alpha:1.00f];
    if (_flag == 0) {
        _flag = 1;
        if (_imageCount == 1) {
            self.photoCommentImageView = [[UIImageView alloc] init];
            [self.contentView addSubview:_photoCommentImageView];
            [self.photoCommentImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.contentView.mas_top).offset(40);
                make.left.equalTo(self.contentView.mas_left).offset(Width * 0.25);
                make.width.equalTo(self.contentView.mas_width).multipliedBy(0.4);
                make.height.mas_equalTo(100.0);
            }];
            self.photoCommentImageView.backgroundColor = [UIColor whiteColor];
            self.photoCommentImageView.contentMode = UIViewContentModeScaleAspectFit;
        } else if (_imageCount == 2 || _imageCount == 4){
            // 设置瀑布流
            self.collectionLayout = [[UICollectionViewFlowLayout alloc] init];
            _collectionLayout.minimumLineSpacing = 10;
            _collectionLayout.minimumInteritemSpacing = 5;
            self.imageCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(Width * 0.25, 40, Width * 0.4 + 5, (Width * 0.2 + 5) * _imageArray.count / 2) collectionViewLayout:_collectionLayout];
            self.imageCollectionView.backgroundColor = [UIColor clearColor];
            self.imageCollectionView.scrollEnabled = NO;
            [self.contentView addSubview:self.imageCollectionView];
            [self.imageCollectionView registerClass:[MAPImageCollectionViewCell class] forCellWithReuseIdentifier:@"imageCell"];
            self.imageCollectionView.delegate = self;
            self.imageCollectionView.dataSource = self;
        } else {
            // 设置瀑布流
            self.collectionLayout = [[UICollectionViewFlowLayout alloc] init];
            _collectionLayout.minimumLineSpacing = 10;
            _collectionLayout.minimumInteritemSpacing = 5;
            unsigned long num = _imageArray.count % 3;
            if (num != 0) {
                num = _imageCount / 3 + 1;
            } else {
                num = _imageCount / 3;
            }
            NSLog(@"--%d--", _imageCount);
            self.imageCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(Width * 0.25, 40, Width * 0.6 + 10, (Width * 0.2 + 5) * num) collectionViewLayout:_collectionLayout];
            self.imageCollectionView.backgroundColor = [UIColor clearColor];
            self.imageCollectionView.scrollEnabled = NO;
            [self.contentView addSubview:self.imageCollectionView];
            [self.imageCollectionView registerClass:[MAPImageCollectionViewCell class] forCellWithReuseIdentifier:@"imageCell"];
            self.imageCollectionView.delegate = self;
            self.imageCollectionView.dataSource = self;
        }
        
    }
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_nicknameLabel.mas_left);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-10);
        make.width.equalTo(self.contentView.mas_width).multipliedBy(0.35);
        make.height.mas_equalTo(20);
    }];
    self.timeLabel.font = [UIFont systemFontOfSize:12];
    
    [self.commentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-5);
        make.bottom.equalTo(_timeLabel.mas_bottom);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(60);
    }];
    [self.commentBtn setImage:[UIImage imageNamed:@"comt"] forState:UIControlStateNormal];
    [self.commentBtn setTitle:[NSString stringWithFormat:@"（%ld）", _commentCount] forState:UIControlStateNormal];
    self.commentBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.commentBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.commentBtn addTarget:self action:@selector(clickCommentButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.likeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_commentBtn.mas_left);
        make.bottom.equalTo(_timeLabel.mas_bottom);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(60);
    }];
    [self.likeBtn setImage:[UIImage imageNamed:@"like"] forState:UIControlStateNormal];
    [self.likeBtn setImage:[UIImage imageNamed:@"定位"] forState:UIControlStateSelected];
    self.likeBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.likeBtn setTitle:[NSString stringWithFormat:@"（%ld）", _likeCount] forState:UIControlStateNormal];
    [self.likeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.likeBtn addTarget:self action:@selector(clickLikeButton:) forControlEvents:UIControlEventTouchUpInside];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _imageCount;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MAPImageCollectionViewCell *imageCollectionViewCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"imageCell" forIndexPath:indexPath];
    [imageCollectionViewCell.imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://47.95.207.40/markMapFile%@", _imageArray[indexPath.row]]] placeholderImage:nil];
    
    return imageCollectionViewCell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (_imageCount == 1) {
        NSLog(@"更新大小 %f", _imageHeight);
        CGSize size = CGSizeMake(Width * 0.4, _imageHeight);
        return size;
    } else {
        CGSize size = CGSizeMake(Width * 0.2, Width * 0.2);
        return size;
    }
}

- (void)clickLikeButton:(UIButton *)sender {
    if ([_delegate respondsToSelector:@selector(clickButton: type: timeLabel:)]) {
        [_delegate clickButton:sender type:@"like" timeLabel:_timeLabel];
    }
}

- (void)clickCommentButton:(UIButton *)sender {
    if ([_delegate respondsToSelector:@selector(clickButton: type: timeLabel:)]) {
        [_delegate clickButton:sender type:@"comment" timeLabel:_timeLabel];
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
