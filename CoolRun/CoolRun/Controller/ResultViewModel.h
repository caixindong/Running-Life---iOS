//
//  ResultViewModel.h
//  CoolRun
//
//  Created by 蔡欣东 on 16/5/29.
//  Copyright © 2016年 蔡欣东. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Run.h"
@interface ResultViewModel : NSObject

/**
 *  上传跑步结果
 *
 *  @param run          跑步信息
 *  @param successBlock 成功回调
 *  @param errorBlock   失败回调
 *  @param failBlock    服务器失败回调
 */
- (void)postRunResultToServer:(Run*)run
            withSuccessBlock:(ReturnValueBlock)successBlock
               failWithError:(ErrorCodeBlock)errorBlock
    failWithNetworkWithBlock:(FailureBlock)failBlock;

/**
 *  根据跑步ID获取排名
 *
 *  @param runID        跑步ID
 *  @param successBlock 成功回调
 *  @param errorBlock   失败回调
 *  @param failBlock    服务器失败回调
 */
- (void)postRunIDToGetRank:(int)runID
          withSuccessBlock:(ReturnValueBlock)successBlock
             failWithError:(ErrorCodeBlock)errorBlock
  failWithNetworkWithBlock:(FailureBlock)failBlock;

@end
