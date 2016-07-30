//
//  MathController.h
//  CoolRun
//
//  Created by 蔡欣东 on 16/5/6.
//  Copyright © 2016年 蔡欣东. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Location.h"
#import "MultiColorPolyline.h"
@interface MathController : NSObject

/**
 *  米换算公里
 *
 *  @param meters 米
 *
 *  @return 公里
 */
+ (NSString *)stringifyDistance:(float)meters;

/**
 *  秒换算为格式化时间
 *
 *  @param seconds    秒
 *  @param longFormat
 *
 *  @return 格式化时间
 */
+ (NSString *)stringifySecondCount:(int)seconds usingLongFormat:(BOOL)longFormat;

/**
 *  格式化速度
 *
 *  @param meters  米
 *  @param seconds 秒
 *
 *  @return 速度
 */
+ (NSString *)stringifyAvgPaceFromDist:(float)meters overTime:(int)seconds;

/**
 *  格式化卡路里
 *
 *  @param meters 米
 *  @param weight kg
 *
 *  @return 卡路里
 */
+ (NSString*)stringifyKcalFromDist:(float)meters withWeight:(float)weight;

/**
 *  根据速度标识不一样颜色的轨迹
 *
 *  @param locations 位置数组
 *
 *  @return 轨迹
 */
+ (NSArray *)colorSegmentsForLocations:(NSArray *)locations;

@end
