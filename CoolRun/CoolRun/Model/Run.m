//
//  Run.m
//  CoolRun
//
//  Created by 蔡欣东 on 16/5/27.
//  Copyright © 2016年 蔡欣东. All rights reserved.
//

#import "Run.h"
#import "Location.h"




@implementation Run


-(NSArray *)convertFromDict:(NSDictionary *)dictionary{
    NSArray* runDictArray = dictionary[@"run"];
    NSMutableArray* dataArray = [NSMutableArray arrayWithCapacity:10];
    for (NSDictionary* dict in runDictArray) {
        Run* run = [[Run alloc]init];
        run.duration = [NSNumber numberWithInt:[dict[@"duration"] intValue]];
        run.timestamp = [NSDate dateWithTimeIntervalSince1970:[dict[@"time"] intValue]];
        run.distance = [NSNumber numberWithFloat:[dict[@"distance"] floatValue]];
        Location* location = [[Location alloc]init];
        NSArray* locationArr = [location convertFromDictionary:dict];
        run.locations = [NSOrderedSet orderedSetWithArray:locationArr];
        [dataArray addObject:run];
    }
    return [dataArray copy];
}

-(NSDictionary *)convertToDictionary{
    NSMutableDictionary* resultDict = [NSMutableDictionary dictionaryWithCapacity:3];
    [resultDict setObject:self.distance.description forKey:@"distance"];
    [resultDict setObject:self.duration.description forKey:@"duration"];
    NSArray* locationArr = [self.locations array];
    NSMutableArray* locationDictArr = [NSMutableArray arrayWithCapacity:10];
    for (Location* location in locationArr) {
        [locationDictArr addObject:[location convertToDictionary]];
    }
    [resultDict setObject:[locationDictArr copy] forKey:@"locations"];
    return [resultDict copy];
}

@end
