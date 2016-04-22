//
//  PickerInformationView.h
//  代拉产调
//
//  Created by 陈思远 on 16/3/23.
//  Copyright © 2016年 陈思远. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^returnBackBlock)(NSString *);
@interface PickerInformationView : UIView<UIPickerViewDataSource,UIPickerViewDelegate>
@property(nonatomic,strong) UIPickerView *pickView;
@property(nonatomic,strong) UIButton *confirmBtn;
@property(nonatomic,strong) NSMutableArray *dataArray;
@property(nonatomic,strong) returnBackBlock returnBackBlo;
@end
