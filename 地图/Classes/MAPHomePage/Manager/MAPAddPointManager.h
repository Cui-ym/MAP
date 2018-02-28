//
//  MAPAddPointManager.h
//  地图
//
//  Created by 崔一鸣 on 2018/2/27.
//  Copyright © 2018年 崔一鸣. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MAPResultModel.h"

// 成功回调的 block
typedef void(^MAPResultHandle)(MAPResultModel *resultModel);

// 失败回调的 block
typedef void(^MAPErrorHandle)(NSError *error);

@interface MAPAddPointManager : NSObject

+ (instancetype)sharedManager;

/**
 *上传点坐标的方法
 *@param name 坐标点的名字
 *@param latitude 纬度
 *@param longitude 经度
 */
- (void)addPointWithName:(NSString *)name Latitude:(double)latitude Longitude:(double)longitude success:(MAPResultHandle)successBlock error:(MAPErrorHandle)errorBlock;

/**
 *上传文字信息的方法
 *@param pointId 点的ID
 *@param content 信息内容
 */
- (void)addMessageWithPointId:(int)pointId Content:(NSString *)content success:(MAPResultHandle)successBlock error:(MAPErrorHandle)errorBlock;

/**
 *上传图片，音频，视频文件
 *@param file 添加的数据
 *@param type 数据类型   （1 图片，2 音频，3 视频)
 *@param pointId 点的ID
 */
- (void)uploadWithPointId:(NSInteger)pointId File:(NSData *)file Type:(int)type success:(MAPResultHandle)succeedBlock error:(MAPErrorHandle)errorBlock;;

@end
