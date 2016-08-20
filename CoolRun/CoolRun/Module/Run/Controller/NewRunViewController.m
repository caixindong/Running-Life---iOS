//
//  NewRunViewController.m
//  CoolRun
//
//  Created by 蔡欣东 on 16/5/6.
//  Copyright © 2016年 蔡欣东. All rights reserved.
//

#import "NewRunViewController.h"
#import "ResultViewController.h"
#import "AppDelegate.h"
#import "Run.h"
#import "MapViewController.h"
#import "Location.h"
#import "LocationDataManager.h"

static NSString * const detailSegueName = @"RunDetails";

@interface NewRunViewController ()<AMapLocationManagerDelegate,MKMapViewDelegate>{
    /**
     *  开始倒计时
     */
    int     _downCount;
    /**
     *  运动时间
     */
    int     _seconds;
    /**
     *  运动距离
     */
    float   _distance;
    /**
     *  是否准备
     */
    BOOL    _isReady;
    /**
     *  暂停计数
     */
    int     _stopCount;
}

@property (nonatomic, strong, readwrite) Run *run;

@property (nonatomic, weak, readwrite) IBOutlet UILabel* promptLabel;

@property (nonatomic, weak, readwrite) IBOutlet UILabel* timeLabel;

@property (nonatomic, weak, readwrite) IBOutlet UILabel* distLabel;

@property (nonatomic, weak, readwrite) IBOutlet UILabel* paceLabel;

@property (nonatomic, weak, readwrite) IBOutlet UIButton* stopButton;

@property (weak, nonatomic, readwrite) IBOutlet UILabel *kmLabel;

@property (weak, nonatomic, readwrite) IBOutlet UIButton *pauseBtn;

@property (weak, nonatomic, readwrite) IBOutlet UIButton *startBtn;

@property (weak, nonatomic, readwrite) IBOutlet UIButton *showMapBtn;

@property (weak, nonatomic, readwrite) IBOutlet UIImageView *timeImg;

@property (weak, nonatomic, readwrite) IBOutlet UIImageView *speedImg;

/**
 *  定位管理
 */
@property (nonatomic, strong) AMapLocationManager* locationManager;

/**
 *  运动位置数组
 */
@property (nonatomic, strong) NSMutableArray* locations;

/**
 *  运动计时器
 */
@property (nonatomic, strong) NSTimer *timer;

/**
 *  倒计时
 */
@property(nonatomic,strong)NSTimer* downTimer;

/**
 *  运动管理
 */
@property(nonatomic,strong)CMMotionManager* motionManger;

/**
 *  地图
 */
@property(nonatomic,strong)MapViewController* mapViewController;

@end

@implementation NewRunViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _downCount = 3;
    
    _stopCount = 0;
    
    _seconds = 0.00;
    
    _distance = 0.00;
    
    [self.locationManager startUpdatingLocation];
    
    [self.view addSubview:self.mapViewController.view];
    
    //开启倒计时
    self.downTimer = [NSTimer
                      scheduledTimerWithTimeInterval:1.0f
                      target:self selector:@selector(countDown:)
                      userInfo:nil
                      repeats:YES];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.mapViewController.view.hidden = YES;
    
    self.isReady = NO;
    
    [self mapBtnAnimation];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.timer invalidate];
    
    [self.locationManager stopUpdatingLocation];
    
    self.locationManager = nil;
}

#pragma mark - event response
/**
 *  倒计时回调
 *
 *  @param timer
 */
- (void)countDown:(NSTimer*)timer {
    _downCount--;
    
    self.promptLabel.text = [NSString stringWithFormat:@"%d",_downCount];
    
    if (_downCount==0) {
        [self.downTimer invalidate];
        
        self.isReady  = YES;
        
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0f
                                                      target:self
                                                    selector:@selector(eachSecond:)
                                                    userInfo:nil
                                                     repeats:YES];
    }
    
}

/**
 *  运动计数器回调
 *
 *  @param timer
 */
- (void)eachSecond:(NSTimer*)timer {
    _seconds++;
    
    //刷新UI
    self.timeLabel.text = [NSString stringWithFormat:@"%@",[MathController stringifySecondCount:_seconds usingLongFormat:NO]];
    
    self.distLabel.text = [NSString stringWithFormat:@"%.2f",_distance/1000];
    
    self.paceLabel.text = [NSString stringWithFormat:@"%@",[MathController stringifyAvgPaceFromDist:_distance overTime:_seconds]];
}

