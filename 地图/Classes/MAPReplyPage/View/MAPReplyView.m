//
//  MAPReplyView.m
//  地图
//
//  Created by 崔一鸣 on 2018/5/16.
//  Copyright © 2018年 崔一鸣. All rights reserved.
//

#import "MAPReplyView.h"
#import "MAPReplyButton.h"
#import "UILabel+LabelHeight.h"
#import "MAPMessageHeaderView.h"

#define KWidth self.frame.size.width
#define KHeight self.frame.size.height

@interface MAPReplyView() <UITableViewDelegate, UITableViewDataSource, UITextViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, assign) float headerViewHeight;

@property (nonatomic, strong) NSMutableArray *cellHeightMutableArray;

// 回复评论
@property (nonatomic, strong) MAPReplyButton *replyButton;

@property (nonatomic, strong) UILabel *commentLabel;

@property (nonatomic, copy) NSString *replyString;

@property (nonatomic, strong) UIView *replyView;

@end

@implementation MAPReplyView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _commentString = @"西邮真的很漂亮";
        
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KWidth, KHeight - 40)];
        [self addSubview:_tableView];
        
        self.replyButton = [[MAPReplyButton alloc] initWithFrame:CGRectMake(0, KHeight - 60, KWidth, 60)];
        [self.replyButton addTarget:self action:@selector(clickReplyButton:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_replyButton];
        
        self.replyString = @"";
       
        _cellHeightMutableArray = [NSMutableArray array];
    }
    return self;
}

- (void)initGrayBackgroundView {
    self.grayBackgroundView = [[UIView alloc] initWithFrame:self.frame];
    self.grayBackgroundView.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
    [self addSubview:_grayBackgroundView];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGrayBackgroundView)];
    tapGestureRecognizer.numberOfTapsRequired = 1;
    [self.grayBackgroundView addGestureRecognizer:tapGestureRecognizer];
    
    self.replyTextView = [[UITextView alloc] initWithFrame:CGRectMake(0, KHeight, KWidth, 100)];
    self.replyTextView.textColor = [UIColor blackColor];
    self.replyTextView.font = [UIFont systemFontOfSize:15];
    self.replyTextView.backgroundColor = [UIColor whiteColor];
    self.replyTextView.text = _replyString;
    self.replyTextView.delegate = self;
    [self.grayBackgroundView addSubview:_replyTextView];
    
    
}

// 点击回复框
- (void)clickReplyButton:(UIButton *)sender {
    NSLog(@"点击评论按钮");
    [self initGrayBackgroundView];
    if ([_delegate respondsToSelector:@selector(popUpKeyboard)]) {
        [_delegate popUpKeyboard];
    }
}

// 点击灰色背景
- (void)tapGrayBackgroundView {
    if ([_delegate respondsToSelector:@selector(pickUpKeyboard)]) {
        [_delegate pickUpKeyboard];
    }
}

- (void)textViewDidChange:(UITextView *)textView {
    self.replyString = textView.text;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [self clickReturnButton];
        return NO;
    }
    return YES;
}

- (void)clickReturnButton {
    if ([_delegate respondsToSelector:@selector(pushReplyComment:)]) {
        [_delegate pushReplyComment:_replyTextView.text];
    }
}

- (void)calculateHeight {
    NSLog(@"%@", _commentString);
    _headerViewHeight = [UILabel_LabelHeight getHeightByWidth:KWidth * 0.88 - 30 title:_commentString font:[UIFont systemFontOfSize:15]];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
//    for (id obj in _commentArray) {
//        CGFloat cellHeight = [UILabel_LabelHeight getHeightByWidth:KWidth * 0.88 - 30 title:obj font:[UIFont systemFontOfSize:15]];
//        [_cellHeightMutableArray addObject:[NSNumber numberWithFloat:cellHeight]];
//    }
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    MAPMessageHeaderView *headerView = [[MAPMessageHeaderView alloc] initWithFrame:CGRectMake(0, 0, KWidth, _headerViewHeight + KWidth * 0.12 + 15)];
    
    return headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return _headerViewHeight + KWidth * 0.12 + 15;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return [_cellHeightMutableArray[indexPath.row] floatValue];
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 100;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
    //    return _commentArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    
    return cell;
}

@end
