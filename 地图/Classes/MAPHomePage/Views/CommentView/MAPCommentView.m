//
//  MAPCommentView.m
//  地图
//
//  Created by 崔一鸣 on 2018/2/10.
//  Copyright © 2018年 崔一鸣. All rights reserved.
//

#import "MAPCommentView.h"

#import "Masonry.h"
#import "MAPCoordinateModel.h"

#define commentCell @"commentCell"

@implementation MAPCommentView

{
    NSMutableArray *cellHeightArray;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.blurryView = [[UIView alloc] initWithFrame:frame];
        [self addSubview:_blurryView];
        
        self.commentTableView = [[UITableView alloc] init];
        [_commentTableView registerClass:[MAPMessageTableViewCell class] forCellReuseIdentifier:commentCell];
        [self addSubview:_commentTableView];
        
        self.cancelButton = [[UIButton alloc] init];
        [self addSubview:_cancelButton];
        
        cellHeightArray = [NSMutableArray array];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    // 给背景添加毛玻璃效果
    self.blurryView.backgroundColor = [UIColor clearColor];
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:self.frame];
    toolbar.barStyle = UIBarStyleBlackTranslucent;
    [self.blurryView addSubview:toolbar];
    
    // 设置 tableView
    self.commentTableView.layer.masksToBounds = YES;
    self.commentTableView.layer.cornerRadius = 10.0;
    self.commentTableView.delegate = self;
    self.commentTableView.dataSource = self;
    [self.commentTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.width.equalTo(self.mas_width).multipliedBy(0.8);
        make.top.equalTo(self.mas_top).offset(64);
        make.bottom.equalTo(self.mas_bottom).offset(-80);
    }];
    
    // 设置取消按钮
    self.cancelButton.layer.masksToBounds = YES;
    self.cancelButton.layer.cornerRadius = 20;
    self.cancelButton.layer.borderWidth = 1.0;
    self.cancelButton.layer.borderColor = [UIColor whiteColor].CGColor;
    [self.cancelButton setImage:[UIImage imageNamed:@"cancel"] forState:UIControlStateNormal];
    [self.cancelButton addTarget:self action:@selector(removeView) forControlEvents:UIControlEventTouchUpInside];
    [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.commentTableView.mas_bottom).offset(20);
        make.height.and.width.mas_equalTo(40);
    }];
}

- (void)removeView {
    if ([_delegate respondsToSelector:@selector(removeCommentView)]) {
        [self.delegate removeCommentView];
    }
}

- (void)calculateHeight {
    for (id obj in _commentArray) {
        CGFloat height = [MAPMessageTableViewCell cellHeightWithComment:[obj content] size:CGSizeMake(self.frame.size.width, 0)];
        [cellHeightArray addObject:[NSNumber numberWithFloat:height]];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UILabel *myLabel = [[UILabel alloc] init];
    myLabel.frame = CGRectMake(0, 0, self.frame.size.width * 0.8, 50);
    myLabel.text = @"文字评论";
    myLabel.textAlignment = NSTextAlignmentCenter;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width * 0.8, 50)];
    [view addSubview:myLabel];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 50.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [cellHeightArray[indexPath.row] floatValue];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _commentArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    _commentCell = [tableView dequeueReusableCellWithIdentifier:commentCell forIndexPath:indexPath];
    _commentCell.nicknameLabel.text = [_commentArray[indexPath.row] username];
    _commentCell.timeLabel.text = [_commentArray[indexPath.row] createAt];
    _commentCell.commentLabel.text = [_commentArray[indexPath.row] content];
    return _commentCell;
}

@end
