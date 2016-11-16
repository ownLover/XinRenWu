//
//  KKRequestSender.m
//  TEST
//
//  Created by bear on 13-3-27.
//  Copyright (c) 2013年 beartech. All rights reserved.
//

#import "KKRequestSender.h"

@implementation KKRequestSender

- (void)sendRequestWithParam:(KKRequestParam *)param requestIndentifier:(NSString*)indentifier{
    [KKRequestManager addRequestWithParam:param requestIndentifier:indentifier requestSender:self];
}

- (void)receivedRequestFinished:(KKFormRequest*)formRequest httpInfomation:(NSDictionary*)httpInfomation requestResult:(NSDictionary*)requestResult{
    
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]init];
    [dictionary setObject:formRequest.identifier forKey:@"identifier"];
    if (requestResult) {
        [dictionary setObject:requestResult forKey:@"requestResult"];
    }
    [dictionary setObject:httpInfomation forKey:@"httpInfomation"];

    [[NSNotificationCenter defaultCenter] postNotificationName:formRequest.identifier
                                                        object:dictionary
                                                      userInfo:nil];
    
    [dictionary release];
}

@end



////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation NSObject (KIRequestManager)

- (void)observeKKRequestNotificaiton:(NSString *)identifier {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(tRequestFinished:)
                                                 name:identifier
                                               object:nil];
}

- (void)tRequestFinished:(NSNotification *)noti {
    NSDictionary *noticeInfo = noti.object;
    NSString *identifier = [noticeInfo objectForKey:@"identifier"];
    NSMutableDictionary *requestResult = [noticeInfo objectForKey:@"requestResult"];
    NSDictionary *httpInfomation = [noticeInfo objectForKey:@"httpInfomation"];

    [self KKRequestRequestFinished:requestResult httpInfomation:httpInfomation requestIdentifier:identifier];
}

- (void)unobserveKKRequestNotificaiton:(NSString *)identifier {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:identifier object:nil];
}


/**
 1、requestResult 请求返回的数据结果
 2、httpInfomation 网络请求返回的HTTP结果
 3、requestIdentifier 网络请求标识符
 */
- (void)KKRequestRequestFinished:(NSDictionary*)requestResult
                  httpInfomation:(NSDictionary*)httpInfomation
               requestIdentifier:(NSString*)requestIdentifier{
    
}




@end

