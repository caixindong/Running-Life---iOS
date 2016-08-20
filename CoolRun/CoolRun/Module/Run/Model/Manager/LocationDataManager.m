//
//  LocationDataManager.m
//  CoolRun
//
//  Created by 蔡欣东 on 16/5/16.
//  Copyright © 2016年 蔡欣东. All rights reserved.
//

#import "LocationDataManager.h"

static LocationDataManager *manager = nil;

@implementation LocationDataManager

+ (LocationDataManager *)shareManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!manager) {
            manager = [[LocationDataManager alloc] init];
        }
    });
    return manager;
}

- (Location*)addLoactionWithLatitude:(NSNumber *)latitude
                         longtitude:(NSNumber *)longtitude
                          timestamp:(NSDate *)timestamp{
    Location* location = [NSEntityDescription
                          insertNewObjectForEntityForName:@"Location" inManagedObjectContext:[CoreDataManager shareManager].managedObjectContext];
    
    location.latitude = latitude;
    location.longtitude = longtitude;
    location.timestamp = timestamp;
    
    [[CoreDataManager shareManager] saveContext];
    
    return location;
}

- (void)mergeTheTempData {
    NSFetchRequest* request = [[NSFetchRequest alloc]initWithEntityName:@"Location"];
    NSError* error = nil;
    NSArray* data = [[CoreDataManager shareManager].tempManagedObjectContext  executeFetchRequest:request error:&error
                     ];
    if (error) {
        NSLog(@"获取临时数据发送错误：%@",error);
        return;
    }
    
    [data enumerateObjectsUsingBlock:^(Location *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        Location* location = [NSEntityDescription
                              insertNewObjectForEntityForName:@"Location" inManagedObjectContext:[CoreDataManager shareManager].managedObjectContext];
        
        location.latitude = obj.latitude;
        location.longtitude = obj.longtitude;
        location.timestamp = obj.timestamp;
    }];
    
    [[CoreDataManager shareManager] saveContext];
    
    [self deleteAllTempLocations];
}

- (void)deleteAllTempLocations {
    NSFetchRequest* request = [[NSFetchRequest alloc]initWithEntityName:@"Location"];
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
