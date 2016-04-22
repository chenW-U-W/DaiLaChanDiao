//
//  ContentListTableViewCell.h
//  代拉产调
//
//  Created by 陈思远 on 16/3/22.
//  Copyright © 2016年 陈思远. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PendDetailObj.h"
@interface ContentListTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *addTimeDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *errorLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UIImageView *postImageView;
@property (nonatomic,strong)PendDetailObj *pendDetailObj;
@end
