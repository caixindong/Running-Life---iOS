//
//  LoginViewController.m
//  CoolRun
//
//  Created by 蔡欣东 on 16/5/24.
//  Copyright © 2016年 蔡欣东. All rights reserved.
//

#import "LoginViewController.h"
#import "LoginViewModel.h"
@interface LoginViewController ()<UITextFieldDelegate>

@property (weak, nonatomic, readwrite) IBOutlet UITextField *password;

@property (weak, nonatomic, readwrite) IBOutlet UITextField *username;

@property(nonatomic, strong, readwrite) LoginViewModel* viewModel;

@property(nonatomic,strong, readwrite) MBProgressHUD* HUD;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self KVOHandler];
    
    [self addTapGesture];
}

#pragma mark - private

- (void)KVOHandler {
    [self.KVOController observe:self.viewModel keyPath:@"invalid" options:NSKeyValueObservingOptionNew block:^(id observer, id object, NSDictionary *change) {
        if ([self.viewModel.invalid boolValue]) {
            [_HUD hideAnimated:YES];
            [Utils showTextHUDWithText:self.viewModel.invalidMsg addToView:self.view];
        }
    }];
    
    [self.KVOController observe:self.viewModel keyPath:@"netFail" options:NSKeyValueObservingOptionNew block:^(id observer, id object, NSDictionary *change) {
        if ([self.viewModel.netFail boolValue]) {
            [_HUD hideAnimated:YES];
            [Utils showTextHUDWithText:@"请检查网络" addToView:self.view];

        }
    }];
    
    [self.KVOController observe:self.viewModel keyPath:@"loginSuccessOrFail" options:NSKeyValueObservingOptionNew block:^(id observer, id object, NSDictionary *change) {
        if ([self.viewModel.loginSuccessOrFail boolValue]) {
            [_HUD hideAnimated:YES];
            [self dismissViewControllerAnimated:YES completion:nil];
        }else {
            [_HUD hideAnimated:YES];
            [Utils showTextHUDWithText:@"密码错误" addToView:self.view];
        }
    }];
}

- (void)addTapGesture {
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchView:)];
    [self.view addGestureRecognizer:tap];
}

#pragma mark - UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    self.viewModel.username = _username.text;
    self.viewModel.password = _password.text;
    
     _HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [self.viewModel login];
    
    [_password resignFirstResponder];
   
    return YES;
}

#pragma mark - event
- (void)touchView:(UITapGestureRecognizer*)re{
    [_username resignFirstResponder];
    [_password resignFirstResponder];
}

- (IBAction)closeBtnClick:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - getter and setter
- (LoginViewModel *)viewModel{
    if (!_viewModel) {
        _viewModel = [[LoginViewModel alloc]init];
    }
    return _viewModel;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
