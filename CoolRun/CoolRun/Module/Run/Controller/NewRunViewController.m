//
//  NewRunViewController.m
//  CoolRun
//
//  Created by 蔡欣东 on 16/5/6.
//  Copyright © 2016年 蔡欣东. All rights reserved.
//

#import "NewRunViewController.h"
#import "ResultViewController.h"
#import "MapViewController.h"
#import "NewRunViewModel.h"
#import "RunningBoardViewModel.h"
#import "RunningBoardView.h"


@interface NewRunViewController ()<AMapLocationManagerDelegate>{
    /**
     *  开始倒计时
     */
    int     _downCount;
    /**
     *  运动时间
     */
    int     _seconds;
}

@property (nonatomic, weak, readwrite) IBOutlet UILabel* promptLabel;

@property (nonatomic, weak, readwrite) IBOutlet UIButton* stopButton;

@property (weak, nonatomic, readwrite) IBOutlet UIButton *pauseBtn;

@property (weak, nonatomic, readwrite) IBOutlet UIButton *startBtn;

@property (weak, nonatomic, readwrite) IBOutlet UIButton *showMapBtn;

@property (nonatomic, strong, readwrite) RunningBoardView *boardView;

/**
 *  运动计时器
 */
@property (nonatomic, strong) NSTimer *timer;

/**
 *  倒计时
 */
@property(nonatomic,strong)NSTimer* downTimer;


/**
 *  地图
 */
@property(nonatomic,strong)MapViewController* mapViewController;

@property(nonatomic, strong, readwrite)NewRunViewModel *viewModel;

@end

@implementation NewRunViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _downCount = 3;

    _seconds = 0.00;
    
    [self KVOHandler];
    
    [self configureView];
    
    //开启倒计时
    self.downTimer = [NSTimer
                      scheduledTimerWithTimeInterval:1.0f
                      target:self selector:@selector(countDown:)
                      userInfo:nil
                      repeats:YES];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    self.KVOController = nil;
    
    [self.timer invalidate];
}

-(void)configureView {
    [self.view addSubview:self.mapViewController.view];
    
    self.mapViewController.view.hidden = YES;
    
    self.boardView.readyRunning = NO;
    
    self.showMapBtn.hidden  = YES;
    
    self.pauseBtn.hidden = YES;
    
    self.startBtn.hidden = YES;
    
    self.stopButton.hidden = YES;
    
    [self mapBtnAnimation];
    
    _boardView = [[RunningBoardView alloc] init];
    
    _boardView.frame = self.view.bounds;
    
    _boardView.readyRunning = NO;
    
    [self.view addSubview:_boardView];
    
    [self.view sendSubviewToBack:_boardView];
}

- (void)KVOHandler {
    [self.KVOController observe:self.viewModel keyPath:@"isRunning" options:NSKeyValueObservingOptionOld block:^(id observer, id object, NSDictionary *change) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([self.viewModel.isRunning boolValue]) {
                self.promptLabel.hidden = YES;
                
                self.showMapBtn.hidden  = NO;
                
                self.pauseBtn.hidden = NO;
                
                self.startBtn.hidden = YES;
                
                self.stopButton.hidden = YES;
                
                self.boardView.readyRunning = YES;
                
                self.boardView.backgroundColor = [UIColor whiteColor];
                
                self.timer.fireDate = [NSDate distantPast];
                
                self.mapViewController.locateEnable = YES;
                
                [self mapBtnAnimation];
            }else {
                self.pauseBtn.hidden = YES;
                
                self.startBtn.hidden = NO;
                
                self.stopButton.hidden = NO;
                
                self.boardView.backgroundColor = [UIColor blackColor];
                
                self.timer.fireDate = [NSDate distantFuture];
                
                self.mapViewController.locateEnable = NO;
                
                [self.showMapBtn.layer removeAllAnimations];
                
                //系统震动
                AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
                
                AudioServicesRemoveSystemSoundCompletion(kSystemSoundID_Vibrate);
            }
        });

    }];
    
    [self.KVOController observe:self.viewModel keyPath:@"runDataChange" options:NSKeyValueObservingOptionOld block:^(id observer, id object, NSDictionary *change) {
        if ([self.viewModel.runDataChange boolValue]) {
            [_boardView configureViewWithViewModel:self.viewModel.currentRunData];
        }
    }];
    
    [self.KVOController observe:self.viewModel keyPath:@"isValid" options:NSKeyValueObservingOptionOld block:^(id observer, id object, NSDictionary *change) {
        AVSpeechSynthesizer *av = [[AVSpeechSynthesizer alloc]init];
        
        AVSpeechUtterance *utterance = [[AVSpeechUtterance alloc]initWithString:@"Stop running"];
        
        [av speakUtterance:utterance];
        if ([self.viewModel.isValid boolValue]) {
            ResultViewController *resultVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ResultViewController"];
            resultVC.viewModel = self.viewModel.resultViewModel;
            [self presentViewController:resultVC animated:YES completion:nil];
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
    _seconds++;
    
    self.viewModel.duration = _seconds;
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

- (MapViewController *)mapViewController{
    if (!_mapViewController) {
        _mapViewController =  [self.storyboard instantiateViewControllerWithIdentifier:@"MapViewController"];
    }
    return _mapViewController;
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
