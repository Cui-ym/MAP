//
//  MAPMessageCommentView.h
//  地图
//
//  Created by 崔一鸣 on 2018/5/15.
//  Copyright © 2018年 崔一鸣. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MAPMessageCommentViewDelegate <NSObject>

- (void)clickTableViewCellWithSection:(int)section;

@end

@interface MAPMessageCommentView : UIView

@property (nonatomic, weak) id<MAPMessageCommentViewDelegate> delegate;

@property (nonatomic, copy) NSArray *commentArray;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *headerViewHeightMutableArray;

- (void)calculateHeight;

@end
