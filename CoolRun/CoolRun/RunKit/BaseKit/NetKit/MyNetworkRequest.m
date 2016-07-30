//
//  MyNetworkRequest.m
//  suidaokou2
//
//  Created by 蔡欣东 on 15/11/23.
//  Copyright © 2015年 蔡欣东. All rights reserved.
//

#import "MyNetworkRequest.h"

@interface MyNetworkRequest()
@end

@implementation MyNetworkRequest

+(BOOL)isNetWorkReachableWithUrlStr:(NSString *)urlStr{
    __block BOOL netSatue = NO;
    NSURL* url = [NSURL URLWithString:urlStr];
    
    AFHTTPRequestOperationManager* manager = [[AFHTTPRequestOperationManager alloc]initWithBaseURL:url];
    
    NSOperationQueue* queue = manager.operationQueue;
    
    [manager.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusReachableViaWWAN:
            case AFNetworkReachabilityStatusReachableViaWiFi:
                [queue setSuspended:NO];
                netSatue = YES;
                break;
            case AFNetworkReachabilityStatusNotReachable:
                netSatue = NO;
            default:
                [queue setSuspended:YES];
                break;
        }
    }];
    [manager.reachabilityManager startMonitoring];
    if (netSatue==YES) {
       
    }else{
    
    }
    return netSatue;
}

+(void)POSTRequestWithURL:(const NSString *)requestURLStr WithParameter:(NSDictionary *)param WithReturnBlock:(ReturnValueBlock)block WithErrorCodeBlock:(ErrorCodeBlock)errorBlock WithFailtureBlock:(FailureBlock)failtureBlock{
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] init];
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    AFHTTPRequestOperation *op = [manager POST:[NSString stringWithFormat:@"%@%@",BASE_API,requestURLStr] parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        int success = [dict[@"success"] intValue];
        if (success==1) {
            if (block) {
                block(dict);
            }
        }else{
            if (errorBlock) {
                errorBlock(dict);
            }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failtureBlock) {
            failtureBlock();
        }
        NSLog(@"%@",error);
    }];
    [op start];
}

+(void)POSTToUrl:(NSString *)url WithData:(NSData *)data WithReturnBlock:(ReturnValueBlock)block WithErrorCodeBlock:(ErrorCodeBlock)errorBlock WithFailtureBlock:(FailureBlock)failtureBlock{
    AFHTTPRequestOperationManager* manager = [[AFHTTPRequestOperationManager alloc]init];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.
                                                         acceptableContentTypes   setByAddingObject:@"text/html"];//重要
    [manager POST:url parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                formatter.dateFormat = @"yyyyMMddHHmmss";
                NSString *str = [formatter stringFromDate:[NSDate date]];
                NSString *fileName = [NSString stringWithFormat:@"%@.png", str];
        [formData appendPartWithFileData:data name:@"upload"fileName:fileName mimeType:@"image/png"];
    }success:^(AFHTTPRequestOperation *operation,id responseObject) {
        int re = [responseObject[@"re"] intValue];
        if (re==1 || re ==5) {
            if (block) {
                block(responseObject);
            }
        }else{
            NSLog(@"server error");
            if (errorBlock) {
                errorBlock(responseObject);
            }
        }
        
    }failure:^(AFHTTPRequestOperation *operation,NSError *error) {
        if (failtureBlock) {
            failtureBlock();
        }
        NSLog(@"upload error%@", error);
    }];
    
}
@end
