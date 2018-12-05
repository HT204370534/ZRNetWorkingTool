//
//  ViewController.m
//  ZRNetWorkingDemo
//
//  Created by 黄涛 on 2018/11/30.
//  Copyright © 2018 黄涛. All rights reserved.
//

#import "ViewController.h"
#import "ZRNetworkingTool.h"
#import <AFNetworking/AFNetworking.h>
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self testUplod];
    
    
//    [[ZRNetworkingTool shareTool] requestWithMethod:post_ZRRequest url:@"http://39.106.209.83:88/Information/GetSwiper" parameters:nil finishedBlock:^(id responseObj, NSError *error) {
//
//        NSLog(@"请求：%@",responseObj);
//
//    }];
//
    
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    manager.responseSerializer = [AFJSONResponseSerializer serializer];
//    
//    [manager POST:@"http://118.24.215.116/index.php/home/api/uploadPic" parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
//        
//    } progress:^(NSProgress * _Nonnull uploadProgress) {
//        
//    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//       
//        
//        NSLog(@"错误信息：%@",error);
//        
//        
//    }];
//    
    
    
}


#pragma mark - 测试上传
- (void)testUplod{
    
    NSArray * arr = @[[UIImage imageNamed:@"文学"],[UIImage imageNamed:@"美术"]];
    
    [[ZRNetworkingTool shareTool] uploadFilesWithUrl:@"http://118.24.215.116/index.php/home/api/uploadPic" parameters:nil filesKey:@"files[]" filesPath:arr progress:nil finishedBlock:^(id responseObj, NSError *error) {
       
        NSLog(@"上传结果:%@",responseObj);
    }];
    
}



@end
