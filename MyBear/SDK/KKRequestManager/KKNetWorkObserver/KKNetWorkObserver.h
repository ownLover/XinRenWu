//
//  KKNetWorkObserver.h
//  ProjectK
//
//  Created by bear on 14-1-7.
//  Copyright (c) 2014年 Beartech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"

extern NSString *const KKNotificationName_NetWorkStatusWillChange;
extern NSString *const KKNotificationName_NetWorkStatusDidChanged;



@interface KKNetWorkObserver : NSObject<UIAlertViewDelegate>{
    Reachability    *_reachability;
}

@property(nonatomic,retain)Reachability    *reachability;
@property(nonatomic,assign)NetworkStatus    status;

+ (KKNetWorkObserver *)sharedInstance;

@end
