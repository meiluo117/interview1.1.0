//
//  YBHttpNetWorkTool.m
//  微博Text
//
//  Created by 于波 on 16/3/3.
//  Copyright © 2016年 于波. All rights reserved.
//

#import "YBHttpNetWorkTool.h"
#import <AFNetworking.h>
#import "JSONKit.h"
#import "UploadFormData.h"

static YBHttpNetWorkTool *_httpAPIClient = nil;

@interface YBHttpNetWorkTool ()
@property (nonatomic,assign)BOOL networkError;
@end

@implementation YBHttpNetWorkTool

+ (void)cancelOperation
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.operationQueue cancelAllOperations];
}

+ (void)networkMonitoring
{
    // 1.获得网络监控的管理者
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    
    // 2.设置网络状态改变后的处理
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        // 当网络状态改变了, 就会调用这个block
        switch (status)
        {
            case AFNetworkReachabilityStatusUnknown://未知网络
                
                _httpAPIClient.networkError = NO;
                NSLog(@"未知网络");
                break;
                
            case AFNetworkReachabilityStatusNotReachable://没有网络(断网)
                
                _httpAPIClient.networkError = YES;
                NSLog(@"断网");
                break;
                
            case AFNetworkReachabilityStatusReachableViaWWAN://手机自带网络
                
                _httpAPIClient.networkError = NO;
                NSLog(@"手机自带网络");
                break;
                
            case AFNetworkReachabilityStatusReachableViaWiFi:// WIFI
                
                _httpAPIClient.networkError = NO;
                NSLog(@"wifi");
                break;
        }
        
    }];
    [manager startMonitoring];
}

+ (void)get:(NSString *)url params:(NSDictionary *)params success:(void (^)(id))success failure:(void (^)(NSError *))failure 
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = TimeoutInterval;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    //申明返回的结果是json类型
//    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    //申明请求的数据是json类型
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    //如果报接受类型不一致请替换一致text/html或别的application/json
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json",@"text/html",@"text/javascript",nil];
    
    [manager GET:url parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];

}

+ (void)post:(NSString *)url params:(NSDictionary *)params success:(void (^)(id))success failure:(void (^)(NSError *))failure header:(NSString *)ticket ShowWithStatusText:(NSString *)statusText
{
    if (statusText.length != 0) {
        SVProgressHUD.defaultStyle = SVProgressHUDStyleDark;
        [SVProgressHUD showWithStatus:statusText];
    }else{
       
    }
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = TimeoutInterval;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *appVer = [defaults objectForKey:@"appVer"];
    NSString *os = [defaults objectForKey:@"os"];
    NSString *did = [defaults objectForKey:@"did"];
    
    NSDictionary *clientInfo = @{@"appNm":@"YT",
                                  @"appVer":appVer,
                                  @"client":@"IPHONE",
                                  @"os":os,
                                  @"screen":@"320",
                                  @"channel":@"appstore",
                                  @"did":did};

    NSString *clientInfoStr = [clientInfo JSONString];
    
    NSDictionary *clientAuth = @{@"userId":@"0",@"ticket":ticket};
    NSString *clientAuthStr = [clientAuth JSONString];
    
    [manager.requestSerializer setValue:clientInfoStr forHTTPHeaderField:@"clientInfo"];
    [manager.requestSerializer setValue:clientAuthStr forHTTPHeaderField:@"clientAuth"];
    
    //申明返回的结果是json类型
//        manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    //申明请求的数据是json类型
//    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json",@"text/html",@"text/plain",nil];
    
    [manager POST:url parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

        if (success) {
            success(responseObject);
        }else{
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        [SVProgressHUD dismiss];
        if (failure) {
            [SVProgressHUD showErrorWithStatus:@"请求超时"];
            failure(error);
            YT_LOG(@"%@",error);
        }
    }];
}

+ (void)post:(NSString *)url params:(NSDictionary *)params success:(void (^)(id))success failure:(void (^)(NSError *))failure ShowWithStatusText:(NSString *)statusText
{
    if (statusText.length != 0) {
        [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
        [SVProgressHUD showWithStatus:@"正在登陆..."];
    }
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = TimeoutInterval;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    //申明返回的结果是json类型
    //manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    //申明请求的数据是json类型
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json",@"text/html",nil];
    
    [manager POST:url parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

            if (success) {
            success(responseObject);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        [SVProgressHUD dismiss];
        if (failure) {
            [SVProgressHUD showErrorWithStatus:@"请求超时"];
            failure(error);
        }
    }];
}

+ (void)post:(NSString *)url params:(NSDictionary *)params uploadParams:(UploadFormData *)uploadParams success:(void (^)(id))success failure:(void (^)(NSError *))failure header:(NSString *)ticket ShowWithStatusText:(NSString *)statusText
{
    if (statusText.length != 0) {
        [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
        [SVProgressHUD showWithStatus:statusText];
    }
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = TimeoutInterval;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *appVer = [defaults objectForKey:@"appVer"];
    NSString *os = [defaults objectForKey:@"os"];
    NSString *did = [defaults objectForKey:@"did"];
    
    NSDictionary *clientInfo = @{@"appNm":@"YT",
                                 @"appVer":appVer,
                                 @"client":@"IPHONE",
                                 @"os":os,
                                 @"screen":@"320",
                                 @"channel":@"appstore",
                                 @"did":did};
    
    NSString *clientInfoStr = [clientInfo JSONString];
    
    NSDictionary *clientAuth = @{@"userId":@"0",@"ticket":ticket};
    NSString *clientAuthStr = [clientAuth JSONString];
    
    [manager.requestSerializer setValue:clientInfoStr forHTTPHeaderField:@"clientInfo"];
    [manager.requestSerializer setValue:clientAuthStr forHTTPHeaderField:@"clientAuth"];
    
    //申明返回的结果是json类型
//    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    //申明请求的数据是json类型
    //    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/html",@"text/plain", nil];
    
    [manager POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        [formData appendPartWithFileData:uploadParams.data name:uploadParams.name fileName:uploadParams.fileName mimeType:uploadParams.mimeType];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        [SVProgressHUD dismiss];
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        [SVProgressHUD dismiss];
        if (failure) {
            [SVProgressHUD showErrorWithStatus:@"请求超时"];
            failure(error);
        }
    }];
}

@end


//@implementation UploadFormData
//
//@end
