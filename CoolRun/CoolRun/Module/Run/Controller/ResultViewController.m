//
//  ResultViewController.m
//  CoolRun
//
//  Created by 蔡欣东 on 16/5/6.
//  Copyright © 2016年 蔡欣东. All rights reserved.
//
#import "ResultViewController.h"
#import "Run.h"
#import "Location.h"
#import "MultiColorPolyline.h"
#import "ResultViewModel.h"
#import "RecordManager.h"
#import "UserModel.h"

@interface ResultViewController ()<MKMapViewDelegate>

@property (nonatomic, weak) IBOutlet MKMapView* mapView;

@property (nonatomic, weak) IBOutlet UILabel* distanceLabel;

@property (nonatomic, weak) IBOutlet UILabel* timeLabel;

@property (nonatomic, weak) IBOutlet UILabel *paceLabel;

@property (weak, nonatomic) IBOutlet UIView *navView;

@property (weak, nonatomic) IBOutlet UILabel *kllLable;

@property (weak, nonatomic) IBOutlet UILabel *rankLabel;

@property (weak, nonatomic) IBOutlet UILabel *countLabel;

@property (weak, nonatomic) IBOutlet UIImageView *headPic;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

@property (nonatomic,strong)ResultViewModel* viewModel;

@end

@implementation ResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self KVOHandler];
    
    [self configureView];

}

#pragma mark - private

- (void)KVOHandler {
    UserStatusManager *manager = [UserStatusManager shareManager];
    [self.KVOController observe:manager keyPath:@"isLogin"  options:NSKeyValueObservingOptionNew   block:^(id observer, id object, NSDictionary *change) {
        NSLog(@"%@",change);
        if (manager.isLogin.boolValue) {
            
            [self.headPic sd_setImageWithURL:[NSURL URLWithString:manager.userModel.avatar] placeholderImage:[UIImage imageNamed:@"defaultHeadPic.png"]];
            
            self.nameLabel.text = manager.userModel.realname;
            
            _loginBtn.enabled = NO;
            
            [self getRank];
        } else {
            
            [self.headPic setImage:[UIImage imageNamed:@"defaultHeadPic.png"]];
            
            self.nameLabel.text = @"未登录";
            
            _loginBtn.enabled = YES;
        }
    }];
    
    //manager.isLogin = @YES;
    
    [self.KVOController observe:self.viewModel keyPath:@"rank" options:NSKeyValueObservingOptionNew block:^(id observer, id object, NSDictionary *change) {
        if (self.viewModel.rank) {
            _rankLabel.text = self.viewModel.rank;
            
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        }
    }];
    
    [self.KVOController observe:self.viewModel keyPath:@"netFail" options:NSKeyValueObservingOptionNew  block:^(id observer, id object, NSDictionary *change) {
        if ([self.viewModel.netFail boolValue]) {
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        }
    }];
}

- (void)getRank {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
        if (self.hideNav) {
            [self.viewModel getRank];
        }else{
            [self.viewModel postRunRecordToServerAndGetRank];
        }
}

-(void)configureView {
    if (self.hideNav) {
        self.navView.hidden = self.hideNav;
    }else{
        self.navView.hidden = NO;
        
    }
    
    self.distanceLabel.text = self.viewModel.distanceLabelText;
    
    self.timeLabel.text     = self.viewModel.timeLabelText;
    
    self.paceLabel.text     = self.viewModel.paceLabelText;
    
    self.kllLable.text      = self.viewModel.kcalLableText;
    
    self.countLabel.text    = self.viewModel.countLabelText;
    
    [self loadMap];
}

- (void)loadMap {
    if (self.run.locations.count > 0) {
        
        self.mapView.hidden = NO;

        [self.mapView setRegion:self.viewModel.region];
        
        [self.mapView addOverlays:self.viewModel.colorSegmentArray];
        
    }
}


#pragma mark - MKMapViewDelegate
-(MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay{
    if ([overlay isKindOfClass:[MultiColorPolyline class]]) {
        MultiColorPolyline * polyLine = (MultiColorPolyline *)overlay;
        MKPolylineRenderer *aRenderer = [[MKPolylineRenderer alloc] initWithPolyline:polyLine];
        aRenderer.strokeColor = polyLine.color;
        aRenderer.lineWidth = 3;
        return aRenderer;
    }
    
    return nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - event response
- (IBAction)toHomeVC:(UIButton *)sender {
    [[[self presentingViewController] presentingViewController] dismissViewControllerAnimated:YES completion:nil];
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

- (IBAction)loginBtnClick:(UIButton *)sender {
    UIViewController *loginVC = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    [self presentViewController:loginVC
                       animated:YES
                     completion:nil];
}

#pragma mark - getter and setter

- (ResultViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[ResultViewModel alloc] initWithRunModel:self.run];
    }
    return _viewModel;
}

@end
