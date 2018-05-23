//
//  MAPMessageTableViewCell.h
//  地图
//
//  Created by 崔一鸣 on 2018/2/10.
//  Copyright © 2018年 崔一鸣. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MAPMessageTableViewCellDelegate<NSObject>


@end

@interface MAPMessageTableViewCell : UITableViewCell

@property (nonatomic, copy) NSString *fromUser;

@property (nonatomic, copy) NSString *toUser;

@property (nonatomic, copy) NSString *comment;

@end
