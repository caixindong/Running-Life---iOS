//
//  ResultViewController.m
//  CoolRun
//
//  Created by 蔡欣东 on 16/5/6.
//  Copyright © 2016年 蔡欣东. All rights reserved.
//
#import "ResultViewController.h"
#import "ResultViewModel.h"
#import "RecordCardView.h"

@interface ResultViewController ()

@property (nonatomic, strong) RecordCardView *recordCardView;

@property (nonatomic, strong) UIImage *shareImage;

@end

@implementation ResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    self.KVOController = nil;
}

#pragma mark - private

- (void)KVOHandler {
    [self.KVOController observe:self.viewModel keyPath:@"rank" options:NSKeyValueObservingOptionNew block:^(id observer, id object, NSDictionary *change) {
        if (self.viewModel.rank) {
            self.recordCardView.rankLabel.text = self.viewModel.rank;
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                UIGraphicsBeginImageContext(self.recordCardView.frame.size);
                [self.recordCardView.layer renderInContext:UIGraphicsGetCurrentContext()];
                _shareImage = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            });
        }
    }];
    
    [self.KVOController observe:self.viewModel keyPath:@"netFail" options:NSKeyValueObservingOptionNew  block:^(id observer, id object, NSDictionary *change) {
        if ([self.viewModel.netFail boolValue]) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }
    }];
}

-(void)configureView {
    self.recordCardView.viewModel = self.viewModel;
    
    [self.view addSubview:self.recordCardView];
    
    UserStatusManager *manager = [UserStatusManager shareManager];
    if (manager.isLogin.boolValue) {
        [self.viewModel postRunRecordToServerAndGetRank];
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - event response
- (IBAction)toHomeVC:(UIButton *)sender {
    [[self navigationController] dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)shareBtnClick:(UIButton *)sender {
    UserStatusManager *manager = [UserStatusManager shareManager];
    if (manager.isLogin.boolValue) {
        [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeImage;
        
        
        if (![[UIApplication sharedApplication]canOpenURL:[NSURL URLWithString:@"weixin://app/wx9f58f3e0c08f1f2a/"]]) {
            [UMSocialSnsService presentSnsIconSheetView:self
                                                 appKey:nil
                                              shareText:@""
                                             shareImage:_shareImage
                                        shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,nil]
                                               delegate:nil];
        }else {
            [UMSocialSnsService presentSnsIconSheetView:self
                                                 appKey:nil
                                              shareText:@""
                                             shareImage:_shareImage
                                        shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToWechatSession,UMShareToWechatTimeline,nil]
                                               delegate:nil];
            
        }
    } else {
        UIViewController* loginVC = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
        
        [self presentViewController:loginVC animated:YES completion:nil];
    }
}

#pragma mark - getter and setter

- (RecordCardView *)recordCardView {
    if (!_recordCardView) {
        _recordCardView = [[RecordCardView alloc] init];
        _recordCardView.frame = CGRectMake(20, 84, WIDTH - 20 * 2, HEIGHT - 84 - 20);
    }
    return _recordCardView;
}

@end
