//
//  PendingContentTableViewCell.m
//  代拉产调
//
//  Created by 陈思远 on 16/3/23.
//  Copyright © 2016年 陈思远. All rights reserved.
//

#import "PendingContentTableViewCell.h"

@implementation PendingContentTableViewCell

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
    _addressLabel.text = [pendDetailObj.area_name stringByAppendingString: [NSString stringWithFormat:@"-%@",pendDetailObj.address ]];
    _addTimeLabel.text = pendDetailObj.add_time;
    _btn.layer.cornerRadius = 5;
}
@end
