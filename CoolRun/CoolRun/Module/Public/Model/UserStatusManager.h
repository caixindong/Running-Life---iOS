//
//  UserStatusManager.h
//  CoolRun
//
//  Created by 蔡欣东 on 16/6/1.
//  Copyright © 2016年 蔡欣东. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UserModel;

@interface UserStatusManager : NSObject

/**
 *  是否开启语音
 */
@property(nonatomic,strong)NSNumber *enableVoice;

/**
 *  是否参与排名
 */
@property(nonatomic,strong)NSNumber *enableRange;

/**
 *  是否登录
 */
@property(nonatomic,strong)NSNumber *isLogin;

/**
 *  是否修改了用户信息
 */
@property(nonatomic,strong)NSNumber *haveChangeInfo;

/**
 *  用户模型
 */
@property(nonatomic,strong)UserModel* userModel;

/**
 *  用户状态全局管理器
 *
 *  @return 
 */
+(UserStatusManager*)shareManager;

@end
