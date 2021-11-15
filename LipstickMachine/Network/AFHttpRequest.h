//
//  AFHttpRequest.h
//  iServiceBusiness
//
//  Created by adtec on 15/3/27.
//  Copyright (c) 2015年 adtec. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>

@interface AFHttpRequest : NSObject

@property (nonatomic, assign) BOOL enableMessage;
@property (nonatomic, assign) NSMutableDictionary *defaultParams;

+ (AFHttpRequest *)shareRequest;

//判断网络是否连接上
+ (BOOL)isNetworkConnected;

+ (BOOL)isWifiConnected;

- (void)configAFInAppDeletage;

//post请求
- (void)requestPOSTWithUrl:(NSString *)urlString  withParams:(id)header withSuccess:(void (^)(id data, NSError *error))success withFailure:(void (^)(id data, NSError *error ,NSDictionary *errorDic))failure;
//get请求
- (void)requestGETWithUrl:(NSString *)urlString  withParams:(id)header withSuccess:(void (^)(id data, NSError *error))success withFailure:(void (^)(id data, NSError *error ,NSDictionary *errorDic))failure;

// 改进版 Post 请求
- (void)requestPOSTWithUrl:(NSString *)url withParams:(id)header withBlock:(void(^) (id data, NSError *error ,NSDictionary *errorDic)) block;
- (void)requestGETWithUrl:(NSString *)url withParams:(id)header withBlock:(void(^) (id data, NSError *error ,NSDictionary *errorDic)) block;
//是否显示菊花
- (void)requestPOSTWithUrl:(NSString *)url isShowHud:(BOOL)isShow withParams:(id)header withBlock:(void(^) (id data, NSError *error ,NSDictionary *errorDic)) block;
- (void)requestGETWithUrl:(NSString *)url isShowHud:(BOOL)isShow withParams:(id)header withBlock:(void(^) (id data, NSError *error ,NSDictionary *errorDic)) block;


//上传文件
- (void)requestPostUrl:(NSString *)url withParams:(id)header withFilesData:(void(^)(id<AFMultipartFormData> formData))postData withSuccess:(void (^)(id data, NSError *error))success withFailuer:(void (^)(id data, NSError *error ,NSDictionary *errorDic))failure;

@end
