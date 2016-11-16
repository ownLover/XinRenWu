//
//  MainViewController.h
//  MyBear
//
//  Created by 紫平方 on 16/10/10.
//  Copyright © 2016年 bear. All rights reserved.
//

#import "BaseViewController.h"

@interface MainViewController : BaseViewController <UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
@property(nonatomic,retain)UITableView *myTableView;
@property(nonatomic,retain)NSMutableArray *dataSource;
@property(nonatomic,retain)NSMutableArray *showDataSource;
@property(nonatomic,retain)NSMutableDictionary *information;
@property(nonatomic,retain)NSMutableArray *selectArr;
@property(nonatomic,assign)    NSInteger nowCengIndex;
@property(nonatomic,retain)    NSMutableArray *yesArr;
@property(nonatomic,retain)NSMutableArray *cutArr;
@end
