//
//  orderTableClass.h
//  FoodOrderingSystem
//
//  Created by llx on 15-1-23.
//  Copyright (c) 2015年 llx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface orderTableClass : NSObject
@property(assign,nonatomic)NSInteger orderTableId;
@property(assign,nonatomic)NSInteger orderTableMenuNum;
@property(retain,nonatomic)NSString *orderTaleMenuName;
@property(retain,nonatomic)NSString *orderTablePrice;
@property(retain,nonatomic)NSString *orderTableKind;
@property(retain,nonatomic)NSString *orderTableRemark;

@end
