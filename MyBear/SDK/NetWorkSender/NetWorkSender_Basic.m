//
//  NetWorkSender_Basic.m
//  CEDongLi
//
//  Created by beartech on 15/9/19.
//  Copyright (c) 2015年 KeKeStudio. All rights reserved.
//

#import "NetWorkSender_Basic.h"
//#import "NetworkFieldHeader.h"
//#import "KKLocationKit.h"

@interface NetWorkSender_Basic ()<KKAlertViewDelegate>

@property (nonatomic,assign)BOOL checkAppVersionNeedShowAlert;
@property (nonatomic,assign)BOOL isShowingAlert;

@end

@implementation NetWorkSender_Basic

+ (NetWorkSender_Basic *)defaultSender{
    static NetWorkSender_Basic *NetWorkSender_Basic_defaultSender = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        NetWorkSender_Basic_defaultSender = [[self alloc] init];
    });
    return NetWorkSender_Basic_defaultSender;
}


@end