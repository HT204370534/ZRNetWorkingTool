//
//  ViewController.m
//  ZRNetWorkingDemo
//
//  Created by 黄涛 on 2018/11/30.
//  Copyright © 2018 黄涛. All rights reserved.
//

#import "ViewController.h"
#import "ZRNetworkingTool.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self testUplod];
    
    
    [[ZRNetworkingTool shareTool] requestWithMethod:post_ZRRequest url:@"http://39.106.209.83:88/Information/GetSwiper" parameters:nil finishedBlock:^(id responseObj, NSError *error) {
       
        NSLog(@"请求：%@",responseObj);
        
    }];
    
    
}


#pragma mark - 测试上传
- (void)testUplod{
    
    [[ZRNetworkingTool shareTool] uploadFilesWithUrl:@"http://39.106.209.83:88/Information/GetSwiper" parameters:nil filesKey:@"files" filesPath:@[[UIImage imageNamed:@"美术"]] progress:nil finishedBlock:^(id responseObj, NSError *error) {
       
        NSLog(@"上传结果");
    }];
    
}



@end
