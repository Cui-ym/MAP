//
//  MAPCoodinateManager.h
//  地图
//
//  Created by 崔一鸣 on 2018/2/6.
//  Copyright © 2018年 崔一鸣. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MAPCoordinateModel.h"
#import "MAPGetPointModel.h"

// 定位请求返回数据的block
typedef void(^MAPCoordinateHandle)(MAPCoordinateModel *resultModel);

// 获取周边point的回调block
typedef void(^MAPGetPointHandle)(MAPGetPointModel *pointModel);

// 请求失败统一回调block
typedef void(^ErrorHandle)(NSError *error);

@interface MAPCoordinateManager : NSObject

+ (instancetype)sharedManager;

// 获取坐标点的信息方法
- (void)fetchCoordinateDataWithPointID:(int)id succeed:(MAPCoordinateHandle)succeedBlock error:(ErrorHandle)errorBlock;

// 获取周围坐标的方法
- (void)fetchPointWithLongitude:(double)longitude Latitude:(double)latitude Range:(int)range succeed:(MAPGetPointHandle)succeedBlock error:(ErrorHandle)errorBlock;

@end
