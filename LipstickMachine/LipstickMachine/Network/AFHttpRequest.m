//
//  AFHttpRequest.m
//  iServiceBusiness
//
//  Created by adtec on 15/3/27.
//  Copyright (c) 2015年 adtec. All rights reserved.
//

#import "AFHttpRequest.h"
#import <SVProgressHUD.h>
#import "NSObject+GetTableView.h"
#import <MJRefresh/MJRefresh.h>
#import "LipstickMachine-Swift.h"

@interface AFHttpRequest ()
@property (nonatomic, strong)AFHTTPSessionManager *sessionManager;
@property (nonatomic, strong)AFSecurityPolicy *securityPolicy;
@property (nonatomic, strong)AFNetworkReachabilityManager *networkManager;
@property (nonatomic, copy) NSMutableSet *mutableSet;
@end

@implementation AFHttpRequest

static AFHttpRequest *request = nil;

+ (AFHttpRequest *)shareRequest
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        request = [[AFHttpRequest alloc] init];
        request.sessionManager = [AFHTTPSessionManager manager];
        request.networkManager = [AFNetworkReachabilityManager sharedManager];
        request.enableMessage = NO;
        
//        AFSecurityPolicy *security = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
//        [security setValidatesDomainName:NO];
//        security.allowInvalidCertificates = YES;
//        request.securityPolicy = security;
        
    });
    return request;
}

- (NSMutableDictionary *)defaultParam:(NSString *)url {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    return dict;
}

- (NSMutableDictionary *)HDdefaultParam {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"user_id"] = [self getUserId];
    return dict;
}


+ (BOOL)isNetworkConnected
{
    AFNetworkReachabilityManager *mgr = [AFNetworkReachabilityManager sharedManager];
    return (mgr.networkReachabilityStatus == AFNetworkReachabilityStatusNotReachable)?NO:YES;
}

+ (BOOL)isWifiConnected
{
    AFNetworkReachabilityManager *mgr = [AFNetworkReachabilityManager sharedManager];
    return mgr.isReachableViaWiFi;
}

- (void)configAFInAppDeletage
{
    __weak typeof(self) weakSelf;
    [self.networkManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        // 当网络状态改变了, 就会调用这个block
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:{ // 未知网络
                //[MBProgressHUD showSuccess:@"网络正常"];
            }
                break;
                
            case AFNetworkReachabilityStatusNotReachable:{ // 没有网络(断网)
                [SVProgressHUD showErrorWithStatus:@"网络异常"];
            }
                break;
                
            case AFNetworkReachabilityStatusReachableViaWWAN:{ // 手机自带网络
                if (weakSelf.enableMessage) {
                    [SVProgressHUD showSuccessWithStatus:@"自带网络"];
                }
            }
                break;
                
            case AFNetworkReachabilityStatusReachableViaWiFi: { // WIFI
                if (weakSelf.enableMessage) {
                    [SVProgressHUD showSuccessWithStatus:@"网络正常"];
                }
            }
                break;
        }
    }];
    
    // 3.开始监控
    [self.networkManager startMonitoring];
}

- (NSMutableSet *)mutableSet
{
    if (!_mutableSet) {
        _mutableSet = [NSMutableSet set];
    }
    return _mutableSet;
}


//post请求
- (void)requestPOSTWithUrl:(NSString *)urlString  withParams:(id)header withSuccess:(void (^)(id data, NSError *error))success withFailure:(void (^)(id data, NSError *error ,NSDictionary *errorDic))failure{

    [self requestPOSTWithUrl:urlString isShowHud:YES withParams:header withSuccess:success withFailure:failure];
    
}

//post请求
- (void)requestPOSTWithUrl:(NSString *)urlString  isShowHud:(BOOL)isShow withParams:(id)header withSuccess:(void (^)(id data, NSError *error))success withFailure:(void (^)(id data, NSError *error ,NSDictionary *errorDic))failure{
    if ([self.mutableSet containsObject:urlString]) {
        return;
    }
    
    if (isShow) {
        [SVProgressHUD show];
    }
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:header];
    [dict addEntriesFromDictionary:self.defaultParams];
    dict[@"platform"] = @"ios";
    if([[dict allKeys]containsObject:@"json"]) {
        [dict removeObjectForKey:@"json"];
            _sessionManager.requestSerializer = [AFJSONRequestSerializer serializer];
    } else {
        [dict addEntriesFromDictionary:[self defaultParam: urlString]];
        _sessionManager.requestSerializer = [AFHTTPRequestSerializer serializer];
    }
    
    [self addHeader: urlString];
    [self.mutableSet addObject:urlString];
    _sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];

    [_sessionManager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    
    [_sessionManager POST:urlString parameters:dict progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self endFreshing];
        id data = [NSJSONSerialization JSONObjectWithData:responseObject
                                                  options:NSJSONReadingMutableContainers error:nil];
        if ([data isKindOfClass:[NSDictionary class]]) {
            if ([data[@"errno"] integerValue] == 0) {
                success(data, nil);
            } else {
                if ([data[@"errno"] integerValue] == 401) {
                    [LoginTool logout];
                    [LoginTool pushLoginController];
                }
                NSError *error = [NSError errorWithDomain:data[@"errmsg"] code:[data[@"errno"] integerValue] userInfo:nil];
                failure(task,error,data);
            }
        } else {
            success(data,nil);
        }
        [self.mutableSet removeObject:urlString];
        [SVProgressHUD dismiss];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(task,error,nil);
        [self.mutableSet removeObject:urlString];
        [SVProgressHUD dismiss];
        [self endFreshing];
        [self addEvent:urlString error:error];
    }];
}


