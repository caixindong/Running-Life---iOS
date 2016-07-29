//
//  RankTableViewCell.h
//  CoolRun
//
//  Created by 蔡欣东 on 16/5/31.
//  Copyright © 2016年 蔡欣东. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RankingUserModel.h"

@interface RankTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *rankLable;
@property (weak, nonatomic) IBOutlet UIImageView *userImg;
@property (weak, nonatomic) IBOutlet UILabel *username;
@property (weak, nonatomic) IBOutlet UILabel *userKcal;

- (void)showUIWithModel:(RankingUserModel *)model;

+(CGFloat)heigthOgCell;

@end
