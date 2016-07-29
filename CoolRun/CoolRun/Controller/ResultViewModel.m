//
//  ResultViewModel.m
//  CoolRun
//
//  Created by 蔡欣东 on 16/5/29.
//  Copyright © 2016年 蔡欣东. All rights reserved.
//

#import "ResultViewModel.h"


@implementation ResultViewModel

-(void)postRunResultToServer:(Run *)run
            withSuccessBlock:(ReturnValueBlock)successBlock
               failWithError:(ErrorCodeBlock)errorBlock
    failWithNetworkWithBlock:(FailureBlock)failBlock{
    NSString* uid = [[NSUserDefaults standardUserDefaults]valueForKey:UID];
    NSString* token = [[NSUserDefaults standardUserDefaults]valueForKey:TOKEN];
    if (uid && token && run) {
        NSDictionary* runDict = [run convertToDictionary];
        NSDictionary* params = @{@"id":uid,
                                 @"token":token,
                                 @"run":runDict};
        [MyNetworkRequest POSTRequestWithURL:@"upload_result" WithParameter:params WithReturnBlock:^(id returnValue) {
            NSLog(@"%@",returnValue);
            if (successBlock) {
                successBlock(returnValue);
            }
        } WithErrorCodeBlock:^(id errorCode) {
            if (errorBlock) {
                errorBlock(errorCode);
            }
        } WithFailtureBlock:^{
            if (failBlock) {
                failBlock();
            }
        }];
    }
}

-(void)postRunIDToGetRank:(int)runID
         withSuccessBlock:(ReturnValueBlock)successBlock
            failWithError:(ErrorCodeBlock)errorBlock
 failWithNetworkWithBlock:(FailureBlock)failBlock{
    NSString* uid = [[NSUserDefaults standardUserDefaults]valueForKey:UID];
    NSString* token = [[NSUserDefaults standardUserDefaults]valueForKey:TOKEN];
    if (uid && token && runID) {
        NSDictionary *params = @{@"id":uid,
                                 @"token":token,
                                 @"running_result_id":[NSString stringWithFormat:@"%d",runID],
                                 @"page":@"1",
                                 @"interval":@"5"
                                 };
        [MyNetworkRequest POSTRequestWithURL:API_GET_RANKING
                               WithParameter:params
                             WithReturnBlock:^(id returnValue) {
                                 NSString *rank = returnValue[@"my_ranking"];
                                 if (successBlock) {
                                     successBlock(rank);
                                 }
                             } WithErrorCodeBlock:^(id errorCode) {
                                 if (errorBlock) {
                                     errorBlock(errorCode);
                                 }
                             } WithFailtureBlock:^{
                                 if (failBlock) {
                                     failBlock();
                                 }
                                 
                             }];
    }
}
@end