/**
 *  结束按钮（有语音）
 *
 *  @param sender
 */
- (IBAction)stopPressed:(UIButton*)sender {
    AVSpeechSynthesizer *av = [[AVSpeechSynthesizer alloc]init];
    
    AVSpeechUtterance *utterance = [[AVSpeechUtterance alloc]initWithString:@"Stop running"];
    
    [av speakUtterance:utterance];
    
    if (_distance/1000>0.01) {
        [self saveRun];
        
        [self performSegueWithIdentifier:detailSegueName sender:nil];
        
    }else{
        
        [self dismissViewControllerAnimated:YES completion:nil];
        
    }
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    [[segue destinationViewController] setRun:self.run];
}

/**
 *  显示地图
 *
 *  @param sender
 */
- (IBAction)showMap:(UIButton *)sender {
    self.mapViewController.view.transform= CGAffineTransformMakeScale(0.01, 0.01);
    
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        
        self.mapViewController.view.transform = CGAffineTransformIdentity;
        
        self.mapViewController.view.hidden = NO;
        
    } completion:^(BOOL finished) {
        
    }];
}

/**
 *  暂停按钮
 *
 *  @param sender
 */
- (IBAction)pauseBtnClick:(UIButton *)sender {
    sender.hidden = YES;
    
    self.view.backgroundColor = [UIColor blackColor];
    
    self.startBtn.hidden = NO;
    
    self.stopButton.hidden = NO;
    
    [self.timer invalidate];
    
    [self.locationManager stopUpdatingLocation];
    
    self.mapViewController.locateEnable = NO;
    
    [self.showMapBtn.layer removeAllAnimations];
    
    //系统震动
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    
    AudioServicesRemoveSystemSoundCompletion(kSystemSoundID_Vibrate);
}

/**
 *  恢复按钮
 *
 *  @param sender
 */
- (IBAction)startClick:(UIButton *)sender {
    sender.hidden = YES;
    
    _stopCount = 0;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.stopButton.hidden = YES;
    
    self.pauseBtn.hidden = NO;
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0f
                                                  target:self
                                                selector:@selector(eachSecond:)
                                                userInfo:nil
                                                 repeats:YES];
    
    [self.locationManager startUpdatingLocation];
    
    self.mapViewController.locateEnable = YES;
    
    [self mapBtnAnimation];
}

#pragma mark - private
/**
 *  保存跑步记录
 */
-(void)saveRun{
    NSMutableArray *locationArray = [NSMutableArray array];
    
    
    for (CLLocation *location in self.locations) {
        Location* locationObject =  [[LocationDataManager shareManager]
                                     addLoactionWithLatitude:[NSNumber
                                                              numberWithDouble:location.coordinate.latitude] longtitude:[NSNumber numberWithDouble:location.coordinate.longitude] timestamp:location.timestamp];
        
        [locationArray addObject:locationObject];
        
    }
    
    Run* runObject =  [[RecordManager shareManager] addRunRecordWithDis:[NSNumber
                                                    numberWithFloat:_distance]
                                           withDur:[NSNumber
                                                    numberWithInt:_seconds]
                                          withTime:[NSDate date]
                                     withLocations:[NSOrderedSet
                                                    orderedSetWithArray:locationArray]];
    
    self.run = runObject;
}

/**
 *  地图旋转动画
 */
