//
//  HealthKitManager.m
//  CoolRun
//
//  Created by 蔡欣东 on 16/5/18.
//  Copyright © 2016年 蔡欣东. All rights reserved.
//

#import "HealthKitManager.h"

@interface HealthKitManager()

@property(nonatomic,strong)HKHealthStore* healthStore;

@end

@implementation HealthKitManager

+ (HealthKitManager *)shareManager {
    static HealthKitManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[HealthKitManager alloc] init];
    });
    return manager;
}

-(instancetype)init{
    if (self = [super init]) {
        _healthStore = [AppDelegate globalDelegate].SDKProcess.healthStore;
    }
    return self;
}

- (void)getDistancesWithYear:(NSInteger)year
                       month:(NSInteger)month
                    complete:(completeBlock) block
               failWithError:(errorBlock)errorBlock{
    
    //想获取的数据类型，我们项目需要的是走路+跑步的距离数据
    HKSampleType* sampleType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierDistanceWalkingRunning];
    
    //按数据开始日期排序
    NSSortDescriptor* start = [NSSortDescriptor sortDescriptorWithKey:HKSampleSortIdentifierStartDate ascending:NO];
    
    //以下操作是为了将字符串的日期转化为NSDate对象
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yy-MM-dd"];
    NSString* startDateStr = [NSString stringWithFormat:@"%ld-%ld-%ld",(long)year,(long)month,(long)1];
    
    //每个月第一天
    NSDate* startDate = [formatter dateFromString:startDateStr];
    
    //每个月的最后一天
    NSDate* endDate = [[NSDate alloc]initWithTimeInterval:31*24*60*60-1 sinceDate:startDate];
    
    //定义一个谓词逻辑，相当于sql语句，我猜测healthKit底层的数据存储应该用的也是CoreData
    NSPredicate* predicate = [HKQuery predicateForSamplesWithStartDate:startDate endDate:endDate options:HKQueryOptionNone];
    
    //定义一个查询操作
    HKSampleQuery* query = [[HKSampleQuery alloc]initWithSampleType:sampleType predicate:predicate limit:HKObjectQueryNoLimit sortDescriptors:@[start] resultsHandler:^(HKSampleQuery * _Nonnull query, NSArray<__kindof HKSample *> * _Nullable results, NSError * _Nullable error) {
        if (error) {
            if (errorBlock) {
                errorBlock(error);
            }
        }else{
            //一个字典，键为日期，值为距离
            NSMutableDictionary* multDict = [NSMutableDictionary dictionaryWithCapacity:30];
            
            //遍历HKQuantitySample数组，遍历计算每一天的距离数据，然后放进multDict
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
            
            //multDict的键值按日期来排序：1号~31号
            arr = [arr sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                NSString* str1 = [NSString stringWithFormat:@"%@",obj1];
                NSString* str2 = [NSString stringWithFormat:@"%@",obj2];
                int num1 = [[str1 substringFromIndex:6] intValue];
                int num2 = [[str2 substringFromIndex:6] intValue];
                if (num1<num2) {
                    return NSOrderedAscending;
                }else{
                    return NSOrderedDescending;
                }
            }];
            
            //按排序好的键取得值装进resultArr返回给业务层
            NSMutableArray* resultArr = [NSMutableArray arrayWithCapacity:30];
            for (NSString* key in arr) {
                [resultArr addObject:multDict[key]];
            }
           
            if (block) {
                block(resultArr);
            }
           
        }
        
    }];
    
    //执行查询
    [self.healthStore executeQuery:query];
}

- (void)getKcalWithWeight:(float)weight
                     year:(NSInteger)year
                    month:(NSInteger)month
                 complete:(completeBlock) block
            failWithError:(errorBlock)errorBlock{
    [self getDistancesWithYear:year month:month complete:^(id distanceArr) {
        
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
