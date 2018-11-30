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

    
}


#pragma mark - 测试上传
- (void)testuplod{
    
    [[ZRNetworkingTool shareTool] uploadFilesWithUrl:@"" parameters:nil filesKey:@"files" filesPath:@[] progress:nil finishedBlock:^(id responseObj, NSError *error) {
       
        NSLog(@"上传结果");
    }];
    
}



@end
