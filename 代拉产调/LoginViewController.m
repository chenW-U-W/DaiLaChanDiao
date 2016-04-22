//
//  LoginViewController.m
//  代拉产调
//
//  Created by 陈思远 on 16/3/22.
//  Copyright © 2016年 陈思远. All rights reserved.
//

#import "LoginViewController.h"
#import "User.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    //self.navigationController.navigationBarHidden = YES;
    _userNameText.layer.borderColor = mainColor.CGColor;
    _passwordText.layer.borderColor = mainColor.CGColor;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnClick:(id)sender {
    
//        //验证
//        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:@"手机号或密码错误" preferredStyle:UIAlertControllerStyleAlert];
//        
//        UIAlertAction *otherAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {}];
//        [alertController addAction:otherAction];
//        [self presentViewController:alertController animated:YES completion:nil];
    
        [self pushDataToServer];
    
}


- (void)pushDataToServer
{
    [User loginWithBlock:^(NSDictionary *posts, NSError *error) {
        if (posts) {
            if (_successLB) {
                self.successLB();
            }
            
            [[NSUserDefaults standardUserDefaults] setObject:_userNameText.text forKey:@"userPhoneNumber"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            NSString *real_name = [posts objectForKey:@"real_name"];
            [[NSUserDefaults standardUserDefaults] setObject:real_name forKey:@"real_name"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            _userNameText.text = @"";
            _passwordText.text = @"";
            [_passwordText resignFirstResponder];
            [self.navigationController popViewControllerAnimated:YES];
            
        }
    } withMobile:_userNameText.text withPassword:_passwordText.text];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.userNameText resignFirstResponder];
    [self.passwordText resignFirstResponder];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES];
    
    
}
//页面将离开时出现
-(void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO];
}
@end
