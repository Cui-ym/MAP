//
//  MAPResultModel.h
//  地图
//
//  Created by 崔一鸣 on 2018/2/6.
//  Copyright © 2018年 崔一鸣. All rights reserved.
//

#import "JSONModel.h"

@interface MAPResultModel : JSONModel

@property (nonatomic, assign) NSUInteger status;

@property (nonatomic, copy) NSString <Optional> *message;

@property (nonatomic, copy) NSString <Optional> *data;

@end
