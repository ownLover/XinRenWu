//
//  KKFormRequest.h
//  TEST
//
//  Created by bear on 13-3-27.
//  Copyright (c) 2013年 beartech. All rights reserved.
//

#import "ASIFormDataRequest.h"
#import "KKRequestParam.h"

@class KKRequestSender;

@interface KKFormRequest : ASIFormDataRequest{
    NSString                    *_identifier;
    KKRequestParam              *_requestParam;
    Class                       delegateClass;
    KKRequestSender             *_requestSender;
}

@property (nonatomic, readonly) NSString        *identifier;
@property (nonatomic, readonly) KKRequestParam  *requestParam;
@property (nonatomic, readonly,assign) KKRequestSender *requestSender;


- (void)startRequest:(NSString *)aIdentifier param:(KKRequestParam *)param requestSender:(KKRequestSender*)aRequestSender;

- (void)startRequest:(NSString *)aIdentifier
               param:(KKRequestParam *)param
       finishedBlock:(void(^)(ASIHTTPRequest *request))finishedBlock
         failedBlock:(void(^)(ASIHTTPRequest *request))failedBlock;

- (void)setRequestIdentifier:(NSString *)aIdentifier param:(KKRequestParam *)param requestSender:(KKRequestSender*)aRequestSender;

@end
