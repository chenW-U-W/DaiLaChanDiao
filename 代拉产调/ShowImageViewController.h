//
//  ShowImageViewController.h
//  财来网内部APP
//
//  Created by 陈思远 on 15/12/10.
//  Copyright © 2015年 陈思远. All rights reserved.
//

#import <UIKit/UIKit.h>
#import"ParentViewController.h"
@interface ShowImageViewController : ParentViewController

@property(nonatomic,strong)UIScrollView *scrollView;
@property(nonatomic,strong)UIButton *cancelBtn;

- (void)creatScrollviewWithArray:(NSArray *)imageAray  withShowingNum:(NSInteger)showingNum isWebString:(BOOL)isWebString haveCancleBtn:(BOOL)canHaveCancleBtn;
@end
