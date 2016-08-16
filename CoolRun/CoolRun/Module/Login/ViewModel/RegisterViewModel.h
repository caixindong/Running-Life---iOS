//
//  RegisterViewModel.h
//  CoolRun
//
//  Created by 蔡欣东 on 16/5/28.
//  Copyright © 2016年 蔡欣东. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RegisterViewModel : NSObject

/**
 *  账号
 */
@property (nonatomic, copy, readwrite)NSString *username;

/**
 *  密码
 */
@property (nonatomic, copy, readwrite)NSString *password;

/**
 *  再一次输入密码
 */
@property (nonatomic, copy, readwrite)NSString *againPassword;

/**
 *  真实姓名
 */
@property (nonatomic, copy, readwrite)NSString *realName;

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
 *  注册成功或失败
 */
@property (nonatomic, strong, readonly)NSNumber *registerSuccessOrFail;

/**
 *  注册
 */
- (void)Register;

@end
