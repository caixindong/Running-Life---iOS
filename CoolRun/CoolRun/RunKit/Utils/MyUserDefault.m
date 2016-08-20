//
//  MyUserDefault.m
//  tuangou_iphone
//
//  Created by 蔡欣东 on 15/11/9.
//  Copyright © 2015年 蔡欣东. All rights reserved.
//

#import "MyUserDefault.h"
#import "FastCoder.h"
@implementation MyUserDefault
static MyUserDefault* myUserdefault = nil;

+(MyUserDefault *)shareUserDefault{
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        myUserdefault = (MyUserDefault*)@"MyUserDefault";
        myUserdefault = [[MyUserDefault alloc]init];
    });
    //防止子类继承调用
    //实例对象转化字符串
    NSString* className = NSStringFromClass([MyUserDefault class]);
    if (![className isEqualToString:@"MyUserDefault"]) {
        NSParameterAssert(nil);
    }
    return myUserdefault;
}
-(instancetype)init{
    NSString* string = (NSString*)myUserdefault;
    if ([string isKindOfClass:[NSString class]]&&[string isEqualToString:@"MyUserDefault"]) {
        if (self = [super init]) {
            
        }
        return self;
    }else{
        return nil;
    }
}
-(void)storeValue:(id)value withKey:(NSString *)key{
    NSParameterAssert(value);
    NSParameterAssert(key);
    NSData* data = [FastCoder dataWithRootObject:value];
    if (data) {
        [[NSUserDefaults standardUserDefaults]setObject:data forKey:key];
        [[NSUserDefaults standardUserDefaults]synchronize];
    }
}
-(id)valueWithKey:(NSString*)key{
    NSParameterAssert(key);
    NSData* data = [[NSUserDefaults standardUserDefaults]valueForKey:key];
    return [FastCoder objectWithData:data];
}

-(void)removeObjectWithKey:(NSString *)key{
    NSParameterAssert(key);
    id data = [[NSUserDefaults standardUserDefaults]valueForKey:key];
    if (data) {
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:key];
        [[NSUserDefaults standardUserDefaults]synchronize];
    }
   
}
@end
