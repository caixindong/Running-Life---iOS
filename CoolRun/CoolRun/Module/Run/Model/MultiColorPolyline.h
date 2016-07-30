//
//  MultiColorPolyline.h
//  CoolRun
//
//  Created by 蔡欣东 on 16/5/20.
//  Copyright © 2016年 蔡欣东. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface MultiColorPolyline : MKPolyline

/**
 *  轨迹颜色
 */
@property(nonatomic,strong)UIColor* color;

@end
