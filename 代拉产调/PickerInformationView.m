//
//  PickerInformationView.m
//  代拉产调
//
//  Created by 陈思远 on 16/3/23.
//  Copyright © 2016年 陈思远. All rights reserved.
//

#import "PickerInformationView.h"
#define confirmBtnHeight 35
@implementation PickerInformationView
- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        _pickView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, confirmBtnHeight, frame.size.width, frame.size.height)];
        _pickView.delegate = self;
        _pickView.dataSource = self;
        _pickView.backgroundColor = [UIColor whiteColor];
        _pickView.showsSelectionIndicator=YES;
        [self addSubview:_pickView];
        
        UIView *barView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, confirmBtnHeight)];
        barView.backgroundColor  = mainColor;
        [self addSubview:barView];
        
        _confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _confirmBtn.frame = CGRectMake(self.frame.size.width-50, 0, 50, confirmBtnHeight);
        [_confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
        [_confirmBtn setBackgroundColor:[UIColor clearColor]];
        [_confirmBtn addTarget:self action:@selector(confirmBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [barView addSubview:_confirmBtn];
        
        _dataArray = [[NSMutableArray alloc] initWithObjects:@"地址不详",@"地址错误",@"其它", nil];
        return self;
    }
    
    
    return nil;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 35;
}

- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return [_dataArray objectAtIndex:row];
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return _dataArray.count;
}

- (void)confirmBtnClick
{
    NSInteger count =  [_pickView selectedRowInComponent:0];
    NSString *str = [_dataArray objectAtIndex:count];
    if (self.returnBackBlo) {
        self.returnBackBlo(str);
    }
}
@end
