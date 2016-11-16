//
//  KKRequestManager.h
//  TEST
//
//  Created by bear on 13-3-27.
//  Copyright (c) 2013年 beartech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KKRequestParam.h"
#import "KKFormRequest.h"
#import "KKRequestSender.h"
#import "KILocalizationManager.h"

#define httpResultCodeKey    @"resultCode"
#define httpResultMessageKey @"resultMessage"
#define httpCodeKey          @"code"
#define httpMessageKey       @"message"

#define NetworkNotReachableCode @"999999" //没有网络连接 错误代码


@interface KKRequestManager : NSObject<ASIHTTPRequestDelegate>

@property(nonatomic,retain)NSMutableArray *requestList;

+ (KKRequestManager*)defaultManager;

+ (void)addRequestWithParam:(KKRequestParam *)param requestIndentifier:(NSString*)indentifier requestSender:(KKRequestSender*)requestSender;

- (void)cancelRequest:(NSString*)indentifier;

@end



