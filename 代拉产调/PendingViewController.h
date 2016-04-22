//
//  PendingViewController.h
//  代拉产调
//
//  Created by 陈思远 on 16/3/22.
//  Copyright © 2016年 陈思远. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ParentViewController.h"
@interface PendingViewController : ParentViewController
@property (weak, nonatomic) IBOutlet UISegmentedControl *setmentControl;
@property (strong, nonatomic) IBOutlet UIButton *chosedAreaBtn;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIView *headerView;

- (IBAction)segmentClick:(id)sender;

- (IBAction)areaClick:(id)sender;


@end
