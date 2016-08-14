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
@property (strong, nonatomic) UITableView *myTableView;

@property (nonatomic, strong) RankTableHeaderView *headView;

@property (nonatomic, strong)RankViewModel *viewModel;

@property (nonatomic, strong)XDRefreshHeader *header;

@property (nonatomic, strong)XDRefreshFooter *footer;

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
                              if ([self.viewModel.haveRefresh boolValue]) {
                                  [_header endRefreshing];
                                  
                                  [_footer endRefreshing];
                                  
                                  [_myTableView reloadData];
                              }
                              
                          }];
    
    [self.KVOController observe:self.viewModel
                        keyPath:@"fail"
                        options:NSKeyValueObservingOptionNew
                          block:^(id observer, id object, NSDictionary *change) {
                              if ([self.viewModel.fail boolValue]) {
                                  [_header endRefreshing];
                                  
                                  [_footer endRefreshing];
                              }
                          }];
    
    [self.header beginRefreshing];
}

#pragma mark - private

- (void)initTableView {
    _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT - 64) style:UITableViewStylePlain];
    
    [_myTableView registerNib:[UINib nibWithNibName:CELLID bundle:nil] forCellReuseIdentifier:CELLID];
    
    _myTableView.rowHeight = [RankTableViewCell heigthOgCell];
    
    [self.headView setFrame:CGRectMake(0, 0, WIDTH, [RankTableHeaderView heightOfRankTableHeaderView])];
    
    _myTableView.tableHeaderView = self.headView;
    
    _myTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    
    [self.view addSubview:_myTableView];
    
    [self header];
    
    [self footer];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.viewModel.dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    RankTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:CELLID];
    
    //[cell showUIWithModel:self.viewModel.dataArray[indexPath.row]];
    
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

- (XDRefreshHeader *)header{
    if (!_header) {
        _header = [XDRefreshHeader headerOfScrollView:self.myTableView refreshingBlock:^{
            NSString *date = [[NSDate date] convertToStringWithWeek];
            
            [_viewModel getRankDataWithDate:date];
        }];
    }
    return _header;
}

- (XDRefreshFooter *)footer{
    if (!_footer) {
        _footer = [XDRefreshFooter footerOfScrollView:self.myTableView refreshingBlock:^{
            NSString *date = [[NSDate date] convertToStringWithWeek];
            
            [_viewModel getMoreRankDataWithDate:date];
        }];
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

