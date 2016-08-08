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

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property(nonatomic,strong)UIScrollView* scrollView;

@property(nonatomic,strong)NSMutableArray* viewArr;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.scrollView];
    
    [self.view sendSubviewToBack:self.scrollView];
    
    [self initContentView];
    
    [self.scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld  context:nil];
}


-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.scrollView removeObserver:self forKeyPath:@"contentOffset"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"contentOffset"]) {
        CGFloat x = self.scrollView.contentOffset.x;
        NSLog(@"%f",x);
        NSInteger page = x/WIDTH;
        self.nameLabel.text = [NSString stringWithFormat:@"%ld/%ld",page+1,(unsigned long)self.viewArr.count];
    }
}

#pragma mark - private

- (void)initContentView {
    for (int i = 0; i<self.viewArr.count; i++) {
        UIView* cardView = self.viewArr[i];
        [self.scrollView addSubview: cardView];
        [cardView setFrame:CGRectMake(WIDTH*i,0, WIDTH, HEIGHT-60)];
    }
    
    if (self.viewArr.count>0) {
        self.nameLabel.text = [NSString stringWithFormat:@"1/%ld",(unsigned long)self.viewArr.count];
    }
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

#pragma mark - setter and getter
- (UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0,40, WIDTH, HEIGHT-40)];
        _scrollView.pagingEnabled = YES;
    }
    return _scrollView;
}

- (NSMutableArray *)viewArr{
    if (!_viewArr) {
        _viewArr = [NSMutableArray arrayWithCapacity:5];
    }
    return _viewArr;
}

- (void)setRunDataArray:(NSArray *)runDataArray{
     self.scrollView.contentSize = CGSizeMake(WIDTH*runDataArray.count, 0);
    
    for (Run* run in runDataArray) {
        ResultViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ResultViewController"];
        vc.run = run;
        vc.hideNav = YES;
        [self.viewArr addObject:vc.view];
    }
}

@end
