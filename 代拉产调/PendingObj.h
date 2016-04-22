//
//  PendingObj.h
//  代拉产调
//
//  Created by 陈思远 on 16/3/22.
//  Copyright © 2016年 陈思远. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PendingObj : NSObject
@property(nonatomic,strong)NSMutableArray *array;
+ (void)getPendingListWithBlock:(void(^)(id posts,NSError *error,NSString *tag))block ButTag:(NSString *)tag Status:(NSString *)status Numbers:(NSString *)number Size:(NSString *)size withAreaID:(NSString *)areaID;
@end
