//
//  ChangePwdViewController.m
//  CoolRun
//
//  Created by 蔡欣东 on 16/5/29.
//  Copyright © 2016年 蔡欣东. All rights reserved.
//

#import "ChangePwdViewController.h"
#import "SettingViewModel.h"
@interface ChangePwdViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *oldPwdTextfield;

@property (weak, nonatomic) IBOutlet UITextField *pwdTextfield;

@property(nonatomic,strong)SettingViewModel* viewModel;

@property(nonatomic,strong)MBProgressHUD* hud;

@end

@implementation ChangePwdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    NSString* oldPWD = _oldPwdTextfield.text;
    NSString* newPWD = _pwdTextfield.text;
    if (textField==_oldPwdTextfield) {
        if ([[oldPWD stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]) {
            return NO;
        }else{
            [_pwdTextfield becomeFirstResponder];
            return YES;
        }
    }else{
        if (![[oldPWD stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]&&![[newPWD stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]) {
            _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [self.viewModel PostOldPwd:oldPWD newPwd:newPWD withSuccessBlock:^(id returnValue) {
                [_hud hideAnimated:YES];
                [Utils showTextHUDWithText:@"修改成功" addToView:self.view];
                [self.navigationController popViewControllerAnimated:YES];
            } failWithError:^(id errorCode) {
                [_hud hideAnimated:YES];
                [Utils showTextHUDWithText:@"修改失败" addToView:self.view];
            } failWithNetworkWithBlock:^{
                [_hud hideAnimated:YES];
                 [Utils showTextHUDWithText:@"请检查网络" addToView:self.view];
            }];
            return YES;
        }else{
            return NO;
        }
    }
}
- (IBAction)backBtnClick:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - setter and getter

- (SettingViewModel *)viewModel{
    if (!_viewModel) {
        _viewModel = [[SettingViewModel alloc]init];
    }
    return _viewModel;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
