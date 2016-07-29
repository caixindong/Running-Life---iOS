//
//  RecordManager+Kcal.h
//  CoolRun
//
//  Created by 蔡欣东 on 16/5/20.
//  Copyright © 2016年 蔡欣东. All rights reserved.
//

#import "RecordManager.h"

@interface RecordManager (Kcal)

-(NSArray*)getKcalDataWithMonth:(NSInteger) month withYear:(NSInteger)year withWeight:(float)weight;

@end
