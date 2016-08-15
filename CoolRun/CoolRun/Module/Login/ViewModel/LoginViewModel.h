//
//  LoginViewModel.h
//  CoolRun
//
//  Created by 蔡欣东 on 16/5/25.
//  Copyright © 2016年 蔡欣东. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoginViewModel : NSObject

/**
 *  账号
 */
@property (nonatomic, copy, readwrite)NSString *username;

/**
 *  密码
 */
@property (nonatomic, copy, readwrite)NSString *password;

/**
 *  无效输入
 */
@property (nonatomic, strong, readonly)NSNumber *invalid;

/**
 *  无效输入提示信息
 */
@property (nonatomic, copy, readonly)NSString *invalidMsg;

/**
 *  网络错误
 */
@property (nonatomic, strong, readonly)NSNumber *netFail;

/**
 *  登陆成功或失败
 */
@property (nonatomic, strong, readonly)NSNumber *loginSuccessOrFail;

/**
 *  登陆
 */
- (void)login;

@end
