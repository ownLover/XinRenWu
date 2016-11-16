//
//  KKRequestManager.m
//  TEST
//
//  Created by bear on 13-3-27.
//  Copyright (c) 2013年 beartech. All rights reserved.
//

#import "KKRequestManager.h"
#import "KKNetWorkObserver.h"

@implementation KKRequestManager
@synthesize requestList;
//@synthesize returnCodeDictionary;

+ (KKRequestManager *)defaultManager{
    static KKRequestManager *defaultManager = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        defaultManager = [[self alloc] init];
    });
    return defaultManager;
}

- (id)init{
    self = [super init];
    if (self) {
        requestList = [[NSMutableArray alloc]init];
//        NSString *returnCodePlistName = @"ReturnCode";
//        NSString *language = [self getPreferredLanguage];
//        NSString *plistName = [NSString stringWithFormat:@"%@(%@)",returnCodePlistName,language];
//        returnCodeDictionary = [[NSMutableDictionary alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:plistName ofType:@"plist"]];
//        if (!returnCodeDictionary) {
//            returnCodeDictionary = [[NSMutableDictionary alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ReturnCode(zh-Hans)" ofType:@"plist"]];
//        }
    }
    return self;
}

///**
// *得到本机现在用的语言
// * en:英文  zh-Hans:简体中文   zh-Hant:繁体中文    ja:日本  ......
// */
//- (NSString*)getPreferredLanguage{
//    NSUserDefaults* defs = [NSUserDefaults standardUserDefaults];
//    NSArray* languages = [defs objectForKey:@"AppleLanguages"];
//    NSString* preferredLang = [languages objectAtIndex:0];
//    return preferredLang;
//}

+ (void)addRequestWithParam:(KKRequestParam *)param requestIndentifier:(NSString*)indentifier requestSender:(KKRequestSender *)requestSender{
    [[KKRequestManager defaultManager] sendRequestWithParam:param requestIndentifier:indentifier requestSender:(KKRequestSender *)requestSender];
}

- (void)sendRequestWithParam:(KKRequestParam *)param requestIndentifier:(NSString*)indentifier requestSender:(KKRequestSender *)requestSender{
    //有网络
    if ([KKNetWorkObserver sharedInstance].status != NotReachable) {
        if (!(param && indentifier && requestSender)) {
            return ;
        }
        
        [self clearRequestWithIdentifier:indentifier];

        KKFormRequest *newFormRequest = [[KKFormRequest alloc] initWithURL:[NSURL URLWithString:param.urlString]];
        [newFormRequest setDelegate:self];
        newFormRequest.timeOutSeconds = 60;
        [newFormRequest startRequest:indentifier param:param requestSender:requestSender];
        [requestList addObject:newFormRequest];
        [newFormRequest release];
        newFormRequest = nil;
    }
    //没网络
    else{
        KKFormRequest *newFormRequest = [[KKFormRequest alloc] initWithURL:[NSURL URLWithString:param.urlString]];
        [newFormRequest setRequestIdentifier:indentifier param:param requestSender:requestSender];

        NSMutableDictionary *httpInfomation = [[NSMutableDictionary alloc]init];
        [httpInfomation setObject:@"" forKey:httpCodeKey];
        [httpInfomation setObject:@"" forKey:httpMessageKey];
        [httpInfomation setObject:NetworkNotReachableCode forKey:httpResultCodeKey];
        [httpInfomation setObject:@"网络连接异常" forKey:httpResultMessageKey];

        [self processRequestFinished:newFormRequest httpInfomation:httpInfomation requestResult:nil];
        
        [newFormRequest release];
        [httpInfomation release];
    }
}

- (void)cancelRequest:(NSString*)indentifier{
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    [tempArray addObjectsFromArray:requestList];
    [requestList removeAllObjects];
    for (NSInteger i=0; i<[tempArray count]; i++) {
        KKFormRequest *tmpRequest = [tempArray objectAtIndex:i];
        if ([tmpRequest.identifier isEqualToString:indentifier]) {
            [tmpRequest clearDelegatesAndCancel];
            continue;
        }
        else{
            [requestList addObject:tmpRequest];
        }
    }
    [tempArray release];
}


