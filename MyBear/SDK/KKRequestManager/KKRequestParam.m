//
//  KKRequestParam.m
//  TEST
//
//  Created by bear on 13-3-27.
//  Copyright (c) 2013年 beartech. All rights reserved.
//

#import "KKRequestParam.h"
#import <objc/runtime.h>

@implementation KKRequestParam

@synthesize urlString           = _urlString;
@synthesize method              = _method;
@synthesize timeout             = _timeout;
@synthesize requestHeaderDic    = _requestHeaderDic;
@synthesize postFilesPathDic    = _postFilesPathDic;
@synthesize postParamDic        = _postParamDic;
@synthesize binaryDataArr       = _binaryDataArr;

- (id)init {
    if (self =[super init]) {
        _method = HTTPMethod_POST;
        _timeout = 60.0f;
    }
    return self;
}

- (BOOL)isGet {
    if ([[_method uppercaseString] isEqualToString:HTTPMethod_GET]) {
        return YES;
    }
    return NO;
}

- (BOOL)isPost {
    if ([[_method uppercaseString] isEqualToString:HTTPMethod_POST]) {
        return YES;
    }
    return NO;
}

- (NSString *)paramStringOfGet{

    NSString *propertyName = nil;
    NSString *propertyValue = nil;

    NSArray *propertyList = [self attributeList];
    NSUInteger count = propertyList.count;
    
    for (int i=0; i<count; i++) {
        propertyName = [propertyList objectAtIndex:i];
        
        if ([propertyName isEqualToString:@"urlString"]
            || [propertyName isEqualToString:@"method"]
            || [propertyName isEqualToString:@"timeout"]
            || [propertyName isEqualToString:@"requestType"]) {
            continue;
        }
        
        propertyValue =[self valueForKey:propertyName];
        
        if (propertyValue == nil) {
            propertyValue = @"";
            //            continue;
        }
        if (propertyName && propertyValue) {
            [self addParam:propertyName withValue:propertyValue];
        }
    }

    
    NSString *paramString = @"?";
    if (_postParamDic != nil) {
        NSInteger length = [[_postParamDic allKeys] count];
        
        NSString    *key;
        id          value;
        NSString    *separate = @"&";
        
        for (int i=0; i<length; i++) {
            key = [[_postParamDic allKeys] objectAtIndex:i];
            
            if ([[key lowercaseString] isEqualToString:@"urlString"]
                || [[key lowercaseString] isEqualToString:@"method"]
                || [[key lowercaseString] isEqualToString:@"timeout"]
                || [[key lowercaseString] isEqualToString:@"postparamdic"]
                || [[key lowercaseString] isEqualToString:@"isHttpRequest"]) {
                continue;
            }
            
            value = [_postParamDic valueForKey:key];
            if (i == length-1) {
                separate = @"";
            }
            
            if (paramString && key && [key length]>0 && separate) {
                if (value && [value isKindOfClass:[NSString class]] && [value length]>0) {
                    paramString = [NSString stringWithFormat:@"%@%@=%@%@", paramString, key, value, separate];
                }
                else if (value && [value isKindOfClass:[NSNumber class]]){
                    paramString = [NSString stringWithFormat:@"%@%@=%@%@", paramString, key, [(NSNumber*)value stringValue], separate];
                }
                else{
                
                }
            }
        }
    }
    
    if ([paramString hasSuffix:@"&"]) {
        paramString = [paramString substringToIndex:[paramString length]-1];
    }
    
    if ([paramString isEqualToString:@"?"]) {
        return @"";
    }
    
    return paramString;
}

- (NSMutableArray *)attributeList {
    static NSMutableDictionary *classDictionary = nil;
    if (classDictionary == nil) {
        classDictionary = [[NSMutableDictionary alloc] init];
    }
    
    NSString *className = NSStringFromClass(self.class);
    
    NSMutableArray *propertyList = [classDictionary objectForKey:className];
    
    if (propertyList != nil) {
        return propertyList;
    }
    
    
    //    NSMutableArray *propertyList = objc_getAssociatedObject(self, kPropertyList);
    //
    //    if (propertyList != nil) {
    //        return propertyList;
    //    }
    
    propertyList = [[NSMutableArray alloc] init];
    
    id theClass = object_getClass(self);
    [self getPropertyList:theClass forList:&propertyList];
    
    [classDictionary setObject:propertyList forKey:className];
    
    [propertyList release];
    
    //    objc_setAssociatedObject(self, kPropertyList, propertyList, OBJC_ASSOCIATION_ASSIGN);
    
    return propertyList;
}

- (void)getPropertyList:(id)theClass forList:(NSMutableArray **)propertyList {
    id superClass = class_getSuperclass(theClass);
    unsigned int count, i;
    objc_property_t *properties = class_copyPropertyList(theClass, &count);
    for (i=0; i<count; i++) {
        objc_property_t property = properties[i];
        NSString *propertyName = [[NSString alloc] initWithCString:property_getName(property)
                                                          encoding:NSUTF8StringEncoding];
        if (propertyName != nil) {
            [*propertyList addObject:propertyName];
            [propertyName release];
            propertyName = nil;
        }
    }
    free(properties);
    
    if (superClass != [NSObject class]) {
        [self getPropertyList:superClass forList:propertyList];
    }
}

- (void)addRequestHeader:(NSString *)key withValue:(id)value{
    if (_requestHeaderDic == nil) {
        _requestHeaderDic = [[NSMutableDictionary alloc] init];
    }
    
    if (value == nil) {
        value = @"";
    }
    
    if (value != nil && key != nil) {
        [_requestHeaderDic setObject:value forKey:key];
    }
}

- (void)addFile:(NSString *)filePath forKey:(NSString *)fileKey{
    if (_postFilesPathDic == nil) {
        _postFilesPathDic = [[NSMutableDictionary alloc] init];
    }

    if (filePath && (![filePath isEqualToString:@""])) {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if ([fileManager fileExistsAtPath:filePath]) {
            if (fileKey && (![fileKey isEqualToString:@""])) {
                [_postFilesPathDic setObject:filePath forKey:fileKey];
            }
            else{
#ifdef DEBUG
                NSLog(@"网络上传文件，Key有误");
#endif
                return;
            }
        }
        else{
#ifdef DEBUG
            NSLog(@"网络上传文件 文件不存在：%@",filePath);
#endif
            return;
        }
    }
}

- (void)addParam:(NSString *)key withValue:(id)value{
    if (_postParamDic == nil) {
        _postParamDic = [[NSMutableDictionary alloc] init];
    }
    
    if (value == nil) {
        return;
    }
    
    if (value != nil && key != nil) {
        [_postParamDic setObject:value forKey:key];
    }
}

- (void)addBinaryData:(KKUploadDataObject *)obj{
    if (_binaryDataArr == nil) {
        _binaryDataArr = [[NSMutableArray alloc] init];
    }
    [_binaryDataArr addObject:obj];
}

- (void)dealloc {
    [_method release];
    _method = nil;
    [_urlString release];
    _urlString = nil;
    
    [_binaryDataArr release];
    _binaryDataArr = nil;

    [_postParamDic release];
    _postParamDic = nil;
    
    [_postFilesPathDic release];
    _postFilesPathDic = nil;
    
    [_requestHeaderDic release];
    _requestHeaderDic = nil;

    [super dealloc];
}

@end
