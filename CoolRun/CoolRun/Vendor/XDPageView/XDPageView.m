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
 *  可见视图以及下标
 */
@property (nonatomic, strong) NSMutableDictionary *visibleViewsItemMap;

/**
 *  存储可复用的视图
 */
@property (nonatomic, strong) NSMutableSet *dequeueViewPool;

@property (nonatomic, strong) UIScrollView *scrollView;

/**
 *  是否响应scrollview的回调
 */
@property (nonatomic, assign) BOOL responseScrollEvent;

@property (nonatomic, assign) CGSize pageSize;

@property (nonatomic, assign) NSInteger numberOfPages;

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
    if (self.pagesCount) _numberOfPages = self.pagesCount();
    if (_numberOfPages > 0 && self.loadViewAtIndexBlock(0,[self dequeueViewFromPool])){
        UIView *view = self.loadViewAtIndexBlock(0,[self dequeueViewFromPool]);
        _pageSize = view.bounds.size;
    }
}

/**
 *  更新scrollview的frame和contensize
 */
- (void)updateScrollFrameAndContentsize {
    self.scrollView.frame = self.frame;
    self.scrollView.contentSize = CGSizeMake(_pageSize.width * _numberOfPages, 0);
}


#pragma mark - load item view,主要逻辑


- (void)loadViewsForNeed {
    CGFloat itemW = _pageSize.width;
    if (itemW) {
        CGFloat W = self.bounds.size.width;
        NSInteger startIndex = floorf((float)_scrollView.contentOffset.x / _pageSize.width);
        NSInteger numberOfVisibleItems = (_scrollView.contentOffset.x/W) == 0.0 ? 1 : 2;
        numberOfVisibleItems = MIN(numberOfVisibleItems, _numberOfPages);
        NSMutableSet *visibleIndexs = [NSMutableSet set];
        for (int i = 0; i < numberOfVisibleItems; i++) {
            NSInteger index = startIndex + i;
            [visibleIndexs addObject:@(index)];
        }
        
        for (NSNumber *num in [_visibleViewsItemMap allKeys]) {
            if (![visibleIndexs containsObject:num]) {
                UIView *view = _visibleViewsItemMap[num];
                [self queueInPoolWithView:view];
                [view removeFromSuperview];
                [_visibleViewsItemMap removeObjectForKey:num];
            }
        }
        
        for (NSNumber *num in visibleIndexs) {
            UIView *view = _visibleViewsItemMap[num];
            if (view == nil) {
                [self loadItemViewAtIndex:[num integerValue]];
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
    if (index >= 0 && index < _numberOfPages) {
        UIView *view = self.loadViewAtIndexBlock(index,[self dequeueViewFromPool]);
        if (view == nil) view = [[UIView alloc] init];
        [self setVisibleView:view atIndex:index];
        [self setFrameForView:view atIndex:index];
        [_scrollView addSubview:view];
        return view;
    }
    return nil;
}

/**
 *  设置item view的frame
 *
 *  @param view  子view
 *  @param index 下标
 */
- (void)setFrameForView:(UIView *)view atIndex:(NSInteger)index{
    CGPoint center = view.center;
    center.x = (index + 0.5f) * _pageSize.width;
    view.center = center;
}


#pragma mark - 可视

- (UIView *)visibleViewAtIndex:(NSInteger)index {
    return _visibleViewsItemMap[@(index)];
}

- (NSInteger)indexOfVisibleView:(UIView *)view {
    NSInteger index = [[_visibleViewsItemMap allValues] indexOfObject:view];
    if (index != NSNotFound) {
        return [[_visibleViewsItemMap allKeys][index] integerValue];
    }
    return NSNotFound;
}

- (void)setVisibleView:(UIView *)view atIndex:(NSInteger)index {
    _visibleViewsItemMap[@(index)] = view;
}

- (NSArray *)visibleViews {
    NSArray *indexs = [[_visibleViewsItemMap allKeys] sortedArrayUsingSelector:@selector(compare:)];
    return [_visibleViewsItemMap objectsForKeys:indexs notFoundMarker:[NSNull null]];
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