//GET请求
- (void)requestGETWithUrl:(NSString *)urlString  withParams:(id)header withSuccess:(void (^)(id data, NSError *error))success withFailure:(void (^)(id data, NSError *error ,NSDictionary *errorDic))failure{

    [self requestGETWithUrl:urlString isShowHud:YES withParams:header withSuccess:success withFailure:failure];
}
//GET请求
- (void)requestGETWithUrl:(NSString *)urlString isShowHud:(BOOL)isShow withParams:(id)header withSuccess:(void (^)(id data, NSError *error))success withFailure:(void (^)(id data, NSError *error ,NSDictionary *errorDic))failure {
    if ([self.mutableSet containsObject:urlString]) {
        return;
    }
    if (isShow) {
        [SVProgressHUD show];
    }
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:header];
    dict[@"platform"] = @"ios";
    if([[dict allKeys]containsObject:@"json"]) {
        [dict removeObjectForKey:@"json"];
            _sessionManager.requestSerializer = [AFJSONRequestSerializer serializer];
        
        _sessionManager.requestSerializer = [AFJSONRequestSerializer serializer];
    } else {
        [dict addEntriesFromDictionary:[self defaultParam: urlString]];
        _sessionManager.requestSerializer = [AFHTTPRequestSerializer serializer];
    }
    
    [self.mutableSet addObject:urlString];
    _sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [_sessionManager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];

    // 添加header
    [self addHeader:urlString];
    
    [_sessionManager GET:urlString parameters:dict progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self endFreshing];
        [self.mutableSet removeObject:urlString];
        [SVProgressHUD dismiss];
        NSError *error;
        id data = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&error];
        if (error != nil) {
            failure(task,error,error.userInfo);
            return;
        }
        if ([data isKindOfClass:[NSDictionary class]]) {
            if ([data[@"errno"] integerValue] == 0) {
                success(data, nil);
            } else {
                if ([data[@"errno"] integerValue] == 401) {
                    [LoginTool logout];
                    [LoginTool pushLoginController];
                }
                NSError *error = [NSError errorWithDomain:data[@"errmsg"] code:[data[@"errno"] integerValue] userInfo:nil];
                failure(task,error,data);
            }
        }else {
            success(data,nil);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self.mutableSet removeObject:urlString];
        failure(task,error,error.userInfo);
        [SVProgressHUD dismiss];
        [self endFreshing];
        [self addEvent:urlString error:error];
    }];
}


- (void)showLoginV {
//    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
//    [app showLoginNavWithDelay:NO];
}

//上传文件
- (void)requestPostUrl:(NSString *)url withParams:(id)header withFilesData:(void(^)(id<AFMultipartFormData> formData))postData withSuccess:(void (^)(id data, NSError *error))success withFailuer:(void (^)(id data, NSError *error ,NSDictionary *errorDic))failure{
    [SVProgressHUD show];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:header];
    if([[dict allKeys]containsObject:@"json"]){
        [dict removeObjectForKey:@"json"];
//                    url = [NSString stringWithFormat:@"%@?user_id=%@&device_id=%@&token=%@",
//                   url,
//                           [self getUserId],
//                   [ToolMethod UUIDString],
//                   [ETLoginManager isLogin] ? [UserInfoModel userInfoModel].token : [UserInfoModel userInfoModel].tourist];
            _sessionManager.requestSerializer = [AFJSONRequestSerializer serializer];
//        }
        
        [self addRequestHeader];
    } else {
        if ([url containsString:@"translator"] || [url containsString:@"chat"]) {
            [dict addEntriesFromDictionary:[self HDdefaultParam]];
        }else {
            [dict addEntriesFromDictionary:[self defaultParam:url]];
        }

        _sessionManager.requestSerializer = [AFHTTPRequestSerializer serializer];
    }
    
    [self addHeader: url];
    [self.mutableSet addObject:url];
    [_sessionManager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
//    _sessionManager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    //_sessionManager.securityPolicy = [self customSecurityPolicy:YES];
    // 添加header
    [_sessionManager POST:url parameters:dict constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        postData(formData);
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if ([responseObject isKindOfClass:[NSData class]]) {
            NSError *error;
            responseObject = [NSJSONSerialization JSONObjectWithData:responseObject
                                                             options:NSJSONReadingMutableLeaves
                                                               error:&error];
            if (error) {
                failure(nil,error,nil);
                return;
            }
        }
        
//        if ([responseObject isKindOfClass:[NSDictionary class]]) {
//            NSString *code = [responseObject objectForKey:@"res_code"];
//            if ([code isEqualToString:tokenOverCode]) {
//                failure(task,nil,responseObject);
//            }else{
//                success(responseObject,nil);
//            }
//        }else{
//            success(responseObject,nil);
//        }
        [self.mutableSet removeObject:url];
        [SVProgressHUD dismiss];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self.mutableSet removeObject:url];
        failure(nil,error,nil);
        [SVProgressHUD dismiss];
        [self addEvent:url error:error];
    }];
    
    
}


