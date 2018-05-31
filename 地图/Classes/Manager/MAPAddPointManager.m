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
//    NSString *URL = [NSString stringWithFormat:@"http://47.95.207.40/markMap/user/login"];
//    NSDictionary *param = @{@"account" : @"111111", @"password" : @"111111"};
    
    NSString *URL = [NSString stringWithFormat:@"http://47.95.207.40/markMap/point/addPoint"];
    NSDictionary *param = @{@"name" : name, @"longitude" : [NSNumber numberWithDouble:longitude], @"latitude" : [NSNumber numberWithDouble:latitude]};
    NSString *token = @"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NSwidHlwZSI6InVzZXIiLCJleHAiOjE1MjgwMjcyNzQsImlhdCI6MTUyNzQyMjQ3NCwidXNlcm5hbWUiOiLltJTltJTltJTltJTltJQifQ.zOxjRXii0fwAS4NNhgMQcQ-2dom5rjM3OmY8Ph2g8dQ";

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/plain", nil];

    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"token"];

    [manager POST:URL parameters:param progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSError *error;
        MAPResultModel *result = [[MAPResultModel alloc] initWithDictionary:responseObject error:&error];
        NSLog(@"%@", result.data);
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

// 文字评论
- (void)addMessageWithPointId:(int)pointId Content:(NSString *)content success:(MAPResultHandle)successBlock error:(MAPErrorHandle)errorBlock {
    NSString *URL = [NSString stringWithFormat:@"http://47.95.207.40/markMap/addMessage/%d", pointId];
    NSDictionary *param = @{@"content" : content};
    NSString *token = @"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NSwidHlwZSI6InVzZXIiLCJleHAiOjE1MjgwMjcyNzQsImlhdCI6MTUyNzQyMjQ3NCwidXNlcm5hbWUiOiLltJTltJTltJTltJTltJQifQ.zOxjRXii0fwAS4NNhgMQcQ-2dom5rjM3OmY8Ph2g8dQ";
    
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

// 上传多张图片
- (void)uploadPhotosWithPointId:(int)pointId Title:(NSString *)title Data:(NSArray *)fileDataArray success:(MAPResultHandle)succeedBlock error:(MAPErrorHandle)errorBlock {
    NSString *URL = [NSString stringWithFormat:@"http://47.95.207.40/markMap/uploadMangPhotos/%d", pointId];
    
    NSLog(@"--title : %@--", title);
    
    NSDictionary *param = @{@"pointId" : [NSNumber numberWithInt:pointId], @"photos" : fileDataArray, @"title" : title};
    NSString *token = @"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NSwidHlwZSI6InVzZXIiLCJleHAiOjE1MjgwMjcyNzQsImlhdCI6MTUyNzQyMjQ3NCwidXNlcm5hbWUiOiLltJTltJTltJTltJTltJQifQ.zOxjRXii0fwAS4NNhgMQcQ-2dom5rjM3OmY8Ph2g8dQ";
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/plain", nil];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"token"];
    
    [manager POST:URL parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        for (id obj in fileDataArray) {
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            // 设置时间格式
            formatter.dateFormat = @"yyyyMMddHHmmss";
            NSString *str = [formatter stringFromDate:[NSDate date]];
            NSString *fileName = [NSString stringWithFormat:@"%@.jpg", str];
            [formData appendPartWithFileData:obj name:@"file" fileName:fileName mimeType:@"image/jpeg"];
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
        NSLog(@"---上传进度--- %@",uploadProgress);
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"response : %@", responseObject);
        NSError *error;
        MAPResultModel *result = [[MAPResultModel alloc] initWithDictionary:responseObject error:&error];
        NSLog(@"result:%@", result);
        if (result.status == 0) {
            succeedBlock(result);
        } else {
            NSLog(@"%@", result.message);
            NSError *error = [[NSError alloc] initWithDomain:result.message code:(NSInteger)result.status userInfo:nil];
            errorBlock(error);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error);
        errorBlock(error);
    }];
}

// 上传文件
- (void)uploadWithPointId:(int)pointId Data:(NSData *)fileData Type:(int)type Title:(NSString *)title success:(MAPResultHandle)succeedBlock error:(MAPErrorHandle)errorBlock {
    NSString *URL = [NSString stringWithFormat:@"http://47.95.207.40/markMap/upload/%d", pointId];
//    NSLog(@"url:%@", URL);
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary:@{@"type" : [NSNumber numberWithInt:type], @"file" : fileData}];
    if (type == 3) {
        [param setObject:title forKey:@"title"];
    }
    NSLog(@"--param--");
    NSLog(@"--param-- : %@", param);
    NSLog(@"--param--");
    NSString *token = @"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NSwidHlwZSI6InVzZXIiLCJleHAiOjE1MjgwMjcyNzQsImlhdCI6MTUyNzQyMjQ3NCwidXNlcm5hbWUiOiLltJTltJTltJTltJTltJQifQ.zOxjRXii0fwAS4NNhgMQcQ-2dom5rjM3OmY8Ph2g8dQ";
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/plain", nil];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"token"];
    
    [manager POST:URL parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        // 设置时间格式
        formatter.dateFormat = @"yyyyMMddHHmmss";
        NSString *str = [formatter stringFromDate:[NSDate date]];
        if (type == 2) {
            NSString *fileName = [NSString stringWithFormat:@"%@.mp3", str];
            [formData appendPartWithFileData:fileData name:@"file" fileName:fileName mimeType:@"mp3"];
        } else if (type == 3) {
            NSString *fileName = [NSString stringWithFormat:@"%@.mp4", str];
            [formData appendPartWithFileData:fileData name:@"file" fileName:fileName mimeType:@"MOV/mp4"];
        }
//        [formData appendPartWithFileData:fileData name:@"file" fileName:fileName mimeType:@"amr/mp3/wmr/wma"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
       
        NSDictionary *responseJSON = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        NSLog(@"responseJSON : %@", responseJSON);
        NSError *error;
        MAPResultModel *result = [[MAPResultModel alloc] initWithDictionary:responseJSON error:&error];
        NSLog(@"result:%@", result);
        if (result.status == 0) {
            succeedBlock(result);
        } else {
            NSLog(@"%@", result.message);
            NSError *error = [[NSError alloc] initWithDomain:result.message code:(NSInteger)result.status userInfo:nil];
            errorBlock(error);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error);
        errorBlock(error);
    }];
    
}

// 回复评论
- (void)addReplyWithInfold:(int)infold TopicId:(int)topicld Content:(NSString *)content toId:(int)toId success:(MAPResultHandle)successBlock error:(MAPErrorHandle)errorBlock {
    NSString *url = [NSString stringWithFormat:@"http://47.95.207.40/markMap/remark/%d", infold];
    NSLog(@"url : %@", url);
    NSDictionary *dictionary = @{@"topicId" : [NSNumber numberWithInt:topicld], @"content" : content};
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary:dictionary];
    if (toId != -1) {
        [param setObject:[NSNumber numberWithInt:toId] forKey:@"toId"];
    }
    NSString *token = @"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NSwidHlwZSI6InVzZXIiLCJleHAiOjE1MjgwMjcyNzQsImlhdCI6MTUyNzQyMjQ3NCwidXNlcm5hbWUiOiLltJTltJTltJTltJTltJQifQ.zOxjRXii0fwAS4NNhgMQcQ-2dom5rjM3OmY8Ph2g8dQ";
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/plain", nil];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"token"];
    [manager POST:url parameters:param progress:^(NSProgress * _Nonnull uploadProgress) {
        
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
