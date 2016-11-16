//
//  KKFormRequest.m
//  TEST
//
//  Created by bear on 13-3-27.
//  Copyright (c) 2013年 beartech. All rights reserved.
//

#import "KKFormRequest.h"
#import "KKRequestManager.h"

@implementation KKFormRequest
@synthesize identifier = _identifier,requestParam = _requestParam;
@synthesize requestSender = _requestSender;

- (void)startRequest:(NSString *)aIdentifier
               param:(KKRequestParam *)param requestSender:(KKRequestSender *)aRequestSender{
    _requestSender = aRequestSender;
    [self startRequest:aIdentifier param:param finishedBlock:nil failedBlock:nil];
}

- (void)startRequest:(NSString *)aIdentifier
               param:(KKRequestParam *)param
       finishedBlock:(void(^)(ASIHTTPRequest *request))finishedBlock
         failedBlock:(void(^)(ASIHTTPRequest *request))failedBlock {
    
    _identifier = [aIdentifier copy];
    _requestParam = [param retain];
    
    [self setRequestMethod:[_requestParam method]];
    [self setTimeOutSeconds:_requestParam.timeout];
    
#ifdef DEBUG
    NSLog(@"网络接口【%@】: %@",[_requestParam method],_requestParam.urlString);
    if (_requestParam.postParamDic) {
        NSLog(@"网络POST参数: %@",_requestParam.postParamDic);
    }
    if (_requestParam.postFilesPathDic) {
        NSLog(@"网络POST文件: %@",_requestParam.postFilesPathDic);
    }
    if (_requestParam.requestHeaderDic) {
        NSLog(@"网络requestHeader: %@",_requestParam.requestHeaderDic);
    }
#endif

    //发送文件
    if ((param.postFilesPathDic!=nil) && ([param.postFilesPathDic count]>0)) {
        NSDictionary *postFiles = [_requestParam postFilesPathDic];
        for (NSString *key in postFiles) {
            [self setFile:[postFiles valueForKey:key] forKey:key];
        }
    }
    
    //_requestHeader
    if ((param.requestHeaderDic!=nil) && ([param.requestHeaderDic count]>0)) {
        NSDictionary *requestHeader = param.requestHeaderDic;
        for (NSString *key in [requestHeader allKeys]) {
            [self addRequestHeader:key value:[requestHeader valueForKey:key]];
        }
    }
    
    //要发送的参数
    if ([_requestParam isPost]) {
        if ((param.postParamDic!=nil) && ([param.postParamDic count]>0)) {
            NSDictionary *postValue = [_requestParam postParamDic];
            for (NSString *key in postValue) {
                [self setPostValue:[postValue valueForKey:key] forKey:key];
            }
        }
    }


    NSString *urlString = _requestParam.urlString;
    if ([_requestParam isGet]) {
#ifdef DEBUG
        NSLog(@"GET原始的URL: %@",urlString);
#endif
        
//        if (![urlString hasSuffix:@"/"]) {
//            urlString = [urlString stringByAppendingString:@"/"];
//        }
        urlString = [NSString stringWithFormat:@"%@%@", urlString, [_requestParam paramStringOfGet]];
#ifdef DEBUG
        NSLog(@"GET请求的URL: %@",urlString);
#endif

    }
    NSURL *requestURL = [[NSURL alloc] initWithString:urlString];
    [self setURL:requestURL];
    [requestURL release];
    requestURL = nil;
    
    //要发送的二进制数据
    if ((param.binaryDataArr!=nil) && ([param.binaryDataArr count]>0)) {
        NSArray *postDataArr = [_requestParam binaryDataArr];
        for (int i=0;i<[postDataArr count];i++) {
            KKUploadDataObject *postObj = (KKUploadDataObject*)[postDataArr objectAtIndex:i];
            if (postObj.type==KKUploadDataTypeImageJPG) {
                [self setData:postObj.data withFileName:postObj.fileName andContentType:@"image/jpg" forKey:postObj.key];
            }
            else if (postObj.type==KKUploadDataTypeImagePNG){
                [self setData:postObj.data withFileName:postObj.fileName andContentType:@"image/png" forKey:postObj.key];
            }
            else{
                [self addData:postObj.data forKey:postObj.key];
            }
        }
    }
    
    //上传图片==================================================
//    NSUInteger size = 0;
//    NSMutableArray* array = [NSMutableArray array];
//    for (int i = 0; i < [productImages count]; i++) {
//        UploadData* data = [[UploadData alloc] init];
//        ProductImageObject *imageObj = [productImages objectAtIndex:i];
//        data.data = UIImageJPEGRepresentation(imageObj.image, 1);
//        [array addObject:data];
//        [data release];
//        
//        size += [data.data length];
//    }
//    NSLog(@"%u",size / 1024);
//    creatShopRequest.uploadDatas = array;

//            [requestForm setData:[NSData dataWithData:UIImagePNGRepresentation(quanquanImage)] withFileName:@"head.png" andContentType:@"image/png" forKey:@"file"];
//    self.fileName = @"Product.jpg";
//    self.ContentType = @"image/jpeg" ;/*@"image/png" */
//    self.key = @"file";
    
    if (finishedBlock) {
        [self setCompletionBlock:^{
            finishedBlock(self);
        }];
    }
    
    if (failedBlock) {
        [self setFailedBlock:^{
            failedBlock(self);
        }];
    }
    
    [self startAsynchronous];
}

- (void)setRequestIdentifier:(NSString *)aIdentifier param:(KKRequestParam *)param requestSender:(KKRequestSender*)aRequestSender{
    _identifier = [aIdentifier copy];
    _requestParam = [param retain];
    _requestSender = aRequestSender;

    [self setRequestMethod:[_requestParam method]];
    [self setTimeOutSeconds:_requestParam.timeout];
}


- (void)dealloc {
    [_identifier release];
    _identifier = nil;
    [_requestParam release];
    _requestParam = nil;
    [super dealloc];
}

@end
