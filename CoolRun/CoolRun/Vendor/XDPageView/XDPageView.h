//
//  XDPageView.h
//  XDPageView
//
//  Created by 蔡欣东 on 2016/8/23.
//  Copyright © 2016年 蔡欣东. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XDPageView : UIView

/**
 *  当前页下标
 */
@property (nonatomic, assign, readwrite) NSInteger currentPageIndex;

/**
 *  自定义page视图，使用的时候判断是否有dequeueView，如果有就直接dequeueView，没有再实例化一个新视图，可以参考tableView cell 复用机制的使用
 */
@property (nonatomic, copy, readwrite) UIView *(^loadViewAtIndexBlock)(NSInteger pageIndex,UIView *dequeueView);

/**
 *  page的数量
 */
@property (nonatomic, copy, readwrite) NSInteger(^pagesCount)();


@end
