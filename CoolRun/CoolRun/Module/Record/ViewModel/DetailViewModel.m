//
//  DetailViewModel.m
//  CoolRun
//
//  Created by 蔡欣东 on 2016/8/16.
//  Copyright © 2016年 蔡欣东. All rights reserved.
//

#import "DetailViewModel.h"

@implementation DetailViewModel

- (instancetype)initWithRunDatas:(NSArray *)runDatas {
    if (self = [super init]) {
        _runDatas = runDatas;
    }
    return self;
}

@end
