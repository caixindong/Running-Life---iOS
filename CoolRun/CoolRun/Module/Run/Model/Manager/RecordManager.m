//
//  RecordManager.m
//  CoolRun
//
//  Created by 蔡欣东 on 16/5/9.
//  Copyright © 2016年 蔡欣东. All rights reserved.
//

#import "RecordManager.h"

static RecordManager *manager;

@implementation RecordManager

+ (RecordManager *)shareManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!manager) {
            manager = [[RecordManager alloc] init];
        }
    });
     return manager;
}

-(Run*)addRunRecordWithDis:(NSNumber *)distance
                   withDur:(NSNumber *)duration
                  withTime:(NSDate *)date
             withLocations:(NSOrderedSet *)locations{
    Run* newRecord = [NSEntityDescription insertNewObjectForEntityForName:@"Run" inManagedObjectContext:[CoreDataManager shareManager].managedObjectContext];
    newRecord.distance = distance;
    newRecord.duration = duration;
    newRecord.timestamp = date;
    newRecord.flag = [NSNumber numberWithInt:0];
    newRecord.locations = locations;
    newRecord.runid = [NSNumber numberWithInt:0];
    [[CoreDataManager shareManager] saveContext];
    return newRecord;
}

- (NSArray *)getAllRecord{
    NSFetchRequest* request = [[NSFetchRequest alloc]initWithEntityName:@"Run"];
    NSError* error = nil;
    @try {
        NSArray* arr = [[CoreDataManager shareManager].managedObjectContext executeFetchRequest:request error:&error];
        NSMutableArray* dataArr = [NSMutableArray arrayWithCapacity:5];
        for (NSManagedObject* obj in arr) {
            Run* run = (Run*)obj;
            [dataArr addObject:run];
        }
        return dataArr;
    } @catch (NSException *exception) {
        NSLog(@"get data error is %@",error.userInfo);
    }
}

- (void)deleteAllRecord{
    NSFetchRequest* request = [[NSFetchRequest alloc]initWithEntityName:@"Run"];
    NSError* error = nil;
    NSArray* data = [[CoreDataManager shareManager].managedObjectContext  executeFetchRequest:request error:&error
                     ];
    @try {
        for (NSManagedObject* obj in data) {
            [[CoreDataManager shareManager].managedObjectContext  deleteObject:obj];
        }
        [[CoreDataManager shareManager] saveContext];
    } @catch (NSException *exception) {
        NSLog(@"delete error is %@",error.userInfo);
    }
}

- (Run *)mostRecentRecord{
    NSArray* data = [self getAllRecord];
    if (data&&data.count>0) {
        return data[data.count-1];
    }
    return nil;
}

- (int)runCount{
    NSArray* data = [self getAllRecord];
    if (data) {
        return (int)data.count;
    }
    return 0;
}

- (float)totalDistance{
    NSArray* data = [self getAllRecord];
    if (data) {
        float distance = 0;
        for (Run* run in data) {
            distance += [run.distance floatValue];
        }
        return distance;
    }
    return 0;
}

- (int)totalTime{
    NSArray* data = [self getAllRecord];
    if (data) {
        int time = 0;
        for (Run* run in data) {
            time += [run.duration intValue];
        }
        return time;
    }
    return 0;
}

