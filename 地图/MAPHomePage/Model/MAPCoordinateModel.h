//
//  MAPCoordinateModel.h
//  地图
//
//  Created by 崔一鸣 on 2018/2/6.
//  Copyright © 2018年 崔一鸣. All rights reserved.
//

#import "MAPResultModel.h"

@protocol MAPDataItemModel
@end

@interface MAPDataItemModel : JSONModel

@property (nonatomic, assign) NSInteger id;

@property (nonatomic, assign) NSInteger pointId;

@property (nonatomic, assign) NSInteger type;

@property (nonatomic, copy) NSString *content;

@end

@interface MAPCoordinateModel : MAPResultModel

@property (nonatomic, copy) NSArray <Optional,MAPDataItemModel> *data;

@end
