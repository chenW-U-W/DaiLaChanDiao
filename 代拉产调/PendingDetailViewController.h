//
//  PendingDetailViewController.h
//  代拉产调
//
//  Created by 陈思远 on 16/3/23.
//  Copyright © 2016年 陈思远. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ParentViewController.h"
#import "PendDetailObj.h"
typedef void(^ReturnBackBlock) (NSString *);
@interface PendingDetailViewController : ParentViewController
@property (weak, nonatomic) IBOutlet UIScrollView *imageScrollview;
@property (nonatomic,strong)PendDetailObj *pendDetailObj;
@property (weak, nonatomic) IBOutlet UIButton *choseImageBtn;
@property (nonatomic,strong) NSString* itemId;
@property (weak, nonatomic) IBOutlet UIButton *reasonBtn;
@property (nonatomic,strong) ReturnBackBlock returnBackB;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UIButton *disPassBtn;
@property (weak, nonatomic) IBOutlet UILabel *phoneNumberLabel;
- (IBAction)submitClick:(id)sender;
- (IBAction)buttonClick:(id)sender;
@end
