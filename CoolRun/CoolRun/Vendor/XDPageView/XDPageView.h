//
//  XDPageView.h
//  XDPageView
//
//  Created by 蔡欣东 on 2016/8/23.
//  Copyright © 2016年 蔡欣东. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XDPageView : UIView

@property (nonatomic, assign, readwrite) NSInteger currentPageIndex;

@property (nonatomic, copy, readwrite) UIView *(^loadViewAtIndexBlock)(NSInteger pageIndex,UIView *dequeueView);

@property (nonatomic, copy, readwrite) NSInteger(^pagesCount)();


@end
