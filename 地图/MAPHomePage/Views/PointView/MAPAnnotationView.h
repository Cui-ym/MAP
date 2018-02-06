//
//  MAPAnnotationView.h
//  地图
//
//  Created by 崔一鸣 on 2018/2/6.
//  Copyright © 2018年 崔一鸣. All rights reserved.
//

#import <BaiduMapAPI_Map/BMKAnnotationView.h>
#import "MAPPaoPaoView.h"

@interface MAPAnnotationView : BMKAnnotationView

@property (nonatomic, readonly) MAPPaoPaoView *paoView;

@end
