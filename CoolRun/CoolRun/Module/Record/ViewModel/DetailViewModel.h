//
//  DetailViewModel.h
//  CoolRun
//
//  Created by 蔡欣东 on 2016/8/16.
//  Copyright © 2016年 蔡欣东. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DetailViewModel : NSObject

/**
 *  某一天全部的跑步数据
 */
@property(nonatomic, copy, readonly) NSArray* runDatas;

- (instancetype)initWithRunDatas:(NSArray *)runDatas;

@end
