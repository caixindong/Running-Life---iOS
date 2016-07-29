//
//  RankViewModel.h
//  CoolRun
//
//  Created by 蔡欣东 on 16/6/4.
//  Copyright © 2016年 蔡欣东. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RankViewModel : NSObject

@property (nonatomic, copy ,readonly)NSArray *dataArray;

@property (nonatomic, strong ,readonly)NSNumber *haveRefresh;

@property (nonatomic, strong, readonly)NSNumber *fail;

- (void)getRankDataWithDate:(NSString *)date;

- (void)getMoreRankDataWithDate:(NSString *)date;

@end
