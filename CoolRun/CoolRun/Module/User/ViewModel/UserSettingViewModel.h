//
//  UserSettingViewModel.h
//  CoolRun
//
//  Created by 蔡欣东 on 16/5/26.
//  Copyright © 2016年 蔡欣东. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserModel.h"
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



//
///**
// *  上传图片
// *
// *  @param imageData    图片数据
// *  @param successBlock 成功Block
// *  @param errorBlock   失败Block
// *  @param failBlock    服务器错误Block
// */
//- (void)uploadImageToServer:(NSData *)imageData
//        withSuccessBlock:(ReturnValueBlock)successBlock
//           failWithError:(ErrorCodeBlock)errorBlock
//failWithNetworkWithBlock:(FailureBlock)failBlock;
//
//
///**
// *  上传用户信息
// *
// *  @param user         用户model
// *  @param successBlock 成功Block
// *  @param errorBlock   失败Block
// *  @param failBlock    服务器错误Block
// */
//- (void)postUserSettingWithUserInfo:(UserModel *)user
//                  withSuccessBlock:(ReturnValueBlock)successBlock
//                     failWithError:(ErrorCodeBlock)errorBlock
//          failWithNetworkWithBlock:(FailureBlock)failBlock;
@end
