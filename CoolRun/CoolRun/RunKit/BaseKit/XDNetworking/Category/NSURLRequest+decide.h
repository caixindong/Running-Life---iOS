//
//  NSURLRequest+decide.h
//  XDNetworking
//
//  Created by 蔡欣东 on 2016/8/9.
//  Copyright © 2016年 蔡欣东. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  判断是不是一样的请求
 */
@interface NSURLRequest (decide)

- (BOOL)isTheSameRequest:(NSURLRequest *)request;

@end
