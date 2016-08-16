//
//  SZCalendarPicker.h
//  SZCalendarPicker
//
//  Created by Stephen Zhuang on 14/12/1.
//  Copyright (c) 2014年 Stephen Zhuang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SZCalendarPicker : UIView<UICollectionViewDelegate , UICollectionViewDataSource>

@property (nonatomic , strong) NSDate *date;

@property (nonatomic , strong) NSDate *today;

@property(nonatomic,copy)NSArray* specialDataArr;

@property (nonatomic, copy) void(^selectDate)(NSDate* date);

@property(nonatomic,copy) void(^changeMonthBlock)(NSInteger year,NSInteger month);

+ (instancetype)showOnView:(UIView *)view;

@end
