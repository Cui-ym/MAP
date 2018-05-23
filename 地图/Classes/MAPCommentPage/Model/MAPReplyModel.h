//
//  MAPReplyModel.h
//  地图
//
//  Created by 崔一鸣 on 2018/5/15.
//  Copyright © 2018年 崔一鸣. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MAPReplyModel : NSObject

@property (nonatomic, copy) NSString *type;

@property (nonatomic, copy) NSString *fromUser;

@property (nonatomic, copy) NSString *toUser;

@property (nonatomic, copy) NSString *text;

@property (nonatomic, copy) NSString *reply;

- (NSAttributedString *)getAttributedReplyString;

@end
