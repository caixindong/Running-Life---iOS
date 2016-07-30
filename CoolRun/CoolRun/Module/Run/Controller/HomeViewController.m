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

@interface HomeViewController (){
    /**
     *  总距离
     */
    float _totalDistance;
    
    /**
     *  总时间
     */
    int _totaltime;
}

@property (weak, nonatomic) IBOutlet UIView *topBackView;

@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;

@property (weak, nonatomic) IBOutlet UILabel *countLabel;

@property (weak, nonatomic) IBOutlet UILabel *speedLabel;

@property (weak, nonatomic) IBOutlet UILabel *infoLabel;

@property (weak, nonatomic) IBOutlet UIView *rewardBgView;

@property (weak, nonatomic) IBOutlet UILabel *rankTimeLabel;

@property (weak, nonatomic) IBOutlet UILabel *rankLabel;

/**
 *  定位管理器
 */
@property(nonatomic,strong)CLLocationManager* locationManager;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _totaltime = 0;
    
    _totalDistance = 0.00;
    
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
    
    

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    RecordManager* manager = [[RecordManager alloc]init];
    
    _totalDistance = [manager totalDistance];
    
    _totaltime = [manager totalTime];
    
    _distanceLabel.text = [MathController stringifyDistance:_totalDistance];
    
    _countLabel.text = [NSString stringWithFormat:@"%ld",(long)[manager runCount]];
    
    _speedLabel.text = [MathController stringifyAvgPaceFromDist:_totalDistance overTime:_totaltime];
    
    NSDate *date = [NSDate date];
    
    _rankTimeLabel.text = [date convertToStringWithWeek];
    
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
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
        
        _distanceLabel.text = [MathController stringifyKcalFromDist:_totalDistance withWeight:weight];
        
    }else{
        _infoLabel.text = @"总公里";
        
        _distanceLabel.text = [MathController stringifyDistance:_totalDistance];
    }
}

/**
 *  显示排名视图
 *
 *  @param sender
 */
- (IBAction)showRankView:(UIButton *)sender {
    UIViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"RankViewController"];
    
    [self presentViewController:vc animated:YES completion:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
