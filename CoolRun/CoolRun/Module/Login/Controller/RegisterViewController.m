//
//  RegisterViewController.m
//  CoolRun
//
//  Created by 蔡欣东 on 16/5/24.
//  Copyright © 2016年 蔡欣东. All rights reserved.
//

#import "RegisterViewController.h"
#import "RegisterViewModel.h"

@interface RegisterViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *titleView;

@property (weak, nonatomic) IBOutlet UIScrollView *myScrollView;

@property (weak, nonatomic) IBOutlet UITextField *username;

@property (weak, nonatomic) IBOutlet UITextField *password;

@property (weak, nonatomic) IBOutlet UITextField *againpwd;

@property (weak, nonatomic) IBOutlet UITextField *name;

@property(nonatomic,strong)RegisterViewModel* viewModel;

@property(nonatomic,strong)MBProgressHUD* HUD;

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addTapGesture];
    
    [self KVOHandler];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark - private

- (void)addTapGesture {
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchView:)];
    [self.myScrollView addGestureRecognizer:tap];
}

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
    
    [self.KVOController observe:self.viewModel keyPath:@"registerSuccessOrFail" options:NSKeyValueObservingOptionNew block:^(id observer, id object, NSDictionary *change) {
        if ([self.viewModel.registerSuccessOrFail boolValue]) {
            [_HUD hideAnimated:YES];
            [[[self presentingViewController]presentingViewController] dismissViewControllerAnimated:YES completion:nil];
        }else {
            [_HUD hideAnimated:YES];
            [Utils showTextHUDWithText:self.viewModel.invalidMsg addToView:self.view];
        }
    }];
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    [_myScrollView setContentOffset:CGPointMake(0, 50) animated:YES];
    _titleView.hidden = YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    self.viewModel.username         = _username.text;
    
    self.viewModel.password         = _password.text;
    
    self.viewModel.againPassword    = _againpwd.text;
    
    self.viewModel.realName         = _name.text;
    
    _HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [self.viewModel Register];
    
    return YES;
}

#pragma mark - event reponse

- (void)touchView:(UITapGestureRecognizer*)re{
    [_myScrollView setContentOffset:CGPointMake(0, -50) animated:YES];
    _titleView.hidden = NO;
    [_name resignFirstResponder];
    [_username resignFirstResponder];
    [_password resignFirstResponder];
    [_againpwd resignFirstResponder];
}

- (IBAction)closeBtnClick:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - getter and setter

- (RegisterViewModel *)viewModel{
    if (!_viewModel) {
        _viewModel = [[RegisterViewModel alloc]init];
    }
    return _viewModel;
}

@end
