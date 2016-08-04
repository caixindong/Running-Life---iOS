//
//  RecordShowView.h
//  CoolRun
//
//  Created by 蔡欣东 on 2016/8/3.
//  Copyright © 2016年 蔡欣东. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  记录显示界面
 */
@interface RecordShowView : UIView
/**
 *  界限值
 */
@property (nonatomic, copy, readwrite)NSString *limmitValue;

/**
 *  普通记录(蓝色表示)
 */
@property (nonatomic, copy, readwrite)NSArray *normalRecords;

/**
 *  特殊记录()
 */
@property (nonatomic, copy, readwrite)NSArray *specialRecords;

@end
