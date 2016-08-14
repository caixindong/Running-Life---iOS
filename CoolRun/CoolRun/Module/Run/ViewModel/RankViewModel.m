//
//  RankViewModel.m
//  CoolRun
//
//  Created by 蔡欣东 on 16/6/4.
//  Copyright © 2016年 蔡欣东. All rights reserved.
//

#import "RankViewModel.h"
#import "RankingUserModel.h"


@interface RankViewModel()

@property(nonatomic, strong ,readwrite) NSMutableArray *mutaDataArray;

@property (nonatomic, strong ,readwrite) NSNumber *haveRefresh;

@property (nonatomic, strong, readwrite) NSNumber *fail;

@property(nonatomic, assign)int page;

@end

@implementation RankViewModel

- (instancetype)init{
    if (self = [super init]) {
        _page = 1;
        
        _mutaDataArray = [NSMutableArray array];
        
        _haveRefresh = @NO;
    }
    
    return self;
}

- (void)getRankDataWithDate:(NSString *)date
                   withPage:(int)page{
    NSString *userID = [[NSUserDefaults standardUserDefaults] valueForKey:UID];
    NSString *token = [[NSUserDefaults standardUserDefaults] valueForKey:TOKEN];
    if (userID && token && date) {
        NSDictionary *params = @{@"token" : token,
                                 @"id" : userID,
                                 @"time" : date,
                                 @"page" : [NSString stringWithFormat:@"%d",page],
                                 @"interval" : @"5"};
        [XDNetworking postWithUrl: API_GET_MONTH_RANKING refreshRequest:YES cache:NO params:params progressBlock:nil successBlock:^(id response) {
            NSArray *data = [self dataArrayFromDictionary:response];
            
            [_mutaDataArray addObjectsFromArray:data];
            self.haveRefresh = @YES;
        } failBlock:^(NSError *error) {
            self.fail = @YES;
        }];
    }
}

- (void)getRankDataWithDate:(NSString *)date{
    [_mutaDataArray removeAllObjects];
    
    _page = 1;
    
    [self getRankDataWithDate:date
                     withPage:_page];
}

- (void)getMoreRankDataWithDate:(NSString *)date{
    _page = _page + 1;
    
    [self getRankDataWithDate:date
                     withPage:_page];
}

- (NSArray *)dataArrayFromDictionary:(NSDictionary *)dict{
    RankingUserModel *model = [[RankingUserModel alloc] init];
    
    NSArray *data = [model convertFromDictionary:dict];
    
    return data;
}

-(NSArray *)dataArray{
    
    return [_mutaDataArray copy];
    
}

@end
