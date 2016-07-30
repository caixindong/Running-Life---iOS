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
@property(nonatomic,strong)UserModel* user;
@end

@implementation NameEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UserStatusManager *manager = [UserStatusManager shareManager];
    _user = manager.userModel;
    _nameTextField.text = _user.realname;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    NSString* name = [_nameTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([name isEqualToString:@""]) {
        return NO;
    }else{
        [_nameTextField resignFirstResponder];
        _user.realname = _nameTextField.text;
        _hud  = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [self.viewModel postUserSettingWithUserInfo:_user withSuccessBlock:^(id returnValue) {
            [_hud hideAnimated:YES];
            [[MyUserDefault shareUserDefault]storeValue:_user withKey:USER];
            [Utils showTextHUDWithText:@"修改成功" addToView:self.view];
            [self dismissViewControllerAnimated:YES completion:nil];
        } failWithError:^(id errorCode) {
            [_hud hideAnimated:YES];
            [Utils showTextHUDWithText:@"修改失败" addToView:self.view];
        } failWithNetworkWithBlock:^{
            [_hud hideAnimated:YES];
            [Utils showTextHUDWithText:@"请检查网络" addToView:self.view];
        }];
        return YES;
    }
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
