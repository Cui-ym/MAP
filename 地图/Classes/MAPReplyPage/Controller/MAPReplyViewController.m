//
//  MAPReplyViewController.m
//  地图
//
//  Created by 崔一鸣 on 2018/5/16.
//  Copyright © 2018年 崔一鸣. All rights reserved.
//

#import "MAPReplyViewController.h"
#import "MAPReplyView.h"

@interface MAPReplyViewController ()<MAPReplyViewDelegate>

@property (nonatomic, strong) MAPReplyView *replyView;

@end

@implementation MAPReplyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = [NSString stringWithFormat:@"%ld条回复", _replyCount];
    
    self.replyView = [[MAPReplyView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _replyView.delegate = self;
    [self.view addSubview:_replyView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillAppear:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillDisAppear:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)popUpKeyboard {
    [self.replyView addSubview:_replyView.grayBackgroundView];
    [self.replyView.replyTextView becomeFirstResponder];
    NSLog(@"弹出键盘 %d", _replyView.replyTextView.canBecomeFirstResponder);
}

- (void)keyboardWillAppear:(NSNotification *)notification {
    CGRect keyboardFrame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGFloat keyboardY = keyboardFrame.origin.y;
    [UIView animateWithDuration:duration animations:^{
        self.replyView.grayBackgroundView.transform = CGAffineTransformMakeTranslation(0, keyboardY - self.view.frame.size.height - 100);
    }];
}

- (void)pickUpKeyboard {
    [self.replyView.replyTextView resignFirstResponder];
    [self.replyView.grayBackgroundView removeFromSuperview];
}

- (void)keyboardWillDisAppear:(NSNotification *)notification {
    CGFloat duration=[notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView animateWithDuration:duration animations:^{
        self.replyView.grayBackgroundView.transform = CGAffineTransformMakeTranslation(0, 0);
    }];
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