//是否显示菊花
- (void)requestPOSTWithUrl:(NSString *)url isShowHud:(BOOL)isShow withParams:(id)header withBlock:(void(^) (id data, NSError *error ,NSDictionary *errorDic)) block {
    [self requestPOSTWithUrl:url isShowHud:isShow withParams:header withSuccess:^(id data, NSError *error) {
        block(data,nil,nil);
    } withFailure:^(id data, NSError *error, NSDictionary *errorDic) {
        block(nil,error,errorDic);
    }];
}
- (void)requestGETWithUrl:(NSString *)url isShowHud:(BOOL)isShow withParams:(id)header withBlock:(void(^) (id data, NSError *error ,NSDictionary *errorDic)) block {
    [self requestGETWithUrl:url isShowHud:isShow withParams:header withSuccess:^(id data, NSError *error) {
         block(data,nil,nil);
    } withFailure:^(id data, NSError *error, NSDictionary *errorDic) {
         block(nil,data,errorDic);
    }];
}

// 改进版 Post GET 请求
- (void)requestPOSTWithUrl:(NSString *)url withParams:(id)header withBlock:(void(^) (id data, NSError *error ,NSDictionary *errorDic)) block{
    [self requestPOSTWithUrl:url withParams:header withSuccess:^(id data, NSError *error) {
        block(data,nil,nil);
    } withFailure:^(id data, NSError *error ,NSDictionary *errorDic) {
        block(nil,error,errorDic);
    }];
}
- (void)requestGETWithUrl:(NSString *)url withParams:(id)header withBlock:(void(^) (id data, NSError *error ,NSDictionary *errorDic)) block{
    [self requestGETWithUrl:url withParams:header withSuccess:^(id data, NSError *error) {
        block(data,nil,nil);
    } withFailure:^(id data, NSError *error ,NSDictionary *errorDic) {
        block(nil,data,errorDic);
    }];
}


#pragma mark----
- (AFSecurityPolicy*)customSecurityPolicy:(BOOL)isHTTPS
{
    if (isHTTPS) {
        NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"client" ofType:@".cer"];
        NSData *certData = [NSData dataWithContentsOfFile:cerPath];
        self.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
        if (certData) {
            [_securityPolicy setPinnedCertificates:[NSSet setWithObject:certData]];
        }
        [_securityPolicy setValidatesDomainName:NO];
        [_securityPolicy setAllowInvalidCertificates:YES];
        
    } else {
        self.securityPolicy = [AFSecurityPolicy defaultPolicy];
    }
    return _securityPolicy;
}

- (void)addRequestHeader {
    AFHTTPRequestSerializer *requestSerializer =  [AFJSONRequestSerializer serializer];
    if (self.defaultParams != nil) {
        for (NSString *httpHeaderField in self.defaultParams.allKeys) {
            NSString *value = self.defaultParams[httpHeaderField];
            [requestSerializer setValue:value forHTTPHeaderField:httpHeaderField];
        }
    }
    _sessionManager.requestSerializer = requestSerializer;
}

- (void)addHeader:(NSString *)url {
//    AFHTTPRequestSerializer *requestSerializer = _sessionManager.requestSerializer;

}

#pragma mark 判断不登录就不加token的
- (BOOL)isAddToken:(NSString *)url {
    BOOL isAdd = YES;
    
//    NSArray *urls = @[
//                      @"verifyDynamicConfig"
//                      ];
//
//    for (NSString *item in urls) {
//        if ([url containsString:item]) {
//            if (![UserInfoModel userInfoModel].token || [[UserInfoModel userInfoModel].token length] == 0) {
//                isAdd = NO;
//                break;
//            }
//        }
//    }
//
    return isAdd;
}

