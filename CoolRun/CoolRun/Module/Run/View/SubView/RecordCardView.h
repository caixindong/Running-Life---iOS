//
//  RecordCardView.h
//  CoolRun
//
//  Created by 蔡欣东 on 2016/8/23.
//  Copyright © 2016年 蔡欣东. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ResultViewModel.h"

@interface RecordCardView : UIView

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@property (weak, nonatomic) IBOutlet UILabel *kcalLabel;

@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UILabel *pageLabel;

@property (weak, nonatomic) IBOutlet UILabel *rankLabel;

@property (weak, nonatomic) IBOutlet UILabel *spendCountLabel;

@property (weak, nonatomic) IBOutlet UIImageView *userImageView;

@property (weak, nonatomic) IBOutlet UILabel *nameLable;

- (void)configureViewWithViewModel:(ResultViewModel *)viewModel;

@end
