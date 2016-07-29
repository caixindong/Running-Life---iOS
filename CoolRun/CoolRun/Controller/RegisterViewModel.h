//
//  RegisterViewModel.h
//  CoolRun
//
//  Created by 蔡欣东 on 16/5/28.
//  Copyright © 2016年 蔡欣东. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RegisterViewModel : NSObject

-(void)PostUsername:(NSString*)usn password:(NSString*)pwd realname:(NSString*)rename withSuccessBlock:(ReturnValueBlock)successBlock failWithError:(ErrorCodeBlock)errorBlock failWithNetworkWithBlock:(FailureBlock)failBlock;

@end
