//
//  DetailViewController.m
//  CoolRun
//
//  Created by 蔡欣东 on 16/5/17.
//  Copyright © 2016年 蔡欣东. All rights reserved.
//

#import "DetailViewController.h"
#import "ResultViewController.h"
@interface DetailViewController ()

@property (weak, nonatomic, readwrite) IBOutlet UILabel *nameLabel;

@property(nonatomic, strong, readwrite) UIScrollView* scrollView;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initScrollView];
    
    [self initContentView];
    
    [self KVOHandler];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - private

- (void)initScrollView {
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0,40, WIDTH, HEIGHT-40)];
    
    _scrollView.contentSize = CGSizeMake(WIDTH*_viewModel.runDatas.count, 0);
    
    _scrollView.pagingEnabled = YES;
    
    [self.view addSubview:_scrollView];
    
    [self.view sendSubviewToBack:_scrollView];
}

- (void)initContentView {
    [_viewModel.runDatas enumerateObjectsUsingBlock:^(Run* obj, NSUInteger idx, BOOL * _Nonnull stop) {
        ResultViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ResultViewController"];
        vc.run = obj;
        vc.hideNav = YES;
        UIView* cardView = vc.view;
        [self.scrollView addSubview: cardView];
        [cardView setFrame:CGRectMake(WIDTH*idx, 0, WIDTH, HEIGHT-60)];
    }];
    
    if (_viewModel.runDatas.count>0) self.nameLabel.text = [NSString stringWithFormat:@"1/%ld",(unsigned long)_viewModel.runDatas.count];

}

- (void)KVOHandler {
    [self.KVOController observe:self.scrollView keyPath:@"contentOffset" options:NSKeyValueObservingOptionNew block:^(id observer, id object, NSDictionary *change) {
        CGFloat x = self.scrollView.contentOffset.x;
        NSInteger page = x/WIDTH;
        self.nameLabel.text = [NSString stringWithFormat:@"%ld/%ld",page+1,(unsigned long)_viewModel.runDatas.count];
    }];
}

#pragma mark - event

- (IBAction)closeBtnClick:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)shareBtnClick:(UIButton *)sender {
    [UMSocialData defaultData].extConfig.wechatTimelineData.title = @"测试";
    [UMSocialData defaultData].extConfig.wechatSessionData.title = @"测试";
    [UMSocialData defaultData].extConfig.wechatSessionData.url = @"http://www.baidu.com";
    [UMSocialData defaultData].extConfig.wechatTimelineData.url = @"http://www.baidu.com";
    if (![[UIApplication sharedApplication]canOpenURL:[NSURL URLWithString:@"weixin://app/wx9f58f3e0c08f1f2a/"]]) {
        [UMSocialSnsService presentSnsIconSheetView:self
                                             appKey:nil
                                          shareText:@"测试"
                                         shareImage:nil
                                    shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,nil]
                                           delegate:nil];
    }else {
        [UMSocialSnsService presentSnsIconSheetView:self
                                             appKey:nil
                                          shareText:@"测试"
                                         shareImage:nil
                                    shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToWechatSession,UMShareToWechatTimeline,nil]
                                           delegate:nil];
        
    }
}



@end
