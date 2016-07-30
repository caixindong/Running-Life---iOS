//
//  ResultViewController.h
//  CoolRun
//
//  Created by 蔡欣东 on 16/5/6.
//  Copyright © 2016年 蔡欣东. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Run.h"

@interface ResultViewController : UIViewController
@property (strong, nonatomic) Run *run;
@property(nonatomic,assign)BOOL hideNav;
@end
