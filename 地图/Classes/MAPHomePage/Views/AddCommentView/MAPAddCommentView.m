//
//  MAPAddCommentView.m
//  地图
//
//  Created by 崔一鸣 on 2018/2/28.
//  Copyright © 2018年 崔一鸣. All rights reserved.
//

#import "MAPAddCommentView.h"

#define height self.frame.size.height
#define width self.frame.size.width

@implementation MAPAddCommentView 

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        self.tableView = [[UITableView alloc] initWithFrame:self.frame];
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        [self addSubview:_tableView];
    }
    return self;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"tableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    if (indexPath.row == 0) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, height * 0.3)];
        view.backgroundColor = [UIColor yellowColor];
        [cell.contentView addSubview:view];
    } else if (indexPath.row == 1) {
        cell.textLabel.text = _pointName;
        cell.textLabel.adjustsFontSizeToFitWidth = YES;
        cell.textLabel.font = [UIFont systemFontOfSize:30];
    } else if (indexPath.row == 2) {
        UITextView *commentTextView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, width, height * 0.5)];
        [cell.contentView addSubview:commentTextView];
    } else if (indexPath.row == 3) {
        UIButton *postButton = [[UIButton alloc] init];
        postButton.frame = CGRectMake(0, 0, width, height * 0.1);
        [postButton setBackgroundColor:[UIColor colorWithRed:0.95f green:0.54f blue:0.54f alpha:1.00f]];
        [postButton setTitle:@"发 布" forState:UIControlStateNormal];
        [cell.contentView addSubview:postButton];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *array = [NSArray arrayWithObjects:[NSNumber numberWithFloat:0.3], [NSNumber numberWithFloat:0.1], [NSNumber numberWithFloat:0.5], [NSNumber numberWithFloat:0.1], nil];
    return height * [array[indexPath.row] floatValue];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

@end
