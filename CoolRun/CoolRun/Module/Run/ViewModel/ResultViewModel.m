//
//  ResultViewModel.m
//  CoolRun
//
//  Created by 蔡欣东 on 16/5/29.
//  Copyright © 2016年 蔡欣东. All rights reserved.
//

#import "ResultViewModel.h"

static float weight = 65;

@interface ResultViewModel()

@property (nonatomic, copy, readwrite) NSString *rank;

@property (nonatomic, strong, readwrite) NSNumber *netFail;


/**
 *  跑步记录
 */
@property (nonatomic, strong, readwrite) Run *run;

/**
 *  记录管理器
 */
@property (nonatomic,strong)RecordManager* manager;

@end

@implementation ResultViewModel

- (instancetype)initWithRunModel:(Run *)run {
    if (self = [super init]) {
        self.run = run;
        self.manager = [RecordManager shareManager];
    }
    return self;
}

- (void)postRunRecordToServerAndGetRank {
     NSLog(@"上传跑步");
    NSString* uid = [[NSUserDefaults standardUserDefaults]valueForKey:UID];
    NSString* token = [[NSUserDefaults standardUserDefaults]valueForKey:TOKEN];
    if (uid && token && self.run) {
        NSDictionary* runDict = [self.run convertToDictionary];
        
        NSDictionary* params = @{@"id":uid,
                                 @"token":token,
                                 @"run":runDict};
        
        [XDNetworking postWithUrl:API_UPLOAD_RESULT refreshRequest:YES cache:NO params:params progressBlock:nil successBlock:^(id response) {
            self.rank = [NSString stringWithFormat:@"第%@名",response[@"my_ranking"]];
            //数据库更新同步状态
            [self.manager touchRun:self.run
                            WithID:[response[@"running_result_id"] intValue]];
            
            [self.manager syncharonizeRun:self.run];
        } failBlock:^(NSError *error) {
            self.netFail = @YES;
        }];
    }

}

- (void)getRankData {
    NSLog(@"获取名词 IS %@",self);
    NSString *uid   = [[NSUserDefaults standardUserDefaults]valueForKey:UID];
    NSString *token = [[NSUserDefaults standardUserDefaults]valueForKey:TOKEN];
    NSString *runID = [NSString stringWithFormat:@"%d",[self.run.runid intValue]];
    
    if (uid && token && runID) {
        NSDictionary *params = @{@"id":uid,
                                 @"token":token,
                                 @"running_result_id":runID,
                                 @"page":@"1",
                                 @"interval":@"5"
                                 };
        [XDNetworking postWithUrl:API_GET_RANKING refreshRequest:YES cache:NO params:params progressBlock:nil successBlock:^(id response) {
            self.rank = [NSString stringWithFormat:@"第%@名",response[@"my_ranking"]];
            ;
        } failBlock:^(NSError *error) {
            self.netFail = @YES;
        }];
    }

}

#pragma mark - getter and setter

- (NSString *)distanceLabelText {
    return [NSString stringWithFormat:@"%@km",[MathController stringifyDistance:self.run.distance.floatValue]];
}

- (NSString *)timeLabelText {
    return [NSString stringWithFormat:@"%@",  [MathController stringifySecondCount:self.run.duration.intValue usingLongFormat:NO]];
}

- (NSString *)paceLabelText {
    return [NSString stringWithFormat:@"%@",  [MathController stringifyAvgPaceFromDist:self.run.distance.floatValue overTime:self.run.duration.intValue]];
}

- (NSString *)kcalLableText {
    return [NSString stringWithFormat:@"%@卡里路",[MathController stringifyKcalFromDist:[self.run.distance floatValue]  withWeight:weight]];
}

- (NSString *)countLabelText {
    return [NSString stringWithFormat:@"x%.2f",[[MathController stringifyKcalFromDist:[self.run.distance floatValue]  withWeight:weight] floatValue]/300];
}

- (MKCoordinateRegion )region {
    MKCoordinateRegion region;
    Location *initialLoc = self.run.locations.firstObject;
    
    float minLat = initialLoc.latitude.floatValue;
    float minLng = initialLoc.longtitude.floatValue;
    float maxLat = initialLoc.latitude.floatValue;
    float maxLng = initialLoc.longtitude.floatValue;
    
    for (Location *location in self.run.locations) {
        if (location.latitude.floatValue < minLat) {
            minLat = location.latitude.floatValue;
        }
        if (location.longtitude.floatValue < minLng) {
            minLng = location.longtitude.floatValue;
        }
        if (location.latitude.floatValue > maxLat) {
            maxLat = location.latitude.floatValue;
        }
        if (location.longtitude.floatValue > maxLng) {
            maxLng = location.longtitude.floatValue;
        }
    }
    
    region.center.latitude = (minLat + maxLat) / 2.0f;
    region.center.longitude = (minLng + maxLng) / 2.0f;
    
    region.span.latitudeDelta = (maxLat - minLat) * 2.0f; // 10% padding
    region.span.longitudeDelta = (maxLng - minLng) * 2.0f; // 10% padding
    
    return region;
}

- (NSArray *)colorSegmentArray {
    return [MathController colorSegmentsForLocations:self.run.locations.array];
}



@end
