//
//  RecordManager+Kcal.m
//  CoolRun
//
//  Created by 蔡欣东 on 16/5/20.
//  Copyright © 2016年 蔡欣东. All rights reserved.
//

#import "RecordManager+Kcal.h"

@implementation RecordManager (Kcal)

- (NSArray *)getKcalDataWithMonth:(NSInteger)month
                             year:(NSInteger)year
                           weight:(float)weight {
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    NSMutableArray* dataArr = [NSMutableArray arrayWithCapacity:30];
    
    for (NSInteger i = 1; i<=31; i++) {
        NSString* dateStr = [NSString stringWithFormat:@"%ld-%ld-%ld",(long)year,month,i];
        NSDate* date = [formatter dateFromString:dateStr];
        
        NSArray* dayRuns = [self getRunInfoInDate:date];
        
        if (dayRuns.count>0) {
            float distance = 0;
            
            for (Run* run in dayRuns) {
                distance = distance + [run.distance floatValue];
            }
            
            int dayKcal = weight*distance/1000*1.036;
            
            [dataArr addObject:@(dayKcal)];
        }else{
            [dataArr addObject:@(0)];
        }
    }
    
    return dataArr;
}

@end
