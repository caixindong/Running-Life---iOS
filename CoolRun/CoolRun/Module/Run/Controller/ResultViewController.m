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
            
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        }
    }];
    
    [self.KVOController observe:self.viewModel keyPath:@"netFail" options:NSKeyValueObservingOptionNew  block:^(id observer, id object, NSDictionary *change) {
        if ([self.viewModel.netFail boolValue]) {
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        }
    }];
}

-(void)configureView {
    self.recordCardView.viewModel = self.viewModel;
    
    [self.view addSubview:self.recordCardView];
    
    UserStatusManager *manager = [UserStatusManager shareManager];
    if (manager.isLogin.boolValue) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        [self.viewModel postRunRecordToServerAndGetRank];

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
    [UMSocialData defaultData].extConfig.wechatTimelineData.title = @"测试";
    [UMSocialData defaultData].extConfig.wechatSessionData.title = @"测试";
    [UMSocialData defaultData].extConfig.wechatSessionData.url = @"http://www.baidu.com";
    [UMSocialData defaultData].extConfig.wechatTimelineData.url = @"http://www.baidu.com";
    if (![[UIApplication sharedApplication]canOpenURL:[NSURL URLWithString:@"weixin://app/wx9f58f3e0c08f1f2a/"]]) {
        [UMSocialSnsService presentSnsIconSheetView:self
                                             appKey:nil
                                          shareText:@"测试"
                                         shareImage:nil
                                    shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,nil]
                                           delegate:nil];
    }else {
        [UMSocialSnsService presentSnsIconSheetView:self
                                             appKey:nil
                                          shareText:@"测试"
                                         shareImage:nil
                                    shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToWechatSession,UMShareToWechatTimeline,nil]
                                           delegate:nil];
        
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
