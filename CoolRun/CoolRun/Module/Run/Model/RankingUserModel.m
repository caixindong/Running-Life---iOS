//
//  RankingUserModel.m
//  CoolRun
//
//  Created by 蔡欣东 on 16/6/4.
//  Copyright © 2016年 蔡欣东. All rights reserved.
//

#import "RankingUserModel.h"

@implementation RankingUserModel

- (NSArray *)convertFromDictionary:(NSDictionary *)dict {
    NSMutableArray *dataArray = [NSMutableArray array];
    NSArray *rankArray = dict[@"ranking"];
    for (NSDictionary *rankDict in rankArray) {
        RankingUserModel *user= [[RankingUserModel alloc] init];
        user.sum = rankDict[@"sum"];
        user.username = rankDict[@"username"];
        [dataArray addObject:user];
    }
    return [dataArray copy];
}

@end
