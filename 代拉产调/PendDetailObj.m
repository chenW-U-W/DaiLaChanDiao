//
//  PendDetailObj.m
//  代拉产调
//
//  Created by 陈思远 on 16/3/22.
//  Copyright © 2016年 陈思远. All rights reserved.
//

#import "PendDetailObj.h"
#import "CailaiAPIClient.h"
@implementation PendDetailObj
- (instancetype)initWithAttributes:(NSDictionary *)dic
{
//    "add_time" = "2016-03-14 16:41:59";
//    address = "\U7ec8\U7ed3\U8005\U5f00\U4e86";
//    "area_id" = 2707;
//    "area_name" = "\U6d66\U4e1c\U65b0\U533a";
//    "deal_time" = "<null>";
//    "deal_yewuyuan_id" = "<null>";
//    id = 178;
//    "mobile_num" = 16666666666;
//    mobile_num = "<null>";
//    "post_address" = "<null>";
//    "post_name" = "<null>";
//    "post_need" = 0;
//    sorgseq = 201603141641525166;
//    "spend_time" = "-404985\U5c0f\U65f618\U5206\U949f1\U79d2";
//    status = 0;
//    tag = "";

    
    if (self = [super init]) {
        NSMutableDictionary *newDic = [[NSMutableDictionary alloc] init];
        NSArray *keyArray = [dic  allKeys];
        for (NSString *str in keyArray) {
            id post = [dic objectForKey:str];
            if ([post isKindOfClass:[NSNull  class]]) {
                post = @"";
            }
            else
            {
                post = post;
            }
            [newDic setValue:post forKey:str];
            
        }
        self.add_time = [newDic objectForKey:@"add_time"];
        self.address = [newDic objectForKey:@"address"];
        self.area_id = [newDic objectForKey:@"area_id"];
        self.area_name = [newDic objectForKey:@"area_name"];
        self.deal_time = [newDic objectForKey:@"deal_time"];
        self.deal_yewuyuan_id = [newDic objectForKey:@"deal_yewuyuan_id"];
        self.itemId = [newDic objectForKey:@"id"];
        self.mobile_num = [newDic objectForKey:@"mobile_num"];
        self.post_address = [newDic objectForKey:@"post_address"];
        self.post_name = [newDic objectForKey:@"post_name"];
        self.post_need = [newDic objectForKey:@"post_need"];
        self.sorgseq = [newDic objectForKey:@"sorgseq"];
        self.spend_time = [newDic objectForKey:@"spend_time"];
        self.status = [newDic objectForKey:@"status"];
        self.tag = [newDic objectForKey:@"tag"];
        NSString *pictureString = [newDic objectForKey:@"pictures"];
        NSArray *picArray = [pictureString componentsSeparatedByString:@","];
        if (!picArray) {
            self.pictures = [[NSArray alloc] init];
        }else
        {
        self.pictures = picArray;
        }
        return self;
    }
    return nil;
}

+ (void)postPendingDetailWithBlock:(void(^)(id posts,NSError *error))block tag:(NSString *)tag streams:(NSArray *)streams itemID:(NSString *)itemID
{
    
    //NSMutableArray *stringStreams = [[NSMutableArray alloc] init];
    NSString *stringStreams ;
    if (streams.count == 0) {
        stringStreams = @"";
    }
    else
    {
        NSData *data = [streams objectAtIndex:0];
        NSString *base64=[data base64EncodedStringWithOptions:0];
        stringStreams = base64;
        for (int i = 1; i< streams.count; i++) {
            NSData *nextData = [streams objectAtIndex:i];
            NSString *nextBase64=[nextData base64EncodedStringWithOptions:0];
           stringStreams = [nextBase64 stringByAppendingString:[NSString stringWithFormat:@",%@",stringStreams]];
        }
        
    
    }
    NSDictionary *param = [[NSDictionary alloc] initWithObjectsAndKeys:
                           @"chandiao.deal", @"sname",itemID,@"id",stringStreams,@"streams",tag,@"tag",                           nil];
    [CailaiAPIClient requestWithParams:param setCookie:@"" success:^(id JSON) {
        if (JSON) {
            
            if (block) {
                block(nil,nil);
            }
            
        }
    } failure:^(NSError *error) {
        if (block) {
            block(nil, error);
        }
    } method:@"POST"];
}

@end
