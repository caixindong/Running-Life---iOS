//
//  AppDelegate.m
//  CoolRun
//
//  Created by 蔡欣东 on 16/5/5.
//  Copyright © 2016年 蔡欣东. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    _UIProcess = [[AppUIInitProcess alloc]initWithApplication:application andLaunchOption:launchOptions];
    
    _SDKProcess = [[SDKInitProcess alloc]initWithApplication:application andLaunchOption:launchOptions];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
   
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application {

}

- (void)applicationWillTerminate:(UIApplication *)application {
    [[CoreDataManager shareManager] saveContext];    
}


- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    BOOL result = [UMSocialSnsService handleOpenURL:url];
    if (result == FALSE) {
        //调用其他SDK
    }
    return result;
}

#pragma mark - getter
+ (AppDelegate *)globalDelegate {
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}





@end
