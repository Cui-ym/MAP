//
//  MAPImageTableViewCell.h
//  地图
//
//  Created by 崔一鸣 on 2018/4/8.
//  Copyright © 2018年 崔一鸣. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MAPImageTableViewCellDelegate <NSObject>

- (void)clickButton:(UIButton *)sender type:(NSString *)type timeLabel:(UILabel *)timeLabel;

@end

@interface MAPImageTableViewCell : UITableViewCell <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, weak) id <MAPImageTableViewCellDelegate> delegate;

@property (nonatomic, strong) UIImageView *headImageView;

@property (nonatomic, strong) UILabel *nicknameLabel;

@property (nonatomic, assign) long commentCount;

@property (nonatomic, assign) long likeCount;

@property (nonatomic, strong) UILabel *timeLabel;

@property (nonatomic, copy) NSArray *imageArray;

@property (nonatomic, strong) UIImageView *photoComment;

@property (nonatomic, strong) UICollectionView *imageCollectionView;

@property (nonatomic, strong) UICollectionViewFlowLayout *collectionLayout;

@property (nonatomic, strong) UIButton *likeBtn;

@property (nonatomic, strong) UIButton *commentBtn;

+(CGFloat)cellHeightWithComment:(NSString *)comment size:(CGSize)contextSize;

@end
