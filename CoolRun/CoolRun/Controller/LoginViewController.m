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
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UITextField *username;
@property(nonatomic,strong)LoginViewModel* viewModel;
@property(nonatomic,strong)MBProgressHUD* HUD;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchView:)];
    [self.view addGestureRecognizer:tap];
}

#pragma mark - UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField==_username) {
        if (![[_username.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]) {
            [_password becomeFirstResponder];
            return YES;
        }else{
            return NO;
        }
    }else{
        if ([[_username.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]||[[_password.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]) {
            return NO;
        }else{
            [_password resignFirstResponder];
            _HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [self.viewModel postUserName:_username.text password:_password.text withSuccessBlock:^(id returnValue) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [_HUD hideAnimated:YES];
                    UserStatusManager *manager = [UserStatusManager shareManager];
                    manager.isLogin = @YES;
                    [self dismissViewControllerAnimated:YES completion:nil];
                });
            } failWithError:^(id errorCode) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [_HUD hideAnimated:YES];
                    [Utils showTextHUDWithText:@"密码错误" addToView:self.view];
                    NSLog(@"login error is %@",errorCode);
                });
            } failWithNetworkWithBlock:^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [_HUD hideAnimated:YES];
                    [Utils showTextHUDWithText:@"请检查网络" addToView:self.view];
                });
            }];
            return YES;
        }
    }
}

#pragma mark - event
-(void)touchView:(UITapGestureRecognizer*)re{
    [_username resignFirstResponder];
    [_password resignFirstResponder];
}

- (IBAction)closeBtnClick:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(LoginViewModel *)viewModel{
    if (!_viewModel) {
        _viewModel = [[LoginViewModel alloc]init];
    }
    return _viewModel;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
@end
