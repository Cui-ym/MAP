//
//  MAPCoordinateModel.m
//  地图
//
//  Created by 崔一鸣 on 2018/2/6.
//  Copyright © 2018年 崔一鸣. All rights reserved.
//

#import "MAPCoordinateModel.h"

@implementation MAPCoordinateModel

@end

@implementation MAPDataItemModel

+(JSONKeyMapper *)keyMapper{
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id":@"ID"}];
}

@end
