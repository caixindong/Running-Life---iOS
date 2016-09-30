//
//  XDPageView.m
//  XDPageView
//
//  Created by 蔡欣东 on 2016/8/23.
//  Copyright © 2016年 蔡欣东. All rights reserved.
//

#import "XDPageView.h"

@interface XDPageView()<UIScrollViewDelegate>

/**
 *  可见视图以及下标，可见视图最大数量为2
 */
@property (nonatomic, strong, readwrite) NSMutableDictionary *visibleViewsItemMap;

/**
 *  容量最大为1的复用池
 */
@property (nonatomic, strong, readwrite) NSMutableSet *dequeueViewPool;

@property (nonatomic, strong, readwrite) UIScrollView *scrollView;

@property (nonatomic, assign, readwrite) CGSize pageSize;

@property (nonatomic, assign, readwrite) NSInteger pageCount;

@end


@implementation XDPageView


- (instancetype)init {
    if (self = [super init]) {
        [self initStatus];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initStatus];
    }
    return self;
}


#pragma mark - initStatsu

- (void)initStatus {
    self.visibleViewsItemMap = [NSMutableDictionary dictionary];
    
    self.dequeueViewPool = [NSMutableSet set];
    
    [self addSubview:self.scrollView];
}

#pragma mark - layout

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self updateCountAndPageSize];
    
    [self updateScrollFrameAndContentsize];
    
    [self loadViewsForNeed];
}

#pragma mark - update

/**
 *  更新数据个数和item size
 */
- (void)updateCountAndPageSize {
    if (self.pagesCount) _pageCount = self.pagesCount();
    
    if (_pageCount > 0 && self.loadViewAtIndexBlock(0,[self dequeueViewFromPool])){
        UIView *view = self.loadViewAtIndexBlock(0,[self dequeueViewFromPool]);
        _pageSize = view.bounds.size;
    }
}

/**
 *  更新scrollview的frame和contensize
 */
- (void)updateScrollFrameAndContentsize {
    self.scrollView.frame = self.frame;
    self.scrollView.contentSize = CGSizeMake(_pageSize.width * _pageCount, 0);
}


#pragma mark - load item view,主要逻辑

- (void)loadViewsForNeed {
    CGFloat itemW = _pageSize.width;
    if (itemW) {
        CGFloat W = self.bounds.size.width;
        //当前页的下标
        //如果参数是小数，则求最大的整数但不大于本身.
        NSInteger startIndex = floorf((float)_scrollView.contentOffset.x / _pageSize.width);

        //如果page数大于1则设置可见item数为2，如果只有一页，那么可见就只有1个
        NSInteger numberOfVisibleItems = (_scrollView.contentOffset.x/W) == 0.0 ? 1 : 2;
        numberOfVisibleItems = MIN(numberOfVisibleItems, _pageCount);
        
        //当前页和它的下一页设置为可见的
        NSMutableSet *visibleIndexs = [NSMutableSet set];
        for (int i = 0; i < numberOfVisibleItems; i++) {
            NSInteger index = startIndex + i;
            [visibleIndexs addObject:@(index)];
        }
        
        for (NSNumber *num in [_visibleViewsItemMap allKeys]) {
            if (![visibleIndexs containsObject:num]) {
                //移出可见视图加入复用池
                UIView *view = _visibleViewsItemMap[num];
                [self queueInPoolWithView:view];
                [view removeFromSuperview];
                [_visibleViewsItemMap removeObjectForKey:num];
            }
        }
        
        for (NSNumber *num in visibleIndexs) {
            UIView *view = _visibleViewsItemMap[num];
            //加载新的可见视图，加载完成后加入可视图容器中
            if (view == nil) {
                view = [self loadItemViewAtIndex:[num integerValue]];
                
                _visibleViewsItemMap[num] = view;
                
                [_scrollView addSubview:view];
            }
        }
    }
}

/**
 *  加载视图
 *
 *  @param index
 */
- (UIView *)loadItemViewAtIndex:(NSInteger)index {
    if (index >= 0 && index < _pageCount) {
        
        UIView *view = self.loadViewAtIndexBlock(index,[self dequeueViewFromPool]);
        
        if (view == nil) view = [[UIView alloc] init];
        
        CGPoint center = view.center;
        
        center.x = (index + 0.5f) * _pageSize.width;
        
        view.center = center;
        
        return view;
    }
    return nil;
}

#pragma mark  - 复用池

/**
 *  加入复用池
 *
 *  @param view
 */
- (void)queueInPoolWithView:(UIView *)view {
    if (view)[_dequeueViewPool addObject:view];
}

/**
 *  移除复用池
 *
 *  @return
 */
- (UIView *)dequeueViewFromPool {
    UIView *view = [_dequeueViewPool anyObject];
    if(view) [_dequeueViewPool removeObject:view];
    return view;
}


#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self loadViewsForNeed];
    self.currentPageIndex =  roundf((float)_scrollView.contentOffset.x / _pageSize.width);
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self loadViewsForNeed];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        [self loadViewsForNeed];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self loadViewsForNeed];
}

#pragma mark - getter and setter

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.frame = self.frame;
        _scrollView.delegate = self;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.pagingEnabled = YES;
    }
    return _scrollView;
}

- (NSInteger)currentPageIndex {
    return roundf((float)_scrollView.contentOffset.x / _pageSize.width);
}


@end
