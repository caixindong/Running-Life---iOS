//
//  ResultViewController.h
//  CoolRun
//
//  Created by 蔡欣东 on 16/5/6.
//  Copyright © 2016年 蔡欣东. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Run.h"


@class ResultViewModel;
/**
 *  跑步结果界面
 */
@interface ResultViewController : UIViewController

/**
 *  跑步记录
 */
@property (strong, nonatomic) Run *run;


@property (nonatomic, strong, readwrite)ResultViewModel *viewModel;

@end
