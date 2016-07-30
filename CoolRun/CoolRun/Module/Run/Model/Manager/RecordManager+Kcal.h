//
//  RecordManager+Kcal.h
//  CoolRun
//
//  Created by 蔡欣东 on 16/5/20.
//  Copyright © 2016年 蔡欣东. All rights reserved.
//

#import "RecordManager.h"

@interface RecordManager (Kcal)

/**
 *  获取，每个月卡路里数据
 *
 *  @param month  月份
 *  @param year   年份
 *  @param weight 重量
 *
 *  @return
 */
- (NSArray*)getKcalDataWithMonth:(NSInteger) month
                           year:(NSInteger)year
                         weight:(float)weight;

@end
