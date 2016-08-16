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

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property(nonatomic,strong)SDKInitProcess* SDKProcess;

@property(nonatomic,strong)AppUIInitProcess* UIProcess;

+ (AppDelegate *)globalDelegate;

@end

