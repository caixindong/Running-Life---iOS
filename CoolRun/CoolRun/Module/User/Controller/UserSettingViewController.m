//
//  UserSettingViewController.m
//  CoolRun
//
//  Created by 蔡欣东 on 16/5/25.
//  Copyright © 2016年 蔡欣东. All rights reserved.
//

#import "UserSettingViewController.h"
#import "UserSettingViewModel.h"
@interface UserSettingViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *sexLable;
@property (weak, nonatomic) IBOutlet UILabel *birthDayLabel;
@property (weak, nonatomic) IBOutlet UILabel *heightLabel;
@property (weak, nonatomic) IBOutlet UILabel *weightLabel;
@property (weak, nonatomic) IBOutlet UIImageView *headPic;
@property (weak, nonatomic) IBOutlet UILabel *realnameLabel;
@property (weak, nonatomic) IBOutlet UILabel *usernameLable;
@property(nonatomic,strong)UserSettingViewModel* viewModel;
@property(nonatomic,strong)MBProgressHUD* hud;
@property(nonatomic,strong)UserModel* user;
@end

@interface UserSettingViewController (private)
/**
 * 打开相册
 **/
-(void)openAlbum;

/**
 * 打开相机
 **/
-(void)openCamera;

/**
 * 刷新user model
 **/
-(void)refreshUserModelInUserDefault;
@end


@implementation UserSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UserStatusManager *manager = [UserStatusManager shareManager];
    
    _user = manager.userModel;
    
    [self.KVOController observe:manager keyPath:@"haveChangeInfo" options:NSKeyValueObservingOptionNew block:^(id observer, id object, NSDictionary *change) {
        NSLog(@"1");
        if (manager.haveChangeInfo.boolValue) {
            _realnameLabel.text = manager.userModel.realname;
            _usernameLable.text = manager.userModel.username;
            _sexLable.text = manager.userModel.sex;
            _birthDayLabel.text = manager.userModel.birth;
            _heightLabel.text = [NSString stringWithFormat:@"%@",manager.userModel.height];
            _weightLabel.text = [NSString stringWithFormat:@"%@",manager.userModel.weight];
            [_headPic sd_setImageWithURL:[NSURL URLWithString:manager.userModel.avatar] placeholderImage:[UIImage imageNamed:@"defaultHeadPic.png"]];
        }
    }];
    
    manager.haveChangeInfo = @YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark - UIImagePickerControllerDelegate

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    NSLog(@"edit");
    UIImage* image = [info objectForKey:UIImagePickerControllerEditedImage];
    UIImage* smallImage = [Utils imageWithImage:image scaleToSize:CGSizeMake(100.0, 100.0)];
    NSData* data = UIImagePNGRepresentation(smallImage);
    dispatch_async(dispatch_get_main_queue(), ^{
        _headPic.image = smallImage;
    });
    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self.viewModel uploadImageToServer:data withSuccessBlock:^(id returnValue) {
        [_hud hideAnimated:YES];
        NSLog(@"url is %@",returnValue);
    } failWithError:^(id errorCode) {
        NSLog(@"error is %@",errorCode);
        [_hud hideAnimated:YES];
    } failWithNetworkWithBlock:^{
        [Utils showTextHUDWithText:@"请检查网络" addToView:self.view];
        [_hud hideAnimated:YES];
    }];
    
   
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - event
- (IBAction)closeBtnClick:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)changeHeadPic:(UIButton *)sender {
    UIAlertController* actionSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction* fromPhoto = [UIAlertAction actionWithTitle:@"从相册中获取" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self openAlbum];
    }];
    UIAlertAction* fromCamera = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self openCamera];
    }];
    UIAlertAction* cancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [actionSheet addAction:fromPhoto];
    [actionSheet addAction:fromCamera];
    [actionSheet addAction:cancle];
    [self presentViewController:actionSheet animated:YES completion:nil];
}




- (IBAction)changeSex:(UIButton *)sender {
    [ActionSheetStringPicker showPickerWithTitle:nil rows:@[@"男",@"女"] initialSelection:0 doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
        self.sexLable.text = [NSString stringWithFormat:@"%@",selectedValue];
        _user.sex = _sexLable.text;
        [self.viewModel postUserSettingWithUserInfo:_user withSuccessBlock:^(id returnValue) {
            NSLog(@"改性别成功");
            [self refreshUserModelInUserDefault];
        } failWithError:^(id errorCode) {
            NSLog(@"error si %@",errorCode);
        } failWithNetworkWithBlock:^{
            NSLog(@"no net");
        }];
        
    } cancelBlock:^(ActionSheetStringPicker *picker) {
        
    } origin:self.view];
}

