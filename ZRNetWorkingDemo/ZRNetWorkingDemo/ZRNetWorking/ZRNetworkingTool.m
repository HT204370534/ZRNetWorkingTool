//
//  ZRNetworkingTool.m
//  简书:https://www.jianshu.com/u/043e94ca450f
//
//  Created by 黄涛 on 2018/5/15.
//  Copyright © 2018年 zero. All rights reserved.
//  网络请求工具 基于AFNetworking 封装

#import "ZRNetworkingTool.h"

@implementation ZRNetworkingTool

static ZRNetworkingTool * _manager = nil;
+ (instancetype)shareTool{
    

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [[self alloc] initWithBaseURL:[NSURL URLWithString:BASE_URL] sessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        _manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/plain", @"text/javascript", @"text/json", @"text/html", nil];
        //请求超时
        _manager.requestSerializer.timeoutInterval = 15;
        //去掉返回空值
        ((AFJSONResponseSerializer *)_manager.responseSerializer).removesKeysWithNullValues = YES;
 
        //设置解析为Jason
        _manager.requestSerializer = [AFJSONRequestSerializer serializer];
        
//        _manager.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
    
    });
    return _manager;
}

#pragma mark - 网络请求
- (NSURLSessionDataTask *) requestWithMethod:(ZRRequestMethod)method url:(NSString *)url parameters:(NSDictionary *)parameters finishedBlock:(void(^)(id responseObj, NSError * error))finished {
    
    NSMutableDictionary * params = [[NSMutableDictionary alloc] initWithDictionary:parameters];
    //这里设置公用参数
    
    //网络状态指示器
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    switch (method) {
        case post_ZRRequest :
        {
            return [self POST:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                NSError * error = [self requestSuccess:responseObject];
                id obj = error == nil ? responseObject : nil;
                
               !finished ? : finished(obj,error);
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                NSLog(@"\n 问题链接 -> %@ \n 请求方式:POST \n 参数:%@ \n",[NSString stringWithFormat:@"%@%@",BASE_URL,url],params);
                !finished ? : finished(nil,error);
                
                
            }];
    
        }break;
           
            
            
        case get_ZRRequest :
        {
         
            return [self GET:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                NSError * error = [self requestSuccess:responseObject];
                id obj = error == nil ? responseObject : nil;
                
                !finished ? : finished(obj,error);
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                NSLog(@"\n 问题链接 -> %@ \n 请求方式:GET \n 参数:%@ \n",[NSString stringWithFormat:@"%@%@",BASE_URL,url],params);
                !finished ? : finished(nil,error);
                
                
            }];
            
        }break;
            
            
        default:  break;
    }
    
}


#pragma mark - 服务器请求
- (NSURLSessionDataTask *)requestFromWebService:(NSString *)serviceIP subset:(NSString *)subsetStr parameters:(NSDictionary *)parameters soapVersion:(CGFloat)soapVersion  finishedBlock:(void(^)(id responseObj))finished{

    NSString * soap_1_1 = @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
    "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n";
    
    NSString * soap_1_2 = @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
    "<soap12:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap12=\"http://www.w3.org/2003/05/soap-envelope\">\n";
    
    NSMutableArray * bodyArr = [NSMutableArray arrayWithArray:@[@"<soap:Body>",[NSString stringWithFormat:@"<%@ xmlns=\"http://tempuri.org/\">",subsetStr],[NSString stringWithFormat:@"</%@>",subsetStr],@"</soap:Body>",@"</soap:Envelope>"]];
    
    
    NSMutableArray * parameArr = [NSMutableArray array];
    
    [parameters enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
      
        NSString * parameStr = [NSString stringWithFormat:@"<%@>%@</%@>",key,obj,key];
        [parameArr addObject:parameStr];
    }];
    
    NSRange range = NSMakeRange(2, parameArr.count);
    NSIndexSet * indexSet = [NSIndexSet indexSetWithIndexesInRange:range];
    [bodyArr insertObjects:parameArr atIndexes:indexSet];
    
    NSString * bodyStr = [bodyArr componentsJoinedByString:@"\n"];
    
    NSString * soapStr = soapVersion == 1.1 ? [soap_1_1 stringByAppendingString:bodyStr] : [soap_1_2 stringByAppendingString:bodyStr];

    //网络状态指示器
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    // 设置HTTPBody
    [_manager.requestSerializer setQueryStringSerializationWithBlock:^NSString * _Nonnull(NSURLRequest * _Nonnull request, id  _Nonnull parameters, NSError * _Nullable __autoreleasing * _Nullable error) {
        
        return nil;
    }];

    return [self POST:serviceIP parameters:soapStr progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

        !finished ? : finished(responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        NSLog(@"\n服务器请求 报错了！\n  服务器IP -> %@ \n 请求拼接:%@ \n",serviceIP,soapStr);
        !finished ? : finished(nil);
        
    }];
    
}


