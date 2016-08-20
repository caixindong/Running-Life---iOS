//
//  Utils.h
//  CoolRun
//
//  Created by 蔡欣东 on 16/5/26.
//  Copyright © 2016年 蔡欣东. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utils : NSObject

/**
 *压缩图片
 **/
+ (UIImage*)imageWithImage:(UIImage*)image scaleToSize:(CGSize)newSize;

/**
 * 获取设备型号
 **/
+ (NSString*)getDeviceName;


+ (void)showTextHUDWithText:(NSString*)text addToView:(UIView*)view;

/**
 *  获取散列值
 *
 *  @param string 字符串
 *
 *  @return 散列值
 */
+ (NSString *)md5:(NSString *)string;

@end
