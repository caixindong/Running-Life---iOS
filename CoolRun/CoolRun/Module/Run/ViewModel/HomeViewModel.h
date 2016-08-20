//
//  HomeViewModel.h
//  CoolRun
//
//  Created by 蔡欣东 on 2016/7/30.
//  Copyright © 2016年 蔡欣东. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HomeViewModel : NSObject

/**
 *  总距离
 */
@property (nonatomic, copy, readonly) NSString *distanceLabelText;

/**
 *  跑步次数
 */
@property (nonatomic, copy, readonly) NSString *countLabelText;

/**
 *  平均速度
 */
@property (nonatomic, copy, readonly) NSString *speedLabelText;

/**
 *  排名日期
 */
@property (nonatomic, copy, readonly) NSString *rankTimeLabelText;

/**
 *  总卡里路
 */
@property (nonatomic, copy, readonly) NSString *kcalText;


/**
 *  如果有临时数据则合并数据
 */
- (void)merge;

@end
