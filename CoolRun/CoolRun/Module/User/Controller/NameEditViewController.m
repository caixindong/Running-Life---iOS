//
//  NameEditViewController.m
//  CoolRun
//
//  Created by 蔡欣东 on 16/5/26.
//  Copyright © 2016年 蔡欣东. All rights reserved.
//

#import "NameEditViewController.h"

@interface NameEditViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;

@property(nonatomic,strong) MBProgressHUD* hud;

@end

@implementation NameEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _viewModel.userModel        = [UserStatusManager shareManager].userModel;
    
    _nameTextField.text         = self.viewModel.realnameLabelText;
    
    [self KVOHandler];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark - private

- (void)KVOHandler {
    [self.KVOController observe:_viewModel keyPath:@"invalid" options:NSKeyValueObservingOptionNew block:^(id observer, id object, NSDictionary *change) {
        [_hud hideAnimated:YES];
        [Utils showTextHUDWithText:@"名字不能为空" addToView:self.view];
    }];
    
    [self.KVOController observe:_viewModel keyPath:@"updateSuccessOrFail" options:NSKeyValueObservingOptionNew block:^(id observer, id object, NSDictionary *change) {
        [_hud hideAnimated:YES];
        if ([_viewModel.updateSuccessOrFail boolValue]) {
            [Utils showTextHUDWithText:@"修改成功" addToView:self.view];
        }else {
            [Utils showTextHUDWithText:@"修改失败" addToView:self.view];
        }
    }];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    _hud  = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    _viewModel.realnameLabelText = _nameTextField.text;
    
    [_viewModel updateUserInfo];
    
    [_nameTextField resignFirstResponder];
    
    return ![_viewModel.invalid boolValue];
}

#pragma mark - event

- (IBAction)closeBtnClick:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
