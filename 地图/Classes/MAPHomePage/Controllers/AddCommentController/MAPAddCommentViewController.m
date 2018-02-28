//
//  MAPAddCommentViewController.m
//  地图
//
//  Created by 崔一鸣 on 2018/2/28.
//  Copyright © 2018年 崔一鸣. All rights reserved.
//

#import "MAPAddCommentViewController.h"

@interface MAPAddCommentViewController ()

@end

@implementation MAPAddCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mainView = [[MAPAddCommentView alloc] initWithFrame:self.view.frame];
    self.mainView.pointName = _pointName;
    [self.view addSubview:_mainView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
