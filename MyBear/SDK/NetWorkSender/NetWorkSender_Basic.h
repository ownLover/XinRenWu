//
//  NetWorkSender_Basic.h
//  CEDongLi
//
//  Created by beartech on 15/9/19.
//  Copyright (c) 2015年 KeKeStudio. All rights reserved.
//

#import "NetWorkSender.h"

//【检查更新】--------------------------------------------------------------------------------
#define URL_System_CheckVersion @"api/version/getVerInfo"
#define CMD_System_CheckVersion @"CMD_System_CheckVersion"


@interface NetWorkSender_Basic : NetWorkSender

+ (NetWorkSender_Basic*)defaultSender;
@end
