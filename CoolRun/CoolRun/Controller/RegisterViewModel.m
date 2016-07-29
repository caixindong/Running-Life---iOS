//
//  RegisterViewModel.m
//  CoolRun
//
//  Created by 蔡欣东 on 16/5/28.
//  Copyright © 2016年 蔡欣东. All rights reserved.
//

#import "RegisterViewModel.h"
#import "UserModel.h"

@implementation RegisterViewModel

-(void)PostUsername:(NSString *)usn password:(NSString *)pwd realname:(NSString *)rename withSuccessBlock:(ReturnValueBlock)successBlock failWithError:(ErrorCodeBlock)errorBlock failWithNetworkWithBlock:(FailureBlock)failBlock{
    if (usn&&pwd&&rename) {
        NSDictionary* dict = @{@"username":usn,@"password":pwd,@"realname":rename};
        [MyNetworkRequest POSTRequestWithURL:@"signup" WithParameter:dict WithReturnBlock:^(id returnValue) {
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
                errorBlock(errorCode[@"error"]);
            }
        } WithFailtureBlock:^{
            if (failBlock) {
                failBlock();
            }
        }];
    }
}


@end
