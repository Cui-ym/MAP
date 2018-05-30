//
//  MAPMessageCommentView.m
//  地图
//
//  Created by 崔一鸣 on 2018/5/15.
//  Copyright © 2018年 崔一鸣. All rights reserved.
//

#import "MAPMessageCommentView.h"
#import "MAPCoordinateModel.h"
#import "UILabel+LabelHeight.h"
#import "MAPMessageHeaderView.h"
#import "MAPMessageFooterView.h"
#import "MAPMessageTableViewCell.h"

@interface MAPMessageCommentView() <UITableViewDelegate, UITableViewDataSource>


@end

@implementation MAPMessageCommentView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.headerViewHeightMutableArray = [NSMutableArray array];
        self.tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStyleGrouped];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_tableView];
    }
    return self;
}

- (void)calculateHeight {
    NSLog(@"%@", _commentArray);
    for (id obj in _commentArray) {
        CGFloat height = [UILabel_LabelHeight getHeightByWidth:self.frame.size.width * 0.88 - 30 title:[obj content] font:[UIFont systemFontOfSize:15]];
        height += self.frame.size.width * 0.06 + 25;
        [self.headerViewHeightMutableArray addObject:[NSNumber numberWithFloat:height]];
    }
//    NSLog(@"headerViewHeightArray:%@", _headerViewHeightMutableArray);
    [self.tableView registerClass:[MAPMessageTableViewCell class] forCellReuseIdentifier:@"messageViewCell"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return [_headerViewHeightMutableArray[section] floatValue];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 30;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _commentArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    MAPMessageHeaderView *headerView = [[MAPMessageHeaderView alloc] init];
    headerView.nicknameLabel.text = [_commentArray[section] username];
    headerView.commentLabel.text = (NSString *)[_commentArray[section] content];
    return headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    MAPMessageFooterView *footerView = [[MAPMessageFooterView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 30)];
    footerView.timeLabel.text = [_commentArray[section] createAt];
    footerView.likeCount = [_commentArray[section] clickCount];
    footerView.commentCount = [_commentArray[section] remarkCount];
    return footerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MAPMessageTableViewCell *messageTableViewCell = [tableView dequeueReusableCellWithIdentifier:@"messageViewCell" forIndexPath:indexPath];
    NSArray *userArray = [NSArray arrayWithObjects:@"崔一鸣", @"赵东", @"李飞艳", @"毋昕仪", @"赵泽宇", @"和书诚", @"孟晨", @"许世豪", @"李黎野", @"万建新", nil];
    NSArray *replyArray = [NSArray arrayWithObjects:@"服务生领卡", @"哦入去皮哦额为", @"从发的是那种吗", @"加快放大书法书法大师发大水短发十分大算法了就", @"银行卡不见不发", @"文如其人", @"范德萨发", @"服务商距离看你吧", @"回复孤可激发快乐傲", @"将范德雷克多久啊", nil];
    messageTableViewCell.fromUser = userArray[indexPath.row];
    messageTableViewCell.toUser = userArray[9 - indexPath.row];
    messageTableViewCell.comment = replyArray[indexPath.row];
    return messageTableViewCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(clickTableViewCellWithSection:)]) {
        [_delegate clickTableViewCellWithSection:(int)indexPath.section];
    }
}

@end
