//
//  MAPAddPointManager.m
//  地图
//
//  Created by 崔一鸣 on 2018/2/27.
//  Copyright © 2018年 崔一鸣. All rights reserved.
//

#import "MAPAddPointManager.h"

#import "AFNetworking.h"

@implementation MAPAddPointManager

+ (instancetype)sharedManager {
    static MAPAddPointManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    return manager;
}

- (void)addPointWithName:(NSString *)name Latitude:(double)latitude Longitude:(double)longitude success:(MAPResultHandle)successBlock error:(MAPErrorHandle)errorBlock {
    NSString *URL = [NSString stringWithFormat:@"http://47.95.207.40/markMap/point/addPoint"];
    NSDictionary *param = @{@"name" : name, @"longitude" : [NSNumber numberWithDouble:longitude], @"latitude" : [NSNumber numberWithDouble:latitude]};
    NSString *token = @"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NSwidHlwZSI6InVzZXIiLCJleHAiOjE1MjAzMjI0NjUsImlhdCI6MTUxOTcxNzY2NSwidXNlcm5hbWUiOiLltJTltJTltJTltJTltJQifQ.1zJLwy_wEqFWJbxyFmFE1GVU0-8KGVaD9iZmtqBtM2E";
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/plain", nil];
    
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"token"];
    
    [manager POST:URL parameters:param progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSError *error;
        MAPResultModel *result = [[MAPResultModel alloc] initWithDictionary:responseObject error:&error];
        NSLog(@"%@", result);
        if (result.status == 0) {
            successBlock(result);
        } else {
            NSError *error = [[NSError alloc] initWithDomain:result.message code:(NSInteger)result.status userInfo:nil];
            errorBlock(error);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error);
        errorBlock(error);
    }];
}

- (void)addMessageWithPointId:(int)pointId Content:(NSString *)content success:(MAPResultHandle)successBlock error:(MAPErrorHandle)errorBlock {
    NSString *URL = [NSString stringWithFormat:@"http://47.95.207.40/markMap/point/addPoint"];
    NSDictionary *param = @{@"pointId" : [NSNumber numberWithInt:pointId], @"content" : content};
    NSString *token = @"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NSwidHlwZSI6InVzZXIiLCJleHAiOjE1MjAzMjI0NjUsImlhdCI6MTUxOTcxNzY2NSwidXNlcm5hbWUiOiLltJTltJTltJTltJTltJQifQ.1zJLwy_wEqFWJbxyFmFE1GVU0-8KGVaD9iZmtqBtM2E";
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/plain", nil];
    
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"token"];
    
    [manager POST:URL parameters:param progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSError *error;
        MAPResultModel *result = [[MAPResultModel alloc] initWithDictionary:responseObject error:&error];
        NSLog(@"%@", result);
        if (result.status == 0) {
            successBlock(result);
        } else {
            NSError *error = [[NSError alloc] initWithDomain:result.message code:(NSInteger)result.status userInfo:nil];
            errorBlock(error);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error);
        errorBlock(error);
    }];
}

@end
