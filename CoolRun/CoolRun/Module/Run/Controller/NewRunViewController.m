//
//  NewRunViewController.m
//  CoolRun
//
//  Created by 蔡欣东 on 16/5/6.
//  Copyright © 2016年 蔡欣东. All rights reserved.
//

#import "NewRunViewController.h"
#import "ResultViewController.h"
#import "NewRunViewModel.h"
#import "RunningBoardViewModel.h"
#import "RunningBoardView.h"
#import "RunnungMapView.h"

@interface NewRunViewController ()<AMapLocationManagerDelegate>{
    /**
     *  开始倒计时
     */
    int     _downCount;
    /**
     *  运动时间
     */
    int     _duration;
}

@property (nonatomic, weak, readwrite) IBOutlet UILabel* promptLabel;

@property (nonatomic, weak, readwrite) IBOutlet UIButton* stopButton;

@property (weak, nonatomic, readwrite) IBOutlet UIButton *pauseBtn;

@property (weak, nonatomic, readwrite) IBOutlet UIButton *startBtn;

@property (weak, nonatomic, readwrite) IBOutlet UIButton *showMapBtn;

@property (nonatomic, strong, readwrite) RunningBoardView *runningBoardView;

@property (nonatomic, strong, readwrite) RunnungMapView *runningMapView;

/**
 *  运动计时器
 */
@property (nonatomic, strong, readwrite) NSTimer *timer;

/**
 *  倒计时
 */
@property(nonatomic, strong, readwrite)NSTimer* downTimer;

@property(nonatomic, strong, readwrite)NewRunViewModel *viewModel;

@end

@implementation NewRunViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _downCount = 3;

    _duration = 0.00;
    
    //开启倒计时
    self.downTimer = [NSTimer
                      scheduledTimerWithTimeInterval:1.0f
                      target:self selector:@selector(countDown:)
                      userInfo:nil
                      repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.downTimer forMode:NSRunLoopCommonModes];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    self.KVOController = nil;
    
    [self.timer invalidate];
}

- (void)configureView {
    self.showMapBtn.hidden  = YES;
    
    self.pauseBtn.hidden = YES;
    
    self.startBtn.hidden = YES;
    
    self.stopButton.hidden = YES;
    
    [self.view addSubview:self.runningBoardView];
    
    [self.view sendSubviewToBack:self.runningBoardView];
    
    [self.view addSubview:self.runningMapView];
    
    [self.view bringSubviewToFront:self.runningMapView];
    
}

- (void)KVOHandler {
    [self.KVOController observe:self.viewModel keyPath:@"isRunning" options:NSKeyValueObservingOptionNew block:^(id observer, id object, NSDictionary *change) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([self.viewModel.isRunning boolValue]) {
                self.promptLabel.hidden = YES;
                
                self.showMapBtn.hidden  = NO;
                
                self.pauseBtn.hidden = NO;
                
                self.startBtn.hidden = YES;
                
                self.stopButton.hidden = YES;
                
                self.runningBoardView.readyRunning = YES;
                
                self.runningBoardView.backgroundColor = [UIColor whiteColor];
                
                self.timer.fireDate = [NSDate distantPast];
                
                [self mapBtnAnimation];
            }else {
                self.pauseBtn.hidden = YES;
                
                self.startBtn.hidden = NO;
                
                self.stopButton.hidden = NO;
                
                self.runningBoardView.backgroundColor = [UIColor blackColor];
                
                self.timer.fireDate = [NSDate distantFuture];
                
                [self.showMapBtn.layer removeAllAnimations];
                //系统震动
                AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
                
                AudioServicesRemoveSystemSoundCompletion(kSystemSoundID_Vibrate);
            }
        });

    }];
    
    [self.KVOController observe:self.viewModel keyPath:@"runDataChange" options:NSKeyValueObservingOptionNew block:^(id observer, id object, NSDictionary *change) {
        if ([self.viewModel.runDataChange boolValue]) self.runningBoardView.viewModel = self.viewModel.currentRunData;
    }];
    
    [self.KVOController observe:self.viewModel keyPath:@"mapDataChange" options:NSKeyValueObservingOptionNew block:^(id observer, id object, NSDictionary *change) {
        if ([self.viewModel.mapDataChange boolValue]) self.runningMapView.viewModel = self.viewModel.mapViewModel;
    }];
    
    [self.KVOController observe:self.viewModel keyPath:@"isValid" options:NSKeyValueObservingOptionNew block:^(id observer, id object, NSDictionary *change) {
        AVSpeechSynthesizer *av = [[AVSpeechSynthesizer alloc]init];
        
        AVSpeechUtterance *utterance = [[AVSpeechUtterance alloc]initWithString:@"Stop running"];
        
        [av speakUtterance:utterance];
        
        if ([self.viewModel.isValid boolValue]) {
            ResultViewController *resultVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ResultViewController"];
            resultVC.viewModel = self.viewModel.resultViewModel;
            [self.navigationController pushViewController:resultVC animated:YES];
        }else {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }];
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
        
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0f
                                                      target:self
                                                    selector:@selector(eachSecond:)
                                                    userInfo:nil
                                                     repeats:YES];
        
        AVSpeechSynthesizer *av = [[AVSpeechSynthesizer alloc]init];
        
        AVSpeechUtterance *utterance = [[AVSpeechUtterance alloc]initWithString:@"Start running"];
        
        [av speakUtterance:utterance];
        
        [self.viewModel beginRunning];
    
    }
    
}

/**
 *  运动计数器回调
 *
 *  @param timer
 */
- (void)eachSecond:(NSTimer*)timer {
    _duration++;
    
    self.viewModel.duration = _duration;
}

/**
 *  结束按钮
 *
 *  @param sender
 */
- (IBAction)stopPressed:(UIButton*)sender {
    [self.viewModel stopRunning];
}


/**
 *  暂停按钮
 *
 *  @param sender
 */
- (IBAction)pauseBtnClick:(UIButton *)sender {
    [self.viewModel pauseRunning];
}

/**
 *  恢复按钮
 *
 *  @param sender
 */
- (IBAction)startClick:(UIButton *)sender {
    [self.viewModel resumeRunning];
}

- (IBAction)showMapViewBtnClick:(UIButton *)sender {
    [self.runningMapView showMapView];
}

#pragma mark - private
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

#pragma mark - getter and setter

- (RunningBoardView *)runningBoardView {
    if (!_runningBoardView) {
        _runningBoardView = [[RunningBoardView alloc] init];
        _runningBoardView.frame = self.view.bounds;
        _runningBoardView.readyRunning = NO;
    }
    return _runningBoardView;
}

- (RunnungMapView *)runningMapView {
    if (!_runningMapView) {
        _runningMapView = [[RunnungMapView alloc] init];
        _runningMapView.frame = self.view.bounds;
        _runningMapView.hidden = YES;
    }
    return _runningMapView;
}

- (NewRunViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[NewRunViewModel alloc] init];
    }
    return _viewModel;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
@end
