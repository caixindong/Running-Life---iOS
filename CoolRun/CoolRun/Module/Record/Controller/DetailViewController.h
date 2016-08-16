//
//  DetailViewController.h
//  CoolRun
//
//  Created by 蔡欣东 on 16/5/17.
//  Copyright © 2016年 蔡欣东. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailViewModel.h"

/**
 *  跑步记录详情页
 */
@interface DetailViewController : UIViewController

@property (nonatomic, readwrite, strong)DetailViewModel *viewModel;

@end
