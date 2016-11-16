//
//  KKRequestSender.h
//  TEST
//
//  Created by bear on 13-3-27.
//  Copyright (c) 2013年 beartech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KKRequestParam.h"
#import "KKRequestManager.h"
#import "KKNetWorkObserver.h"
#import "KKFormRequest.h"

#define NetWorkNoneCode 999

@interface KKRequestSender : NSObject

- (void)sendRequestWithParam:(KKRequestParam *)param requestIndentifier:(NSString*)indentifier;

/*子类可重写此方法*/
- (void)receivedRequestFinished:(KKFormRequest*)formRequest httpInfomation:(NSDictionary*)httpInfomation requestResult:(NSDictionary*)requestResult;

@end


////////////////////////////////////////////////////////////////////////////////////////////////////
/*
 
 */
@interface NSObject (KIRequestManager)

/*注册成为监听器*/
- (void)observeKKRequestNotificaiton:(NSString *)identifier;

- (void)unobserveKKRequestNotificaiton:(NSString *)identifier;

/*子类重写此方法*/
/**
 1、requestResult 请求返回的数据结果
 2、httpInfomation 网络请求返回的HTTP结果
 3、requestIdentifier 网络请求标识符
 */
- (void)KKRequestRequestFinished:(NSDictionary*)requestResult
                  httpInfomation:(NSDictionary*)httpInfomation
               requestIdentifier:(NSString*)requestIdentifier;

@end
