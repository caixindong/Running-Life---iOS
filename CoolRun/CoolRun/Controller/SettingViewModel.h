//
//  SettingViewModel.h
//  CoolRun
//
//  Created by 蔡欣东 on 16/5/29.
//  Copyright © 2016年 蔡欣东. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SettingViewModel : NSObject

-(void)PostOldPwd:(NSString*)oldPwd
           newPwd:(NSString*)pwd
            withSuccessBlock:(ReturnValueBlock)successBlock
               failWithError:(ErrorCodeBlock)errorBlock
    failWithNetworkWithBlock:(FailureBlock)failBlock;

-(void)logout;
@end
