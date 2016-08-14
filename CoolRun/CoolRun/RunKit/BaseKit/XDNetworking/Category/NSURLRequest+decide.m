//
//  NSURLRequest+decide.m
//  XDNetworking
//
//  Created by 蔡欣东 on 2016/8/9.
//  Copyright © 2016年 蔡欣东. All rights reserved.
//

#import "NSURLRequest+decide.h"

@implementation NSURLRequest (decide)

- (BOOL)isTheSameRequest:(NSURLRequest *)request {
    if ([self.HTTPMethod isEqualToString:request.HTTPMethod]) {
        if ([self.URL.absoluteString isEqualToString:request.URL.absoluteString]) {
            if ([self.HTTPMethod isEqualToString:@"GET"]||[self.HTTPBody isEqualToData:request.HTTPBody]) {
                return YES;
            }
        }
    }
    return NO;
}

@end
