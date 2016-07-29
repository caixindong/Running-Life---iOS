//
//  AMapLocationServices.h
//  AMapLocationKit
//
//  Created by AutoNavi on 15/10/22.
//  Copyright © 2015年 AutoNavi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AMapLocationServices : NSObject

+ (AMapLocationServices *)sharedServices;

/// API Key, 在使用搜索服务之前需要先绑定key.
@property (nonatomic, copy) NSString *apiKey;

/// SDK 版本号, 形式如v1.0.0
@property (nonatomic, readonly) NSString *SDKVersion;

@end
