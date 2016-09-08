//
//  RunningMapViewModel.h
//  CoolRun
//
//  Created by 蔡欣东 on 2016/9/8.
//  Copyright © 2016年 蔡欣东. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RunningMapViewModel : NSObject

@property(nonatomic, assign, readwrite)MKCoordinateRegion region;

@property(nonatomic, strong, readwrite)MKPolyline *polyline;

@end
