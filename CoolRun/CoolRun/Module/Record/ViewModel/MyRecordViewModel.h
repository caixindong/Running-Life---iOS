//
//  MyRecordViewModel.h
//  CoolRun
//
//  Created by 蔡欣东 on 16/5/28.
//  Copyright © 2016年 蔡欣东. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DetailViewModel.h"

@interface MyRecordViewModel : NSObject


/**
 *  跑步+走路卡路里数据
 */
@property (nonatomic, copy, readonly) NSArray *walkAndRunKcalArray;

/**
 *  跑步卡路里数据
 */
@property (nonatomic, copy, readonly) NSArray *runKcalArray;

/**
 *  获取某月跑步+走路卡路里数据
 *
 *  @param month  月份
 *  @param year   年份
 *  @param weight 体重
 */
- (void)getWalkAndRunKcalArrayWithMonth:(NSInteger)month
                              year:(NSInteger)year
                            weigth:(float)weight;

/**
 *  获取某个月跑步卡路里数据
 *
 *  @param month  月份
 *  @param year   年份
 *  @param weight 体重
 */
- (void)getRunKcalArrayWithMonth:(NSInteger)month
                              year:(NSInteger)year
                            weigth:(float)weight;

/**
 *  获取具体某天的跑步记录
 *
 *  @param date 日期
 *
 *  @return 记录详情页的viewModel
 */
- (DetailViewModel *)getRunRecordWithDate:(NSDate *)date;

@end
