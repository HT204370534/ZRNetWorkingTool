//
//  ZRNetworkingTool.h
//  简书:https://www.jianshu.com/u/043e94ca450f
//
//  Created by 黄涛 on 2018/5/15.
//  Copyright © 2018年 zero. All rights reserved.
//  网络请求工具 基于AFNetworking 封装

#import <AFNetworking/AFNetworking.h>

#define BASE_URL @"http://118.24.215.116/index.php/home/"

typedef enum RequestMethod{
    post_ZRRequest = 0,
    get_ZRRequest
}ZRRequestMethod;

@interface ZRNetworkingTool : AFHTTPSessionManager

/** 初始化 */
+ (instancetype)shareTool;

/** 网络请求 */
- (NSURLSessionDataTask *) requestWithMethod:(ZRRequestMethod)method url:(NSString *)url parameters:(NSDictionary *)parameters finishedBlock:(void(^)(id responseObj, NSError * error))finished;

/** 上传数据 filesKey:例 单图:files 多图:files[] 具体和后台拟定*/
- (NSURLSessionDataTask *)uploadFilesWithUrl:(NSString *)url parameters:(NSDictionary *)parameters filesKey:(NSString *)filesKey filesPath:(NSArray *)filesPath progress:(void (^)(NSProgress *))progress finishedBlock:(void (^)(id responseObj, NSError * error))finished;

/** 服务器请求(webService) */
- (NSURLSessionDataTask *)requestFromWebService:(NSString *)serviceIP subset:(NSString *)subsetStr parameters:(NSDictionary *)parameters soapVersion:(CGFloat)soapVersion  finishedBlock:(void(^)(id responseObj))finished;



@end
