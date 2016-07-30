//
//  RankTableHeaderView.m
//  CoolRun
//
//  Created by 蔡欣东 on 16/5/31.
//  Copyright © 2016年 蔡欣东. All rights reserved.
//

#import "RankTableHeaderView.h"

@implementation RankTableHeaderView

-(instancetype)init{
    if (self = [super init]) {
        self = [[[NSBundle mainBundle]loadNibNamed:@"RankTableHeaderView" owner:self options:nil]firstObject];
    }
    return self;
}

+(CGFloat)heightOfRankTableHeaderView{
    return 140;
}

@end
