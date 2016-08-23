//
//  DetailViewModel.m
//  CoolRun
//
//  Created by 蔡欣东 on 2016/8/16.
//  Copyright © 2016年 蔡欣东. All rights reserved.
//

#import "DetailViewModel.h"
#import "ResultViewModel.h"

@implementation DetailViewModel

- (instancetype)initWithRunDatas:(NSArray *)runDatas {
    if (self = [super init]) {
        NSMutableArray *mutlArray = [NSMutableArray array];
        [runDatas enumerateObjectsUsingBlock:^(Run *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            ResultViewModel *viewModel = [[ResultViewModel alloc] initWithRunModel:obj];
            [mutlArray addObject:viewModel];
        }];
        _recordViewModels = [mutlArray copy];
    }
    return self;
}

@end
