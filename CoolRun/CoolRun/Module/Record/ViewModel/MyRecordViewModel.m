//
//  MyRecordViewModel.m
//  CoolRun
//
//  Created by 蔡欣东 on 16/5/28.
//  Copyright © 2016年 蔡欣东. All rights reserved.
//

#import "MyRecordViewModel.h"
#import "RecordManager+Kcal.h"

@interface MyRecordViewModel()

@property (nonatomic, copy, readwrite) NSArray *walkAndRunKcalArray;

@property (nonatomic, copy, readwrite) NSArray *runKcalArray;

/**
 *  健康数据管理器
 */
@property (nonatomic, strong, readwrite) HealthKitManager* manager;

/**
 *  跑步记录管理器
 */
@property (nonatomic, strong, readwrite) RecordManager* recordManager;

@end

@implementation MyRecordViewModel

- (instancetype)init {
    if (self = [super init]) {
        _manager                = [HealthKitManager shareManager];
        _recordManager          = [RecordManager shareManager];
        _walkAndRunKcalArray    = [NSArray array];
        _runKcalArray           = [NSArray array];
        
    }
    return self;
}

- (void)getWalkAndRunKcalArrayWithMonth:(NSInteger)month year:(NSInteger)year weigth:(float)weight {
    [_manager getKcalWithWeight:weight
                            year:year
                            month:month
                       complete:^(id arr) {
                           self.walkAndRunKcalArray     = arr;
                           self.runKcalArray            = [_recordManager getKcalDataWithMonth:month year:year weight:weight];
                } failWithError:^(NSError * error) {
                            NSLog(@"get kcal error is %@",error);
    }];
}

- (DetailViewModel *)getRunRecordWithDate:(NSDate *)date {
    NSArray *dataArray = [_recordManager getRunInfoInDate:date];
    if (dataArray.count ==0 ) return nil;
    DetailViewModel *viewModel = [[DetailViewModel alloc] initWithRunDatas:[dataArray copy]];
    return viewModel;
}

@end
