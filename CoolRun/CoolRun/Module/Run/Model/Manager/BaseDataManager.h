//
//  BaseDataManager.h
//  CoolRun
//
//  Created by 蔡欣东 on 16/5/16.
//  Copyright © 2016年 蔡欣东. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  数据管理基类
 */
@interface BaseDataManager : NSObject

/**
 *  全局context
 */
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

/**
 *  保存上下文
 */
-(void)saveContext;

@end
