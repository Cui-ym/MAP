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

@property (nonatomic, assign) int ID;

@property (nonatomic, copy) NSString *username;

@property (nonatomic, strong) NSObject *content;

//@property (nonatomic, copy) NSArray *content;

@property (nonatomic, copy) NSString *createAt;

@property (nonatomic, assign) NSInteger pointId;

@property (nonatomic, assign) NSInteger type;

@property (nonatomic, assign) NSInteger clickCount;

@property (nonatomic, assign) NSInteger remarkCount;

@end

@interface MAPCoordinateModel : MAPResultModel

@property (nonatomic, copy) NSArray <Optional,MAPDataItemModel> *data;

@end
