//
//  Net.h
//  MyBear
//
//  Created by 紫平方 on 16/10/10.
//  Copyright © 2016年 bear. All rights reserved.
//

#import "NetWorkSender.h"
@interface Net : NetWorkSender
+ (Net*)defaultSender;



#define URL_RegistGetToken @"get"
#define CMD_RegistGetToken @"CMD_RegistGetToken"
#pragma mark - 获取token
- (void)getToken;

#define URLsend  @"send"
#define CMDsend  @"CMDsend"
#pragma mark - 获取token
- (void)post:(NSString *)string;


@end
