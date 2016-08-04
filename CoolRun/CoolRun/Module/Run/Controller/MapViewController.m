//
//  MapViewController.m
//  CoolRun
//
//  Created by 蔡欣东 on 16/5/10.
//  Copyright © 2016年 蔡欣东. All rights reserved.
//

#import "MapViewController.h"

@interface MapViewController ()<MKMapViewDelegate,AMapLocationManagerDelegate>

/**
 *  地图
 */
@property (weak, nonatomic, readwrite) IBOutlet MKMapView *myMapView;

/**
 *  定位管理器
 */
@property (nonatomic, strong, readwrite) AMapLocationManager* locationManager;

/**
 *  记录位置的数组
 */
@property (nonatomic, strong, readwrite) NSMutableArray* locations;

/**
 *  是否第一次定位
 */
@property(nonatomic, assign, readwrite)BOOL firstLocate;

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [_myMapView setShowsUserLocation:YES];
    
    _firstLocate = YES;
    
    [self.locationManager startUpdatingLocation];
}

#pragma mark - AMapLocationManagerDelegate

- (void)amapLocationManager:(AMapLocationManager *)manager didFailWithError:(NSError *)error {
    [_locationManager stopUpdatingLocation];
}

- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location {
    
    if (location.horizontalAccuracy < 30) {
        _firstLocate = NO;
        NSDate *eventDate = location.timestamp;
        
        NSTimeInterval howRecent = [eventDate timeIntervalSinceNow];
        if (fabs(howRecent) < 2.0 && location.horizontalAccuracy < 30) {
            
            if (self.locations.count > 0) {
                
                CLLocationCoordinate2D coords[2];
                coords[0] = ((CLLocation *)self.locations.lastObject).coordinate;
                coords[1] = location.coordinate;
                
                MKCoordinateRegion region =
                MKCoordinateRegionMakeWithDistance(location.coordinate, 500, 500);
                [self.myMapView setRegion:region animated:YES];
                
                [self.myMapView addOverlay:[MKPolyline polylineWithCoordinates:coords count:2]];
            }
            
            [self.locations addObject:location];
        }
    }else{
        if (_firstLocate) {
            MKCoordinateRegion region =
            MKCoordinateRegionMakeWithDistance(location.coordinate, 500, 500);
            [self.myMapView setRegion:region animated:YES];
            _firstLocate = NO;
        }
        
    }
    
}

#pragma mark - MKMapViewDelegate
- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id < MKOverlay >)overlay {
    if ([overlay isKindOfClass:[MKPolyline class]]) {
        MKPolyline *polyLine = (MKPolyline *)overlay;
        MKPolylineRenderer *aRenderer = [[MKPolylineRenderer alloc] initWithPolyline:polyLine];
        aRenderer.strokeColor = UIColorFromRGB(0x43B5FE);
        aRenderer.lineWidth = 3;
        return aRenderer;
    }
    return nil;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark - event response

- (IBAction)closeBtn:(UIButton *)sender {
    self.view.transform = CGAffineTransformIdentity;
    
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.view.transform= CGAffineTransformMakeScale(0.01, 0.01);
        
    } completion:^(BOOL finished) {
        self.view.hidden = YES;
    }];
}

#pragma mark - getter and setter

- (void)setLocateEnable:(BOOL)locateEnable{
    if (locateEnable) {
        [self.locationManager startUpdatingLocation];
    }else{
        [self.locationManager stopUpdatingLocation];
    }
}

- (AMapLocationManager *)locationManager{
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

- (NSMutableArray *)locations{
    if (!_locations) {
        _locations = [NSMutableArray array];
    }
    return _locations;
}

@end
