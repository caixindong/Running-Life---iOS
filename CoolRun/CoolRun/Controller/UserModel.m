//
//  UserModel.m
//  CoolRun
//
//  Created by 蔡欣东 on 16/5/29.
//  Copyright © 2016年 蔡欣东. All rights reserved.
//

#import "UserModel.h"

@implementation UserModel

-(instancetype)initWithDictionary:(NSDictionary *)dict{
    if (self = [super init]) {
        self.uid = dict[@"id"];
        self.username = dict[@"username"];
        self.realname = dict[@"realname"];
        self.height = dict[@"height"];
        self.weight = dict[@"weight"];
        self.sex = dict[@"sex"];
        self.birth = dict[@"birth"];
        self.avatar = dict[@"avatar"];
    }
    return self;
}

@end
