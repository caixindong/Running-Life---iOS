//
//  Utils.m
//  CoolRun
//
//  Created by 蔡欣东 on 16/5/26.
//  Copyright © 2016年 蔡欣东. All rights reserved.
//

#import "Utils.h"

@implementation Utils

+(UIImage *)imageWithImage:(UIImage *)image scaleToSize :(CGSize )newSize{
    UIGraphicsBeginImageContext(newSize);
    
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
}

+(NSString *)getDeviceName{
    int height = (int)[UIScreen mainScreen].bounds.size.height;
    switch (height) {
        case 568:
            return @"5";
            break;
        case 667:
            return @"6";
            break;
        case 736:
            return @"6+";
            break;
        case 480:
            return @"4";
            break;
        default:
            return @"unknown";
            break;
    }
    
}

+(void)showTextHUDWithText:(NSString *)text addToView:(UIView *)view{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.label.text = text;
    [hud hideAnimated:YES afterDelay:1.f];
}

@end
