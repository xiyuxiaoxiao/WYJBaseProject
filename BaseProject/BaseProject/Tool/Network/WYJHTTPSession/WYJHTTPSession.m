//
//  WYJHTTPSession.m
//  PuzzleWYJ
//
//  Created by ZSXJ on 16/9/30.
//  Copyright © 2016年 ZSXJ. All rights reserved.
//

#import "WYJHTTPSession.h"
#import "AFNetworkActivityIndicatorManager.h"

static NSString *serverURL = @"https://api.leancloud.cn/1.1/";

@interface WYJHTTPSession ()

@end

@implementation WYJHTTPSession

+(void)POST:(NSString *)actStr withSession: (NSString *)session ReqParams:(NSDictionary *)params success:(SuccessBlock)succBlc failure:(FailedBlcok)failBlc {
    
    
    AFNetworkActivityIndicatorManager *indicatorManager = [AFNetworkActivityIndicatorManager sharedManager];
    indicatorManager.enabled = YES;
    [indicatorManager incrementActivityCount];
    
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    // 设置网络请求超时时间
//    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
//    manager.requestSerializer.timeoutInterval = 15.0F;
//    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    NSString *postURL = [[NSString alloc] initWithFormat:@"%@%@", serverURL, actStr];
    
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    if (session) {
        [manager.requestSerializer setValue:session forHTTPHeaderField:@"X-LC-Session"];
    }
    
    NSDictionary *postData = params;
    [manager POST:postURL
    parameters:postData
      progress:nil
       success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
           [indicatorManager decrementActivityCount];
           succBlc(task,responseObject);
       } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
           [indicatorManager decrementActivityCount];
           failBlc(task,error);
       }];
}

+(void)GET:(NSString *)actStr ReqParams:(NSDictionary *)params success:(SuccessBlock)succBlc failure:(FailedBlcok)failBlc {
    
    AFNetworkActivityIndicatorManager *indicatorManager = [AFNetworkActivityIndicatorManager sharedManager];
    indicatorManager.enabled = YES;
    [indicatorManager incrementActivityCount];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:
                                                         @"application/json",
                                                         @"text/json",
                                                         @"text/javascript",
                                                         @"text/html",
                                                         @"text/plain",
                                                         nil];
    
    NSString *postURL = [[NSString alloc] initWithFormat:@"%@%@", serverURL, actStr];
    postURL = actStr;
//    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
//    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
//    [manager.requestSerializer setValue:@"uun5qoMwt5bRkLoFNs8Pzvxs-gzGzoHsz" forHTTPHeaderField:@"X-LC-Id"];
//    [manager.requestSerializer setValue:@"t5KRntGqwmY93EjSucRQotcv" forHTTPHeaderField:@"X-LC-Key"];

    
    NSDictionary *postData = params;
    
    [manager GET:postURL
       parameters:postData
         progress:nil
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              [indicatorManager decrementActivityCount];
              succBlc(task,responseObject);
          } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              [indicatorManager decrementActivityCount];
              failBlc(task,error);
          }];
}


@end