- (IBAction)changeBirthDay:(UIButton *)sender {
    [ActionSheetDatePicker showPickerWithTitle:nil datePickerMode:UIDatePickerModeDate selectedDate:[NSDate date] doneBlock:^(ActionSheetDatePicker *picker, id selectedDate, id origin) {
        NSDate* date = (NSDate*)selectedDate;
        NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
        formatter.dateFormat = @"yyyy-MM-dd";
        NSString* dateStr = [formatter stringFromDate:date];
        self.birthDayLabel.text = dateStr;
        
        _user.birth = _birthDayLabel.text;
        [self.viewModel postUserSettingWithUserInfo:_user withSuccessBlock:^(id returnValue) {
            NSLog(@"改生日成功");
            [self refreshUserModelInUserDefault];
        } failWithError:^(id errorCode) {
            NSLog(@"error si %@",errorCode);
        } failWithNetworkWithBlock:^{
            NSLog(@"no net");
        }];
    } cancelBlock:^(ActionSheetDatePicker *picker) {
        
    } origin:self.view];
}

- (IBAction)changeHeight:(UIButton *)sender {
    NSMutableArray* heightArr = [NSMutableArray arrayWithCapacity:250];
    for (int i = 60; i<310; i++) {
        [heightArr addObject:[NSString stringWithFormat:@"%dcm",i]];
    }
    [ActionSheetStringPicker showPickerWithTitle:nil rows:heightArr initialSelection:100 doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
        self.heightLabel.text = [NSString stringWithFormat:@"%@",selectedValue];
        _user.height = _heightLabel.text;
        [self.viewModel postUserSettingWithUserInfo:_user withSuccessBlock:^(id returnValue) {
            NSLog(@"改身高成功");
             [self refreshUserModelInUserDefault];
        } failWithError:^(id errorCode) {
            NSLog(@"error si %@",errorCode);
        } failWithNetworkWithBlock:^{
            NSLog(@"no net");
        }];
    } cancelBlock:^(ActionSheetStringPicker *picker) {
        
    } origin:self.view];
}

- (IBAction)changeWeight:(UIButton *)sender {
    NSMutableArray* weightArr = [NSMutableArray arrayWithCapacity:250];
    for (int i = 30; i<300; i++) {
        [weightArr addObject:[NSString stringWithFormat:@"%dkg",i]];
    }
    [ActionSheetStringPicker showPickerWithTitle:nil rows:weightArr initialSelection:20 doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
        self.weightLabel.text = [NSString stringWithFormat:@"%@",selectedValue];
        _user.weight = _weightLabel.text;
        [self.viewModel postUserSettingWithUserInfo:_user withSuccessBlock:^(id returnValue) {
            NSLog(@"改体重成功");
             [self refreshUserModelInUserDefault];
        } failWithError:^(id errorCode) {
            NSLog(@"error si %@",errorCode);
        } failWithNetworkWithBlock:^{
            NSLog(@"no net");
        }];
    } cancelBlock:^(ActionSheetStringPicker *picker) {
        
    } origin:self.view];
}

- (IBAction)changeName:(UIButton *)sender {
    UIViewController *nvc = [self.storyboard instantiateViewControllerWithIdentifier:@"NameEditViewController"];
    [self presentViewController:nvc animated:YES completion:nil];
}

#pragma mark - setter and setter
-(UserSettingViewModel *)viewModel{
    if (!_viewModel) {
        _viewModel = [[UserSettingViewModel alloc]init];
    }
    return _viewModel;
}

@end

@implementation UserSettingViewController (private)



-(void)openAlbum{
    UIImagePickerController* picker = [[UIImagePickerController alloc]init];
    picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.allowsEditing = YES;
    picker.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:picker animated:YES completion:nil];
}

-(void)openCamera{
    UIImagePickerController* picker = [[UIImagePickerController alloc]init];
    picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    picker.allowsEditing = YES;
    picker.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:picker animated:YES completion:nil];
}

-(void)refreshUserModelInUserDefault{
    UserStatusManager *manager = [UserStatusManager shareManager];
    [[MyUserDefault shareUserDefault] storeValue:_user withKey:USER];
     manager.haveChangeInfo = @YES;
}
@end
