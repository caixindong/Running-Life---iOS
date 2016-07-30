//
//  UserStatusManager.m
//  CoolRun
//
//  Created by 蔡欣东 on 16/6/1.
//  Copyright © 2016年 蔡欣东. All rights reserved.
//

#import "UserStatusManager.h"
#import "UserModel.h"
@implementation UserStatusManager

+ (UserStatusManager *)shareManager {
    static UserStatusManager* manager;
    //记得加static
    static dispatch_once_t once;
    if (!manager) {
        dispatch_once(&once, ^{
            manager = [[UserStatusManager alloc]init];
        });
    }
    return manager;
}

- (UserModel *)userModel {
    UserModel* user = (UserModel*)[[MyUserDefault shareUserDefault] valueWithKey:USER];
    if (user) {
        return user;
    }
    return nil;
}

- (NSNumber *)isLogin {
    NSNumber* status = [[NSUserDefaults standardUserDefaults]valueForKey:ISLOGIN];
    if (status) {
        return status;
    }
    return @NO;
}

- (void)setIsLogin:(NSNumber *)isLogin {
    [[NSUserDefaults standardUserDefaults] setObject:isLogin forKey:ISLOGIN];
}

@end
