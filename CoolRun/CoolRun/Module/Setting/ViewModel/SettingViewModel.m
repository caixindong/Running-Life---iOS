//
//  SettingViewModel.m
//  CoolRun
//
//  Created by 蔡欣东 on 16/5/29.
//  Copyright © 2016年 蔡欣东. All rights reserved.
//

#import "SettingViewModel.h"

@implementation SettingViewModel

- (void)PostOldPwd:(NSString *)oldPwd
           newPwd:(NSString *)pwd
 withSuccessBlock:(ReturnValueBlock)successBlock
    failWithError:(ErrorCodeBlock)errorBlock
failWithNetworkWithBlock:(FailureBlock)failBlock{
    NSString* uid = [[NSUserDefaults standardUserDefaults]valueForKey:UID];
    NSString* token = [[NSUserDefaults standardUserDefaults]valueForKey:TOKEN];
    if (uid&&token&&oldPwd&&pwd) {
        NSDictionary* params = @{@"token":token,
                                 @"id":uid,
                                 @"old_password":oldPwd,
                                 @"new_password":pwd};
        [XDNetworking postWithUrl:API_CHANGE_PWD refreshRequest:YES cache:NO params:params progressBlock:nil successBlock:^(id response) {
            if (successBlock) {
                successBlock(response);
            }
        } failBlock:^(NSError *error) {
            if (failBlock) {
                failBlock();
            }
        }];
    }
}

- (void)logout{
    [[CoreDataManager shareManager] switchToTempDatabase];
    
    UserStatusManager *manager = [UserStatusManager shareManager];
    
    manager.userModel = nil;
    
    manager.isLogin = @NO;
}

@end
