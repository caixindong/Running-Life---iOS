//
//  XDMemoryCache.h
//  XDNetworking
//
//  Created by 蔡欣东 on 2016/7/25.
//  Copyright © 2016年 蔡欣东. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  到时可以拓展内存缓存策略
 */
@interface XDMemoryCache : NSObject

/**
 *  将数据写入内存
 *
 *  @param data 数据
 *  @param key  键值
 */
+ (void)writeData:(id) data forKey:(NSString *)key;

/**
 *  从内存中读取数据
 *
 *  @param key 键值
 *
 *  @return 数据
 */
+ (id)readDataWithKey:(NSString *)key;

@end
