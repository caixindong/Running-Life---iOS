//
//  RunningBoardView.h
//  CoolRun
//
//  Created by 蔡欣东 on 2016/9/5.
//  Copyright © 2016年 蔡欣东. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RunningBoardViewModel;

@interface RunningBoardView : UIView

@property(nonatomic, assign, readwrite)BOOL readyRunning;

- (void)configureViewWithViewModel:(RunningBoardViewModel *)viewModel;

@end
