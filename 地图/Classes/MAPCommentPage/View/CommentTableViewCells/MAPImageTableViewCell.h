//
//  MAPImageTableViewCell.h
//  地图
//
//  Created by 崔一鸣 on 2018/4/8.
//  Copyright © 2018年 崔一鸣. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MAPImageCollectionViewCell.h"

@protocol MAPImageTableViewCellDelegate <NSObject>

- (void)clickButton:(UIButton *)sender type:(NSString *)type timeLabel:(UILabel *)timeLabel;

- (void)viewPicturesWithImageArray:(NSArray *)imageArray andNumber:(NSInteger)number;

@end

@interface MAPImageTableViewCell : UITableViewCell <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, weak) id <MAPImageTableViewCellDelegate> delegate;

@property (nonatomic, strong) UIImageView *headImageView;

@property (nonatomic, strong) UILabel *nicknameLabel;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, assign) long commentCount;

@property (nonatomic, assign) long likeCount;

@property (nonatomic, assign) int imageCount;

@property (nonatomic, assign) int flag;

@property (nonatomic, assign) float imageHeight;

@property (nonatomic, strong) UILabel *timeLabel;

@property (nonatomic, copy) NSArray *imageArray;

@property (nonatomic, strong) UIImageView *photoCommentImageView;

@property (nonatomic, strong) UICollectionView *imageCollectionView;

@property (nonatomic, strong) UICollectionViewFlowLayout *collectionLayout;

@property (nonatomic, strong) UIButton *likeBtn;

@property (nonatomic, strong) UIButton *commentBtn;

+(CGFloat)cellHeightWithImageArray:(NSArray *)imageArray size:(CGSize)contextSize;

@end
