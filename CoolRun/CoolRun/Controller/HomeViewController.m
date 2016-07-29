//
//  HomeViewController.m
//  CoolRun
//
//  Created by 蔡欣东 on 16/5/6.
//  Copyright © 2016年 蔡欣东. All rights reserved.
//

#import "HomeViewController.h"
#import "Run.h"
#define weight 60

@interface HomeViewController ()
@property (weak, nonatomic) IBOutlet UIView *topBackView;
@property(nonatomic,strong)CLLocationManager* locationManager;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UILabel *speedLabel;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet UIView *rewardBgView;
@property (weak, nonatomic) IBOutlet UILabel *rankTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *rankLabel;
@property(nonatomic,assign)float totalDistance;
@property(nonatomic,assign)int totaltime;
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    if (!_locationManager) {
        _locationManager = [[CLLocationManager alloc] init];
        if ([_locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
            [_locationManager requestWhenInUseAuthorization];
            [_locationManager requestAlwaysAuthorization];
        }
    }
    self.rewardBgView.layer.borderColor = UIColorFromRGB(0xE8E9E8).CGColor;
    self.rewardBgView.layer.borderWidth = 1;
    
    

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    RecordManager* manager = [[RecordManager alloc]init];
    self.totalDistance = [manager totalDistance];
    self.totaltime = [manager totalTime];
    _distanceLabel.text = [MathController stringifyDistance:self.totalDistance];
    _countLabel.text = [NSString stringWithFormat:@"%ld",(long)[manager runCount]];
    _speedLabel.text = [MathController stringifyAvgPaceFromDist:self.totalDistance overTime:self.totaltime];
    
    NSDate *date = [NSDate date];
    _rankTimeLabel.text = [date convertToStringWithWeek];
    
}

- (IBAction)changeBtn:(UIButton *)sender {
    if ([_infoLabel.text isEqualToString:@"总公里"]) {
        _infoLabel.text = @"总卡路里";
        _distanceLabel.text = [MathController stringifyKcalFromDist:self.totalDistance withWeight:weight];
        
    }else{
        _infoLabel.text = @"总公里";
        _distanceLabel.text = [MathController stringifyDistance:self.totalDistance];
    }
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (IBAction)openDrawer:(UIButton *)sender {
    [[AppDelegate globalDelegate].UIProcess toggleLeftDrawer:self animated:YES];
    
}

- (IBAction)showRankView:(UIButton *)sender {
    UIViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"RankViewController"];
    [self presentViewController:vc animated:YES completion:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
