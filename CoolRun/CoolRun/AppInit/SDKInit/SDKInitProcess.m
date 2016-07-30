//
//  SDKInitProcess.m
//  CoolRun
//
//  Created by 蔡欣东 on 16/5/29.
//  Copyright © 2016年 蔡欣东. All rights reserved.
//

#import "SDKInitProcess.h"

@implementation SDKInitProcess

-(instancetype)initWithApplication:(UIApplication *)application andLaunchOption:(NSDictionary *)option{
    if (self = [super init]) {
        [self initAMMapSetting];
        [self initHealthKitSetting];
        [self initUMSetting];
    }
    return self;
}

-(void)initAMMapSetting{
    [AMapLocationServices sharedServices].apiKey =@"1ad2f773b7d4c6dfeab95f79b9242811";
}

-(void)initHealthKitSetting{
    if (![HKHealthStore isHealthDataAvailable]) {
        NSLog(@"设备不支持healthKit");
    }
    
    HKObjectType *walkingRuningDistance = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierDistanceWalkingRunning];
    HKObjectType *stepCount = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount];
    
    NSSet *healthSet = [NSSet setWithObjects:walkingRuningDistance,stepCount, nil];
    
    //从健康应用中获取权限
    [self.healthStore requestAuthorizationToShareTypes:nil readTypes:healthSet completion:^(BOOL success, NSError * _Nullable error) {
        if (success)
        {
            NSLog(@"获取距离权限成功");
        }
        else
        {
            NSLog(@"获取距离权限失败");
        }
    }];

}

-(void)initUMSetting{
    [UMSocialData setAppKey:UmengAppkey];
    [UMSocialWechatHandler setWXAppId:WEIXINAppID appSecret:@"db426a9829e4b49a0dcac7b4162da6b6" url:@"http://www.umeng.com/social"];
}

-(HKHealthStore *)healthStore{
    if (!_healthStore) {
        _healthStore = [[HKHealthStore alloc]init];
    }
    return _healthStore;
}
@end
