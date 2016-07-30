//
//  UserModel.h
//  CoolRun
//
//  Created by 蔡欣东 on 16/5/29.
//  Copyright © 2016年 蔡欣东. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserModel : NSObject
@property(nonatomic,copy)NSString* uid;
@property(nonatomic,copy)NSString* username;
@property(nonatomic,copy)NSString* userpk;
@property(nonatomic,copy)NSString* realname;
@property(nonatomic,copy)NSString* avatar;
@property(nonatomic,copy)NSString* height;
@property(nonatomic,copy)NSString* weight;
@property(nonatomic,copy)NSString* sex;
@property(nonatomic,copy)NSString* birth;

-(instancetype)initWithDictionary:(NSDictionary*)dict;

@end
