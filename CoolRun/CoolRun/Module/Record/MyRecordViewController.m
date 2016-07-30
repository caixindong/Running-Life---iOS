//
//  MyRecordViewController.m
//  CoolRun
//
//  Created by 蔡欣东 on 16/5/16.
//  Copyright © 2016年 蔡欣东. All rights reserved.
//

#import "MyRecordViewController.h"
#import "DetailViewController.h"
#import "RecordManager+Kcal.h"

@interface MyRecordViewController ()
@property(nonatomic,strong) HealthKitManager* manager;
@property(nonatomic,strong)RecordManager* recordManager;
@property(nonatomic,copy)NSArray* kcalArr;
@property(nonatomic,copy)NSArray* runKcalArr;
@property(nonatomic,strong)CAShapeLayer* recordLayer;
@property(nonatomic,strong)CAShapeLayer* runRecordLayer;
@end

@implementation MyRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self draw];
    SZCalendarPicker* calendar = [SZCalendarPicker showOnView:self.view];
    calendar.today = [NSDate date];
    calendar.date = calendar.today;
    calendar.frame = CGRectMake(0, 64,WIDTH , HEIGHT/2);
   
    WeakObj(calendar)
    calendar.changeMonthBlock = ^(NSInteger year,NSInteger month){
        [self.manager getKcalWithWeight:65
                                   year:year
                                  month:month
                                    day:1
                               complete:^(id arr) {
                                   self.kcalArr = arr;
                                   NSLog(@"%@",self.kcalArr);
                                   dispatch_async(dispatch_get_main_queue(), ^{
                                       [self drawRecord];
                                       self.runKcalArr = [self.recordManager getKcalDataWithMonth:month year:year weight:65];
                
                                       StrongObj(calendarWeak)
                
                                       calendarWeakStrong.specialDataArr = self.runKcalArr;
                                       [self drawRunRecord];
                                   });
                               }
                          failWithError:^(NSError * error) {
                              NSLog(@"get kcal error is %@",error);
                          }];
    };
    
    
    calendar.calendarBlock = ^(NSDate* date){
        NSDateFormatter* dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSArray* runArr = [self.recordManager getRunInfoInDate:date];
        if (runArr) {
            DetailViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailViewController"];
            vc.runDataArray = runArr;
            [self presentViewController:vc animated:YES completion:nil];
        }
    };
    
    NSDateComponents *comp = [[NSCalendar currentCalendar]
                              components:(NSCalendarUnitYear
                                          | NSCalendarUnitMonth
                                          | NSCalendarUnitDay)
                              fromDate:calendar.today];
    [self.manager getKcalWithWeight:65
                               year:comp.year
                              month:comp.month
                                day:1 complete:^(id arr) {
                                    self.kcalArr = arr;
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        [self drawRecord];
                                        self.runKcalArr = [self.recordManager getKcalDataWithMonth:comp.month year:comp.year weight:65];
                                        [self drawRunRecord];
                                        StrongObj(calendarWeak)
                                        calendarWeakStrong.specialDataArr = self.runKcalArr;
                                    });
                                } failWithError:^(NSError * error) {
                                    NSLog(@"get kcal error is %@",error);
                                }];
    
   
}

/**
 *  画出基础界面
 */
-(void)draw{
    CGFloat aliginW2 = (WIDTH-40)/(5*7);
    CGFloat lineH2 = 4;
    UIBezierPath* smallPath = [UIBezierPath bezierPath];
    for (int i = 1; i<=35; i++) {
        [smallPath moveToPoint:CGPointMake(20+aliginW2*i, HEIGHT-20)];
        [smallPath addLineToPoint:CGPointMake(20+aliginW2*i, HEIGHT-20-lineH2)];
    }
    CAShapeLayer* layer2 = [CAShapeLayer layer];
    layer2.path = smallPath.CGPath;
    layer2.strokeColor = [UIColor lightGrayColor].CGColor;
    layer2.lineWidth = 2;
    [self.view.layer addSublayer:layer2];
    
    
    
    UIBezierPath* path1 = [UIBezierPath bezierPath];
    [path1 moveToPoint:CGPointMake(20, 64+HEIGHT/2+10)];
    [path1 addLineToPoint:CGPointMake(20, HEIGHT-20)];
    [path1 moveToPoint:CGPointMake(20, HEIGHT-20)];
    [path1 addLineToPoint:CGPointMake(WIDTH-20, HEIGHT-20)];
    
    CGFloat aliginW = (WIDTH-40)/5;
    CGFloat lineH = 5;
    for (int i = 1; i<=4; i++) {
        [path1 moveToPoint:CGPointMake(20+aliginW*i, HEIGHT-20)];
        [path1 addLineToPoint:CGPointMake(20+aliginW*i, HEIGHT-20-lineH)];
    }
    
    [path1 moveToPoint:CGPointMake(20, HEIGHT/2+64+20)];
    [path1 addLineToPoint:CGPointMake(20+10, HEIGHT/2+64+20)];
    
    CAShapeLayer* layer = [CAShapeLayer layer];
    layer.path = path1.CGPath;
    layer.strokeColor = [UIColor grayColor].CGColor;
    layer.lineWidth = 2;
    
    [self.view.layer addSublayer:layer];
    
    CATextLayer* textLayer = [CATextLayer layer];
    textLayer.string = @"1200卡路里";
    textLayer.fontSize = 12;
    textLayer.bounds = CGRectMake(0, 0, 100, 100);
    textLayer.foregroundColor = UIColorFromRGB(0x43B5FE).CGColor;
    textLayer.contentsScale = [UIScreen mainScreen].scale;
    textLayer.position = CGPointMake(20+10+55, HEIGHT/2+64+60);
    [self.view.layer addSublayer:textLayer];


}

