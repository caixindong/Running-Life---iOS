//
//  RecordCardView.m
//  CoolRun
//
//  Created by 蔡欣东 on 2016/8/23.
//  Copyright © 2016年 蔡欣东. All rights reserved.
//

#import "RecordCardView.h"

@interface RecordCardView()<MKMapViewDelegate>

@end

@implementation RecordCardView

- (instancetype)init {
    if (self = [super init]) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"RecordCardView" owner:self options:nil] firstObject];
    }
    return self;
}

- (void)configureViewWithViewModel:(ResultViewModel *)viewModel {
    self.distanceLabel.text     = viewModel.distanceLabelText;
    
    self.timeLabel.text         = viewModel.timeLabelText;
    
    self.pageLabel.text         = viewModel.paceLabelText;
    
    self.kcalLabel.text         = viewModel.kcalLableText;
    
    self.spendCountLabel.text   = viewModel.countLabelText;
    
    self.mapView.delegate = self;
    
    [self.mapView setRegion: viewModel.region];
    
    [self.mapView addOverlays: viewModel.colorSegmentArray];
    
    UserStatusManager *manager = [UserStatusManager shareManager];
    if (manager.isLogin.boolValue) {
        
        [self.userImageView sd_setImageWithURL:[NSURL URLWithString:manager.userModel.avatar] placeholderImage:[UIImage imageNamed:@"defaultHeadPic.png"]];
        
        self.nameLable.text = manager.userModel.realname;
        
    } else {
        
        [self.userImageView setImage:[UIImage imageNamed:@"defaultHeadPic.png"]];
        
        self.nameLable.text = @"未登录";
    }

}

#pragma mark - MKMapViewDelegate
- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay{
    if ([overlay isKindOfClass:[MultiColorPolyline class]]) {
        MultiColorPolyline * polyLine = (MultiColorPolyline *)overlay;
        MKPolylineRenderer *aRenderer = [[MKPolylineRenderer alloc] initWithPolyline:polyLine];
        aRenderer.strokeColor = polyLine.color;
        aRenderer.lineWidth = 3;
        return aRenderer;
    }
    
    return nil;
}

@end
