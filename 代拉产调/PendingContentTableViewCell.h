//
//  PendingContentTableViewCell.h
//  代拉产调
//
//  Created by 陈思远 on 16/3/23.
//  Copyright © 2016年 陈思远. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PendDetailObj.h"
@interface PendingContentTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *addTimeLabel;
@property (nonatomic,strong)PendDetailObj *pendDetailObj;
@property (weak, nonatomic) IBOutlet UIImageView *aimageView;
@property (weak, nonatomic) IBOutlet UIButton *btn;

@end
