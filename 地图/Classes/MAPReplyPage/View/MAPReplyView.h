//
//  MAPReplyView.h
//  地图
//
//  Created by 崔一鸣 on 2018/5/16.
//  Copyright © 2018年 崔一鸣. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MAPReplyViewDelegate <NSObject>

- (void)popUpKeyboard;

- (void)pickUpKeyboard;

- (void)pushReplyComment:(NSString *)comment;

@end


@interface MAPReplyView : UIView

@property (nonatomic, weak) id <MAPReplyViewDelegate> delegate;

// 被评论用户的信息
@property (nonatomic, copy) NSString *timeString;

@property (nonatomic, copy) NSString *commentString;

@property (nonatomic, copy) NSURL *headImageViewUrl;

@property (nonatomic, copy) NSString *nicknameString;

@property (nonatomic, assign) int userId;

// 回复用户数组
@property (nonatomic, copy) NSArray *commentArray;

@property (nonatomic, strong) UITextView *replyTextView;

@property (nonatomic, strong) UIView *grayBackgroundView;

- (void)calculateHeight;

@end
