//
//  NSDate+week.m
//  CoolRun
//
//  Created by 蔡欣东 on 16/6/4.
//  Copyright © 2016年 蔡欣东. All rights reserved.
//

#import "NSDate+week.h"

@implementation NSDate (week)

- (NSString *)convertToStringWithWeek{
    NSDateComponents *component = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:self];
    NSInteger year = component.year;
    NSInteger month = component.month;
    NSInteger day = component.day;
    NSInteger weak = day/30 + 1;
    NSString *str = [NSString stringWithFormat:@"%ld年%ld月第%ld周",(long)year,month,weak];
    return str;
}

@end
