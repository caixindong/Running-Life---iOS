//
//  XDNetworking.h
//  XDNetworking
//
//  Created by 蔡欣东 on 2016/7/25.
//  Copyright © 2016年 蔡欣东. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  网络状态
 */
typedef NS_ENUM(NSInteger, XDNetworkStatus) {
    /**
     *  未知网络
     */
    XDNetworkStatusUnknown             = 1 << 0,
    /**
     *  无法连接
     */
    XDNetworkStatusNotReachable        = 1 << 1,
    /**
     *  WWAN网络
     */
    XDNetworkStatusReachableViaWWAN    = 1 << 2,
    /**
     *  WiFi网络
     */
    XDNetworkStatusReachableViaWiFi    = 1 << 3
};

/**
 *  请求任务
 */
typedef NSURLSessionTask XDURLSessionTask;

/**
 *  成功回调
 *
 *  @param response 成功后返回的数据
 */
typedef void(^XDResponseSuccessBlock)(id response);

/**
 *  失败回调
 *
 *  @param error 失败后返回的错误信息
 */
typedef void(^XDResponseFailBlock)(NSError *error);

/**
 *  下载进度
 *
 *  @param bytesWritten              已下载的大小
 *  @param totalBytes                总下载大小
 */
typedef void (^XDDownloadProgress)(int64_t bytesRead,
                                   int64_t totalBytes);

/**
 *  下载成功回调
 *
 *  @param url                       下载存放的路径
 */
typedef void(^XDDownloadSuccessBlock)(NSURL *url);


/**
 *  上传进度
 *
 *  @param bytesWritten              已上传的大小
 *  @param totalBytes                总上传大小
 */
typedef void(^XDUploadProgressBlock)(int64_t bytesWritten,
                                     int64_t totalBytes);
/**
 *  多文件上传成功回调
 *
 *  @param response 成功后返回的数据
 */
typedef void(^XDMultUploadSuccessBlock)(NSArray *responses);

/**
 *  多文件上传失败回调
 *
 *  @param error 失败后返回的错误信息
 */
typedef void(^XDMultUploadFailBlock)(NSArray *errors);

typedef XDDownloadProgress XDGetProgress;

typedef XDDownloadProgress XDPostProgress;

typedef XDResponseFailBlock XDDownloadFailBlock;

@interface XDNetworking : NSObject

/**
 *  正在运行的网络任务
 *
 *  @return 
 */
+ (NSArray *)currentRunningTasks;


/**
 *  配置请求头
 *
 *  @param httpHeader 请求头
 */
+ (void)configHttpHeader:(NSDictionary *)httpHeader;

/**
 *  取消GET请求
 */
+ (void)cancelRequestWithURL:(NSString *)url;

/**
 *  取消所有请求
 */
+ (void)cancleAllRequest;

/**
 *	设置超时时间
 *
 *  @param timeout 超时时间
 */
+ (void)setupTimeout:(NSTimeInterval)timeout;

/**
 *  GET请求
 *
 *  @param url              请求路径
 *  @param cache            是否缓存
 *  @param refresh          是否刷新请求(遇到重复请求，若为YES，则会取消旧的请求，用新的请求，若为NO，则忽略新请   求，用旧请求)
 *  @param params           拼接参数
 *  @param progressBlock    进度回调
 *  @param successBlock     成功回调
 *  @param failBlock        失败回调
 *
 *  @return 返回的对象中可取消请求
 */
+ (XDURLSessionTask *)getWithUrl:(NSString *)url
                  refreshRequest:(BOOL)refresh
                           cache:(BOOL)cache
                          params:(NSDictionary *)params
                   progressBlock:(XDGetProgress)progressBlock
                    successBlock:(XDResponseSuccessBlock)successBlock
                       failBlock:(XDResponseFailBlock)failBlock;




/**
 *  POST请求
 *
 *  @param url              请求路径
 *  @param cache            是否缓存
 *  @param refresh          解释同上
 *  @param params           拼接参数
 *  @param progressBlock    进度回调
 *  @param successBlock     成功回调
 *  @param failBlock        失败回调
 *
 *  @return 返回的对象中可取消请求
 */
+ (XDURLSessionTask *)postWithUrl:(NSString *)url
                   refreshRequest:(BOOL)refresh
                            cache:(BOOL)cache
                           params:(NSDictionary *)params
                    progressBlock:(XDPostProgress)progressBlock
                     successBlock:(XDResponseSuccessBlock)successBlock
                        failBlock:(XDResponseFailBlock)failBlock;




/**
 *  文件上传
 *
 *  @param url              上传文件接口地址
 *  @param data             上传文件数据
 *  @param type             上传文件类型
 *  @param name             上传文件服务器文件夹名
 *  @param mimeType         mimeType
 *  @param progressBlock    上传文件路径
 *	@param successBlock     成功回调
 *	@param failBlock		失败回调
 *
 *  @return 返回的对象中可取消请求
 */
+ (XDURLSessionTask *)uploadFileWithUrl:(NSString *)url
                                fileData:(NSData *)data
                                    type:(NSString *)type
                                    name:(NSString *)name
                                mimeType:(NSString *)mimeType
                           progressBlock:(XDUploadProgressBlock)progressBlock
                            successBlock:(XDResponseSuccessBlock)successBlock
                               failBlock:(XDResponseFailBlock)failBlock;


/**
 *  多文件上传
 *
 *  @param url           上传文件地址
 *  @param datas         数据集合
 *  @param type          类型
 *  @param name          服务器文件夹名
 *  @param mimeType      mimeTypes
 *  @param progressBlock 上传进度
 *  @param successBlock  成功回调
 *  @param failBlock     失败回调
 *
 *  @return 任务集合
 */
+ (NSArray *)uploadMultFileWithUrl:(NSString *)url
                         fileDatas:(NSArray *)datas
                              type:(NSString *)type
                              name:(NSString *)name
                          mimeType:(NSString *)mimeTypes
                     progressBlock:(XDUploadProgressBlock)progressBlock
                      successBlock:(XDMultUploadSuccessBlock)successBlock
                         failBlock:(XDMultUploadFailBlock)failBlock;

/**
 *  文件下载
 *
 *  @param url           下载文件接口地址
 *  @param progressBlock 下载进度
 *  @param successBlock  成功回调
 *  @param failBlock     下载回调
 *
 *  @return 返回的对象可取消请求
 */
+ (XDURLSessionTask *)downloadWithUrl:(NSString *)url
                        progressBlock:(XDDownloadProgress)progressBlock
                         successBlock:(XDDownloadSuccessBlock)successBlock
                            failBlock:(XDDownloadFailBlock)failBlock;


@end
