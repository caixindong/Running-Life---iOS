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
 *  上传图片
 *
 *  @param imageData    图片数据
 *  @param successBlock 成功Block
 *  @param errorBlock   失败Block
 *  @param failBlock    服务器错误Block
 */
- (void)uploadImageToServer:(NSData *)imageData
        withSuccessBlock:(ReturnValueBlock)successBlock
           failWithError:(ErrorCodeBlock)errorBlock
failWithNetworkWithBlock:(FailureBlock)failBlock;


/**
 *  上传用户信息
 *
 *  @param user         用户model
 *  @param successBlock 成功Block
 *  @param errorBlock   失败Block
 *  @param failBlock    服务器错误Block
 */
- (void)postUserSettingWithUserInfo:(UserModel *)user
                  withSuccessBlock:(ReturnValueBlock)successBlock
                     failWithError:(ErrorCodeBlock)errorBlock
          failWithNetworkWithBlock:(FailureBlock)failBlock;
@end
