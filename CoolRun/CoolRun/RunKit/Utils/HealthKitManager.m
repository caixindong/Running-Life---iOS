//
//  HealthKitManager.m
//  CoolRun
//
//  Created by 蔡欣东 on 16/5/18.
//  Copyright © 2016年 蔡欣东. All rights reserved.
//

#import "HealthKitManager.h"

@interface HealthKitManager()

@end

@implementation HealthKitManager


-(instancetype)init{
    if (self = [super init]) {
        _healthStore = [AppDelegate globalDelegate].SDKProcess.healthStore;
    }
    return self;
}

- (void)getDistancesWithYear:(NSInteger)year
                       month:(NSInteger)month
                         day:(NSInteger)day
                    complete:(completeBlock) block
               failWithError:(errorBlock)errorBlock{
    HKSampleType* sampleType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierDistanceWalkingRunning];
    NSSortDescriptor* start = [NSSortDescriptor sortDescriptorWithKey:HKSampleSortIdentifierStartDate ascending:NO];
    NSSortDescriptor *end = [NSSortDescriptor sortDescriptorWithKey:HKSampleSortIdentifierEndDate ascending:NO];
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yy-MM-dd"];
    NSString* startDateStr = [NSString stringWithFormat:@"%ld-%ld-%ld",(long)year,(long)month,(long)day];
    NSDate* startDate = [formatter dateFromString:startDateStr];
    NSDate* endDate = [[NSDate alloc]initWithTimeInterval:31*24*60*60-1 sinceDate:startDate];
    
    NSPredicate* predicate = [HKQuery predicateForSamplesWithStartDate:startDate endDate:endDate options:HKQueryOptionNone];
    
    HKSampleQuery* query = [[HKSampleQuery alloc]initWithSampleType:sampleType predicate:predicate limit:0 sortDescriptors:@[start,end] resultsHandler:^(HKSampleQuery * _Nonnull query, NSArray<__kindof HKSample *> * _Nullable results, NSError * _Nullable error) {
        if (error) {
            if (errorBlock) {
                errorBlock(error);
            }
        }else{
            NSMutableDictionary* multDict = [NSMutableDictionary dictionaryWithCapacity:30];

            for (HKQuantitySample* sample in results) {
                NSString* dateStr = [formatter stringFromDate:sample.startDate] ;
                if ([[multDict allKeys]containsObject:dateStr]) {
                    int distance = (int)[[multDict valueForKey:dateStr] doubleValue];
                    distance = distance + [sample.quantity doubleValueForUnit:[HKUnit meterUnit]];
                    [multDict setObject:@(distance) forKey:dateStr];
                }else{
                    int distance = (int)[sample.quantity doubleValueForUnit:[HKUnit meterUnit]];
                    [multDict setObject: @(distance) forKey:dateStr];
                }
            }
            NSArray* arr = multDict.allKeys;
            
            arr = [arr sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                NSString* str1 = [NSString stringWithFormat:@"%@",obj1];
                NSString* str2 = [NSString stringWithFormat:@"%@",obj2];
                int num1 = [[str1 substringFromIndex:6] intValue];
                int num2 = [[str2 substringFromIndex:6]intValue];
                if (num1<num2) {
                    return NSOrderedAscending;
                }else{
                    return NSOrderedDescending;
                }
            }];
            NSMutableArray* resultArr = [NSMutableArray arrayWithCapacity:30];
            for (NSString* key in arr) {
                [resultArr addObject:multDict[key]];
            }
           
            if (block) {
                block(resultArr);
            }
           
        }
        
    }];
    [self.healthStore executeQuery:query];
}

- (void)getKcalWithWeight:(float)weight
                     year:(NSInteger)year
                    month:(NSInteger)month
                      day:(NSInteger)day
                 complete:(completeBlock) block
            failWithError:(errorBlock)errorBlock{
    [self getDistancesWithYear:year month:month day:day complete:^(id distanceArr) {
        
        NSArray* distanceDatas = (NSArray*)distanceArr;
        NSMutableArray* kcalDatas = [NSMutableArray arrayWithCapacity:30];
        for (id distance in distanceDatas) {
            int kcal = (int)weight*[distance intValue]/1000*1.036;
            [kcalDatas addObject:@(kcal)];
        }
        if (block) {
            dispatch_async(dispatch_get_main_queue(), ^{
                block(kcalDatas);
            });
        }
    } failWithError:^(NSError * error) {
        if (errorBlock) {
            errorBlock(error);
        }
    }];
    
}



@end
