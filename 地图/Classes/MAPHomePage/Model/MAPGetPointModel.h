//
//  MAPGetPointModel.h
//  地图
//
//  Created by 崔一鸣 on 2018/2/6.
//  Copyright © 2018年 崔一鸣. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSONModel.h"
#import "MAPResultModel.h"

@protocol MAPPointItemModel

@end

@interface MAPPointItemModel : JSONModel

@property (nonatomic, copy) NSString *createAt;

@property (nonatomic, assign) int createBy;

@property (nonatomic, assign) int ID;

@property (nonatomic, assign) int mesCount;

@property (nonatomic, assign) int phoCount;

@property (nonatomic, assign) int audCount;

@property (nonatomic, assign) int vidCount;

@property (nonatomic, assign) double latitude;

@property (nonatomic, assign) double longitude;

@property (nonatomic, copy) NSString *pointName;

@end

@interface MAPGetPointModel : MAPResultModel

@property (nonatomic, copy) NSArray <Optional, MAPPointItemModel>* data;

@end
