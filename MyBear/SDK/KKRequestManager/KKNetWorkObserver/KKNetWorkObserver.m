//
//  KKNetWorkObserver.m
//  ProjectK
//
//  Created by bear on 14-1-7.
//  Copyright (c) 2014年 Beartech. All rights reserved.
//

#import "KKNetWorkObserver.h"

NSString *const KKNotificationName_NetWorkStatusWillChange = @"KKNotificationName_NetWorkStatusWillChange";
NSString *const KKNotificationName_NetWorkStatusDidChanged = @"KKNotificationName_NetWorkStatusDidChanged";


@interface KKNetWorkObserver()

@end


@implementation KKNetWorkObserver
@synthesize reachability = _reachability;
@synthesize status;

- (void)dealloc{
    [_reachability release];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}

+ (KKNetWorkObserver *)sharedInstance {
    static KKNetWorkObserver *KKNETWORK_OBSERVER = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        KKNETWORK_OBSERVER = [[self alloc] init];
    });
    return KKNETWORK_OBSERVER;
}

- (id)init {
    self = [super init];
    if (self) {
        NSString *host = @"www.baidu.com";
        _reachability = [[Reachability reachabilityWithHostname:host] retain];
        [_reachability startNotifier];
        status = ReachableViaWiFi;
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(reachabilityChanaged:)
                                                     name:kReachabilityChangedNotification
                                                   object:nil];
    }
    return self ;
}

#pragma mark ==================================================
#pragma mark == 通知
#pragma mark ==================================================
- (void)reachabilityChanaged:(NSNotification *)noti {
    Reachability *reachability = [noti object];
    if ([reachability isKindOfClass:[Reachability class]]) {
        [self updateInterfaceWithReachability:reachability];
    }
}

- (void)updateInterfaceWithReachability:(Reachability *)reachability {
    NetworkStatus newStatus = [reachability currentReachabilityStatus];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:[NSNumber numberWithInt:status] forKey:@"oldNetworkStatus"];
    [dic setObject:[NSNumber numberWithInt:newStatus] forKey:@"newNetworkStatus"];
    [[NSNotificationCenter defaultCenter] postNotificationName:KKNotificationName_NetWorkStatusWillChange
                                                        object:nil
                                                      userInfo:dic];
    status = newStatus;
    [[NSNotificationCenter defaultCenter] postNotificationName:KKNotificationName_NetWorkStatusDidChanged object:[NSNumber numberWithInteger:status]];
}



@end
