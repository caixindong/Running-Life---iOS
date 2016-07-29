//
//  UserSettingViewModel.m
//  CoolRun
//
//  Created by 蔡欣东 on 16/5/26.
//  Copyright © 2016年 蔡欣东. All rights reserved.
//

#import "UserSettingViewModel.h"

static NSString *const API_TOKEN = @"token";
static NSString *const API_ID = @"id";
static NSString *const API_AVATAR = @"avatar";
static NSString *const API_HEIGHT = @"user_height";
static NSString *const API_WEIGHT = @"user_weight";
static NSString *const API_BIRTH = @"user_birth";
static NSString *const API_SEX = @"user_sex";
static NSString *const API_REALNAME = @"realname";

@implementation UserSettingViewModel

- (void)uploadImageToServer:(NSData *)imageData
        withSuccessBlock:(ReturnValueBlock)successBlock
           failWithError:(ErrorCodeBlock)errorBlock
failWithNetworkWithBlock:(FailureBlock)failBlock{
    NSString* uid = [[NSUserDefaults standardUserDefaults]valueForKey:UID];
    NSString* token = [[NSUserDefaults standardUserDefaults]valueForKey:TOKEN];
    if (imageData&&uid&&token) {
        NSLog(@"%@",imageData);
        NSDictionary* params = @{API_TOKEN:token,
                                 API_ID:uid,
                                API_AVATAR:[NSString stringWithFormat:@"%@",imageData]};
        NSLog(@"%@",params);
        [MyNetworkRequest POSTRequestWithURL:API_POST_IMG WithParameter:params WithReturnBlock:^(id returnValue) {
            if (successBlock) {
                successBlock(returnValue[@"avatar"]);
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

- (void)postUserSettingWithUserInfo:(UserModel*)user
                  withSuccessBlock:(ReturnValueBlock)successBlock
                     failWithError:(ErrorCodeBlock)errorBlock
          failWithNetworkWithBlock:(FailureBlock)failBlock{
    NSString* uid = [[NSUserDefaults standardUserDefaults]valueForKey:UID];
    NSString* token = [[NSUserDefaults standardUserDefaults]valueForKey:TOKEN];
    if (user&&uid&&token) {
        NSDictionary* params = @{
                                 API_ID:uid,
                                 API_TOKEN:token,
                                 API_HEIGHT:user.height,
                                 API_WEIGHT:user.weight,
                                 API_SEX:user.sex,
                                 API_BIRTH:user.birth,
                                 API_REALNAME:user.realname
                                 };
        [MyNetworkRequest POSTRequestWithURL:API_CHANGE_INFO
                               WithParameter:params
                             WithReturnBlock:^(id returnValue) {
                                 if (successBlock) {
                                     successBlock(returnValue);
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
