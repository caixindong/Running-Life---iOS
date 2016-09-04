//
//  HealthKitManager.h
//  CoolRun
//
//  Created by 蔡欣东 on 16/5/18.
//  Copyright © 2016年 蔡欣东. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^completeBlock)(id);

typedef void(^errorBlock)(NSError*);

/**
 *  健康数据管理对象
 */
@interface HealthKitManager : NSObject

/**
 *  全局管理类
 *
 *  @return 
 */
+ (HealthKitManager *)shareManager;

/**
 *  获取某年某月的健康数据中路程数据(原生数据)
 *
 *  @param year       年份
 *  @param month      月份
 *  @param block      成功回调
 *  @param errorBlock 失败回调
 */
- (void)getDistancesWithYear:(NSInteger)year
                       month:(NSInteger)month
                    complete:(completeBlock) block
               failWithError:(errorBlock)errorBlock;


/**
 *  获取某年某月的卡路里数据（计算数据）
 *
 *  @param weight     体重
 *  @param year       年份
 *  @param month      月份
 *  @param block      成功回调
 *  @param errorBlock 失败回调
 */
- (void)getKcalWithWeight:(float)weight
                     year:(NSInteger)year
                    month:(NSInteger)month
                 complete:(completeBlock) block
            failWithError:(errorBlock)errorBlock;

@end
