//
//  LoginViewModel.h
//  CoolRun
//
//  Created by 蔡欣东 on 16/5/25.
//  Copyright © 2016年 蔡欣东. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoginViewModel : NSObject

-(void)postUserName:(NSString*)usn password:(NSString*)pwd withSuccessBlock:(ReturnValueBlock)successBlock failWithError:(ErrorCodeBlock)errorBlock failWithNetworkWithBlock:(FailureBlock)failBlock;

@end
