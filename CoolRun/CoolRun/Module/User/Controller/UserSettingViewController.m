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

@end

@implementation UserSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self KVOHandler];
    
    self.viewModel.infoRefresh = @YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark - private
- (void)KVOHandler {
    [self.KVOController observe:self.viewModel keyPath:@"infoRefresh" options:NSKeyValueObservingOptionNew block:^(id observer, id object, NSDictionary *change) {
        self.viewModel.userModel    = [UserStatusManager shareManager].userModel;
        _realnameLabel.text         = self.viewModel.realnameLabelText;
        _usernameLable.text         = self.viewModel.usernameLableText;
        _sexLable.text              = self.viewModel.sexLabelText;
        _birthDayLabel.text         = self.viewModel.birthdayLabelText;
        _heightLabel.text           = self.viewModel.heightLabelText;
        _weightLabel.text           = self.viewModel.weightLabelText;
        [_headPic sd_setImageWithURL:[NSURL URLWithString:self.viewModel.userImgUrl] placeholderImage:[UIImage imageNamed:@"defaultHeadPic.png"] options:SDWebImageRefreshCached];
    }];
    
    [self.KVOController observe:self.viewModel keyPath:@"updateSuccessOrFail" options:NSKeyValueObservingOptionNew block:^(id observer, id object, NSDictionary *change) {
        [_hud hideAnimated:YES];
    }];
}

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

#pragma mark - UIImagePickerControllerDelegate

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    UIImage* image = [info objectForKey:UIImagePickerControllerEditedImage];
    UIImage* smallImage = [Utils imageWithImage:image scaleToSize:CGSizeMake(100.0, 100.0)];
    NSData* data = UIImagePNGRepresentation(smallImage);
    dispatch_async(dispatch_get_main_queue(), ^{
        _headPic.image = smallImage;
    });
    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.viewModel.imageData = data;
    [self.viewModel uploadAvatar];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - event response
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
        self.viewModel.sexLabelText = [NSString stringWithFormat:@"%@",selectedValue];
        [self.viewModel updateUserInfo];
    } cancelBlock:^(ActionSheetStringPicker *picker) {
        
    } origin:self.view];
}

- (IBAction)changeBirthDay:(UIButton *)sender {
    [ActionSheetDatePicker showPickerWithTitle:nil datePickerMode:UIDatePickerModeDate selectedDate:[NSDate date] doneBlock:^(ActionSheetDatePicker *picker, id selectedDate, id origin) {
        NSDate* date = (NSDate*)selectedDate;
        NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
        formatter.dateFormat = @"yyyy-MM-dd";
        NSString* dateStr = [formatter stringFromDate:date];
        self.viewModel.birthdayLabelText = dateStr;
        [self.viewModel updateUserInfo];
    } cancelBlock:^(ActionSheetDatePicker *picker) {
        
    } origin:self.view];
}

- (IBAction)changeHeight:(UIButton *)sender {
    NSMutableArray* heightArr = [NSMutableArray arrayWithCapacity:250];
    for (int i = 60; i<310; i++) {
        [heightArr addObject:[NSString stringWithFormat:@"%dcm",i]];
    }
    [ActionSheetStringPicker showPickerWithTitle:nil rows:heightArr initialSelection:100 doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
        self.viewModel.heightLabelText = [NSString stringWithFormat:@"%@",selectedValue];
        [self.viewModel updateUserInfo];
    } cancelBlock:^(ActionSheetStringPicker *picker) {
        
    } origin:self.view];
}

- (IBAction)changeWeight:(UIButton *)sender {
    NSMutableArray* weightArr = [NSMutableArray arrayWithCapacity:250];
    for (int i = 30; i<300; i++) {
        [weightArr addObject:[NSString stringWithFormat:@"%dkg",i]];
    }
    [ActionSheetStringPicker showPickerWithTitle:nil rows:weightArr initialSelection:20 doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
        self.viewModel.weightLabelText = [NSString stringWithFormat:@"%@",selectedValue];
        [self.viewModel updateUserInfo];
    } cancelBlock:^(ActionSheetStringPicker *picker) {
        
    } origin:self.view];
}

- (IBAction)changeName:(UIButton *)sender {
    UIViewController *nvc = [self.storyboard instantiateViewControllerWithIdentifier:@"NameEditViewController"];
    [nvc setValue:self.viewModel forKey:@"viewModel"];
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

