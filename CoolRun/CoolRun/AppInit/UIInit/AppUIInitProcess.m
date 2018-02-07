//
//  AppUIInitProcess.m
//  CoolRun
//
//  Created by 蔡欣东 on 16/5/29.
//  Copyright © 2016年 蔡欣东. All rights reserved.
//

#import "AppUIInitProcess.h"

static NSString* SELECTVC = @"SelectViewController";

static NSString* FIRSTVC = @"HomeViewController";


@interface AppUIInitProcess()

@property(nonatomic, strong)UIViewController* selectViewController;

@property(nonatomic, strong)UIViewController* firstViewController;

@end

@implementation AppUIInitProcess

- (instancetype)initWithApplication:(UIApplication *)application andLaunchOption:(NSDictionary *)option{
    if (self = [super init]) {
        [self initUIWithApplication:application];
    }
    return self;
}


- (void)initUIWithApplication:(UIApplication*)application{
    application.delegate.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    application.delegate.window.rootViewController = self.drawController;
    
    self.drawController.leftViewController = self.selectViewController;
    self.drawController.centerViewController = self.firstViewController;
    self.drawController.leftDrawerWidth = WIDTH/2;
    self.drawController.animator = self.drawerAnimator;
    self.drawController.backgroundImage = [UIImage imageNamed:@"run.jpg"];
    UIView* backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    backView.backgroundColor = [UIColor blackColor];
    backView.alpha = 0.5;
    [self.drawController.view insertSubview:backView atIndex:1];
    
    UserStatusManager *userManager = [UserStatusManager shareManager];
    
    if ([userManager.isLogin boolValue]) {
        [[CoreDataManager shareManager] switchToDatabase:[Utils md5:userManager.userModel.username]];
    }else {
        [[CoreDataManager shareManager] switchToTempDatabase];
    }
    
    [application.delegate.window makeKeyAndVisible];
}

- (void)toggleLeftDrawer:(id)sender animated:(BOOL)animated {
    [self.drawController toggleDrawerWithSide:JVFloatingDrawerSideLeft animated:animated completion:nil];
}

#pragma mark - getter and setter
- (JVFloatingDrawerViewController *)drawController{
    if (!_drawController) {
        _drawController = [[JVFloatingDrawerViewController alloc]init];
    }
    return _drawController;
}

- (JVFloatingDrawerSpringAnimator *)drawerAnimator{
    if (!_drawerAnimator) {
        _drawerAnimator = [[JVFloatingDrawerSpringAnimator alloc]init];
    }
    return _drawerAnimator;
}

- (UIStoryboard *)mainStroyboard{
    if (!_mainStroyboard) {
        _mainStroyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    }
    return _mainStroyboard;
}

- (UIViewController *)selectViewController{
    if (!_selectViewController) {
        _selectViewController = [self.mainStroyboard instantiateViewControllerWithIdentifier:SELECTVC];
    }
    return _selectViewController;
}

- (UIViewController *)firstViewController{
    if (!_firstViewController) {
        _firstViewController = [self.mainStroyboard instantiateViewControllerWithIdentifier:FIRSTVC];
    }
    return _firstViewController;
}

@end