-(void)mapBtnAnimation{
    CABasicAnimation* rotationAnimation;
    
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
    
    rotationAnimation.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    
    rotationAnimation.toValue = [ NSValue valueWithCATransform3D:
                                 
                                 CATransform3DMakeRotation(M_PI, 0.0, 0.0, 1.0) ];
    
    rotationAnimation.duration = 1.0;
    
    rotationAnimation.cumulative = YES;
    
    rotationAnimation.repeatCount = MAXFLOAT;
    
    [self.showMapBtn.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
    
}

#pragma mark - AMapLocationManagerDelegate
- (void)amapLocationManager:(AMapLocationManager *)manager didFailWithError:(NSError *)error {
    [_locationManager stopUpdatingLocation];
}

- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location {
        if (location.horizontalAccuracy < 30) {
            NSDate *eventDate = location.timestamp;
            
            NSTimeInterval howRecent = [eventDate timeIntervalSinceNow];
            
            if (fabs(howRecent) < 2.0 && location.horizontalAccuracy < 30) {
                if (self.locations.count > 0) {
                    _distance += [location distanceFromLocation:self.locations.lastObject];
                }
                
                [self.locations addObject:location];
            }
        }
}


#pragma mark - getter and setter

-(AMapLocationManager *)locationManager{
    if (!_locationManager) {
        _locationManager = [[AMapLocationManager alloc] init];
        
        _locationManager.delegate = self;
        
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        
        _locationManager.distanceFilter = kCLDistanceFilterNone;
        
        //设置允许后台定位参数，保持不会被系统挂起
        [_locationManager setPausesLocationUpdatesAutomatically:NO];
        
        if([[[UIDevice currentDevice] systemVersion] floatValue]>9.0){
            [_locationManager setAllowsBackgroundLocationUpdates:YES];//iOS9(含)以上系统需设置    
        }
        
    }
    return _locationManager;
}

-(MapViewController *)mapViewController{
    if (!_mapViewController) {
        _mapViewController =  [self.storyboard instantiateViewControllerWithIdentifier:@"MapViewController"];
    }
    return _mapViewController;
}

-(NSMutableArray *)locations{
    if (!_locations) {
        _locations = [NSMutableArray arrayWithCapacity:10];
    }
    return _locations;
}

-(CMMotionManager *)motionManger{
    if (!_motionManger) {
        _motionManger = [[CMMotionManager alloc]init];
        _motionManger.gyroUpdateInterval = 1.0;
    }
    return _motionManger;
}

-(void)setIsReady:(BOOL)isReady{
    if (isReady) {
        self.promptLabel.hidden = YES;
        
        self.timeLabel.hidden = NO;
        
        self.distLabel.hidden = NO;
        
        self.paceLabel.hidden = NO;
        
        self.kmLabel.hidden = NO;
        
        self.pauseBtn.hidden = NO;
        
        self.showMapBtn.hidden  = NO;
        
        self.speedImg.hidden = NO;
        
        self.timeImg.hidden = NO;
        
        AVSpeechSynthesizer *av = [[AVSpeechSynthesizer alloc]init];
        
        AVSpeechUtterance *utterance = [[AVSpeechUtterance alloc]initWithString:@"Start running"];
        
        [av speakUtterance:utterance];
        
        NSOperationQueue* queue = [[NSOperationQueue alloc]init];
        
        /**
         *  重力感应是否可用
         */
        if (self.motionManger.gyroAvailable) {
            
            [self.motionManger startGyroUpdatesToQueue:queue withHandler:^(CMGyroData * _Nullable gyroData, NSError * _Nullable error) {
                
                CGFloat y = gyroData.rotationRate.y;
                
                CGFloat z = gyroData.rotationRate.z;
                
                if (fabs(y)>2||fabs(z)>2) {
                    
                    _stopCount = 0;
                    
                    if (!self.startBtn.hidden) {
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            if ([self respondsToSelector:@selector(startClick:)]) {
                                
                                [self startClick:self.startBtn];
                                
                            }
                        });
                    }
                }else{
                    
                    _stopCount++;
                    
                    if (_stopCount>8&&self.startBtn.hidden) {
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            if ([self respondsToSelector:@selector(pauseBtnClick:)]) {
                                
                                [self pauseBtnClick:self.pauseBtn];
                            }
                        });
                        
                    }
                }
            }];
        }else{
            NSLog(@"重力感应不可用");
        }
    }else{
        self.promptLabel.hidden = NO;
        
        self.timeLabel.hidden = YES;
        
        self.distLabel.hidden = YES;
        
        self.paceLabel.hidden = YES;
        
        self.stopButton.hidden = YES;
        
        self.kmLabel.hidden = YES;
        
        self.pauseBtn.hidden = YES;
        
        self.startBtn.hidden = YES;
        
        self.showMapBtn.hidden = YES;
        
        self.timeImg.hidden = YES;
        
        self.speedImg.hidden = YES;

    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
@end
