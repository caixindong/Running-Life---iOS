//
//  AppDelegate.h
//  CoolRun
//
//  Created by 蔡欣东 on 16/5/5.
//  Copyright © 2016年 蔡欣东. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "AppUIInitProcess.h"
#import "SDKInitProcess.h"
@class JVFloatingDrawerSpringAnimator;
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property(nonatomic,strong)SDKInitProcess* SDKProcess;

@property(nonatomic,strong)AppUIInitProcess* UIProcess;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;

@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

+ (AppDelegate *)globalDelegate;
- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;


@end

