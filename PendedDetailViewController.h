//
//  PendedDetailViewController.h
//  代拉产调
//
//  Created by 陈思远 on 16/3/23.
//  Copyright © 2016年 陈思远. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PendDetailObj.h"
#import "ParentViewController.h"
@interface PendedDetailViewController : ParentViewController
@property (weak, nonatomic) IBOutlet UILabel *linkMan;
@property (weak, nonatomic) IBOutlet UILabel *linkNumber;
@property (weak, nonatomic) IBOutlet UILabel *linkAddress;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (nonatomic,strong)PendDetailObj *pendDetailObj;
@end
