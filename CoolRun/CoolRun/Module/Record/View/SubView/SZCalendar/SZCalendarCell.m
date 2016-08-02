//
//  SZCalendarCell.m
//  SZCalendarPicker
//
//  Created by Stephen Zhuang on 14/12/1.
//  Copyright (c) 2014年 Stephen Zhuang. All rights reserved.
//

#import "SZCalendarCell.h"

@implementation SZCalendarCell



- (UILabel *)dateLabel
{
    if (!_dateLabel) {
        _dateLabel = [[UILabel alloc] initWithFrame:self.bounds];
        [_dateLabel setTextAlignment:NSTextAlignmentCenter];
        [_dateLabel setFont:[UIFont systemFontOfSize:17]];
        [self addSubview:_dateLabel];
    }
    return _dateLabel;
}

-(UIView *)typeView{
    if (!_typeView) {
        CGFloat W = self.bounds.size.width;
        CGFloat H = self.bounds.size.height;
        _typeView = [[UIView alloc]initWithFrame:CGRectMake(15, H-15, W-15*2, 2)];
        _typeView.backgroundColor = UIColorFromRGB(0x43B5FE);
        _typeView.layer.cornerRadius = 1;
        [self bringSubviewToFront:_typeView];
        _typeView.hidden = YES;
        [self addSubview:_typeView];
    }
    return _typeView;
}
@end
