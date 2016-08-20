//
//  UserStatusManager.m
//  CoolRun
//
//  Created by 蔡欣东 on 16/6/1.
//  Copyright © 2016年 蔡欣东. All rights reserved.
//

#import "UserStatusManager.h"
#import "UserModel.h"

@interface UserStatusManager(){
    NSNumber *_isLogin;
    UserModel* _user;
}
@end


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
    if (!_user) {
        _user = (UserModel*)[[MyUserDefault shareUserDefault] valueWithKey:USER];
    }
    return _user;
}

- (void)setUserModel:(UserModel *)userModel {
    if (userModel) {
        _user = userModel;
        [[MyUserDefault shareUserDefault] storeValue:_user withKey:USER];
    }else {
        [[MyUserDefault shareUserDefault] removeObjectWithKey:USER];
    }
}

- (NSNumber *)isLogin {
    if (!_isLogin) {
        _isLogin = [[NSUserDefaults standardUserDefaults]valueForKey:ISLOGIN]?[[NSUserDefaults standardUserDefaults]valueForKey:ISLOGIN]:@NO;

    }
    return _isLogin;    
}

- (void)setIsLogin:(NSNumber *)isLogin {
    _isLogin = isLogin;
    [[NSUserDefaults standardUserDefaults] setObject:isLogin forKey:ISLOGIN];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
