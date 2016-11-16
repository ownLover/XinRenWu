//
//  NetWorkSender.m
//  KKLibrary_Demo
//
//  Created by beartech on 15/1/13.
//  Copyright (c) 2015年 KeKeStudio. All rights reserved.
//

#import "NetWorkSender.h"

@implementation NetWorkSender

- (NSString*)requestURLForInterface:(NSString*)interface{
    return [NSString stringWithFormat:@"%@/%@",ServerIP,interface];
}



+ (NSString *)requestFullURLString:(NSString*)url {
    if ([NSString isStringEmpty:url]) {
        return @"";
    }
    
    //如果是完整的URL链接，则不需要拼接http头
    NSString *lowString = [url lowercaseString];
    if ([lowString hasPrefix:@"http://"]) {
        return url;
    }
    
    NSString *head = ServerIP;
    NSString *tail = url;
    if ([head hasSuffix:@"/"] && [tail hasPrefix:@"/"]) {
        tail = [tail substringFromIndex:1];
    }
    else if (![head hasSuffix:@"/"] && ![tail hasPrefix:@"/"]){
        head = [head stringByAppendingString:@"/"];
    }
    NSString *returnString = [NSString stringWithFormat:@"%@%@", head,tail];

    return returnString;
}

+ (NSString*)imageFullURLString:(NSString*)url{
    
    if ([NSString isStringEmpty:url]) {
        return @"";
    }
    
    //如果是完整的URL链接，则不需要拼接http头
    NSString *lowString = [url lowercaseString];
    if ([lowString hasPrefix:@"http://"]) {
        return url;
    }
    
    
    NSString *returnString = nil;
    
    NSString *lastPathComponent = [[url lastPathComponent] lowercaseString];
    if ([lastPathComponent hasSuffix:@"gif"]) {
        NSString *head = ServerIP;
        NSString *tail = [url stringByReplacingOccurrencesOfString:[url lastPathComponent] withString:@""];
        if ([head hasSuffix:@"/"] && [tail hasPrefix:@"/"]) {
            tail = [tail substringFromIndex:1];
        }
        else if (![head hasSuffix:@"/"] && ![tail hasPrefix:@"/"]){
            head = [head stringByAppendingString:@"/"];
        }
        returnString = [NSString stringWithFormat:@"%@%@", head,tail];
        returnString = [returnString stringByAppendingString:[url lastPathComponent]];
    }
    else{
        NSString *head = ServerIP;
        NSString *tail = url;
        if ([head hasSuffix:@"/"] && [tail hasPrefix:@"/"]) {
            tail = [tail substringFromIndex:1];
        }
        else if (![head hasSuffix:@"/"] && ![tail hasPrefix:@"/"]){
            head = [head stringByAppendingString:@"/"];
        }
        returnString = [NSString stringWithFormat:@"%@%@", head,tail];
    }
    return returnString;
}

@end