#pragma mark ==================================================
#pragma mark == ASIHTTPRequestDelegate
#pragma mark ==================================================
/*ASIHTTPRequest代理*/
- (void)requestStarted:(ASIHTTPRequest *)request {

}

- (void)requestFinished:(ASIHTTPRequest *)request {
    KKFormRequest *formRequest = (KKFormRequest *)request;
    
    if (formRequest.responseData) {
        NSError *error;
        NSDictionary *dicData = [NSJSONSerialization JSONObjectWithData:formRequest.responseData options:NSJSONReadingMutableContainers error:&error];
        
        NSDictionary *dicString = [NSJSONSerialization JSONObjectWithData:[formRequest.responseString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&error];

        if ([NSJSONSerialization isValidJSONObject:dicData]) {
#ifdef DEBUG
            NSLog(@"★★★★★★★★★★Request %@ Finished【Data】: \n%@",formRequest.identifier,dicData);
#endif

            NSMutableDictionary *httpInfomation = [[NSMutableDictionary alloc]init];
            [httpInfomation setObject:[NSString stringWithFormat:@"%d",request.responseStatusCode] forKey:httpCodeKey];
            [httpInfomation setObject:[NSString stringWithFormat:@"%@",request.responseStatusMessage] forKey:httpMessageKey];
            [httpInfomation setObject:@"0" forKey:httpResultCodeKey];
            [httpInfomation setObject:@"请求成功" forKey:httpResultMessageKey];

            [self processRequestFinished:formRequest httpInfomation:httpInfomation requestResult:dicData];
            [httpInfomation release];
        }
        else if([NSJSONSerialization isValidJSONObject:dicString]){
#ifdef DEBUG
            NSLog(@"★★★★★★★★★★Request %@ Finished【Data】nil【String】: \n%@",formRequest.identifier,formRequest.responseString);
#endif

            NSMutableDictionary *httpInfomation = [[NSMutableDictionary alloc]init];
            [httpInfomation setObject:[NSString stringWithFormat:@"%d",request.responseStatusCode] forKey:httpCodeKey];
            [httpInfomation setObject:[NSString stringWithFormat:@"%@",request.responseStatusMessage] forKey:httpMessageKey];
            [httpInfomation setObject:@"0" forKey:httpResultCodeKey];
            [httpInfomation setObject:@"请求成功" forKey:httpResultMessageKey];

            [self processRequestFinished:formRequest httpInfomation:httpInfomation requestResult:dicString];
            [httpInfomation release];
        }
        else{
#ifdef DEBUG
            NSLog(@"★★★★★★★★★★Request %@ Finished【Data】nil【String】nil",formRequest.identifier);
            NSLog(@"%@",formRequest.responseString);
#endif

            NSMutableDictionary *httpInfomation = [[NSMutableDictionary alloc]init];
            [httpInfomation setObject:[NSString stringWithFormat:@"%d",request.responseStatusCode] forKey:httpCodeKey];
            [httpInfomation setObject:[NSString stringWithFormat:@"%@",request.responseStatusMessage] forKey:httpMessageKey];
            [httpInfomation setObject:@"0" forKey:httpResultCodeKey];
            [httpInfomation setObject:@"请求成功" forKey:httpResultMessageKey];

            [self processRequestFinished:formRequest httpInfomation:httpInfomation requestResult:nil];
            [httpInfomation release];
        }
    }
    else if (formRequest.responseString){
        NSError *error;
        NSDictionary *dicString = [NSJSONSerialization JSONObjectWithData:[formRequest.responseString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&error];

        if([NSJSONSerialization isValidJSONObject:dicString]){
#ifdef DEBUG
            NSLog(@"★★★★★★★★★★Request %@ Finished【Data】nil【String】: \n%@",formRequest.identifier,dicString);
#endif

            NSMutableDictionary *httpInfomation = [[NSMutableDictionary alloc]init];
            [httpInfomation setObject:[NSString stringWithFormat:@"%d",request.responseStatusCode] forKey:httpCodeKey];
            [httpInfomation setObject:[NSString stringWithFormat:@"%@",request.responseStatusMessage] forKey:httpMessageKey];
            [httpInfomation setObject:@"0" forKey:httpResultCodeKey];
            [httpInfomation setObject:@"请求成功" forKey:httpResultMessageKey];

            [self processRequestFinished:formRequest httpInfomation:httpInfomation requestResult:nil];
            [httpInfomation release];
        }
        else{
#ifdef DEBUG
            NSLog(@"★★★★★★★★★★Request %@ Finished【Data】nil【String】nil",formRequest.identifier);
            NSLog(@"%@",formRequest.responseString);
#endif
            NSMutableDictionary *httpInfomation = [[NSMutableDictionary alloc]init];
            [httpInfomation setObject:[NSString stringWithFormat:@"%d",request.responseStatusCode] forKey:httpCodeKey];
            [httpInfomation setObject:[NSString stringWithFormat:@"%@",request.responseStatusMessage] forKey:httpMessageKey];
            [httpInfomation setObject:@"0" forKey:httpResultCodeKey];
            [httpInfomation setObject:@"请求成功" forKey:httpResultMessageKey];

            [self processRequestFinished:formRequest httpInfomation:httpInfomation requestResult:nil];
            [httpInfomation release];
        }
    }
    else{
#ifdef DEBUG
        NSLog(@"★★★★★★★★★★Request %@ Finished【Data】nil【String】nil",formRequest.identifier);
        NSLog(@"%@",formRequest.responseString);
#endif
        NSMutableDictionary *httpInfomation = [[NSMutableDictionary alloc]init];
        [httpInfomation setObject:[NSString stringWithFormat:@"%d",request.responseStatusCode] forKey:httpCodeKey];
        [httpInfomation setObject:[NSString stringWithFormat:@"%@",request.responseStatusMessage] forKey:httpMessageKey];
        [httpInfomation setObject:@"0" forKey:httpResultCodeKey];
        [httpInfomation setObject:@"请求成功" forKey:httpResultMessageKey];

        [self processRequestFinished:formRequest httpInfomation:httpInfomation requestResult:nil];
        [httpInfomation release];
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request {
    NSMutableDictionary *httpInfomation = [[NSMutableDictionary alloc]init];
    [httpInfomation setObject:[NSString stringWithFormat:@"%d",request.responseStatusCode] forKey:httpCodeKey];
    [httpInfomation setObject:[NSString stringWithFormat:@"%@",request.responseStatusMessage] forKey:httpMessageKey];
    [httpInfomation setObject:@"1" forKey:httpResultCodeKey];
    [httpInfomation setObject:@"网络请求失败" forKey:httpResultMessageKey];
    
    [self processRequestFinished:(KKFormRequest*)request httpInfomation:httpInfomation requestResult:nil];
    [httpInfomation release];
}

- (void)processRequestFinished:(KKFormRequest*)formRequest httpInfomation:(NSDictionary*)httpInfomation requestResult:(id)requestResult{

    [self clearRequest:formRequest];
    KKRequestSender *requestSender = (KKRequestSender*)formRequest.requestSender;
    [requestSender receivedRequestFinished:formRequest httpInfomation:(NSDictionary*)httpInfomation requestResult:requestResult];
    
}

- (void)clearRequest:(KKFormRequest*)formRequest{
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    [tempArray addObjectsFromArray:requestList];
    [requestList removeAllObjects];
    for (NSInteger i=0; i<[tempArray count]; i++) {
        KKFormRequest *tmpRequest = [tempArray objectAtIndex:i];
        if ([tmpRequest.identifier isEqualToString:((KKFormRequest*)formRequest).identifier]) {
            [tmpRequest clearDelegatesAndCancel];
            continue;
        }
        else{
            [requestList addObject:tmpRequest];
        }
    }
    [tempArray release];
}

- (void)clearRequestWithIdentifier:(NSString*)aIdentifier{
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    [tempArray addObjectsFromArray:requestList];
    [requestList removeAllObjects];
    for (NSInteger i=0; i<[tempArray count]; i++) {
        KKFormRequest *tmpRequest = [tempArray objectAtIndex:i];
        if ([tmpRequest.identifier isEqualToString:aIdentifier]) {
            [tmpRequest clearDelegatesAndCancel];
            continue;
        }
        else{
            [requestList addObject:tmpRequest];
        }
    }
    [tempArray release];
}

@end



