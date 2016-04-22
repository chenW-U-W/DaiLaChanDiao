//
//  PendDetailObj.h
//  代拉产调
//
//  Created by 陈思远 on 16/3/22.
//  Copyright © 2016年 陈思远. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PendDetailObj : NSObject
@property (nonatomic,strong)NSString *add_time;
@property (nonatomic,strong)NSString *address;
@property (nonatomic,strong)NSString *area_id;
@property (nonatomic,strong)NSString *area_name;
@property (nonatomic,strong)NSString *deal_time;
@property (nonatomic,strong)NSString *deal_yewuyuan_id;
@property (nonatomic,strong)NSString *itemId;//id
@property (nonatomic,strong)NSString *mobile_num;
@property (nonatomic,strong)NSArray  *pictures;
@property (nonatomic,strong)NSString *post_address;
@property (nonatomic,strong)NSString *post_name;
@property (nonatomic,strong)NSString *post_need;
@property (nonatomic,strong)NSString *sorgseq;
@property (nonatomic,strong)NSString *spend_time;
@property (nonatomic,strong)NSString *status;
@property (nonatomic,strong)NSString *tag;

- (instancetype)initWithAttributes:(NSDictionary *)dic;

+ (void)postPendingDetailWithBlock:(void(^)(id posts,NSError *error))block tag:(NSString *)tag streams:(NSArray *)streams itemID:(NSString *)itemID;
@end
