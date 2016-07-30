//
//  RankingUserModel.h
//  CoolRun
//
//  Created by 蔡欣东 on 16/6/4.
//  Copyright © 2016年 蔡欣东. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RankingUserModel : NSObject

@property (nonatomic, copy) NSString *sum;

@property (nonatomic, copy) NSString *username;

- (NSArray *)convertFromDictionary: (NSDictionary *)dict;

@end
