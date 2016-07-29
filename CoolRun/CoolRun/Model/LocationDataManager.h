//
//  LocationDataManager.h
//  CoolRun
//
//  Created by 蔡欣东 on 16/5/16.
//  Copyright © 2016年 蔡欣东. All rights reserved.
//

#import "BaseDataManager.h"

@interface LocationDataManager : BaseDataManager
-(Location*)addLoactionWithLatitude:(NSNumber*) latitude withLongtitude:(NSNumber*) longtitude withTimestamp:(NSDate*) timestamp;
@end