#pragma mark 添加自定义事件
- (void)addEvent:(NSString *)url error:(NSError *)error {
    NSDictionary *att = @{
                          @"url"    : url,
                          @"error"  : error
                          };
//    [MobClick event:RequestFail attributes:att];
}


#pragma mark endfresh
- (void)endFreshing {
    [self getScrollView:^(UIScrollView *scrollView) {
        if (scrollView) {

            if (scrollView.mj_header && scrollView.mj_header.isRefreshing) {
                [scrollView.mj_header endRefreshing];
            }

            if (scrollView.mj_footer && scrollView.mj_footer.isRefreshing) {
                [scrollView.mj_footer endRefreshing];
            }

        }
    }];
}

- (NSString *)getUserId {
    return @"";
//
//    NSString *userId = [UserInfoModel userInfoModel].user_id;
//
//    if (!userId || userId.length == 0) {
//        userId = [UserInfoModel userInfoModel].tourist;
//    }
//
////    NSString *userId = ([UserInfoModel userInfoModel].user_id && ![[UserInfoModel userInfoModel].user_id isEqualToString:@""] && [UserInfoModel userInfoModel].user_id.length != 0) ? [UserInfoModel userInfoModel].user_id : [UserInfoModel userInfoModel].tourist;
//    return userId;
}

- (NSString *)getMsgWithCode:(NSString *)code {
    NSString *msg;
    
//    if (![[code class] isKindOfClass:[NSString class]]) {
//        code = [NSString stringWithFormat:@"%@", code];
//    }
//
//    if ([code isEqualToString:@"00000E"]) {
//        msg = [LYLanguageTool localizedStringWithString:LYError_00000E];
//    } else {
//        switch ([code integerValue]) {
//            case 1:
//                msg = [LYLanguageTool localizedStringWithString:LYError_000001];
//                break;
//            case 3:
//                msg = [LYLanguageTool localizedStringWithString:LYError_000003];
//                break;
//            case 4:
//                msg = [LYLanguageTool localizedStringWithString:LYError_000004];
//                break;
//            case 9:
//                msg = [LYLanguageTool localizedStringWithString:LYError_000009];
//                break;
//            case 22:
//                msg = [LYLanguageTool localizedStringWithString:LYError_000022];
//                break;
//            case 25:
//                msg = [LYLanguageTool localizedStringWithString:LYError_000025];
//                break;
//            case 97:
//                msg = [LYLanguageTool localizedStringWithString:LYError_000097];
//                break;
//            case 99:
//                msg = [LYLanguageTool localizedStringWithString:LYError_000099];
//                break;
//            case 101:
//                msg = [LYLanguageTool localizedStringWithString:LYError_000101];
//                break;
//            case 110:
//                msg = [LYLanguageTool localizedStringWithString:LYError_000110];
//                break;
//            case 113:
//                msg = [LYLanguageTool localizedStringWithString:LYError_000113];
//                break;
//            case 301:
//                msg = [LYLanguageTool localizedStringWithString:LYError_000301];
//                break;
//            case 305:
//                msg = [LYLanguageTool localizedStringWithString:LYError_000305];
//                break;
//            case 308:
//                msg = [LYLanguageTool localizedStringWithString:LYError_000308];
//                break;
//            case 309:
//                msg = [LYLanguageTool localizedStringWithString:LYError_000309];
//                break;
//            case 357:
//                msg = [LYLanguageTool localizedStringWithString:LYError_000357];
//                break;
//            case 358:
//                msg = [LYLanguageTool localizedStringWithString:LYError_000358];
//                break;
//            case 400:
//                msg = [LYLanguageTool localizedStringWithString:LYError_400];
//                break;
//            case 401:
//                msg = [LYLanguageTool localizedStringWithString:LYError_401];
//                break;
//            case 404:
//                msg = [LYLanguageTool localizedStringWithString:LYDeviceDoesNotExist];
//                break;
//            case 405:
//                msg = [LYLanguageTool localizedStringWithString:LYRequestDataDoesNotExist];
//                break;
//            case 406:
//                msg = [LYLanguageTool localizedStringWithString:LYRequestDataIsNotAvailable];
//                break;
//            case 416:
//                msg = [LYLanguageTool localizedStringWithString:LYTokenVerificationFailed];
//                break;
//            case 500:
//                msg = [LYLanguageTool localizedStringWithString:LYOperationFailed];
//                break;
//            case 503:
//                msg = [LYLanguageTool localizedStringWithString:LYErrorRequestingAI];
//                break;
//            case 4001:
//                msg = [LYLanguageTool localizedStringWithString:LYError_004001];
//                break;
//            case 9999:
//                msg = [LYLanguageTool localizedStringWithString:LYError_009999];
//                break;
//            default:
//                msg = @"";
//                break;
//        }
//    }
    return msg;
    
}

@end
