//
//  KKRequestParam.h
//  TEST
//
//  Created by bear on 13-3-27.
//  Copyright (c) 2013年 beartech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KKUploadDataObject.h"
#define HTTPMethod_POST @"POST"
#define HTTPMethod_GET @"GET"

@interface KKRequestParam : NSObject {
    NSString            *_urlString;
    NSString            *_method;
    NSTimeInterval      _timeout;
    
    /*_requestHeader*/
    NSMutableDictionary *_requestHeaderDic;

    /*上传文件*/
    NSMutableDictionary *_postFilesPathDic;//value路径 key
    
    /*要发送的参数*/
    NSMutableDictionary *_postParamDic;
    
    /*要发送的二进制数据*/
    NSMutableArray *_binaryDataArr;
}

@property (nonatomic, retain) NSMutableDictionary   *requestHeaderDic;
@property (nonatomic, retain) NSMutableDictionary   *postFilesPathDic;
@property (nonatomic, retain) NSMutableDictionary   *postParamDic;
@property (nonatomic, retain) NSMutableArray        *binaryDataArr;

@property (nonatomic, retain) NSString              *urlString;
@property (nonatomic, retain) NSString              *method;
@property (nonatomic, assign) NSTimeInterval        timeout;

- (BOOL)isGet;
- (BOOL)isPost;

- (NSString *)paramStringOfGet;

- (void)addRequestHeader:(NSString *)key withValue:(id)value;
- (void)addFile:(NSString *)filePath forKey:(NSString *)fileKey;
- (void)addParam:(NSString *)key withValue:(id)value;
- (void)addBinaryData:(KKUploadDataObject *)obj;

@end
