//
//  User.h
//  Cai
//
//  Created by Cameron Ling on 4/29/15.
//  Copyright (c) 2015 启竹科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject


@property (nonatomic, strong) NSString  *mobile;//手机号码

@property (nonatomic, strong) NSString  *password;//密码

@property (nonatomic, strong) NSString  *sessionId;//sessionID


+ (instancetype)shared;


// 登录
+ (NSURLSessionDataTask *)loginWithBlock:(void (^)(NSDictionary *posts, NSError *error))block  withMobile:(NSString *)mobile  withPassword:(NSString *)password;


+ (void)signOut;


//
////向服务器发送设备类型和channelID
//+(NSURLSessionDataTask *)putPropertyWithBlock:(void (^)(NSDictionary * posts, NSError *error))block withChannelID:(NSString *)channelID  withType:(NSString *)deviceType withUserId:(NSString *)userID;

@end
