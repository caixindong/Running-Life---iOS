//
//  MyUserDefault.h
//  tuangou_iphone
//
//  Created by 蔡欣东 on 15/11/9.
//  Copyright © 2015年 蔡欣东. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyUserDefault : NSObject
+(MyUserDefault*)shareUserDefault;
-(void)storeValue:(id)value withKey:(NSString*)key;
-(id)valueWithKey:(NSString*)key;
-(void)removeObjectWithKey:(NSString*)key;
@end
