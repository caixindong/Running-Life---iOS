//
//  RankTableViewCell.h
//  CoolRun
//
//  Created by 蔡欣东 on 16/5/31.
//  Copyright © 2016年 蔡欣东. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RankingUserModel.h"

/**
 *  排名cell
 */
@interface RankTableViewCell : UITableViewCell

/**
 *  排名
 */
@property (weak, nonatomic) IBOutlet UILabel *rankLable;

/**
 *  用户头像
 */
@property (weak, nonatomic) IBOutlet UIImageView *userImg;

/**
 *  用户名
 */
@property (weak, nonatomic) IBOutlet UILabel *username;

/**
 *  用户消耗卡路里
 */
@property (weak, nonatomic) IBOutlet UILabel *userKcal;

/**
 *  显示cell
 *
 *  @param model
 */
- (void)showUIWithModel:(RankingUserModel *)model;

/**
 *  cell高度
 *
 *  @return 
 */
+(CGFloat)heigthOgCell;

@end
