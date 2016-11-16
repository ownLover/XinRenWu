//
//  BaseViewController.h
//  MyBaseProject
//
//  Created by Bear on 16/1/6.
//  Copyright (c) 2016年 Bear. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KKViewController.h"

@interface BaseViewController : KKViewController
- (void)isShowCenterBtn:(BOOL)isShow;
- (void)nav;

- (NSMutableArray *)read;

- (void)save:(NSArray *)arr;

@end
