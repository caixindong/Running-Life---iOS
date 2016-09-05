//
//  NewRunViewModel.h
//  CoolRun
//
//  Created by 蔡欣东 on 2016/9/5.
//  Copyright © 2016年 蔡欣东. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RunningBoardViewModel;

@class ResultViewModel;

@interface NewRunViewModel : NSObject

/**
 *  跑步持续时间
 */
@property (nonatomic, assign , readwrite)int duration;

/**
 *  跑步数据是否改变
 */
@property (nonatomic, strong, readonly)NSNumber *runDataChange;

/**
 *  当前的跑步数据
 */
@property (nonatomic, strong, readonly)RunningBoardViewModel *currentRunData;

/**
 *  是否在跑步中
 */
@property (nonatomic, strong, readonly)NSNumber *isRunning;

/**
 *  这次跑步是否有效
 */
@property (nonatomic, strong, readonly)NSNumber *isValid;

/**
 *  跑步结果viewModel
 */
@property (nonatomic, strong, readonly)ResultViewModel *resultViewModel;

/**
 *  开始跑步
 */
- (void)beginRunning;

/**
 *  暂停跑步
 */
- (void)pauseRunning;

/**
 *  继续跑步
 */
- (void)resumeRunning;

/**
 *  结束跑步
 */
- (void)stopRunning;

@end
