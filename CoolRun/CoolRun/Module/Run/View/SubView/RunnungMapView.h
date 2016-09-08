//
//  RunnungMapView.h
//  CoolRun
//
//  Created by 蔡欣东 on 2016/9/8.
//  Copyright © 2016年 蔡欣东. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RunningMapViewModel;

@interface RunnungMapView : UIView

@property (nonatomic, strong, readwrite)RunningMapViewModel *viewModel;

/**
 *  显示地图
 */
- (void)showMapView;

@end
