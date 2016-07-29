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
@property (nonatomic,strong)ResultViewModel* viewModel;
@property (nonatomic,strong)RecordManager* manager;
@property (weak, nonatomic) IBOutlet UILabel *rankLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UIImageView *headPic;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (nonatomic, assign) float weight;
@end

@implementation ResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.hideNav) {
        self.navView.hidden = self.hideNav;
    }else{
        self.navView.hidden = NO;
       
    }
    
    self.weight = 65.0;
    
    UserStatusManager *manager = [UserStatusManager shareManager];
    
    [self.KVOController observe:manager
                        keyPath:@"isLogin"
                        options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld
                          block:^(id observer, id object, NSDictionary *change) {
                              NSLog(@"get");
                              if (manager.isLogin.boolValue) {
                                  [self.headPic sd_setImageWithURL:[NSURL URLWithString:manager.userModel.avatar] placeholderImage:[UIImage imageNamed:@"defaultHeadPic.png"]];
                                  self.nameLabel.text = manager.userModel.realname;
                                  self.weight = [manager.userModel.weight floatValue];
                                  _loginBtn.enabled = NO;
                                  [self getRank];
                              }else{
                                  [self.headPic setImage:[UIImage imageNamed:@"defaultHeadPic.png"]];
                                  self.nameLabel.text = @"未登录";
                                  self.weight = 65.0;
                                  _loginBtn.enabled = YES;
                              }
    }];
    
    manager.isLogin = manager.isLogin;
    
    [self configureView];

}

- (void)getRank {
        _viewModel = [[ResultViewModel alloc]init];
    
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        if (self.hideNav) {
            [_viewModel postRunIDToGetRank:[_run.runid intValue]
                          withSuccessBlock:^(id returnValue) {
                              [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                              _rankLabel.text = [NSString stringWithFormat:@"第%@名",returnValue];
         
                          } failWithError:^(id errorCode) {
                              [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                          } failWithNetworkWithBlock:^{
                              [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                              [Utils showTextHUDWithText:@"请检查网络" addToView:self.view];
                          }];
        }else{
            [_viewModel postRunResultToServer:self.run withSuccessBlock:^(id returnValue) {
                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                _rankLabel.text = [NSString stringWithFormat:@"第%@名",returnValue[@"my_ranking"]];
                [self.manager touchRun:_run
                                WithID:[returnValue[@"running_result_id"] intValue]];

                [self.manager syncharonizeRun:_run];
            } failWithError:^(id errorCode) {
                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                NSLog(@"post error is %@",errorCode);
            } failWithNetworkWithBlock:^{
                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                [Utils showTextHUDWithText:@"请检查网络" addToView:self.view];
                NSLog(@"no net");
            }];
        }
}

-(void)configureView{
    
    
    self.distanceLabel.text = [NSString stringWithFormat:@"%@km",[MathController stringifyDistance:self.run.distance.floatValue]];
    
    self.timeLabel.text = [NSString stringWithFormat:@"%@",  [MathController stringifySecondCount:self.run.duration.intValue usingLongFormat:NO]];
    
    self.paceLabel.text = [NSString stringWithFormat:@"%@",  [MathController stringifyAvgPaceFromDist:self.run.distance.floatValue overTime:self.run.duration.intValue]];
    
    self.kllLable.text = [NSString stringWithFormat:@"%@卡里路",[MathController stringifyKcalFromDist:[self.run.distance floatValue]  withWeight:_weight]];
    
    self.countLabel.text = [NSString stringWithFormat:@"x%.2f",[[MathController stringifyKcalFromDist:[self.run.distance floatValue]  withWeight:_weight] floatValue]/300];
    
    
    
    [self loadMap];
}

- (void)loadMap
{
    if (self.run.locations.count > 0) {
        
        self.mapView.hidden = NO;

        [self.mapView setRegion:[self mapRegion]];
        
        NSArray *colorSegmentArray = [MathController colorSegmentsForLocations:self.run.locations.array];
        [self.mapView addOverlays:colorSegmentArray];
        
    }
}

- (MKCoordinateRegion)mapRegion
{
    MKCoordinateRegion region;
    Location *initialLoc = self.run.locations.firstObject;
    
    float minLat = initialLoc.latitude.floatValue;
    float minLng = initialLoc.longtitude.floatValue;
    float maxLat = initialLoc.latitude.floatValue;
    float maxLng = initialLoc.longtitude.floatValue;
    
    for (Location *location in self.run.locations) {
        if (location.latitude.floatValue < minLat) {
            minLat = location.latitude.floatValue;
        }
        if (location.longtitude.floatValue < minLng) {
            minLng = location.longtitude.floatValue;
        }
        if (location.latitude.floatValue > maxLat) {
            maxLat = location.latitude.floatValue;
        }
        if (location.longtitude.floatValue > maxLng) {
            maxLng = location.longtitude.floatValue;
        }
    }
    
    region.center.latitude = (minLat + maxLat) / 2.0f;
    region.center.longitude = (minLng + maxLng) / 2.0f;
    
    region.span.latitudeDelta = (maxLat - minLat) * 2.0f; // 10% padding
    region.span.longitudeDelta = (maxLng - minLng) * 2.0f; // 10% padding
    
    return region;
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

#pragma mark - setter
-(void)setRun:(Run *)run
{
    if (_run != run) {
        _run = run;
    }
}

-(RecordManager *)manager{
    if (!_manager) {
        _manager = [[RecordManager alloc]init];
    }
    return _manager;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

@end