#pragma mark - 上传
- (NSURLSessionDataTask *)uploadFilesWithUrl:(NSString *)url parameters:(NSDictionary *)parameters filesKey:(NSString *)filesKey filesPath:(NSArray *)filesPath progress:(void (^)(NSProgress *))progress finishedBlock:(void (^)(id responseObj, NSError * error))finished{
    
    if (!filesPath.hash){
       NSLog(@"骚年，你没有选择 file");
       return nil;
    }
        
    //这里设置公用参数
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:parameters];
    
    /* 在这里添加每个接口都有的参数
    params[@"version"] = [[NSBundle mainBundle].infoDictionary objectForKey:JKCurrentVersionKey];//[[NSUserDefaults standardUserDefaults] stringForKey:JKCurrentVersionKey];

    params[@"time"] = @([JKDateTool getCurrentTimeStamp]).stringValue;

    NSString *alkey = [JKNetworkingTool alkeySortMD5WithParamDict:params extraStrings:nil];
    params[@"alkey"] = alkey;
     
     */
    
    
     [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;

    return [self POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        for (id file in filesPath) {
            
            NSData * fileData = [file isKindOfClass:[UIImage class]] ?
            [self compressWithImg:file MaxLength:1024 * 2]:
            [NSData dataWithContentsOfURL:file];
            
            NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat = @"yyyyMMddHHmmss";
            NSString * dataStr = [formatter stringFromDate:[NSDate date]];
            NSString * formatStr = [file isKindOfClass:[UIImage class]] ?
            @"jpg":@"mp4";
            NSString * fileName = [NSString stringWithFormat:@"%@.%@",dataStr,formatStr];
            
            NSLog(@"上传文件名 ： %@",fileName);
            [formData appendPartWithFileData:fileData name:filesKey fileName:fileName mimeType:@"multipart/form-data"];
    
        }
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
         !progress ? : progress(uploadProgress);
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        NSError * error = [self requestSuccess:responseObject];
        id obj = error == nil ? responseObject : nil;
        
        !finished ? : finished(obj,error);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        NSLog(@"臣妾做不到啊 ~ （上传失败）/n Error:%@",error);
        
    }];
    
    
}



#pragma mark - 请求成功处理
- (NSError *)requestSuccess:(id  _Nullable )responseObject {
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    //空数据处理
    if (responseObject == nil) {
        
        NSError * error = [NSError errorWithDomain:@"noDataError" code:1000 userInfo:@{@"message" : @"寡人没有获取到数据"}];
        return error;
    }
    
    // 请求成功，但是返回的错误信息，在这里处理一下
    if ([responseObject[@"errorCode"] integerValue] != 0) {
        
         NSLog(@"错误信息:%@-->/n错误码:%@-->%@", responseObject[@"errorMessage"], responseObject[@"result"], responseObject[@"data"]);
        
        NSError * error = [NSError errorWithDomain:@"noDataError" code:1000 userInfo:@{@"message" : responseObject [@"errorMessage"] ? responseObject[@"errorMessage"] : @"寡人请求失败"}] ;

        return error;
    }
    
    return nil;
}

#pragma mark - 图片压缩
- (NSData *)compressWithImg:(UIImage *)img MaxLength:(NSUInteger)maxLength{
    // Compress by quality
    CGFloat compression = 1;
    NSData *data = UIImageJPEGRepresentation(img, compression);
    //NSLog(@"Before compressing quality, image size = %ld KB",data.length/1024);
    if (data.length < maxLength) return data;
    
    CGFloat max = 1;
    CGFloat min = 0;
    for (int i = 0; i < 6; ++i) {
        compression = (max + min) / 2;
        data = UIImageJPEGRepresentation(img, compression);
        //NSLog(@"Compression = %.1f", compression);
        //NSLog(@"In compressing quality loop, image size = %ld KB", data.length / 1024);
        if (data.length < maxLength * 0.9) {
            min = compression;
        } else if (data.length > maxLength) {
            max = compression;
        } else {
            break;
        }
    }
    //NSLog(@"After compressing quality, image size = %ld KB", data.length / 1024);
    if (data.length < maxLength) return data;
    UIImage *resultImage = [UIImage imageWithData:data];
    // Compress by size
    NSUInteger lastDataLength = 0;
    while (data.length > maxLength && data.length != lastDataLength) {
        lastDataLength = data.length;
        CGFloat ratio = (CGFloat)maxLength / data.length;
        //NSLog(@"Ratio = %.1f", ratio);
        CGSize size = CGSizeMake((NSUInteger)(resultImage.size.width * sqrtf(ratio)),
                                 (NSUInteger)(resultImage.size.height * sqrtf(ratio))); // Use NSUInteger to prevent white blank
        UIGraphicsBeginImageContext(size);
        [resultImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
        resultImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        data = UIImageJPEGRepresentation(resultImage, compression);
        //NSLog(@"In compressing size loop, image size = %ld KB", data.length / 1024);
    }
    //NSLog(@"After compressing size loop, image size = %ld KB", data.length / 1024);
    return data;
}


@end