/**
 *  画健康数据界面
 */
-(void)drawRecord{
    if (_recordLayer) {
        [_recordLayer removeFromSuperlayer];
    }
    CGFloat lineHight = HEIGHT-20-(64+HEIGHT/2+10);
    CGFloat lineWidth = WIDTH-40;
    CGFloat aliginW = lineWidth/(5*7);
    UIBezierPath* recordPath = [UIBezierPath bezierPath];
    _recordLayer = [CAShapeLayer layer];
    for (int i = 1; i<self.kcalArr.count; i++) {
        CGFloat recordH = [self.kcalArr[i] intValue]*lineHight/1200;
        NSLog(@"%f",recordH);
        [recordPath moveToPoint:CGPointMake(20+aliginW*i, HEIGHT-20)];
        [recordPath addLineToPoint:CGPointMake(20+aliginW*i, HEIGHT-20-recordH)];
    }
    _recordLayer.path = recordPath.CGPath;
    _recordLayer.strokeColor =  UIColorFromRGB(0x43B5FE).CGColor;
    _recordLayer.lineWidth = 4;
    _recordLayer.lineCap = kCALineCapRound;
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animation.fromValue = @(0.0);
    animation.toValue = @(1.0);
    animation.autoreverses = NO;
    animation.duration = 0.8;
    
    [_recordLayer addAnimation:animation forKey:nil];
    [self.view.layer addSublayer:_recordLayer];
    
}

/**
 *  画跑步数据界面
 */
-(void)drawRunRecord{
    if (_runRecordLayer) {
        [_runRecordLayer removeFromSuperlayer];
    }
    CGFloat lineHight = HEIGHT-20-(64+HEIGHT/2+10);
    CGFloat lineWidth = WIDTH-40;
    CGFloat aliginW = lineWidth/(5*7);
    UIBezierPath* recordPath = [UIBezierPath bezierPath];
    _runRecordLayer = [CAShapeLayer layer];
    for (int i = 1; i<self.runKcalArr.count; i++) {
        int value = [self.runKcalArr[i] intValue];
        if (value>0) {
            CGFloat recordH = value*lineHight/1200;
            [recordPath moveToPoint:CGPointMake(20+aliginW*i, HEIGHT-20)];
            [recordPath addLineToPoint:CGPointMake(20+aliginW*i, HEIGHT-20-recordH)];
        }
    }
    _runRecordLayer.path = recordPath.CGPath;
    _runRecordLayer.strokeColor =  UIColorFromRGB(0x3D4FBB).CGColor;
    _runRecordLayer.lineWidth = 4;
    _runRecordLayer.lineCap = kCALineCapRound;
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animation.fromValue = @(0.0);
    animation.toValue = @(1.0);
    animation.autoreverses = NO;
    animation.duration = 0.2;
    
    [_runRecordLayer addAnimation:animation forKey:nil];
    [self.view.layer addSublayer:_runRecordLayer];
}


#pragma mark - getter and setter
-(HealthKitManager *)manager{
    if (!_manager) {
        _manager = [[HealthKitManager alloc]init];
    }
    return _manager;
}

-(RecordManager *)recordManager{
    if (!_recordManager) {
        _recordManager = [[RecordManager alloc]init];
    }
    return _recordManager;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (IBAction)openDrawer:(UIButton *)sender {
    [[AppDelegate globalDelegate].UIProcess toggleLeftDrawer:self animated:YES];
}

@end
