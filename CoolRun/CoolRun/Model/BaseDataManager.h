//
//  BaseDataManager.h
//  CoolRun
//
//  Created by 蔡欣东 on 16/5/16.
//  Copyright © 2016年 蔡欣东. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseDataManager : NSObject
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
-(void)saveContext;
@end
