//
//  ShareMapView.m
//  CoolRun
//
//  Created by 蔡欣东 on 2016/9/6.
//  Copyright © 2016年 蔡欣东. All rights reserved.
//

#import "ShareMapView.h"

@implementation ShareMapView

+ (ShareMapView *)shareMapView {
    static ShareMapView *mapView;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mapView = [[ShareMapView alloc] init];
    });
    return mapView;
}

@end
