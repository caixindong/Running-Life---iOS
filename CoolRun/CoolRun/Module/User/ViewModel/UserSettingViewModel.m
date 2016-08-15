//
//  UserSettingViewModel.m
//  CoolRun
//
//  Created by 蔡欣东 on 16/5/26.
//  Copyright © 2016年 蔡欣东. All rights reserved.
//

#import "UserSettingViewModel.h"
#import "UserModel.h"

@interface UserSettingViewModel()

@property (nonatomic, strong, readwrite)NSNumber *updateSuccessOrFail;

@property (nonatomic, strong, readwrite)NSNumber *invalid;

@end

@implementation UserSettingViewModel

- (void)uploadAvatar {
    NSString* uid = [[NSUserDefaults standardUserDefaults]valueForKey:UID];
    NSString* token = [[NSUserDefaults standardUserDefaults]valueForKey:TOKEN];
    
    if (uid && token && self.imageData) {
        NSDictionary* params = @{@"token":token,
                                 @"id":uid,
                                 @"avatar":[NSString stringWithFormat:@"%@",self.imageData]};
        [XDNetworking postWithUrl:API_POST_IMG refreshRequest:YES cache:NO params:params progressBlock:nil successBlock:^(id response) {
            NSString *imgUrl = [NSString stringWithFormat:@"%@",response[@"avatar"]];
            self.userImgUrl = imgUrl;
            
            [self refreshLocalUserData];
            
            self.updateSuccessOrFail =  @YES;
        } failBlock:^(NSError *error) {
            self.updateSuccessOrFail =  @NO;
        }];
    }
}

- (void)updateUserInfo {
    if ([[self.realnameLabelText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]) {
        self.invalid = @YES;
        return;
    }
    
    NSString* uid = [[NSUserDefaults standardUserDefaults]valueForKey:UID];
    NSString* token = [[NSUserDefaults standardUserDefaults]valueForKey:TOKEN];
    if (uid && token && _userModel) {
        NSDictionary* params = @{
                                 @"id":uid,
                                 @"token":token,
                                 @"user_height":_userModel.height,
                                 @"user_weight":_userModel.weight,
                                 @"user_sex":_userModel.sex,
                                 @"user_birth":_userModel.birth,
                                 @"realname":_userModel.realname
                                 };
        [XDNetworking postWithUrl:API_CHANGE_INFO refreshRequest:YES cache:NO params:params progressBlock:nil successBlock:^(id response) {
            [self refreshLocalUserData];
            self.updateSuccessOrFail =  @YES;
        } failBlock:^(NSError *error) {
            self.updateSuccessOrFail =  @NO;
        }];
    }

}

- (void)refreshLocalUserData {
    UserStatusManager *manager = [UserStatusManager shareManager];
    [[MyUserDefault shareUserDefault] storeValue:_userModel withKey:USER];
    manager.haveChangeInfo = @YES;
    self.infoRefresh = @YES;
}

#pragma mark - getter and setter

- (NSString *)sexLabelText {
    return _userModel.sex;
}

- (NSString *)realnameLabelText {
    return _userModel.realname;
}

- (NSString *)usernameLableText {
    return _userModel.username;
}

- (NSString *)heightLabelText {
    return _userModel.height;
}

- (NSString *)weightLabelText {
    return _userModel.weight;
}

- (NSString *)birthdayLabelText {
    return _userModel.birth;
}

- (NSString *)userImgUrl {
    return _userModel.avatar;
}

- (void)setSexLabelText:(NSString *)sexLabelText {
    _userModel.sex  = sexLabelText;
}

- (void)setRealnameLabelText:(NSString *)realnameLabelText {
    _userModel.realname = realnameLabelText;
}

- (void)setUsernameLableText:(NSString *)usernameLableText {
    _userModel.username = usernameLableText;
}

- (void)setHeightLabelText:(NSString *)heightLabelText {
    _userModel.height = heightLabelText;
}

- (void)setWeightLabelText:(NSString *)weightLabelText {
    _userModel.weight = weightLabelText;
}

- (void)setBirthdayLabelText:(NSString *)birthdayLabelText {
    _userModel.birth = birthdayLabelText;
}

- (void)setUserImgUrl:(NSString *)userImgUrl {
    _userModel.avatar = userImgUrl;
}

@end
