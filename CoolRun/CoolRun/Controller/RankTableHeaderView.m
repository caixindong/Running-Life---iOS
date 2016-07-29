//
//  RankTableHeaderView.m
//  CoolRun
//
//  Created by 蔡欣东 on 16/5/31.
//  Copyright © 2016年 蔡欣东. All rights reserved.
//

#import "RankTableHeaderView.h"

@implementation RankTableHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

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
