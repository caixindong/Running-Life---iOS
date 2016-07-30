//
//  Location.m
//  CoolRun
//
//  Created by 蔡欣东 on 16/5/27.
//  Copyright © 2016年 蔡欣东. All rights reserved.
//

#import "Location.h"
#import "Run.h"

@implementation Location

-(NSDictionary *)convertToDictionary{
    NSMutableDictionary* result = [NSMutableDictionary dictionaryWithCapacity:3];
    [result setObject:self.latitude.description forKey:@"latitude"];
    [result setObject:self.longtitude.description forKey:@"longitude"];
    [result setObject:[NSString stringWithFormat:@"%f",self.timestamp.timeIntervalSince1970] forKey:@"time"];
    return  [result copy];
}

-(NSArray *)convertFromDictionary:(NSDictionary *)dict{
    NSMutableArray* dataArray = [NSMutableArray arrayWithCapacity:10];
    NSArray* locationDictArr = dict[@"run"];
    for (NSDictionary* dict in locationDictArr) {
        Location* location = [[Location alloc]init];
        location.latitude = [NSNumber numberWithDouble:[dict[@"latitude"] doubleValue]];
        location.longtitude = [NSNumber numberWithDouble:[dict[@"longitude"] doubleValue]];
        location.timestamp = [NSDate dateWithTimeIntervalSince1970:[dict[@"time"] intValue]];
        [dataArray addObject:location];
    }
    return dataArray;
}

@end
