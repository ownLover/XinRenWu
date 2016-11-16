//
//  SettingViewController.h
//  MyBear
//
//  Created by 紫平方 on 16/10/10.
//  Copyright © 2016年 bear. All rights reserved.
//

#import "BaseViewController.h"

@interface SettingViewController : BaseViewController <UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,retain)UITableView *myTableView;
@property(nonatomic,retain)NSMutableArray *dataSource;
@property(nonatomic,retain)NSMutableDictionary *information;

@end
