//
//  XDBaseViewController.m
//  CoolRun
//
//  Created by 蔡欣东 on 2016/9/5.
//  Copyright © 2016年 蔡欣东. All rights reserved.
//

#import "XDBaseViewController.h"

@interface XDBaseViewController ()

@end

@implementation XDBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self KVOHandler];
    
    [self configureView];

}

- (void)KVOHandler{};

- (void)configureView{};

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}



@end
