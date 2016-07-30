//
//  LoginViewModel.m
//  CoolRun
//
//  Created by 蔡欣东 on 16/5/25.
//  Copyright © 2016年 蔡欣东. All rights reserved.
//

#import "LoginViewModel.h"

#import "UserModel.h"

@implementation LoginViewModel

-(void)postUserName:(NSString *)usn password:(NSString *)pwd withSuccessBlock:(ReturnValueBlock)successBlock failWithError:(ErrorCodeBlock)errorBlock failWithNetworkWithBlock:(FailureBlock)failBlock{
    if (usn&&pwd) {
        NSDictionary* dict = @{@"username":usn,@"password":pwd};
        [MyNetworkRequest POSTRequestWithURL: API_LOGIN WithParameter:dict WithReturnBlock:^(id returnValue) {
            NSLog(@"%@",returnValue);
            UserModel* user = [[UserModel alloc]initWithDictionary:returnValue];
            [[NSUserDefaults standardUserDefaults] setValue:user.uid forKey:UID];
            [[NSUserDefaults standardUserDefaults] setValue:returnValue[@"token"] forKey:TOKEN];
            [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:ISLOGIN];
            
            [[MyUserDefault shareUserDefault] storeValue:user withKey:USER];
            if (successBlock) {
                successBlock(user);
            }
        } WithErrorCodeBlock:^(id errorCode) {
            if (errorBlock) {
                errorBlock(errorCode);
            }
        } WithFailtureBlock:^{
            if (failBlock) {
                failBlock();
            }
        }];
    }
    

}

@end
