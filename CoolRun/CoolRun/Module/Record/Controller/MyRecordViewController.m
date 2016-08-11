//
//  MyRecordViewController.m
//  CoolRun
//
//  Created by 蔡欣东 on 16/5/16.
//  Copyright © 2016年 蔡欣东. All rights reserved.
//

#import "MyRecordViewController.h"
#import "DetailViewController.h"
#import "RecordShowView.h"
#import "MyRecordViewModel.h"

/**
 *  记录界面
 */
@interface MyRecordViewController ()

@property (nonatomic, strong, readwrite) RecordShowView *showView;

@property (nonatomic, strong, readwrite) SZCalendarPicker* calendar;

@property (nonatomic, strong, readwrite) MyRecordViewModel *viewModel;

@end

@implementation MyRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initCalendar];
    
    [self initShowView];
    
    [self getKcalData];
    
    [self KVOHandler];
}

#pragma mark - private

- (void)initCalendar {
    _calendar = [SZCalendarPicker showOnView:self.view];
    _calendar.today = [NSDate date];
    _calendar.date = _calendar.today;
    _calendar.frame = CGRectMake(0, 64,WIDTH , HEIGHT/2);
    
    WeakObj(self);
    _calendar.changeMonthBlock = ^(NSInteger year,NSInteger month){
        StrongObj(selfWeak)
        [selfWeakStrong.viewModel getWalkAndRunKcalArrayWithMonth:month year:year weigth:65];
        [selfWeakStrong.viewModel getRunKcalArrayWithMonth:month year:year weigth:65];
    };
    
    _calendar.calendarBlock = ^(NSDate* date){
        StrongObj(selfWeak)
        NSArray* runArr = [selfWeakStrong.viewModel getRunRecordWithDate:date];
        if (runArr) {
            DetailViewController* vc = [selfWeakStrong.storyboard instantiateViewControllerWithIdentifier:@"DetailViewController"];
            vc.runDataArray = runArr;
            [selfWeakStrong presentViewController:vc animated:YES completion:nil];
        }
    };
}

- (void)initShowView {
    _showView = [[RecordShowView alloc] initWithFrame:CGRectMake(0, HEIGHT/2 + 64, WIDTH, HEIGHT/2 - 64)];
    [self.view addSubview:_showView];
}

- (void)getKcalData {
    NSDateComponents *comp = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear| NSCalendarUnitMonth| NSCalendarUnitDay) fromDate:[NSDate date]];
    
    [self.viewModel getWalkAndRunKcalArrayWithMonth:comp.month year:comp.year weigth:65];
    
    [self.viewModel getRunKcalArrayWithMonth:comp.month year:comp.year weigth:65];
}

- (void)KVOHandler {
    [self.KVOController observe:self.viewModel keyPath:@"updateWalkAndRunData" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld block:^(id observer, id object, NSDictionary *change) {
        if ([self.viewModel.updateWalkAndRunData boolValue]) {
            _showView.normalRecords = self.viewModel.walkAndRunKcalArray;
        }
    }];
    
    [self.KVOController observe:self.viewModel keyPath:@"updateRunData" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld block:^(id observer, id object, NSDictionary *change) {
        if ([self.viewModel.updateRunData boolValue]) {
            _showView.specialRecords    = self.viewModel.runKcalArray;
            _calendar.specialDataArr    = self.viewModel.runKcalArray;
        }
    }];
}

#pragma mark - getter and setter

- (MyRecordViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[MyRecordViewModel alloc] init];
    }
    return _viewModel;
}

#pragma mark - event response

- (IBAction)openDrawer:(UIButton *)sender {
    [[AppDelegate globalDelegate].UIProcess toggleLeftDrawer:self animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
