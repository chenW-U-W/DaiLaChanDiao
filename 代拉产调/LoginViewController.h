//
//  LoginViewController.h
//  代拉产调
//
//  Created by 陈思远 on 16/3/22.
//  Copyright © 2016年 陈思远. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^successLoginBlock)(void);

@interface LoginViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *userNameText;
@property (weak, nonatomic) IBOutlet UITextField *passwordText;
@property (nonatomic,strong) successLoginBlock successLB;
- (IBAction)btnClick:(id)sender;
@end
