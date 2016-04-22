//
//  User.m
//  Cai
//
//  Created by Cameron Ling on 4/29/15.
//  Copyright (c) 2015 启竹科技. All rights reserved.
//

#import "User.h"
#import "CailaiAPIClient.h"

@implementation User

//单例
+ (instancetype)shared {
    static User *user = nil ;
    static dispatch_once_t predicate;
    
    dispatch_once(&predicate, ^{
        user = [[self alloc] init];

    });
   
    return user;
}




- (instancetype)initWithAttributes:(NSDictionary *)attributes {
    
    self = [super init];
    if (!self) {
        return nil;
    }
    self.mobile = [attributes objectForKey:@"mobile"];
    return self;
}



+ (NSURLSessionDataTask *)loginWithBlock:(void (^)(NSDictionary * posts, NSError *error))block
                                 withMobile:(NSString *)mobile
                               withPassword:(NSString *)password{
   
    
    
    NSDictionary *param = [[NSDictionary alloc] initWithObjectsAndKeys:
                           @"user.login", @"sname",
                           mobile, @"mobile",
                           password, @"passwd",
                           nil];
    NSURLSessionDataTask *task = [CailaiAPIClient requestWithParams:param setCookie:@"" success:^(id JSON) {
        NSDictionary *dataDic = [JSON objectForKey:@"data"];        
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        if (block) {
            block(dataDic, nil);
        }
        
    } failure:^(NSError *error) {
        if (block) {
            block(nil, error);
        }
    } method:@"POST"];
    
        return task;
}




+ (void)signOut {
    NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (NSHTTPCookie *each in cookieStorage.cookies) {
        [cookieStorage deleteCookie:each];
    }
    // 并清空本地用户号码
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userPhoneNumber"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"real_name"];
}



//+ (NSURLSessionDataTask *)putPropertyWithBlock:(void (^)(NSDictionary * posts, NSError *error))block withChannelID:(NSString *)channelID  withType:(NSString *)deviceType withUserId:(NSString *)userID
//{
//    
//    NSDictionary *param = [[NSDictionary alloc] initWithObjectsAndKeys:
//                           @"user.pushdata.set", @"sname",channelID,@"channelId",deviceType,@"deviceType",
//                           userID,@"userId",
//                           nil];
//    
//    return [CailaiAPIClient requestWithParams:param setCookie:@"" success:^(id JSON) {
//        
//        
//    } failure:^(NSError *error) {
//        
//    } method:@"POST"];
//    
//    
//}
//






@end
