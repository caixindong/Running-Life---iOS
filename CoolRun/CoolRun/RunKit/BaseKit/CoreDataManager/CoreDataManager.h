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
 *  管理上下文对象
 */
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;

/**
 *  对象模型
 */
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;

/**
 *  持久层管理助手
 */
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

/**
 *  全局管理类
 *
 *  @return 
 */
+ (CoreDataManager *)shareManager;

/**
 *  保存上下文对象
 */
- (void)saveContext;

@end
