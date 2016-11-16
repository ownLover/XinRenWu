//
//  Net.m
//  MyBear
//
//  Created by 紫平方 on 16/10/10.
//  Copyright © 2016年 bear. All rights reserved.
//

#import "Net.h"

@implementation Net
+ (Net *)defaultSender{
    static Net *NetWorkSender_Report_defaultSender = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        NetWorkSender_Report_defaultSender = [[self alloc] init];
    });
    return NetWorkSender_Report_defaultSender;
}

#pragma mark - 获取
- (void)getToken{
    BaseRequestParam *parm = [[BaseRequestParam alloc] init];
    parm.urlString = [self requestURLForInterface:URL_RegistGetToken];
    parm.method = HTTPMethod_GET;
    [self sendRequestWithParam:parm requestIndentifier:CMD_RegistGetToken];
    
}

#pragma mark - 发送
- (void)post:(NSString *)string{
    BaseRequestParam *parm = [[BaseRequestParam alloc] init];
    parm.urlString = [self requestURLForInterface:URLsend];
    parm.method = HTTPMethod_POST;
    [parm addParam:@"data" withValue:string];
    [self sendRequestWithParam:parm requestIndentifier:CMDsend];
    
}

@end