- (NSArray *)getRunInfoInDate:(NSDate *)date{
    NSArray* dataArray = [self getAllRecord];
    NSDateFormatter* formatter= [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString* dataStr = [formatter stringFromDate:date];
    NSMutableArray* resultArr = [NSMutableArray arrayWithCapacity:6];
    if (dataArray) {
        for (Run* run in dataArray) {
            NSString* runDateStr = [formatter stringFromDate:run.timestamp];
            if ([runDateStr isEqualToString:dataStr]) {
                [resultArr addObject:run];
            }
        }
        return resultArr;
    }
    return nil;
}

- (NSArray *)getUnsynchronizedRunData{
    NSFetchRequest* request = [[NSFetchRequest alloc]initWithEntityName:@"Run"];
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"flag=0"];
    request.predicate = predicate;
    NSError* error = nil;
    @try {
        NSArray* arr = [[CoreDataManager shareManager].managedObjectContext  executeFetchRequest:request error:&error];
        NSMutableArray* dataArr = [NSMutableArray arrayWithCapacity:5];
        for (NSManagedObject* obj in arr) {
            Run* run = (Run*)obj;
            [dataArr addObject:run];
        }
        return dataArr;
    } @catch (NSException *exception) {
        NSLog(@"get data error is %@",error.userInfo);
    }
}

- (void)synchronizedRunData{
    NSFetchRequest* request = [[NSFetchRequest alloc]initWithEntityName:@"Run"];
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"flag=0"];
    request.predicate = predicate;
    NSError* error = nil;
    @try {
        NSArray* arr = [[CoreDataManager shareManager].managedObjectContext  executeFetchRequest:request error:&error];
        for (NSManagedObject* obj in arr) {
            Run* run = (Run*)obj;
            run.flag = [NSNumber numberWithInt:1];
        }
        [[CoreDataManager shareManager] saveContext];
    } @catch (NSException *exception) {
        NSLog(@"synchronizedRunData error is %@",error.userInfo);
    }
}

- (void)syncharonizeRun:(Run *)run{
    run.flag = [NSNumber numberWithInt:1];
    [[CoreDataManager shareManager] saveContext];
}

- (void)touchRun:(Run *)run WithID:(int)runid{
    run.runid = [NSNumber numberWithInt:runid];
    [[CoreDataManager shareManager] saveContext];
}


- (void)mergeTheTempData {
    NSFetchRequest* request = [[NSFetchRequest alloc]initWithEntityName:@"Run"];
    NSError* error = nil;
    NSArray* data = [[CoreDataManager shareManager].tempManagedObjectContext  executeFetchRequest:request error:&error
                     ];
    if (error) {
        NSLog(@"获取临时跑步数据发送错误：%@",error);
        return;
    }
    
    if (data.count == 0) {
        return;
    }
    
    [data enumerateObjectsUsingBlock:^(Run *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        Run* newRecord = [NSEntityDescription insertNewObjectForEntityForName:@"Run" inManagedObjectContext:[CoreDataManager shareManager].managedObjectContext];
        newRecord.distance  = obj.distance;
        newRecord.duration  = obj.duration;
        newRecord.timestamp = obj.timestamp;
        newRecord.flag      = obj.flag;
        newRecord.runid     = obj.runid;
        
        NSMutableOrderedSet *mutaLocations = [NSMutableOrderedSet orderedSet];
        [obj.locations enumerateObjectsUsingBlock:^(Location *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            Location* location = [NSEntityDescription
                                  insertNewObjectForEntityForName:@"Location" inManagedObjectContext:[CoreDataManager shareManager].managedObjectContext];
            
            location.latitude = obj.latitude;
            location.longtitude = obj.longtitude;
            location.timestamp = obj.timestamp;
            [mutaLocations addObject:location];
        }];
        
        newRecord.locations = [mutaLocations copy];
    }];
    
    [[CoreDataManager shareManager] saveContext];
}

- (void)deleteAllTempRecords {
    NSFetchRequest* request = [[NSFetchRequest alloc]initWithEntityName:@"Run"];
    NSError* error = nil;
    NSArray* data = [[CoreDataManager shareManager].tempManagedObjectContext  executeFetchRequest:request error:&error
                     ];
    @try {
        for (NSManagedObject* obj in data) {
            [[CoreDataManager shareManager].tempManagedObjectContext  deleteObject:obj];
        }
        [[CoreDataManager shareManager] saveTempContext];
    } @catch (NSException *exception) {
        NSLog(@"delete error is %@",error.userInfo);
    }
}

@end
