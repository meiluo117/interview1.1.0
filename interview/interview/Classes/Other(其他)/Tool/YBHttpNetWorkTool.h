//
//  YBHttpNetWorkTool.h
//  微博Text
//
//  Created by 于波 on 16/3/3.
//  Copyright © 2016年 于波. All rights reserved.
//

//超时时间
#define TimeoutInterval 10.0f

#import <Foundation/Foundation.h>
@class UploadFormData;
@interface YBHttpNetWorkTool : NSObject

/**
 *  取消所有网络请求
 */
+ (void)cancelOperation;

/**
 *  检测网络状态
 */
+ (void)networkMonitoring;

/**
 *  发送GET请求
 *
 *  @param url     请求链接
 *  @param params  请求参数（字典）
 *  @param success 请求成功 以block形式返回
 *  @param failure 请求失败 以block形式返回
 */
+ (void)get:(NSString *)url
     params:(NSDictionary *)params
    success:(void (^)(id json))success
    failure:(void (^)(NSError *error))failure;

/**
 *  发送POST请求 带header
 *
 *  @param url     请求链接
 *  @param params  请求参数（字典）
 *  @param success 请求成功 以block形式返回
 *  @param failure 请求失败 以block形式返回
 */
+ (void)post:(NSString *)url
      params:(NSDictionary *)params
     success:(void (^)(id json))success
     failure:(void (^)(NSError *error))failure
      header:(NSString *)header
ShowWithStatusText:(NSString *)statusText;

/**
 *  发送POST请求
 *
 *  @param url     请求链接
 *  @param params  请求参数（字典）
 *  @param success 请求成功 以block形式返回
 *  @param failure 请求失败 以block形式返回
 */
+ (void)post:(NSString *)url
      params:(NSDictionary *)params
     success:(void (^)(id json))success
     failure:(void (^)(NSError *error))failure
ShowWithStatusText:(NSString *)statusText;

/**
 *  发送POST请求，带文件参数(需要使用UploadFormData类)
 *
 *  @param url          请求链接
 *  @param params       请求参数（字典）
 *  @param uploadParams 文件uploadParams的对象（用时封装）
 *  @param success      请求成功 以block形式返回
 *  @param failure      请求失败 以block形式返回
 */
+ (void)post:(NSString *)url
      params:(NSDictionary *)params
    uploadParams:(UploadFormData*)uploadParams
     success:(void (^)(id json))success
     failure:(void (^)(NSError *error))failure
      header:(NSString *)ticket
ShowWithStatusText:(NSString *)statusText;

@end


/*使用POST添加文件时使用的下面的文件类封装*/
//@interface UploadFormData : NSObject
///**请求参数名 根据服务器定*/
//@property (nonatomic, copy, readwrite) NSString *name;
///**保存到服务器的文件名（可不填）*/
//@property (nonatomic, copy, readwrite) NSString *fileName;
///**文件类型 文件类型 image/jpeg，application/pdf*/
//@property (nonatomic, copy, readwrite) NSString *mimeType;
///**二进制数据*/
//@property (nonatomic, strong, readwrite) NSData *data;
//@end