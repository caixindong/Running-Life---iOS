//
//  RecordManager.h
//  CoolRun
//
//  Created by 蔡欣东 on 16/5/9.
//  Copyright © 2016年 蔡欣东. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseDataManager.h"
#import "Run.h"
#import "Location.h"
@interface RecordManager : BaseDataManager

/**
 * 添加记录
 **/
-(Run*)addRunRecordWithDis:(NSNumber*)distance
                   withDur:(NSNumber*)duration
                  withTime:(NSDate*)data
             withLocations:(NSOrderedSet<Location*>*) locations;

/**
 * 获取全部跑步记录
 **/
-(NSArray*)getAllRecord;

/**
 * 获取最近一次跑步记录
 **/
-(Run*)mostRecentRecord;

/**
 * 删除所有跑步记录
 **/
-(void)deleteAllRecord;


/**
 * 获取跑步次数
 **/
-(NSInteger)runCount;

/**
 * 跑步总距离
 **/
-(float)totalDistance;

/**
 * 跑步总时间
 **/
-(int)totalTime;

/**
 * 获取指定日期的跑步数据
 **/
-(NSArray*)getRunInfoInDate:(NSDate*)date;

/**
 * 获取未同步的数据
 **/
-(NSArray*)getUnsynchronizedRunData;

/**
 * 修改未同步数据的状态位
 **/
-(void)synchronizedRunData;

/**
 * 同步某一次一次跑步
 **/
-(void)syncharonizeRun:(Run*)run;

/**
 *  给跑步记录赋予一个ID
 *
 *  @param runid
 */
- (void)touchRun:(Run *)run WithID:(int) runid;
@end
