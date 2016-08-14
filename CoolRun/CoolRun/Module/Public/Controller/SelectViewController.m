//
//  SelectViewController.m
//  CoolRun
//
//  Created by 蔡欣东 on 16/5/9.
//  Copyright © 2016年 蔡欣东. All rights reserved.
//

#import "SelectViewController.h"
#import "UserModel.h"
#import "UserSettingViewController.h"

/**
 *  抽屉选择界面
 */
@interface SelectViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *headPic;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end

@implementation SelectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self initView];
    
    UserStatusManager* manager = [UserStatusManager shareManager];
    
    [self.KVOController observe:manager
                        keyPath:@"isLogin"
                        options:NSKeyValueObservingOptionNew
                          block:^(id observer, id object, NSDictionary *change) {
                              [self initView];
                          }];
    
    [self.KVOController observe:manager
                        keyPath:@"haveChangeInfo"
                        options:NSKeyValueObservingOptionNew
                          block:^(id observer, id object, NSDictionary *change) {
                              if (manager.haveChangeInfo.boolValue) {
                                  [self initView];
                              }
                          }];
    
}


-(void)initView{
    UserModel* user = (UserModel*)[[MyUserDefault shareUserDefault] valueWithKey:USER];
    if (user) {
        [_headPic sd_setImageWithURL:[NSURL URLWithString:user.avatar] placeholderImage:[UIImage imageNamed:@"defaultHeadPic.png"] options:SDWebImageRefreshCached];
        
        _nameLabel.text = user.realname;
        
    }else{
        [_headPic setImage:[UIImage imageNamed:@"defaultHeadPic.png"]];
        
        _nameLabel.text = @"未登录";
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (IBAction)loginOrSetting:(UIButton *)sender {
    UserStatusManager* manager = [UserStatusManager shareManager];
    if (manager.isLogin.boolValue) {
        UserSettingViewController* usvc = [self.storyboard instantiateViewControllerWithIdentifier:@"UserSettingViewController"];
        [self presentViewController:usvc animated:YES completion:nil];
    }else{
        UIViewController* loginVC = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
        [self presentViewController:loginVC animated:YES completion:nil];
    }
}


- (IBAction)selectBtn:(UIButton *)sender {
    switch (sender.tag) {
        case 1:{
            UIViewController* firstVC = [self.storyboard instantiateViewControllerWithIdentifier:@"HomeViewController"];
            [AppDelegate globalDelegate].UIProcess.drawController.centerViewController = firstVC;
            [[AppDelegate globalDelegate].UIProcess toggleLeftDrawer:self animated:YES];
            
        }
            break;
        case 2:{
            UIViewController* recordVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MyRecordViewController"];
            [AppDelegate globalDelegate].UIProcess.drawController.centerViewController = recordVC;
            [[AppDelegate globalDelegate].UIProcess toggleLeftDrawer:self animated:YES];
        }
            
            break;
        case 3:{
            UIViewController* settingVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SettingViewController"];
            UINavigationController* nav = [[UINavigationController alloc]initWithRootViewController:settingVC];
            [AppDelegate globalDelegate].UIProcess.drawController.centerViewController = nav;
            [[AppDelegate globalDelegate].UIProcess toggleLeftDrawer:self animated:YES];
        }
            
            break;
        default:
            break;
    }
}

@end
