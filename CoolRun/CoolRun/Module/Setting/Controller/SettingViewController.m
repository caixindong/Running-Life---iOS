//
//  SettingViewController.m
//  CoolRun
//
//  Created by 蔡欣东 on 16/5/26.
//  Copyright © 2016年 蔡欣东. All rights reserved.
//

#import "SettingViewController.h"
#import "SettingViewModel.h"
@interface SettingViewController ()
@property(nonatomic,strong)SettingViewModel *viewModel;
@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (IBAction)openDrawer:(UIButton *)sender {
    [[AppDelegate globalDelegate].UIProcess toggleLeftDrawer:self animated:YES];
    
}

- (IBAction)logout:(UIButton *)sender {
    UIAlertController* actionSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction* logoutBtn = [UIAlertAction actionWithTitle:@"退出" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.viewModel logout];
    }];
    UIAlertAction* cancleBtn = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [actionSheet addAction:logoutBtn];
    [actionSheet addAction:cancleBtn];
    
    [self presentViewController:actionSheet animated:YES completion:nil];
    
}

- (SettingViewModel *)viewModel{
    if (!_viewModel) {
        _viewModel = [[SettingViewModel alloc]init];
    }
    return _viewModel;
}

@end
