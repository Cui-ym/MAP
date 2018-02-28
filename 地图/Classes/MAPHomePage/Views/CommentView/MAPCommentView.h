//
//  MAPCommentView.h
//  地图
//
//  Created by 崔一鸣 on 2018/2/10.
//  Copyright © 2018年 崔一鸣. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MAPMessageTableViewCell.h"

@protocol MAPCommentViewDelegate <NSObject>

@required
- (void)removeCommentView;

@end

@interface MAPCommentView : UIView <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) id<MAPCommentViewDelegate> delegate;

@property (nonatomic, copy) NSArray *commentArray;

@property (nonatomic, strong) UIView *blurryView;

@property (nonatomic, strong) UITableView *commentTableView;

@property (nonatomic, strong) UIButton *cancelButton;

@property (nonatomic, strong) MAPMessageTableViewCell *commentCell;

- (void)calculateHeight;

@end
