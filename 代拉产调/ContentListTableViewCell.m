//
//  ContentListTableViewCell.m
//  代拉产调
//
//  Created by 陈思远 on 16/3/22.
//  Copyright © 2016年 陈思远. All rights reserved.
//

#import "ContentListTableViewCell.h"

@implementation ContentListTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setPendDetailObj:(PendDetailObj *)pendDetailObj
{
    
    _pendDetailObj = pendDetailObj;
    _addressLabel.text =[pendDetailObj.area_name stringByAppendingString:[NSString stringWithFormat:@"-%@",pendDetailObj.address]];
    _addTimeDateLabel.text = pendDetailObj.add_time;
    NSString *statusStr;
    NSString *string = @"已处理";
    statusStr = [string stringByAppendingString:[NSString stringWithFormat:@"(用时%@)",pendDetailObj.spend_time]];
    _statusLabel.text = statusStr;
    _statusLabel.textColor = [UIColor redColor];
    _errorLabel.text = pendDetailObj.tag;
    if ([pendDetailObj.post_need integerValue] == 0) {
        _postImageView.hidden = YES;
    }else
    {
        _postImageView.hidden = NO;
    }
}
@end
