//
//  MathController.m
//  CoolRun
//
//  Created by 蔡欣东 on 16/5/6.
//  Copyright © 2016年 蔡欣东. All rights reserved.
//

#import "MathController.h"

static bool const isMetric = YES;
static float const metersInKM = 1000;
static float const metersInMile = 1609.344;

@implementation MathController
+ (NSString *)stringifyDistance:(float)meters {
    NSString* result;
    float km  = meters/1000;
    if (km<10) {
        result = [NSString stringWithFormat:@"%.2f",km];
    }else if (km<100){
        result = [NSString stringWithFormat:@"%.1f",km];
    }else if (km<1000){
        result = [NSString stringWithFormat:@"%d",(int)km];
    }else if (km<10000){
        result = [NSString stringWithFormat:@"%.2fk",km/1000];
    }else if (km<100000){
        result = [NSString stringWithFormat:@"%.1fk",km/1000];
    }else{
        result = [NSString stringWithFormat:@"%.1fk",km/1000];
    }
    
    return result;
    
}

+ (NSString *)stringifySecondCount:(int)seconds usingLongFormat:(BOOL)longFormat {
    int remainingSeconds = seconds;
    int hours = remainingSeconds / 3600;
    remainingSeconds = remainingSeconds - hours * 3600;
    int minutes = remainingSeconds / 60;
    remainingSeconds = remainingSeconds - minutes * 60;
    
    if (longFormat) {
        if (hours > 0) {
            return [NSString stringWithFormat:@"%ihr %imin %isec", hours, minutes, remainingSeconds];
        } else if (minutes > 0) {
            return [NSString stringWithFormat:@"%imin %isec", minutes, remainingSeconds];
        } else {
            return [NSString stringWithFormat:@"%isec", remainingSeconds];
        }
    } else {
        if (hours > 0) {
            return [NSString stringWithFormat:@"%02i:%02i:%02i", hours, minutes, remainingSeconds];
        } else if (minutes > 0) {
            return [NSString stringWithFormat:@"%02i:%02i", minutes, remainingSeconds];
        } else {
            return [NSString stringWithFormat:@"00:%02i", remainingSeconds];
        }
    }
}

+ (NSString *)stringifyAvgPaceFromDist:(float)meters overTime:(int)seconds {
    if (seconds == 0 || meters == 0) {
        return @"0'00''/km";
    }
    
    float avgPaceSecMeters = seconds / meters;
    
    float unitMultiplier;
    NSString *unitName;
    
    // 公制
    if (isMetric) {
        unitName = @"/km";
        unitMultiplier = metersInKM;
        // 美国
    } else {
        unitName = @"/mi";
        unitMultiplier = metersInMile;
    }
    
    int paceMin = (int) ((avgPaceSecMeters * unitMultiplier) / 60);
    int paceSec = (int) (avgPaceSecMeters * unitMultiplier - (paceMin*60));
    
    return [NSString stringWithFormat:@"%i'%02i''%@", paceMin, paceSec,unitName];
}

+ (NSString *)stringifyKcalFromDist:(float)meters withWeight:(float)weight {
    float kcal = weight*meters/1000*1.036;
    NSString* result;
    if (kcal<100) {
        result = [NSString stringWithFormat:@"%.1f",kcal];
    }else if (kcal<1000){
        result = [NSString stringWithFormat:@"%d",(int)kcal];
    }else if (kcal<10000){
        result = [NSString stringWithFormat:@"%.2fk",kcal/1000];
    }else if(kcal<100000){
        result = [NSString stringWithFormat:@"%.1fk",kcal/1000];
    }else if (kcal<1000000){
        result = [NSString stringWithFormat:@"%dk",(int)(kcal/1000)];
    }else if (kcal<10000000){
        result = [NSString stringWithFormat:@"%.2fM",kcal/1000000];
    }else{
        result = [NSString stringWithFormat:@"%.2fM",kcal/1000000];
    }
    return result;
}

+ (NSArray *)colorSegmentsForLocations:(NSArray *)locations {
    NSMutableArray *speeds = [NSMutableArray array];
    double slowestSpeed = DBL_MAX;
    double fastestSpeed = 0.0;
    
    for (int i = 1; i < locations.count; i++) {
        Location *firstLoc = [locations objectAtIndex:(i-1)];
        Location *secondLoc = [locations objectAtIndex:i];
        
        CLLocation *firstLocCL = [[CLLocation alloc] initWithLatitude:firstLoc.latitude.doubleValue longitude:firstLoc.longtitude.doubleValue];
        CLLocation *secondLocCL = [[CLLocation alloc] initWithLatitude:secondLoc.latitude.doubleValue longitude:secondLoc.longtitude.doubleValue];
        
        double distance = [secondLocCL distanceFromLocation:firstLocCL];
        double time = [secondLoc.timestamp timeIntervalSinceDate:firstLoc.timestamp];
        double speed = distance/time;
        
        slowestSpeed = speed < slowestSpeed ? speed : slowestSpeed;
        fastestSpeed = speed > fastestSpeed ? speed : fastestSpeed;
        
        [speeds addObject:@(speed)];
        
    }
    
    double meanSpeed = (slowestSpeed + fastestSpeed)/2;
    
    // 慢的用红色
    CGFloat r_red = 139/255.0f;
    CGFloat r_green = 254/255.0f;
    CGFloat r_blue = 132/255.0f;
    
    // 不快不慢的用黄色
    CGFloat y_red = 101/255.0f;
    CGFloat y_green = 254/255.0f;
    CGFloat y_blue = 249/255.0f;
    
    // 快的用绿色
    CGFloat g_red = 67/255.0f;
    CGFloat g_green = 181/255.0f;
    CGFloat g_blue = 254/255.0f;
    
    NSMutableArray *colorSegments = [NSMutableArray array];
    
    for (int i = 1; i < locations.count; i++) {
        Location* firstLoc = [locations objectAtIndex:(i-1)];
        Location* secondLoc = [locations objectAtIndex:i];
        
        CLLocationCoordinate2D coords[2];
        coords[0].latitude = firstLoc.latitude.doubleValue;
        coords[0].longitude = firstLoc.longtitude.doubleValue;
        
        coords[1].latitude = secondLoc.latitude.doubleValue;
        coords[1].longitude = secondLoc.longtitude.doubleValue;
        
        NSNumber * speed = [speeds objectAtIndex:(i-1)];
        UIColor * color = [UIColor blackColor];
        
        // between red and yellow
        if (speed.doubleValue < meanSpeed) {
            double ratio = (speed.doubleValue - slowestSpeed) / (meanSpeed - slowestSpeed);
            CGFloat red = r_red + ratio * (y_red - r_red);
            CGFloat green = r_green + ratio * (y_green - r_green);
            CGFloat blue = r_blue + ratio * (y_blue - r_blue);
            color = [UIColor colorWithRed:red green:green blue:blue alpha:1.0f];
            
            // between yellow and green
        } else {
            double ratio = (speed.doubleValue - meanSpeed) / (fastestSpeed - meanSpeed);
            CGFloat red = y_red + ratio * (g_red - y_red);
            CGFloat green = y_green + ratio * (g_green - y_green);
            CGFloat blue = y_blue + ratio * (g_blue - y_blue);
            color = [UIColor colorWithRed:red green:green blue:blue alpha:1.0f];
        }
        
        MultiColorPolyline *segment = [MultiColorPolyline polylineWithCoordinates:coords count:2];
        segment.color = color;
        
        [colorSegments addObject:segment];
    }
    
    return colorSegments;
}
@end
