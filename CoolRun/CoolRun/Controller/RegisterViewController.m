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
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchView:)];
    [self.myScrollView addGestureRecognizer:tap];
    
}

-(void)touchView:(UITapGestureRecognizer*)re{
    [_myScrollView setContentOffset:CGPointMake(0, -50) animated:YES];
    _titleView.hidden = NO;
    [_name resignFirstResponder];
    [_username resignFirstResponder];
    [_password resignFirstResponder];
    [_againpwd resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    [_myScrollView setContentOffset:CGPointMake(0, 50) animated:YES];
    _titleView.hidden = YES;
}



-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    NSString* usernameText = _username.text;
    NSString* passwordText = _password.text;
    NSString* againPasswordText = _againpwd.text;
    NSString* realnameText = _name.text;
    
    if (textField==_username) {
        if (![[usernameText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]) {
            [_password becomeFirstResponder];
            return YES;
        }else{
            return NO;
        }
    }else if (textField==_password){
        if (![[passwordText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]) {
            [_againpwd becomeFirstResponder];
            return YES;
        }else{
            return NO;
        }
    }else if (textField==_againpwd){
        if (![[againPasswordText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]&&[[passwordText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:[againPasswordText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]]) {
            [_name becomeFirstResponder];
            return YES;
        }else{
            return NO;
        }
    }else{
        if ([[usernameText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]||[[passwordText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]||[[againPasswordText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]||[[realnameText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]||![[passwordText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:[againPasswordText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]]) {
            return NO;
        }else{
            _HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [_name resignFirstResponder];
            [self.viewModel PostUsername:usernameText password:passwordText realname:realnameText withSuccessBlock:^(id returnValue) {
                [_HUD hideAnimated:YES];
                 [[NSNotificationCenter defaultCenter]postNotificationName:ISLOGIN object:nil];
                [[[self presentingViewController]presentingViewController] dismissViewControllerAnimated:YES completion:nil];
            } failWithError:^(id errorCode) {
                [_HUD hideAnimated:YES];
                NSLog(@"%@",errorCode);
                [Utils showTextHUDWithText:[NSString stringWithFormat:@"%@",errorCode] addToView:self.view];
            } failWithNetworkWithBlock:^{
                [_HUD hideAnimated:YES];
                [Utils showTextHUDWithText:@"请检查网络" addToView:self.view];
            }];
            return YES;
        }
    }
}

- (IBAction)closeBtnClick:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(RegisterViewModel *)viewModel{
    if (!_viewModel) {
        _viewModel = [[RegisterViewModel alloc]init];
    }
    return _viewModel;
}
@end
