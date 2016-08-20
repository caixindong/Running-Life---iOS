//
//  HomeViewController.m
//  CoolRun
//
//  Created by 蔡欣东 on 16/5/6.
//  Copyright © 2016年 蔡欣东. All rights reserved.
//

#import "HomeViewController.h"
#import "HomeViewModel.h"


@interface HomeViewController ()

@property (weak, nonatomic) IBOutlet UIView *topBackView;

@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;

@property (weak, nonatomic) IBOutlet UILabel *countLabel;

@property (weak, nonatomic) IBOutlet UILabel *speedLabel;

@property (weak, nonatomic) IBOutlet UILabel *infoLabel;

@property (weak, nonatomic) IBOutlet UIView *rewardBgView;

@property (weak, nonatomic) IBOutlet UILabel *rankTimeLabel;

@property (weak, nonatomic) IBOutlet UILabel *rankLabel;

@property (weak, nonatomic) IBOutlet UIButton *drawerBtn;


@property (nonatomic, strong) HomeViewModel *viewModel;

/**
 *  定位管理器
 */
@property(nonatomic,strong)CLLocationManager* locationManager;


@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /**
     *  判断是否可以定位
     */
    if (!_locationManager) {
        _locationManager = [[CLLocationManager alloc] init];
        if ([_locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
            [_locationManager requestWhenInUseAuthorization];
            [_locationManager requestAlwaysAuthorization];
        }
    }
    
    self.rewardBgView.layer.borderColor = UIColorFromRGB(0xE8E9E8).CGColor;
    
    self.rewardBgView.layer.borderWidth = 1;
    
    [self KVOhandler];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    _distanceLabel.text = self.viewModel.distanceLabelText;
    
    _countLabel.text = self.viewModel.countLabelText;
    
    _speedLabel.text = self.viewModel.speedLabelText;
    
    _rankTimeLabel.text = self.viewModel.rankTimeLabelText;
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}


#pragma mark - private

- (void)KVOhandler {
    UserStatusManager *manager = [UserStatusManager shareManager];
    [self.KVOController observe:manager keyPath:@"isLogin" options:NSKeyValueObservingOptionNew block:^(id observer, id object, NSDictionary *change) {
        if ([manager.isLogin boolValue]) {
            [self.viewModel merge];
        }
    }];
    
    NSNumber *isLogin = manager.isLogin;
    
    manager.isLogin = isLogin;
}

#pragma mark - event reponse

/**
 *  打开抽屉
 *
 *  @param sender
 */
- (IBAction)openDrawer:(UIButton *)sender {
    [[AppDelegate globalDelegate].UIProcess toggleLeftDrawer:self animated:YES];
    
}

/**
 *  公里切换卡里路
 *
 *  @param sender
 */
- (IBAction)changeBtn:(UIButton *)sender {
    if ([_infoLabel.text isEqualToString:@"总公里"]) {
        _infoLabel.text = @"总卡路里";
        
        _distanceLabel.text = self.viewModel.kcalText;
        
    }else{
        _infoLabel.text = @"总公里";
        
        _distanceLabel.text = self.viewModel.distanceLabelText;
    }
}

/**
 *  显示排名视图
 *
 *  @param sender
 */
- (IBAction)showRankView:(UIButton *)sender {
    UserStatusManager* manager = [UserStatusManager shareManager];
    
    if (manager.isLogin.boolValue) {
        UIViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"RankViewController"];
        
        [self presentViewController:vc animated:YES completion:nil];
    }else{
        UIViewController* loginVC = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
        
        [self presentViewController:loginVC animated:YES completion:nil];
    }
    

}


#pragma mark - getter and setter

- (HomeViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[HomeViewModel alloc] init];
    }
    return _viewModel;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
