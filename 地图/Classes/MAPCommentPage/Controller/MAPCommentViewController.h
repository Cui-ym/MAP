//
//  MAPCommentViewController.h
//  地图
//
//  Created by 崔一鸣 on 2018/4/18.
//  Copyright © 2018年 崔一鸣. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVKit/AVKit.h>

@interface MAPCommentViewController : UIViewController 

@property (nonatomic, assign) int type;


@property (nonatomic, copy) NSArray *commentArray;

@property (nonatomic, copy) NSArray *navigationTitleArray;


@end
