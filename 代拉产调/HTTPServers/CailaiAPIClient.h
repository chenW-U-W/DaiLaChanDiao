//
//  CailaiAPIClient.h
//  Cai
//
//  Created by Cameron Ling on 4/17/15.
//  Copyright (c) 2015 启竹科技. All rights reserved.
//

#import "AFHTTPSessionManager.h"

typedef void (^HttpSuccessBlock)(id JSON);
typedef void (^HttpFailureBlock)(NSError *error);

@interface CailaiAPIClient : AFHTTPSessionManager

+ (instancetype)sharedClient;
+ (NSURLSessionDataTask *)requestWithParams:(NSDictionary *)params
                                  setCookie:(NSString *)cookie
                                    success:(HttpSuccessBlock)success
                                    failure:(HttpFailureBlock)failure
                                     method:(NSString *)method;
@end
