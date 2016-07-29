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
+(NSString *)stringifyDistance:(float)meters;

+(NSString *)stringifySecondCount:(int)seconds usingLongFormat:(BOOL)longFormat;

+(NSString *)stringifyAvgPaceFromDist:(float)meters overTime:(int)seconds;

+(NSString*)stringifyKcalFromDist:(float)meters withWeight:(float)weight;

+ (NSArray *)colorSegmentsForLocations:(NSArray *)locations;
@end
