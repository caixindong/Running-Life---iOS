//
//  ResultViewModel.h
//  CoolRun
//
//  Created by 蔡欣东 on 16/5/29.
//  Copyright © 2016年 蔡欣东. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Run.h"

@interface ResultViewModel : NSObject

/**
 *  跑步距离
 */
@property (nonatomic, copy, readonly) NSString *distanceLabelText;

/**
 *  跑步时间
 */
@property (nonatomic, copy, readonly) NSString *timeLabelText;

/**
 *  跑步步数
 */
@property (nonatomic, copy, readonly) NSString *paceLabelText;

/**
 *  卡路里
 */
@property (nonatomic, copy, readonly) NSString *kcalLableText;

/**
 *  消耗鸡腿数
 */
@property (nonatomic, copy, readonly) NSString *countLabelText;

/**
 *  运动轨迹（不同颜色）
 */
@property (nonatomic, copy, readonly) NSArray *colorSegmentArray;

/**
 *  地图显示区域
 */
@property (nonatomic, assign, readonly) MKCoordinateRegion region;

/**
 *  跑步排名
 */
@property (nonatomic, copy, readonly) NSString *rank;


/**
 *  网络失败
 */
@property (nonatomic, strong, readonly) NSNumber *netFail;

/**
 *  构造器
 *
 *  @param run 跑步记录
 *
 *  @return 
 */
- (instancetype)initWithRunModel:(Run *)run;

/**
 *  上传跑步记录并获取排名
 */
- (void)postRunRecordToServerAndGetRank;

/**
 *  仅仅获取获取跑步排名
 */
- (void)getRankData;


@end
