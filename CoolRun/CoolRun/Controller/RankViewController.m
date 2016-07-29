//
//  RankViewController.m
//  CoolRun
//
//  Created by 蔡欣东 on 16/5/31.
//  Copyright © 2016年 蔡欣东. All rights reserved.
//

#import "RankViewController.h"
#import "RankTableViewCell.h"
#import "RankTableHeaderView.h"
#import "RankViewModel.h"

static NSString *const CELLID = @"RankTableViewCell";

@interface RankViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@property (nonatomic, strong) RankTableHeaderView *headView;

//@property (nonatomic, copy) NSArray *usernameArr;
//
//@property (nonatomic, copy) NSArray *userPicArr;
//
//@property (nonatomic, copy) NSArray *userKcalArr;
//
//@property (nonatomic, copy) NSArray *userRankArr;

@property (nonatomic, copy) NSArray *dataArray;

@property (nonatomic, strong)RankViewModel *viewModel;

@property (nonatomic, strong)MJRefreshNormalHeader *header;

@property (nonatomic, strong)MJRefreshAutoNormalFooter *footer;
@end

@implementation RankViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self initTableView];
    
    
    [self.KVOController observe:self.viewModel
                        keyPath:@"haveRefresh"
                        options:NSKeyValueObservingOptionNew
                          block:^(id observer, id object, NSDictionary *change) {
                              NSLog(@"get data");
                              if ([self.viewModel.haveRefresh boolValue]) {
                                  [_header endRefreshing];
                                  
                                  [_footer endRefreshing];
                                  
                                  _dataArray = _viewModel.dataArray;
                                  
                                  [_myTableView reloadData];
                              }
                              
                          }];
    
    [self.KVOController observe:self.viewModel
                        keyPath:@"fail"
                        options:NSKeyValueObservingOptionNew
                          block:^(id observer, id object, NSDictionary *change) {
                              if (self.viewModel.fail) {
                                  [_header endRefreshing];
                                  
                                  [_footer endRefreshing];
                                  
                              }
                          }];
    
    [self.header beginRefreshing];
    
//    _usernameArr = @[@"蔡欣东",@"尹子韶",@"钟鑫基",@"宦小明",@"关哲伦"];
//    _userKcalArr = @[@"1000卡路里",@"900卡路里",@"820卡路里",@"800卡路里",@"600卡路里"];
//    _userPicArr = @[@"head1",@"head2",@"head3",@"head4",@"head5"];
//    _userRankArr = @[@"1",@"2",@"3",@"4",@"4"];
}

#pragma mark - private

- (void)initTableView {
    [_myTableView registerNib:[UINib nibWithNibName:CELLID bundle:nil] forCellReuseIdentifier:CELLID];
    
    _myTableView.rowHeight = [RankTableViewCell heigthOgCell];
    
    [self.headView setFrame:CGRectMake(0, 0, WIDTH, [RankTableHeaderView heightOfRankTableHeaderView])];
    
    _myTableView.tableHeaderView = self.headView;
    
    _myTableView.mj_header = self.header;
    
    _myTableView.mj_footer = self.footer;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    RankTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:CELLID];
    
    [cell showUIWithModel:_dataArray[indexPath.row]];
    
    return cell;
}

#pragma mark - UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [RankTableViewCell heigthOgCell];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark - event response
- (IBAction)closeBtnClick:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - getter and setter
-(RankTableHeaderView *)headView{
    if (!_headView) {
        _headView = [[RankTableHeaderView alloc]init];
    }
    return _headView;
}

- (MJRefreshNormalHeader *)header{
    if (!_header) {
        _header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            NSString *date = [[NSDate date] convertToStringWithWeek];
            
            [_viewModel getRankDataWithDate:date];
        }];
        
        _header.lastUpdatedTimeLabel.hidden = YES;
    }
    return _header;
}

- (MJRefreshAutoFooter *)footer{
    if (!_footer) {
        _footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            NSString *date = [[NSDate date] convertToStringWithWeek];
            
            [_viewModel getMoreRankDataWithDate:date];
            
        }];
        [_footer setTitle:@"点击加载更多" forState:MJRefreshStateIdle];
        
        [_footer setTitle:@"加载中" forState:MJRefreshStateRefreshing];
        
        [_footer setTitle:@"没有更多的数据了..." forState:MJRefreshStateNoMoreData];
    }
    return _footer;
}

- (RankViewModel *)viewModel {
    if (!_viewModel) {
         _viewModel = [[RankViewModel alloc] init];
    }
    return _viewModel;
}
    
@end

