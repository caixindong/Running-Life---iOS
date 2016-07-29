//
//  MyNetworkRequest.h
//  suidaokou2
//
//  Created by 蔡欣东 on 15/11/23.
//  Copyright © 2015年 蔡欣东. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef void (^NetWorkBlock)(BOOL netConnetState);

@interface MyNetworkRequest : NSObject


/**
 检查网络连接
 **/
+(BOOL)isNetWorkReachableWithUrlStr:(NSString*)urlStr;


/**
 POST请求
 **/
+(void)POSTRequestWithURL:(NSString*)requestURLStr WithParameter:(NSDictionary*)param WithReturnBlock:(ReturnValueBlock)block WithErrorCodeBlock:(ErrorCodeBlock)errorBlock WithFailtureBlock:(FailureBlock)failtureBlock;

/**
 上传
 **/
+(void)POSTToUrl:(NSString*)url WithData:(NSData*)data WithReturnBlock:(ReturnValueBlock)block WithErrorCodeBlock:(ErrorCodeBlock)errorBlock WithFailtureBlock:(FailureBlock)failtureBlock;
@end
