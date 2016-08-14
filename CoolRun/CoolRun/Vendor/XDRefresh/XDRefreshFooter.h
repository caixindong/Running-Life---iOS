//
//  XDRefreshFooter.h
//  XDRefresh
//
//  Created by 蔡欣东 on 2016/7/27.
//  Copyright © 2016年 蔡欣东. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void(^XDRefreshingBlock)();

@interface XDRefreshFooter : NSObject

/**
 *  绑定滚动视图
 *
 *  @param scrollView 滚动视图
 *  @param block      刷新回调
 */
+ (XDRefreshFooter *)footerOfScrollView:(UIScrollView *)scrollView
                        refreshingBlock:(XDRefreshingBlock)block;

/**
 *  开始刷新
 */
- (void)beginRefreshing;

/**
 *  结束刷新
 */
- (void)endRefreshing;

/**
 *  无数据停止刷新
 */
- (void)endRefreshingWithNoMoreDataWithTitle:(NSString *)title;

/**
 *  重设无数据状态
 */
- (void)resetNoMoreData;


@end
