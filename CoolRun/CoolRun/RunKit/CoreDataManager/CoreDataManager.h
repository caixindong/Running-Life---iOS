//
//  CoreDataManager.h
//  CoolRun
//
//  Created by 蔡欣东 on 2016/8/16.
//  Copyright © 2016年 蔡欣东. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CoreDataManager : NSObject

/**
 *  临时管理上下文对象
 */
@property (readonly, strong, nonatomic) NSManagedObjectContext *tempManagedObjectContext;

/**
 *  管理上下文对象
 */
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;

/**
 *  全局管理类
 *
 *  @return 
 */
+ (CoreDataManager *)shareManager;

/**
 *  切换数据库，如果没有就新建
 *
 *  @param name 数据库名字
 */
- (void)switchToDatabase:(NSString *)name;

/**
 *  切换到临时数据库
 */
- (void)switchToTempDatabase;

/**
 *  保存上下文对象
 */
- (void)saveContext;

/**
 *  保存临时上下文对象
 */
- (void)saveTempContext;

@end
