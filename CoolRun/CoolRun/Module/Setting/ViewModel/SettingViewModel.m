//
//  SettingViewModel.m
//  CoolRun
//
//  Created by 蔡欣东 on 16/5/29.
//  Copyright © 2016年 蔡欣东. All rights reserved.
//

#import "SettingViewModel.h"

@implementation SettingViewModel

-(void)PostOldPwd:(NSString *)oldPwd
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
        [MyNetworkRequest POSTRequestWithURL:API_CHANGE_PWD
                               WithParameter:params
                             WithReturnBlock:^(id returnValue) {
                                 if (successBlock) {
                                     successBlock(returnValue);
                                 }
                             } WithErrorCodeBlock:^(id errorCode) {
                                 if (errorBlock) {
                                     errorBlock(errorCode[@"error"]);
                                 }
                             } WithFailtureBlock:^{
                                 if (failBlock) {
                                     failBlock();
                                 }
                             }];
    }
}

-(void)logout{
    UserStatusManager *manager = [UserStatusManager shareManager];
    [[MyUserDefault shareUserDefault] removeObjectWithKey:USER];
    manager.isLogin = @NO;
}
@end
