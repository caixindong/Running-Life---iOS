//
//  RunningBoardView.m
//  CoolRun
//
//  Created by 蔡欣东 on 2016/9/5.
//  Copyright © 2016年 蔡欣东. All rights reserved.
//

#import "RunningBoardView.h"
#import "RunningBoardViewModel.h"


@interface RunningBoardView()

@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UILabel *speedLabel;

@property (weak, nonatomic) IBOutlet UILabel *kmLabel;

@property (weak, nonatomic) IBOutlet UIImageView *timeImgView;

@property (weak, nonatomic) IBOutlet UIImageView *speedImgView;

@end

@implementation RunningBoardView

- (instancetype)init {
    if (self = [super init]) {
        self = [[[NSBundle mainBundle]loadNibNamed:@"RunningBoardView" owner:self options:nil] lastObject];
    }
    return self;
}

- (void)configureViewWithViewModel:(RunningBoardViewModel *)viewModel {
    _distanceLabel.text = viewModel.distance;
    _speedLabel.text    = viewModel.speed;
    _timeLabel.text     = viewModel.duration;
}

- (void)setReadyRunning:(BOOL)readyRunning {
    _readyRunning = readyRunning;
    if (_readyRunning) {
        _distanceLabel.hidden = NO;
        _speedLabel.hidden = NO;
        _kmLabel.hidden = NO;
        _timeLabel.hidden = NO;
        _speedImgView.hidden = NO;
        _timeImgView.hidden = NO;
    }else {
        _distanceLabel.hidden = YES;
        _speedLabel.hidden = YES;
        _kmLabel.hidden = YES;
        _timeLabel.hidden = YES;
        _speedImgView.hidden = YES;
        _timeImgView.hidden = YES;
    }
}


@end
