//
//  UserSettingViewModel.h
//  CoolRun
//
//  Created by 蔡欣东 on 16/5/26.
//  Copyright © 2016年 蔡欣东. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserSettingViewModel : NSObject

/**
 *  姓名
 */
@property (nonatomic, copy, readwrite)NSString *realnameLabelText;

/**
 *  账号
 */
@property (nonatomic, copy, readwrite)NSString *usernameLableText;

/**
 *  性别
 */
@property (nonatomic, copy, readwrite)NSString *sexLabelText;

/**
 *  生日
 */
@property (nonatomic, copy, readwrite)NSString *birthdayLabelText;

/**
 *  身高
 */
@property (nonatomic, copy, readwrite)NSString *heightLabelText;

/**
 *  体重
 */
@property (nonatomic, copy, readwrite)NSString *weightLabelText;

/**
 *  用户头像
 */
@property (nonatomic, copy, readwrite)NSString *userImgUrl;

/**
 *  更新的头像数据
 */
@property (nonatomic, strong, readwrite)NSData *imageData;

/**
 *  用户信息改变
 */
@property (nonatomic, strong, readwrite)NSNumber *infoRefresh;

/**
 *  用户数据模型
 */
@property (nonatomic, strong, readwrite)UserModel *userModel;


/**
 *  更新信息成功与否
 */
@property (nonatomic, strong, readonly)NSNumber *updateSuccessOrFail;

/**
 *  无效输入
 */
@property (nonatomic, strong, readonly)NSNumber *invalid;



/**
 *  更新头像
 */
- (void)uploadAvatar;

/**
 *  更新用户数据
 */
- (void)updateUserInfo;

@end
