//
//  BaseDataManager.m
//  CoolRun
//
//  Created by 蔡欣东 on 16/5/16.
//  Copyright © 2016年 蔡欣东. All rights reserved.
//

#import "BaseDataManager.h"

@implementation BaseDataManager
-(void)saveContext{
    [((AppDelegate*)[UIApplication sharedApplication].delegate) saveContext];
}


-(NSManagedObjectContext *)managedObjectContext{
    if (!_managedObjectContext) {
        _managedObjectContext =  ((AppDelegate*)[UIApplication sharedApplication].delegate).managedObjectContext;
    }
    return _managedObjectContext;
}
@end
