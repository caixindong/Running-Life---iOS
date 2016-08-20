//
//  RecordManager.h
//  CoolRun
//
//  Created by 蔡欣东 on 16/5/9.
//  Copyright © 2016年 蔡欣东. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Run.h"
#import "Location.h"

/**
 *  跑步记录管理者
 */
@interface RecordManager : NSObject


/**
 *  全局管理器
 *
 *  @return 
 */
+ (RecordManager *)shareManager;

/**
 *  添加记录
 *
 *  @param distance  距离
 *  @param duration  时长
 *  @param data      日期
 *  @param locations 位置数组
 *
 *  @return 跑步记录
 */
- (Run*)addRunRecordWithDis:(NSNumber*)distance
                   withDur:(NSNumber*)duration
                  withTime:(NSDate*)date
             withLocations:(NSOrderedSet<Location*>*) locations;

/**
 *  获取所有跑步数据
 *
 *  @return 所有跑步记录
 */
- (NSArray*)getAllRecord;


/**
 *  获取最近最近一次跑步记录
 *
 *  @return 最近一次跑步记录
 */
- (Run*)mostRecentRecord;


/**
 *  删除所有跑步数据
 */
- (void)deleteAllRecord;

/**
 *  获取跑步次数
 *
 *  @return 跑步次数
 */
- (int)runCount;


/**
 *  跑步总距离
 *
 *  @return
 */
- (float)totalDistance;

/**
 *  跑步总时间
 *
 *  @return
 */
- (int)totalTime;

/**
 *  获取指定日期的跑步数据
 *
 *  @param date 日期
 *
 *  @return 跑步数据
 */
- (NSArray*)getRunInfoInDate:(NSDate*)date;


/**
 *  获取未同步的跑步数据
 *
 *  @return 跑步数据
 */
- (NSArray*)getUnsynchronizedRunData;

/**
 *  同步所有跑步数据
 */
- (void)synchronizedRunData;

/**
 *  同步某次跑步记录
 *
 *  @param run 跑步记录
 */
- (void)syncharonizeRun:(Run*)run;

/**
 *  给跑步记录赋予一个ID
 *
 *  @param runid
 */
- (void)touchRun:(Run *)run WithID:(int) runid;


/**
 *  合并临时数据
 */
- (void)mergeTheTempData;

/**
 *  删除临时数据
 */
- (void)deleteAllTempRecords;


@end
