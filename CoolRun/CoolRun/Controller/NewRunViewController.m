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
@interface NewRunViewController ()<AMapLocationManagerDelegate,MKMapViewDelegate>
@property (nonatomic, strong) Run *run;

@property (nonatomic, weak) IBOutlet UILabel* promptLabel;
@property (nonatomic, weak) IBOutlet UILabel* timeLabel;
@property (nonatomic, weak) IBOutlet UILabel* distLabel;
@property (nonatomic, weak) IBOutlet UILabel* paceLabel;
@property (nonatomic, weak) IBOutlet UIButton* stopButton;
@property (weak, nonatomic) IBOutlet UILabel *kmLabel;
@property (nonatomic,assign)int seconds;
@property (nonatomic,assign)float distance;
@property (nonatomic, strong) AMapLocationManager* locationManager;
@property (nonatomic, strong) NSMutableArray* locations;
@property (nonatomic, strong) NSTimer *timer;
@property(nonatomic,strong)NSTimer* downTimer;
@property(nonatomic,assign)int downCount;
@property (weak, nonatomic) IBOutlet UIButton *pauseBtn;
@property(nonatomic,strong)MapViewController* mapViewController;
@property (weak, nonatomic) IBOutlet UIButton *startBtn;
@property (weak, nonatomic) IBOutlet UIButton *showMapBtn;
@property (weak, nonatomic) IBOutlet UIImageView *timeImg;
@property (weak, nonatomic) IBOutlet UIImageView *speedImg;
@property(nonatomic,assign)BOOL isReady;
@property(nonatomic,strong)CMMotionManager* motionManger;
@property(nonatomic,assign)int stopCount;
@end

@implementation NewRunViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.downCount = 3;
    self.stopCount = 0;
    [self.locationManager startUpdatingLocation];
    [self.view addSubview:self.mapViewController.view];
    self.downTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(countDown:) userInfo:nil repeats:YES];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.mapViewController.view.hidden = YES;
    self.isReady = NO;
    [self mapBtnAnimation];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.timer invalidate];
    [self.locationManager stopUpdatingLocation];
    self.locationManager = nil;
    NSLog(@"dis");
}

#pragma mark - event response
-(void)countDown:(NSTimer*)timer{
    self.downCount--;
    self.promptLabel.text = [NSString stringWithFormat:@"%d",self.downCount];
    if (self.downCount==0) {
        [self.downTimer invalidate];
        self.isReady  = YES;
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self
                                                    selector:@selector(eachSecond:) userInfo:nil repeats:YES];
    }
    
}

- (void)eachSecond:(NSTimer*)timer{
    self.seconds++;
    self.timeLabel.text = [NSString stringWithFormat:@"%@",[MathController stringifySecondCount:self.seconds usingLongFormat:NO]];
    self.distLabel.text = [NSString stringWithFormat:@"%.2f",self.distance/1000];
    self.paceLabel.text = [NSString stringWithFormat:@"%@",[MathController stringifyAvgPaceFromDist:self.distance overTime:self.seconds]];
}

-(IBAction)stopPressed:(UIButton*)sender
{
    AVSpeechSynthesizer *av = [[AVSpeechSynthesizer alloc]init];
    AVSpeechUtterance *utterance = [[AVSpeechUtterance alloc]initWithString:@"Stop running"];
    [av speakUtterance:utterance];
    if (self.distance/1000>0.01) {
        [self saveRun];
        [self performSegueWithIdentifier:detailSegueName sender:nil];
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [[segue destinationViewController] setRun:self.run];
}

- (IBAction)showMap:(UIButton *)sender {
    self.mapViewController.view.transform= CGAffineTransformMakeScale(0.01, 0.01);
    
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.mapViewController.view.transform = CGAffineTransformIdentity;
        self.mapViewController.view.hidden = NO;
    } completion:^(BOOL finished) {
    }];
    
    
    
}
- (IBAction)pauseBtnClick:(UIButton *)sender {
    sender.hidden = YES;
    self.view.backgroundColor = [UIColor blackColor];
    self.startBtn.hidden = NO;
    self.stopButton.hidden = NO;
    [self.timer invalidate];
    [self.locationManager stopUpdatingLocation];
    self.mapViewController.locateEnable = NO;
    [self.showMapBtn.layer removeAllAnimations];
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    AudioServicesRemoveSystemSoundCompletion(kSystemSoundID_Vibrate);
}

- (IBAction)startClick:(UIButton *)sender {
    sender.hidden = YES;
    self.stopCount = 0;
    self.view.backgroundColor = [UIColor whiteColor];
    self.stopButton.hidden = YES;
    self.pauseBtn.hidden = NO;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self
                                                selector:@selector(eachSecond:) userInfo:nil repeats:YES];
    [self.locationManager startUpdatingLocation];
    self.mapViewController.locateEnable = YES;
    [self mapBtnAnimation];
}

-(void)saveRun{
    NSMutableArray *locationArray = [NSMutableArray array];
    RecordManager* manager = [[RecordManager alloc]init];
    LocationDataManager* locationManager = [[LocationDataManager alloc]init];
    for (CLLocation *location in self.locations) {
        Location* locationObject =  [locationManager
                                     addLoactionWithLatitude:[NSNumber
                                                              numberWithDouble:location.coordinate.latitude] withLongtitude:[NSNumber numberWithDouble:location.coordinate.longitude] withTimestamp:location.timestamp];
        [locationArray addObject:locationObject];
        
    }
    
    Run* runObject =  [manager addRunRecordWithDis:[NSNumber
                                                    numberWithFloat:self.distance]
                                           withDur:[NSNumber
                                                    numberWithInt:self.seconds]
                                          withTime:[NSDate date]
                                     withLocations:[NSOrderedSet
                                                    orderedSetWithArray:locationArray]];
    self.run = runObject;
}

#pragma mark - AMapLocationManagerDelegate
- (void)amapLocationManager:(AMapLocationManager *)manager didFailWithError:(NSError *)error{
    [_locationManager stopUpdatingLocation];
}

- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location{
        if (location.horizontalAccuracy < 30) {
            NSDate *eventDate = location.timestamp;
            NSTimeInterval howRecent = [eventDate timeIntervalSinceNow];
            if (fabs(howRecent) < 2.0 && location.horizontalAccuracy < 30) {
                if (self.locations.count > 0) {
                    self.distance += [location distanceFromLocation:self.locations.lastObject];
                }
                [self.locations addObject:location];
            }
        }
}

#pragma mark - MKMapViewDelegate
- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id < MKOverlay >)overlay
{
    if ([overlay isKindOfClass:[MKPolyline class]]) {
        MKPolyline *polyLine = (MKPolyline *)overlay;
        MKPolylineRenderer *aRenderer = [[MKPolylineRenderer alloc] initWithPolyline:polyLine];
        aRenderer.strokeColor = [UIColor blueColor];
        aRenderer.lineWidth = 3;
        return aRenderer;
    }
    return nil;
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

-(int)seconds{
    if (!_seconds) {
        _seconds = 0.00;
    }
    return _seconds;
}

-(float)distance{
    if (!_distance) {
        _distance = 0.00;
    }
    return _distance;
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
        NSLog(@"yes");
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
                    self.stopCount++;
                    if (self.stopCount>8&&self.startBtn.hidden) {
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
        NSLog(@"no");
    }
}

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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
@end
