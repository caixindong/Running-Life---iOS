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

@property(nonatomic,strong)NSNumber *enableVoice;

@property(nonatomic,strong)NSNumber *enableRange;

@property(nonatomic,strong)NSNumber *isLogin;

@property(nonatomic,strong)NSNumber *haveChangeInfo;

@property(nonatomic,strong)UserModel* userModel;

+(UserStatusManager*)shareManager;

@end
