//
//  NetWorkSender.h
//  KKLibrary_Demo
//
//  Created by beartech on 15/1/13.
//  Copyright (c) 2015年 KeKeStudio. All rights reserved.
//

#import "KKRequestSender.h"
#import "BaseRequestParam.h"


#define RequestFullURLString(string) ([NetWorkSender requestFullURLString:string])
#define ImageFullURLString(string)   ([NetWorkSender imageFullURLString:string])

#define ListDataPerPage 50

@interface NetWorkSender : KKRequestSender

- (NSString*)requestURLForInterface:(NSString*)interface;

+ (NSString *)requestFullURLString:(NSString*)url;

+ (NSString*)imageFullURLString:(NSString*)url;

@end
