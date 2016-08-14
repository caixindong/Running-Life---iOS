//
//  XDRefreshHeader.m
//  XDRefresh
//
//  Created by 蔡欣东 on 2016/7/27.
//  Copyright © 2016年 蔡欣东. All rights reserved.
//

#import "XDRefreshHeader.h"

@interface XDRefreshHeader(){
    CGFloat     _lastPosition;
    CGFloat     _contentHeight;
    CGFloat     _headerHeight;
    BOOL        _isRefreshing;
}

/**
 *  头部视图
 */
@property (nonatomic, strong, readwrite) UIView *headerView;

/**
 *  状态文本
 */
@property (nonatomic, strong, readwrite) UILabel *statusLabel;

/**
 *  箭头
 */
@property (nonatomic, strong, readwrite) UIImageView *arrowView;

/**
 *  菊花视图
 */
@property (nonatomic, strong, readwrite) UIActivityIndicatorView *indicator;

/**
 *  刷新回调
 */
@property (nonatomic, copy, readwrite) XDRefreshingBlock refreshingBlock;

/**
 *  滚动视图
 */
@property(nonatomic, strong ,readwrite)UIScrollView *scrollView;

@end

@implementation XDRefreshHeader

- (instancetype)init {
    if ([super init]) {
        _loadingText    = @"加载中";
        _pulldownText   = @"下拉刷新";
        _releaseText    = @"松开刷新";
    }
    return self;
}

+ (XDRefreshHeader *)headerOfScrollView:(UIScrollView *)scrollView
                        refreshingBlock:(XDRefreshingBlock)block {
    XDRefreshHeader *header = [[XDRefreshHeader alloc] init];
    header.scrollView       = scrollView;
    header.refreshingBlock  = block;
    
    [header initHeader];
    
    return header;
}

- (void)initHeader {
    _isRefreshing = NO;
    _lastPosition = 0;
    _headerHeight = 35;
    
    CGFloat scrollViewW = _scrollView.frame.size.width;
    CGFloat arrowW  = 13;
    CGFloat arrowH  = _headerHeight;
    CGFloat labelw  = 130;
    CGFloat labelH  = _headerHeight;
    
    _headerView         = [[UIView alloc] init];
    _headerView.frame   = CGRectMake(0,-_headerHeight - 10, scrollViewW, _headerHeight);
    [_scrollView addSubview:_headerView];
    
    _statusLabel                = [[UILabel alloc] init];
    _statusLabel.frame          = CGRectMake((scrollViewW - labelw)/2, 0, labelw, labelH);
    _statusLabel.textAlignment  = NSTextAlignmentCenter;
    _statusLabel.font           = [UIFont systemFontOfSize:14];
    _statusLabel.textColor      = [UIColor blackColor];
    _statusLabel.text           = _pulldownText;
    [_headerView addSubview:_statusLabel];
    
    _arrowView                  = [[UIImageView alloc] init];
    _arrowView.frame            = CGRectMake((scrollViewW - labelw)/2-arrowW-10, 0, arrowW, arrowH);
    _arrowView.image            = [UIImage imageNamed:@"XDRefresh_arrow"];
    [_headerView addSubview:_arrowView];
    _arrowView.hidden           = YES;
    
    _indicator          = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _indicator.frame    = CGRectMake((scrollViewW-labelw)/2-arrowW, 0, arrowW, arrowH);
    [_headerView addSubview:_indicator];
    _indicator.hidden   = YES;
    
    [_scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
}

#pragma mark - kvo回调
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSString *,id> *)change
                       context:(void *)context {
    if ([keyPath isEqualToString:@"contentOffset"]) {
        _contentHeight = _scrollView.contentSize.height;
        
        if (_scrollView.isDragging) {
            CGFloat currentPosition = _scrollView.contentOffset.y;
            
            if (!_isRefreshing) {
                [UIView animateWithDuration:0.3f animations:^{
                    //下拉过程超过_headerHeight*1.5
                    if (currentPosition < -_headerHeight* 1.5 ) {
                        _statusLabel.text       = _releaseText;
                        _arrowView.transform    = CGAffineTransformMakeRotation(M_PI);
                    }else {
                        //上拉
                        if (currentPosition - _lastPosition > 5) {
                            _lastPosition = currentPosition;
                            _statusLabel.text = _pulldownText;
                            _arrowView.transform = CGAffineTransformMakeRotation(M_PI*2);
                            //下拉不超过_headerHeight*1.5
                        }else if(_lastPosition - currentPosition > 5) {
                            _lastPosition = currentPosition;
                        }
                    }
                }];
            }
            
        }else {
            //松开手时
            if ([_statusLabel.text isEqualToString:_releaseText]) {
                [self beginRefreshing];
            }
        }

    }
}

- (void)beginRefreshing {
    if (!_isRefreshing) {
        _isRefreshing = YES;
        
        _statusLabel.text   = _loadingText;
        _arrowView.hidden   = YES;
        _indicator.hidden   = NO;
        [_indicator startAnimating];
        
        [UIView animateWithDuration:0.3f animations:^{
            CGFloat currentPosition = _scrollView.contentOffset.y;
            if (currentPosition > -_headerHeight * 1.5) {
                _scrollView.contentOffset = CGPointMake(0, currentPosition - _headerHeight * 1.5);
            }
            _scrollView.contentInset = UIEdgeInsetsMake(_headerHeight * 1.5, 0, 0, 0);
        }];
        if (self.refreshingBlock) {
            self.refreshingBlock();
        }
    }
}


-(void)endRefreshing {
    _isRefreshing = NO;
    
    dispatch_async(dispatch_get_main_queue(), ^{
       [UIView animateWithDuration:0.3f animations:^{
           CGFloat currentPosition = _scrollView.contentOffset.y;
           if (currentPosition != 0) {
               _scrollView.contentOffset    = CGPointMake(0, currentPosition + _headerHeight * 1.5);
               _scrollView.contentInset     = UIEdgeInsetsMake(0, 0, 0, 0);
               
               _statusLabel.text = _pulldownText;
               
               _arrowView.hidden    = NO;
               _arrowView.transform = CGAffineTransformMakeRotation(M_PI*2);
               
               [_indicator stopAnimating];
               _indicator.hidden = YES;
           }
       }];
    });
}

- (void)dealloc {
    [_scrollView removeObserver:self forKeyPath:@"contentOffset"];
}

#pragma mark - setter

- (void)setLoadingText:(NSString *)loadingText {
    _loadingText        = loadingText;
    _statusLabel.text   = _loadingText;
}

- (void)setReleaseText:(NSString *)releaseText {
    _releaseText        = releaseText;
    _statusLabel.text   = _releaseText;
}

- (void)setPulldownText:(NSString *)pulldownText {
    _pulldownText       = pulldownText;
    _statusLabel.text   = _pulldownText;
}

@end
