//
//  LoginViewModel.m
//  CoolRun
//
//  Created by 蔡欣东 on 16/5/25.
//  Copyright © 2016年 蔡欣东. All rights reserved.
//

#import "LoginViewModel.h"
#import "UserModel.h"

@interface LoginViewModel()

@property (nonatomic, strong, readwrite)NSNumber *invalid;

@property (nonatomic, copy, readwrite)NSString *invalidMsg;

@property (nonatomic, strong, readwrite)NSNumber *netFail;

@property (nonatomic, strong, readwrite)NSNumber *loginSuccessOrFail;

@end

@implementation LoginViewModel

- (void)login {
    if ([[self.username stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]||[[self.password stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]) {
        self.invalid    = @YES;
        self.invalidMsg = @"账号或密码为空";
        return;
    }
    
    if (self.username && self.password) {
        NSDictionary* params = @{@"username":self.username,@"password":self.password};
        [XDNetworking postWithUrl:API_LOGIN refreshRequest:YES cache:NO params:params progressBlock:nil successBlock:^(id response) {
            NSLog(@"%@",response);
            if (response[@"success"] && [response[@"success"] intValue] == 0) {
                self.loginSuccessOrFail = @NO;
            }else {
                UserModel* user = [[UserModel alloc]initWithDictionary:response];
                
                [[NSUserDefaults standardUserDefaults] setValue:user.uid forKey:UID];
                [[NSUserDefaults standardUserDefaults] setValue:response[@"token"] forKey:TOKEN];
                [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:ISLOGIN];
                
                [[MyUserDefault shareUserDefault] storeValue:user withKey:USER];
                
                UserStatusManager *manager = [UserStatusManager shareManager];
                manager.isLogin = @YES;
                
                self.loginSuccessOrFail = @YES;
            }

        } failBlock:^(NSError *error) {
            self.netFail = @YES;
        }];
    }
    
}

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
