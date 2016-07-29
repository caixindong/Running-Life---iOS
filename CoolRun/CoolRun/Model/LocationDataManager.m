//
//  LocationDataManager.m
//  CoolRun
//
//  Created by 蔡欣东 on 16/5/16.
//  Copyright © 2016年 蔡欣东. All rights reserved.
//

#import "LocationDataManager.h"

@implementation LocationDataManager

-(Location*)addLoactionWithLatitude:(NSNumber *)latitude withLongtitude:(NSNumber *)longtitude withTimestamp:(NSDate *)timestamp{
    Location* location = [NSEntityDescription insertNewObjectForEntityForName:@"Location" inManagedObjectContext:self.managedObjectContext];
    location.latitude = latitude;
    location.longtitude = longtitude;
    location.timestamp = timestamp;
    [self saveContext];
    return location;
}

@end
