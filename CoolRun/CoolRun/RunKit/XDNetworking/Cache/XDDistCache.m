//
//  XDDistCache.m
//  XDNetworking
//
//  Created by 蔡欣东 on 2016/7/25.
//  Copyright © 2016年 蔡欣东. All rights reserved.
//

#import "XDDistCache.h"

@implementation XDDistCache

+ (void)writeData:(id)data
            toDir:(NSString *)directory
         filename:(NSString *)filename{
    assert(data);
    
    assert(directory);
    
    assert(filename);
    
    NSError *error = nil;
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:directory isDirectory:nil]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:directory withIntermediateDirectories:YES attributes:nil error:&error];
    }
    
    if (error) {
        NSLog(@"createDirectory error is %@",error.localizedDescription);
        return;
    }
    
    NSString *filePath = [directory stringByAppendingPathComponent:filename];
    
    [[NSFileManager defaultManager] createFileAtPath:filePath contents:data attributes:nil];
    
}

+ (id)readDataFromDir:(NSString *)directory
             filename:(NSString *)filename {
    assert(directory);
    
    assert(filename);
    
    NSData *data = nil;
    
    NSString *filePath = [directory stringByAppendingPathComponent:filename];
    
    data = [[NSFileManager defaultManager] contentsAtPath:filePath];
    
    return data;
}

+ (unsigned long long)dataSizeInDir:(NSString *)directory {
    
    if (!directory) {
        return 0;
    }
    
    BOOL isDir = NO;
    unsigned long long total = 0;
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:directory isDirectory:&isDir]) {
        if (isDir) {
            NSError *error = nil;
            NSArray *array = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:directory error:&error];
            if (!error) {
                for (NSString *subFile in array) {
                    NSString *filePath = [directory stringByAppendingPathComponent:subFile];
                    NSDictionary *attributes = [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:&error];
                    
                    if (!error) {
                        total += [attributes[NSFileSize] unsignedIntegerValue];
                    }
                }
            }
        }
    }
    
    return total;
}

+ (void)clearDataIinDir:(NSString *)directory {
    if (directory) {
        if ([[NSFileManager defaultManager] fileExistsAtPath:directory isDirectory:nil]) {
            NSError *error = nil;
            [[NSFileManager defaultManager] removeItemAtPath:directory error:&error];
            if (error) {
                NSLog(@"清理缓存是出现错误：%@",error.localizedDescription);
            }
        }
    }
}


@end
