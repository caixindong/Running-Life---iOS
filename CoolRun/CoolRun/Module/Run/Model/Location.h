//
//  Location.h
//  CoolRun
//
//  Created by 蔡欣东 on 16/5/27.
//  Copyright © 2016年 蔡欣东. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Run;

NS_ASSUME_NONNULL_BEGIN



@interface Location : NSManagedObject


- (NSDictionary*)convertToDictionary;

- (NSArray*)convertFromDictionary:(NSDictionary*)dict;

@end

NS_ASSUME_NONNULL_END

#import "Location+CoreDataProperties.h"
