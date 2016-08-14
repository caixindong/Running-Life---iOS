//
//  XDRefreshHeader.h
//  XDRefresh
//
//  Created by 蔡欣东 on 2016/7/27.
//  Copyright © 2016年 蔡欣东. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void(^XDRefreshingBlock)();

@interface XDRefreshHeader : NSObject

/**
 *  刷新中文本
 */
@property (nonatomic, copy, readwrite) NSString *loadingText;

/**
 *  下拉刷新文本
 */
@property (nonatomic, copy, readwrite) NSString *pulldownText;

/**
 *  松开刷新文本
 */
@property (nonatomic, copy, readwrite) NSString *releaseText;

/**
 *  绑定滚动视图
 *
 *  @param scrollView 滚动视图
 *  @param block      刷新回调
 */
+ (XDRefreshHeader *)headerOfScrollView:(UIScrollView *)scrollView
                        refreshingBlock:(XDRefreshingBlock)block;

/**
 *  开始刷新
 */
- (void)beginRefreshing;

/**
 *  结束刷新
 */
- (void)endRefreshing;

@end
