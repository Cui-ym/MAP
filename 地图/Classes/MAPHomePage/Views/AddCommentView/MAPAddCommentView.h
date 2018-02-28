//
//  MAPAddCommentView.h
//  地图
//
//  Created by 崔一鸣 on 2018/2/28.
//  Copyright © 2018年 崔一鸣. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MAPAddCommentView : UIView <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, copy) NSString *type;

@property (nonatomic, copy) NSString *pointName; 

@property (nonatomic, strong) UITableView *tableView;

@end
