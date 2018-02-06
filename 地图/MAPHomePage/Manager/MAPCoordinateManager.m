//
//  MAPCoodinateManager.m
//  地图
//
//  Created by 崔一鸣 on 2018/2/6.
//  Copyright © 2018年 崔一鸣. All rights reserved.
//

#import "MAPCoordinateManager.h"
#import "AFNetworking.h"
#import "MAPCoordinateModel.h"
#import "MAPGetPointModel.h"

@implementation MAPCoordinateManager

static MAPCoordinateManager *manager = nil;

+ (id)sharedManager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    return manager;
}

- (void)fetchCoordinateDataWithPointID:(int)ID succeed:(MAPCoordinateHandle)succeedBlock error:(ErrorHandle)errorBlock{
    NSString *URL = [NSString stringWithFormat:@"http://47.95.207.40/map/getMessage/%d",ID];
    [[AFHTTPSessionManager manager] GET:URL parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSError *error;
        NSLog(@"resp:%@",responseObject);
        MAPCoordinateModel *model = [[MAPCoordinateModel alloc] initWithDictionary:responseObject error:&error];
        if (error) {
            errorBlock(error);
        }else{
            if (model.status == 0) {
                succeedBlock(model);
            }else{
                NSError *error = [[NSError alloc] initWithDomain:model.msg code:(NSInteger)model.status userInfo:nil];
                errorBlock(error);
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        errorBlock(error);
    }];
}

- (void)fetchPointWithLongitude:(double)longitude Latitude:(double)latitude Range:(int)range succeed:(MAPGetPointHandle)succeedBlock error:(ErrorHandle)errorBlock{
    NSString *URL = [NSString stringWithFormat:@"http://47.95.207.40/map/getPoints?longitude=%lf&latitude=%lf&range=%d",longitude,latitude,range];
    
    NSDictionary *param = @{@"longitude":[NSNumber numberWithDouble:longitude],@"latitude":[NSNumber numberWithDouble:latitude],@"range":[NSNumber numberWithInt:range]};
    
    [[AFHTTPSessionManager manager] POST:URL parameters:param progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"response : %@", responseObject);
        NSError *error;
        MAPGetPointModel *model = [[MAPGetPointModel alloc] initWithDictionary:responseObject error:&error];
        if (error) {
            NSLog(@"error");
            errorBlock(error);
        } else {
            if (model.msg == nil) {
                succeedBlock(model);
            } else {
                NSError *error = [[NSError alloc] initWithDomain:model.msg code:(NSInteger)model.status userInfo:nil];
                errorBlock(error);
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        errorBlock(error);
    }];
}
@end
