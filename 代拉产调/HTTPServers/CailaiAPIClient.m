//
//  CailaiAPIClient.m
//  Cai
//
//  Created by Cameron Ling on 4/17/15.
//  Copyright (c) 2015 启竹科技. All rights reserved.
//

#import "CailaiAPIClient.h"
#import <CommonCrypto/CommonDigest.h>


@implementation CailaiAPIClient

+ (instancetype)sharedClient {
    static CailaiAPIClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[CailaiAPIClient alloc] initWithBaseURL:[NSURL URLWithString:CailaiAPIBaseURLString]];
        _sharedClient.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        _sharedClient.securityPolicy.allowInvalidCertificates = YES;
    });
    
    return _sharedClient;
}


+ (NSURLSessionDataTask *)requestWithParams:(NSDictionary *)params
                                  setCookie:(NSString *)aCookie
                                    success:(HttpSuccessBlock)success
                                    failure:(HttpFailureBlock)failure
                                     method:(NSString *)method {
    NSString *path = @"";
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:CailaiAPIBaseURLString]];
    //设置超时时间
    manager.requestSerializer.timeoutInterval = 20.0;
    //设置response的接收类型
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain",@"application/json", @"text/json", @"text/javascript", @"text/html", nil];
    
    //设置cookie
//    NSData *cookiesdata = [[NSUserDefaults standardUserDefaults] objectForKey:@"kUserDefaultsCookie"];
//    NSArray *cookies = [NSKeyedUnarchiver unarchiveObjectWithData:cookiesdata];
//    if(cookies.count>0) {
//        NSHTTPCookie *cookie;
//        for (cookie in cookies) {
//            [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
//            NSLog(@"cookie:------%@",cookie);
//        }  
//    }
//    
    
    
        if ([method isEqual: @"GET"]) {
        return [manager GET:path parameters:[self getPostDictionary:params] success:^(NSURLSessionDataTask *task, id responseObject) {
            NSLog(@"GET成功:%@",responseObject);
            NSInteger code = [[responseObject valueForKey:@"code"] integerValue];
            NSString *msg = [responseObject valueForKey:@"msg"];
            if (code != 0) {
                NSError *theError = [[NSError alloc] initWithDomain:msg code:(int)code userInfo:nil];
                failure(theError);
            } else {
                success(responseObject);
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            NSLog(@"fail Get!!%@",error);
            failure(error);
        }];
    } else if ([method isEqual:@"POST"]){
        NSURLSessionDataTask *dataTask = [manager POST:path parameters:[self getPostDictionary:params] success:^(NSURLSessionDataTask *task, id responseObject) {
                
            NSLog(@"POST成功:%@",responseObject);
            
            NSInteger code = [[responseObject valueForKey:@"code"] integerValue];
            NSString *msg = [responseObject valueForKey:@"msg"];
            id data = [responseObject objectForKey:@"data"];
            if (code != 0&&code != 104) {
                NSError *theError = [[NSError alloc] initWithDomain:msg code:(int)code userInfo:nil];
                failure(theError);
            } else if ([data isEqual:[NSNull null]]) {
                NSError *theError = [[NSError alloc] initWithDomain:@"data 为空" code:-1 userInfo:nil];
                failure(theError);
            } else {
                success(responseObject);
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            NSLog(@"fail POST!!%@",error);
            failure(error);
        }];        
       


        return dataTask;
    }
    return nil;
}



+ (NSURLSessionDataTask *)requestWithParams:(NSDictionary *)params
                                  setCookie:(NSString *)aCookie
                                    success:(HttpSuccessBlock)success
                                    failure:(HttpFailureBlock)failure
                                     method:(NSString *)method
                                    streams:(NSMutableArray *)streams
                                     itemID:(NSString *)itemID{
    NSString *path = @"";
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:CailaiAPIBaseURLString]];
    //设置超时时间
    manager.requestSerializer.timeoutInterval = 20.0;
    //设置response的接收类型
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain",@"application/json", @"text/json", @"text/javascript", @"text/html", nil];
    
    if ([method isEqual:@"POST"]){
        NSURLSessionDataTask *dataTask = [manager POST:path parameters:[self getPostDictionary:params] constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            for(NSInteger i = 0; i < streams.count; i++)
            {
                NSData * imageData = [streams   objectAtIndex: i];            // 上传的参数名
                NSString * Name = [NSString stringWithFormat:@"%@%ld",itemID,i+1];            // 上传filename
                NSString * fileName = [NSString stringWithFormat:@"%@.jpg", Name];
                [formData appendPartWithFileData:imageData name:Name fileName:fileName mimeType:@"image/jpeg"];
            }
            } success:^(NSURLSessionDataTask *task, id responseObject) {
            
            NSLog(@"POST成功:%@",responseObject);
            
            NSInteger code = [[responseObject valueForKey:@"code"] integerValue];
            NSString *msg = [responseObject valueForKey:@"msg"];
            id data = [responseObject objectForKey:@"data"];
            if (code != 0&&code != 104) {
                NSError *theError = [[NSError alloc] initWithDomain:msg code:(int)code userInfo:nil];
                failure(theError);
            } else if ([data isEqual:[NSNull null]]) {
                NSError *theError = [[NSError alloc] initWithDomain:@"data 为空" code:-1 userInfo:nil];
                failure(theError);
            } else {
                success(responseObject);
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            NSLog(@"fail POST!!%@",error);
            failure(error);
        }];
        
        
        
        return dataTask;
    }
    return nil;
}

+ (NSDictionary *)getPostDictionary: (NSDictionary *)param {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithDictionary:param];
    // 第一步：组成请求内容的数组
    [dict setValue:@"ios" forKey:@"pname"];
    // 第二步: 生成请求内容的json字符串
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict
                                                       options:0
                                                         error:&error];
    NSString *content = [[NSString alloc] initWithData:jsonData
                                                 encoding:NSUTF8StringEncoding];
    // 第三步：连接第二步产生的json字符串与校验码
    NSString *preToken = [NSString stringWithFormat:@"%@%@", content, SecretKey];
    // 第四步：通过md5生成签名的token值
    NSString *token = [self md5:preToken];
    // 第五步：生成 post 数据
    NSDictionary *postDic = [[NSDictionary alloc] initWithObjectsAndKeys:content, @"content", token, @"token", nil];
//    [postDic setValue:content forKey:@"content"];
//    [postDic setValue:token forKey:@"token"];
    return postDic;
}



+ (NSString *) md5:(NSString *) input
{
    const char *cStr = [input UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), digest); // This is the md5 call
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return  output;
    
}
@end
