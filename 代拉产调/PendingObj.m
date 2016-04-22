//
//  PendingObj.m
//  代拉产调
//
//  Created by 陈思远 on 16/3/22.
//  Copyright © 2016年 陈思远. All rights reserved.
//

#import "PendingObj.h"
#import "CailaiAPIClient.h"
#import "PendDetailObj.h"
@implementation PendingObj

- (instancetype)initWithAttributes:(NSArray *)array
{
    if (self = [super init]) {
        self.array = [[NSMutableArray alloc] init];
        for (NSDictionary *dic in array) {
           PendDetailObj *pendDetailObj = [[PendDetailObj alloc] initWithAttributes:dic];
            [self.array addObject:pendDetailObj];
        }
        
        return self;
    }
    return nil;
}

+ (void)getPendingListWithBlock:(void(^)(id posts,NSError *error,NSString *tag))block ButTag:(NSString *)tag Status:(NSString *)status Numbers:(NSString *)number Size:(NSString *)size withAreaID:(NSString *)areaID
{
    NSDictionary *param = [[NSDictionary alloc] initWithObjectsAndKeys:
                           @"chandiao.list", @"sname",areaID,@"area_id",status,@"status",number,@"page_num",size,@"page_size",
                           nil];
   [CailaiAPIClient requestWithParams:param setCookie:@"" success:^(id JSON) {
        if (JSON) {
            NSArray *responseArra =  [JSON objectForKey:@"data"];
            PendingObj *pendingObj = [[PendingObj alloc] initWithAttributes:responseArra];
            
            if (block) {
                block(pendingObj.array,nil,tag);
            }
            
        }
    } failure:^(NSError *error) {
        if (block) {
            block(nil, error,tag);
        }
    } method:@"POST"];
}
@end
