//
//  NameEditViewController.m
//  CoolRun
//
//  Created by 蔡欣东 on 16/5/26.
//  Copyright © 2016年 蔡欣东. All rights reserved.
//

#import "NameEditViewController.h"
#import "UserSettingViewModel.h"
@interface NameEditViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;

@property(nonatomic,strong)UserSettingViewModel* viewModel;

@property(nonatomic,strong)MBProgressHUD* hud;

@end

@implementation NameEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _nameTextField.text = self.viewModel.realnameLabelText;
    
    [self KVOHandler];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)KVOHandler {
    [self.KVOController observe:self.viewModel keyPath:@"invalid" options:NSKeyValueObservingOptionNew block:^(id observer, id object, NSDictionary *change) {
        [_hud hideAnimated:YES];
        [Utils showTextHUDWithText:@"名字不能为空" addToView:self.view];
    }];
    
    [self.KVOController observe:self.viewModel keyPath:@"updateSuccessOrFail" options:NSKeyValueObservingOptionNew block:^(id observer, id object, NSDictionary *change) {
        [_hud hideAnimated:YES];
        if ([self.viewModel.updateSuccessOrFail boolValue]) {
            [Utils showTextHUDWithText:@"修改成功" addToView:self.view];
        }else {
            [Utils showTextHUDWithText:@"修改失败" addToView:self.view];
        }
    }];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    self.viewModel.realnameLabelText = _nameTextField.text;
    
     _hud  = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [self.viewModel updateUserInfo];
    
    [_nameTextField resignFirstResponder];
    
    return YES;
}

#pragma mark - event

- (IBAction)closeBtnClick:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - setter and getter

- (UserSettingViewModel *)viewModel{
    if (!_viewModel) {
        _viewModel = [[UserSettingViewModel alloc]init];
    }
    return _viewModel;
}
@end
