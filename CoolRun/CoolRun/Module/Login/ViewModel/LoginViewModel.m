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
        [XDNetworking postWithUrl:API_LOGIN refreshRequest:YES cache:NO params:dict progressBlock:nil successBlock:^(id response) {
            NSLog(@"%@",response);
            UserModel* user = [[UserModel alloc]initWithDictionary:response];
            [[NSUserDefaults standardUserDefaults] setValue:user.uid forKey:UID];
            [[NSUserDefaults standardUserDefaults] setValue:response[@"token"] forKey:TOKEN];
            [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:ISLOGIN];
            
            [[MyUserDefault shareUserDefault] storeValue:user withKey:USER];
            if (successBlock) {
                successBlock(user);
            }
        } failBlock:^(NSError *error) {
            if (failBlock) {
                failBlock();
            }
        }];
    }
}

@end
