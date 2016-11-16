//
//  MainViewController.m
//  MyBear
//
//  Created by 紫平方 on 16/10/10.
//  Copyright © 2016年 bear. All rights reserved.
//

#import "MainViewController.h"
#import "SettingViewController.h"
#import "XinZengViewController.h"
#import "MainTableViewCell.h"

@interface MainViewController ()

@end

@implementation MainViewController{
    NSMutableArray *selectIndexArr;
    NSMutableArray *selectStringArr;
    NSString *nowFuQin;
    NSInteger selectIndex;
    NSUInteger taptime;
    NSUInteger lastIndex;
        NSMutableArray *delMuArr;
    NSInteger nowClickLine;
    
    BOOL isEdit;
    
    NSMutableArray *titleArr;
    
}
@synthesize myTableView;
@synthesize information;
@synthesize dataSource;
@synthesize showDataSource;
@synthesize selectArr;
@synthesize yesArr;
@synthesize cutArr;

@synthesize nowCengIndex;

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    self.tabBarController.tabBar.hidden=YES;
//    self.navigationController.navigationBar.hidden=YES;
    
//    [self reloadUI];
    [self reloadUI3];
    [self setNavRightButtonTitle:@"" selector:@selector(navRightButtonClick11)];
    
}

- (void)resaveData{
    
}
//@{
//saveContentKey:_tf.text,
//saveChildKey:@[],
//saveFinishKey:@"NO",
//saveFuQinKey:@"",
//saveCengJiKey:@"0"
//}

- (void)NavLeftButtonClick{
    nowCengIndex=nowCengIndex-1;
    [titleArr removeLastObject];
    nowClickLine=[[titleArr lastObject] integerValue];
    [selectIndexArr removeLastObject];
    [selectStringArr removeLastObject];
    if (selectStringArr.count==0) {
        nowFuQin=@"";
    }else{
        nowFuQin=[selectStringArr lastObject];

    }

    [self reloadUI3];
}

- (void)NavLeftButtonClick1{
    
}

- (void)reloadUI3{
    
    if (nowCengIndex>0) {
        for (int i=0; i<dataSource.count; i++) {
            NSDictionary *aaDic=dataSource[i];
            NSInteger aaInt=[[aaDic objectForKey:saveCengJiKey] integerValue];
            if (aaInt==nowCengIndex) {
                self.title=aaDic[saveFuQinKey];
            }
        }
        self.title=[dataSource objectAtIndex:nowClickLine][saveContentKey];
//        self.title=[[dataSource objectAtIndex:0] objectForKey:saveFuQinKey];
        [self setNavLeftButtonTitle:@"返回" selector:@selector(NavLeftButtonClick)];
    }else{
        self.title=@"鑫任务";
        [self setNavLeftButtonTitle:@"" selector:@selector(NavLeftButtonClick1)];

    }

//    NSArray *arr=[LDefault objectForKey:saveKey];
    NSArray *arr=nil;;

    
    //缓存目录
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
//    NSString *cachesDirectory = [paths objectAtIndex:0];
//    //文件完整目录
//    NSString *fileFullPath = [NSString stringWithFormat:@"%@/log.txt",cachesDirectory];
    
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *fileName =@"鑫任务的备份.plist";
    NSString *logFilePath = [documentsDirectory stringByAppendingPathComponent:fileName];

    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if([fileManager fileExistsAtPath:logFilePath]){
        NSMutableArray *data1 = [[NSMutableArray alloc] initWithContentsOfFile:logFilePath];
        arr=data1;
    }
    NSLog(@"有%ld条数据  %@ 有%ld条数据",arr.count,arr,arr.count);
    [dataSource removeAllObjects];
    [dataSource addObjectsFromArray:arr];

    NSMutableArray *bArr=[[NSMutableArray alloc]init];
    for (int i=0; i<dataSource.count; i++) {
        NSDictionary *adic=[dataSource objectAtIndex:i];
        [bArr addObject:[adic objectForKey:saveContentKey]];

    }
    
    
    
    //子类的个数
    for (int i=0; i<dataSource.count; i++) {
        NSMutableDictionary *dic=[[NSMutableDictionary alloc]initWithDictionary:[dataSource objectAtIndex:i]];
        
        NSInteger zigeshu=0;
        for (int j=0; j<dataSource.count; j++) {
            NSDictionary *dicdic=[dataSource objectAtIndex:j];
            if ([[dicdic objectForKey:saveFuQinKey] isEqualToString:[dic objectForKey:saveContentKey]]) {
                zigeshu=zigeshu+1;
            }
        }
        
        [dic setObject:Lstring(zigeshu) forKey:saveZiLeiGeShuKey];
        
        [dataSource replaceObjectAtIndex:i withObject:dic];
        
    }
    
    [LDefault setObject:dataSource forKey:saveKey];
    
    //处理 没有父亲的
    for (int i=0; i<dataSource.count; i++) {
        NSMutableDictionary *adic=[[NSMutableDictionary alloc]initWithDictionary:[dataSource objectAtIndex:i]];
       NSString * ziDeFuString = [adic objectForKey:saveFuQinKey];
        
        NSInteger tempInt=0;
        
        for (id obj in bArr) {
            
            if ([obj isKindOfClass:[NSString class]]) {
                
                NSString *objStr = (NSString *)obj;
                
                if ([objStr containsString:ziDeFuString]) {
//                    NSLog(@"objStr:%@", objStr);
                    tempInt=tempInt+1;
                    
                }
                
            }
            
        }

        if (tempInt==0) {
            [adic setObject:@"" forKey:saveFuQinKey];
            [adic setObject:@"0" forKey:saveCengJiKey];
        }
        [dataSource replaceObjectAtIndex:i withObject:adic];
    }
    
    for (int i=0; i<dataSource.count; i++) {
        NSMutableDictionary *dic=[[NSMutableDictionary alloc]initWithDictionary:dataSource[i]];
      NSString *ziDeFuString = [dic objectForKey:saveFuQinKey] ;
        
        NSInteger fuDeIndex=0;
        for (int j=0; j<bArr.count; j++) {
            NSString *string=[bArr objectAtIndex:j];
            if ([string isEqualToString:ziDeFuString]) {
                fuDeIndex=j;
            }
        }
        NSDictionary *fuDic=[dataSource objectAtIndex:fuDeIndex];
        
       NSInteger index= [[fuDic objectForKey:saveCengJiKey] integerValue];
        
        if ([[dic objectForKey:saveCengJiKey] integerValue]>0) {
            [dic setObject:Lstring(index+1) forKey:saveCengJiKey];
        }
        [dataSource replaceObjectAtIndex:i withObject:dic];

    }
    
    
    [LDefault setObject:dataSource forKey:saveKey];
    NSArray *paths1 = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsDirectory1 = [paths1 objectAtIndex:0];
    NSString *fileName1 =@"鑫任务的备份.plist";
    NSString *logFilePath1 = [documentsDirectory1 stringByAppendingPathComponent:fileName1];
    if ([dataSource writeToFile:logFilePath1 atomically:YES]) {
        NSLog(@"写入成功");
    };

    [myTableView reloadData];
}
- (void)reloadUI2{
    NSArray *arr=[LDefault objectForKey:saveKey];
    [dataSource addObjectsFromArray:arr];
    for (int i=0; i<arr.count; i++) {
       NSInteger ceng = [[[arr objectAtIndex:i] objectForKey:saveCengJiKey] integerValue];
        if (ceng==nowCengIndex) {
            NSMutableDictionary *dic=[[NSMutableDictionary alloc]initWithDictionary:[arr objectAtIndex:i]];
            [dic setObject:Lstring(i) forKey:saveShowIndexKey];
            NSString *fuqin = [dic objectForKey:saveFuQinKey];
            if ([nowFuQin isEqualToString:fuqin]) {
                [showDataSource addObject:[arr objectAtIndex:i]];
            }
        }
    }
    [myTableView reloadData];
}

- (void)reloadUI{
    NSArray *arr=[LDefault objectForKey:saveKey];
    
    dataSource=[[NSMutableArray alloc]init];
    showDataSource=[[NSMutableArray alloc]init];
//    @{saveContentKey:_tf.text,saveChildKey:@[],saveFinishKey:@"NO"}
    if (arr) {
        [dataSource addObjectsFromArray:arr];
    }
    
    if (selectIndexArr&&selectIndexArr.count==0) {
        [showDataSource addObjectsFromArray:dataSource];
    }else{
        [showDataSource removeAllObjects];
        //@[@{_tf.text:@[]}]
        
        NSArray *tempArr;
        for (int i=0; i<selectIndexArr.count; i++) {
            NSInteger num=[selectIndexArr[i] integerValue];
            if (i==0) {
                tempArr = [[dataSource objectAtIndex:num] objectForKey:saveChildKey];
            }else{
                tempArr = [[tempArr objectAtIndex:num] objectForKey:saveChildKey];
            }
        }
//        @{saveContentKey:_tf.text,saveChildKey:@[],saveFinishKey:@"NO"}
        [showDataSource addObjectsFromArray:tempArr];
        
    }
    
    if (myTableView) {
        [myTableView reloadData];
    }

}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
//    self.tabBarController.tabBar.hidden=NO;
    [self setNavRightButtonTitle:@"" selector:@selector(navRightButtonClick11)];
    [yesArr removeAllObjects];
    [myTableView reloadData];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    taptime=0;
    delMuArr=[[NSMutableArray alloc]init];

    isEdit=NO;
    
    self.title=@"Getodo";
    nowCengIndex=0;
    nowFuQin=@"";
    titleArr=[[NSMutableArray alloc]init];;
    selectStringArr=[[NSMutableArray alloc]init];
    selectIndexArr=[[NSMutableArray alloc]init];
    yesArr=[[NSMutableArray alloc]init];
    cutArr=[[NSMutableArray alloc]init];

    dataSource=[[NSMutableArray alloc]init];
    myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ApplicationWidth, ApplicationHeight-44)];
    myTableView.delegate = self;
    myTableView.dataSource = self;
    //myTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [myTableView setTableFooterView:[[UIView alloc]init]];
    myTableView.backgroundColor=myBgColor;
    [self.view addSubview:myTableView];

    [myTableView registerNib:[UINib nibWithNibName:@"MainTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    
//    NSArray *arr=@[@"备份",@"恢复",@"新增",@"设置"];
    NSArray *arr=@[@"",@"",@"新增",@""];
    for (int i = 0; i<arr.count; i++) {
        UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
//        btn.frame=CGRectMake(i*(ApplicationWidth/(arr.count)), Screen_Height-64, (ApplicationWidth/(arr.count)), 64);
        btn.frame=CGRectMake(0, Screen_Height-64, ApplicationWidth, 64);
        [btn setTitle:arr[i] forState:UIControlStateNormal];
        btn.tag=100+i;
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitleColor:myTxColor forState:UIControlStateNormal];
        [self.view addSubview:btn];
    }
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]
                                               initWithTarget:self action:@selector(longPressGestureRecognized:)];
    [myTableView addGestureRecognizer:longPress];
    

//    for (int i=0; i<30; i++) {
//        [dataSource addObject:Lstring(i)];
//    }
    
    
    [self reloadUI3];

    
}

- (void)wancCLick{
    myTableView.editing=NO;
    [self setNavRightButtonTitle:@"" selector:@selector(wancCLick1)];
    if (nowCengIndex>0) {
        for (int i=0; i<dataSource.count; i++) {
            NSDictionary *aaDic=dataSource[i];
            NSInteger aaInt=[[aaDic objectForKey:saveCengJiKey] integerValue];
            if (aaInt==nowCengIndex) {
                self.title=aaDic[saveFuQinKey];
            }
        }
        self.title=[dataSource objectAtIndex:nowClickLine][saveContentKey];
        //        self.title=[[dataSource objectAtIndex:0] objectForKey:saveFuQinKey];
        [self setNavLeftButtonTitle:@"返回" selector:@selector(NavLeftButtonClick)];
    }else{
        self.title=@"鑫任务";
        [self setNavLeftButtonTitle:@"" selector:@selector(NavLeftButtonClick1)];
        
    }
    
    UIButton *btn=(UIButton *)[self.view viewWithTag:102];
    btn.hidden=NO;

    isEdit=NO;

    
    [myTableView reloadData];
}


- (void)wancCLick1{

}


- (void)longPressGestureRecognized:(UILongPressGestureRecognizer *)gesture{
    UIGestureRecognizerState state = gesture.state;
    NSLog(@"%ld",(long)state);
    myTableView.editing=YES;
    isEdit=YES;

    [self setNavRightButtonTitle:@"完成" selector:@selector(wancCLick)];

    UIButton *btn=(UIButton *)[self.view viewWithTag:102];
    btn.hidden=YES;
    
    self.title=@"拖动排序";
    
    
    CGPoint location = [gesture locationInView:myTableView];
    NSIndexPath *indexPath = [myTableView indexPathForRowAtPoint:location];
    
    NSLog(@"%ld",indexPath.row);
    
    
    static UIView       *snapshot = nil;        ///< A snapshot of the row user is moving.
    static NSIndexPath  *sourceIndexPath = nil; ///< Initial index path, where gesture begins.
    
    switch (state) {
        case UIGestureRecognizerStateBegan: {
//            if (indexPath) {
//                sourceIndexPath = indexPath;
//
//                UITableViewCell *cell = [myTableView cellForRowAtIndexPath:indexPath];
//                
//                // Take a snapshot of the selected row using helper method.
//                snapshot = [self customSnapshotFromView:cell];
//                
//                // Add the snapshot as subview, centered at cell's center...
//                __block CGPoint center = cell.center;
//                snapshot.center = center;
//                snapshot.alpha = 0.0;
//                [myTableView addSubview:snapshot];
//                [UIView animateWithDuration:0.25 animations:^{
//                    
//                    // Offset for gesture location.
//                    center.y = location.y;
//                    snapshot.center = center;
//                    snapshot.transform = CGAffineTransformMakeScale(1.05, 1.05);
//                    snapshot.alpha = 0.1;
//                    
//                    // Black out. 
//                    cell.backgroundColor = [UIColor colorWithRed:0.12 green:0.22 blue:0.29 alpha:1];
//                } completion:nil];
//            }
            myTableView.editing=YES;

            break;
        } 
            // More coming soon...
        case UIGestureRecognizerStateChanged: {
//            CGPoint center = snapshot.center;
//            center.y = location.y;
//            snapshot.center = center;
//            
//            // Is destination valid and is it different from source?
//            if (indexPath && ![indexPath isEqual:sourceIndexPath]) {
//                
//                // ... update data source.
////                [dataSource exchangeObjectAtIndex:indexPath.row withObjectAtIndex:sourceIndexPath.row];
//                [dataSource exchangeObjectAtIndex:indexPath.row withObjectAtIndex:sourceIndexPath.row];
//                [LDefault setObject:dataSource forKey:saveKey];
//                NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
//                NSString *documentsDirectory = [paths objectAtIndex:0];
//                NSString *fileName =@"鑫任务的备份.plist";
//                NSString *logFilePath = [documentsDirectory stringByAppendingPathComponent:fileName];
//                if ([dataSource writeToFile:logFilePath atomically:YES]) {
//                    NSLog(@"写入成功");
//                };
//                
//
//                // ... move the rows.
//                [myTableView moveRowAtIndexPath:sourceIndexPath toIndexPath:indexPath];
//                
//                // ... and update source so it is in sync with UI changes. 
//                sourceIndexPath = indexPath;
//                
//            }
            myTableView.editing=YES;

            break;
        }
            
        default: {
            // Clean up.
//            UITableViewCell *cell = [myTableView cellForRowAtIndexPath:sourceIndexPath];
//            [UIView animateWithDuration:0.25 animations:^{
//                
//                snapshot.center = cell.center;
//                snapshot.transform = CGAffineTransformIdentity;
//                snapshot.alpha = 0.0;
//                
//                // Undo the black-out effect we did.
//                cell.backgroundColor = [UIColor whiteColor];
//                
//            } completion:^(BOOL finished) {
//                
//                [snapshot removeFromSuperview]; 
//                snapshot = nil; 
//                
//            }]; 
//            sourceIndexPath = nil;
//            myTableView.editing=NO;

            break;
        } 

            // More coming soon...
    } 

    [yesArr removeAllObjects];
    
    [myTableView reloadData];
    
//    [myTableView setEditing:NO];
    
}

// 移动 cell 时触发
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    // 移动cell之后更换数据数组里的循序
    [dataSource exchangeObjectAtIndex:sourceIndexPath.row withObjectAtIndex:destinationIndexPath.row];
                    [LDefault setObject:dataSource forKey:saveKey];
                    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
                    NSString *documentsDirectory = [paths objectAtIndex:0];
                    NSString *fileName =@"鑫任务的备份.plist";
                    NSString *logFilePath = [documentsDirectory stringByAppendingPathComponent:fileName];
                    if ([dataSource writeToFile:logFilePath atomically:YES]) {
                        NSLog(@"写入成功");
                    };
                    

}

- (UIView *)customSnapshotFromView:(UIView *)inputView {
    
    UIView *snapshot = [inputView snapshotViewAfterScreenUpdates:YES];
    snapshot.layer.masksToBounds = NO;
    snapshot.layer.cornerRadius = 0.0;
    snapshot.layer.shadowOffset = CGSizeMake(-5.0, 0.0);
    snapshot.layer.shadowRadius = 5.0;
    snapshot.layer.shadowOpacity = 0.4;
    
    return snapshot;
}

//默认编辑模式下，每个cell左边有个红色的删除按钮，设置为None即可去掉
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleNone;
}

//是否允许indexPath的cell移动
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}


- (NSString*)dictionaryToJson:(NSDictionary *)dic

{
    
    NSError *parseError = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
}

- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    
    if (jsonString == nil) {
        
        return nil;
        
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError *err;
    
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                         
                                                        options:NSJSONReadingMutableContainers
                         
                                                          error:&err];
    
    if(err) {
        
        NSLog(@"json解析失败：%@",err);
        
        return nil;
        
    }
    
    return dic;
    
}

- (void)btnClick:(UIButton *)btn{
//    @[@"备份",@"恢复",@"新增",@"设置"]
    
    XinZengViewController *viewController = [[XinZengViewController alloc]init];
    viewController.nowCeng=nowCengIndex;
    viewController.nowFuQin=nowFuQin;
    [self.navigationController pushViewController:viewController animated:NO];

    
    if (btn.tag==100) {
//        [self observeKKRequestNotificaiton:CMDsend];
//        NSString *str = [self dictionaryToJson:@{@"key":[LDefault objectForKey:saveKey]}];
//        [[Net defaultSender]post:str];

    }
    if (btn.tag==101) {
//        [self observeKKRequestNotificaiton:CMD_RegistGetToken];
//        
//        [[Net defaultSender]getToken];

    }
    if (btn.tag==102) {
//        XinZengViewController *viewController = [[XinZengViewController alloc]init];
//        viewController.nowCeng=nowCengIndex;
//        viewController.nowFuQin=nowFuQin;
//        [self.navigationController pushViewController:viewController animated:NO];

    }
    if (btn.tag==103) {
//        SettingViewController *viewController = [[SettingViewController alloc]init];
//        [self.navigationController pushViewController:viewController animated:YES];

    }
}

#pragma mark ========================================
#pragma mark ==UITableView
#pragma mark ========================================
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return dataSource.count;
}

- (void)zirewnwuClick:(UIButton *)btn{
    nowClickLine=btn.tag-1000;
    [titleArr addObject:Lstring(nowClickLine)];
    if (cutArr.count==0) {
        [self setNavRightButtonTitle:@"" selector:@selector(navRightButtonClick11)];
        [yesArr removeAllObjects];
        
    }
    
    NSInteger inta = btn.tag-1000;
    nowCengIndex=nowCengIndex+1;
    
    nowFuQin=[dataSource[inta]objectForKey:saveContentKey];
    
    [selectIndexArr addObject:Lstring(inta)];
    [selectStringArr addObject:[dataSource[inta]objectForKey:saveContentKey]];
    [self reloadUI3];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier01=@"cell";
    MainTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier01];
    if (!cell) {
        cell=[[MainTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier01];
        
        
    }
    //@[@{_tf.text:@[]}]
    //        @{saveContentKey:_tf.text,saveChildKey:@[],saveFinishKey:@"NO"}
    
    //@{
    //saveContentKey:_tf.text,
    //saveChildKey:@[],
    //saveFinishKey:@"NO",
    //saveFuQinKey:@"",
    //saveCengJiKey:@"0"
    //}
    
    cell.neirong.text=[dataSource[indexPath.row] objectForKey:saveContentKey];
    cell.neirong.font=Lfont(15);
    CGSize size=[@"你好测试" sizeWithFont:Lfont(15) maxWidth:(ApplicationWidth-(5+20+5+80))];
    cell.neirong.frame=CGRectMake(5+20+15, 10, (ApplicationWidth-(5+20+5+80)), size.height);
    cell.neirong.numberOfLines=1;
    cell.neirong.textColor=myTxColor;
    
    cell.wancheng.frame=CGRectMake(5, 5, ApplicationWidth-10, 12);
    cell.wancheng.font=Lfont(11);
    cell.wancheng.text=[[dataSource[indexPath.row] objectForKey:saveFinishKey]isEqualToString:@"NO"]?@"未完成":@"完成";
    cell.wancheng.textColor=myTxColor;
    cell.wancheng.hidden=YES;
    
    cell.yanse.bounds=CGRectMake(0, 0, 10, 10);
    cell.yanse.center=CGPointMake(5+10, (size.height+20)/2);
    cell.yanse.backgroundColor=[[dataSource[indexPath.row] objectForKey:saveFinishKey]isEqualToString:@"NO"]?[UIColor greenColor]:[UIColor whiteColor];
    
    
    cell.geshu.bounds=CGRectMake(0, 0, 35, 35);
    cell.geshu.center=CGPointMake(ApplicationWidth-20, (size.height+20)/2);
    cell.geshu.textColor=myTxColor;
    
    cell.zirewnwu.tag=1000+indexPath.row;
    [cell.zirewnwu addTarget:self action:@selector(zirewnwuClick:) forControlEvents:UIControlEventTouchUpInside];
    [cell.zirewnwu setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    if (isEdit==NO) {
        cell.zirewnwu.hidden=NO;
    }else{
        cell.zirewnwu.hidden=YES;
        
    }
    NSInteger tempInt=0;
    NSDictionary *dic=dataSource[indexPath.row];
    NSString *afuqin = [dic objectForKey:saveContentKey];
    for (int i=0 ; i<dataSource.count; i++) {
        NSDictionary *adic=dataSource[i];
        if ([[adic objectForKey:saveFuQinKey]isEqualToString:afuqin]) {
            tempInt=tempInt+1;
        }
    }
    
    if (tempInt>0) {
        cell.geshu.text=Lstring(tempInt);
        
    }else{
        cell.geshu.text=@"";
        
    }
    
    //    cell.neirong.text=[showDataSource[indexPath.row] objectForKey:saveContentKey];
    //    cell.neirong.font=Lfont(15);
    //    CGSize size=[cell.neirong.text sizeWithFont:Lfont(15) maxWidth:(ApplicationWidth-(5+20+5+80))];
    //    cell.neirong.frame=CGRectMake(5+20+15, 25, (ApplicationWidth-(5+20+5+80)), size.height);
    //
    //    cell.wancheng.frame=CGRectMake(5, 5, ApplicationWidth-10, 15);
    //    cell.wancheng.font=Lfont(15);
    //    cell.wancheng.text=[[showDataSource[indexPath.row] objectForKey:saveFinishKey]isEqualToString:@"NO"]?@"未完成":@"完成";
    //
    //    cell.yanse.bounds=CGRectMake(0, 0, 10, 10);
    //    cell.yanse.center=CGPointMake(5+10, (size.height+40)/2);
    //
    //    cell.geshu.bounds=CGRectMake(0, 0, 40, 40);
    //    cell.geshu.center=CGPointMake(ApplicationWidth-20, (size.height+40)/2);
    //
    //
    //添加轻扫手势
    UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeGesture:)];
    //设置轻扫的方向
    swipeGesture.direction = UISwipeGestureRecognizerDirectionRight; //默认向右
    [cell.contentView addGestureRecognizer:swipeGesture];
    
    UISwipeGestureRecognizer *swipeGesture1 = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeGesture:)];
    //设置轻扫的方向
    swipeGesture.direction = UISwipeGestureRecognizerDirectionLeft; //向左
    [cell.contentView addGestureRecognizer:swipeGesture1];
    
    
    NSInteger ceng = [[[dataSource objectAtIndex:indexPath.row] objectForKey:saveCengJiKey] integerValue];
    if (ceng==nowCengIndex) {
        NSMutableDictionary *dic=[[NSMutableDictionary alloc]initWithDictionary:[dataSource objectAtIndex:indexPath.row]];
        NSString *fuqin = [dic objectForKey:saveFuQinKey];
        if ([nowFuQin isEqualToString:fuqin]) {
            cell.neirong.hidden=NO;
            cell.wancheng.hidden=NO;
            cell.yanse.hidden=NO;
            cell.geshu.hidden=NO;
            
            
        }
    }else{
        cell.neirong.hidden=YES;
        cell.wancheng.hidden=YES;
        cell.yanse.hidden=YES;
        cell.geshu.hidden=YES;
        
        
    }
    cell.wancheng.hidden=YES;
    NSUInteger temp=0;
    for (int i=0; i<yesArr.count; i++) {
        if ([[yesArr objectAtIndex:i] integerValue]==indexPath.row) {
            temp=temp+1;
        }
    }
    if (temp>0) {
        cell.backgroundColor=[UIColor lightGrayColor];
    }else{
        cell.backgroundColor=myBgColor;
        
    }
    cell.textLabel.font=Lfont(18);
    cell.textLabel.numberOfLines=0;
    //    cell.textLabel.text=[showDataSource[indexPath.row] objectForKey:saveContentKey];
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
    cell.selectedBackgroundView.backgroundColor = myTxColor;
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    NSUInteger curr = [[NSDate date] timeIntervalSince1970];
    if (curr-taptime<1&&lastIndex==indexPath.row) {
        //        [self doubleTap];
        NSLog(@"双击");
        XinZengViewController *viewController = [[XinZengViewController alloc]init];
        viewController.nowCeng=nowCengIndex;
        viewController.isEdit=YES;
        viewController.selectIndex=indexPath.row;
        viewController.nowFuQin=nowFuQin;
        viewController.tempEditDic=dataSource[indexPath.row];
        [self.navigationController pushViewController:viewController animated:NO];
        
    }else{
        NSLog(@"单机");
        if (yesArr.count==0) {
            [yesArr addObject:Lstring(indexPath.row)];
        }else{
            
            NSInteger temp=0;
            for (int i =0; i<yesArr.count; i++) {
                NSInteger aInt=[[yesArr objectAtIndex:i] integerValue];
                if (aInt==indexPath.row) {
                    temp=temp+1;
                }
            }
            if (temp==0) {
                [yesArr addObject:Lstring(indexPath.row)];
            }else{
                [yesArr removeObject:Lstring(indexPath.row)];
            }
            
        }
        if (yesArr.count>0) {
            [self showTwo];
        }else{
            [self setNavRightButtonTitle:@"" selector:@selector(navRightButtonClick11)];
            
        }
        [myTableView reloadData];
    }
    taptime = curr;
    
    lastIndex=indexPath.row;
    
    NSLog(@"选择了%ld条",yesArr.count);
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *text=[dataSource[indexPath.row] objectForKey:saveContentKey];
    CGSize size=[@"你好" sizeWithFont:Lfont(15) maxWidth:(ApplicationWidth-(5+20+5+80))];
    
    NSInteger ceng = [[[dataSource objectAtIndex:indexPath.row] objectForKey:saveCengJiKey] integerValue];
    if (ceng==nowCengIndex) {
        NSMutableDictionary *dic=[[NSMutableDictionary alloc]initWithDictionary:[dataSource objectAtIndex:indexPath.row]];
        NSString *fuqin = [dic objectForKey:saveFuQinKey];
        if ([nowFuQin isEqualToString:fuqin]) {
            return size.height+20;
        }
        
    }
    
    return 0.001;
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [dataSource removeObjectAtIndex:indexPath.row];
        NSDictionary *dic=[dataSource objectAtIndex:indexPath.row];
        NSMutableArray *muArr=[[NSMutableArray alloc]init];
        NSString *string=[dic objectForKey:saveContentKey];
        [muArr addObject:string];
        for (int i=0; i<dataSource.count; i++) {
            NSDictionary *adic=dataSource[i];
            NSString *fuString=[adic objectForKey:saveFuQinKey];
            if ([fuString isEqualToString:string]) {
                [muArr addObject:[adic objectForKey:saveContentKey]];
            }
        }
        
        [LDefault setObject:dataSource forKey:saveKey];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *fileName =@"鑫任务的备份.plist";
        NSString *logFilePath = [documentsDirectory stringByAppendingPathComponent:fileName];
        if ([dataSource writeToFile:logFilePath atomically:YES]) {
            NSLog(@"写入成功");
        };
        
        
        [myTableView reloadData];
    }
}


//轻扫手势触发方法
-(void)swipeGesture:(id)sender
{
    
    UISwipeGestureRecognizer *swipe = sender;
    
    if (swipe.direction == UISwipeGestureRecognizerDirectionLeft)
        
    {
        CGPoint location = [swipe locationInView:myTableView];
        NSIndexPath *indexPath = [myTableView indexPathForRowAtPoint:location];
        
        NSDictionary *dic=dataSource[indexPath.row];
        NSMutableDictionary *adic=[[NSMutableDictionary alloc]initWithDictionary:dic];
        
        [adic setObject:@"NO" forKey:saveFinishKey];
        
        [dataSource replaceObjectAtIndex:indexPath.row withObject:adic];
        
        [LDefault setObject:dataSource forKey:saveKey];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *fileName =@"鑫任务的备份.plist";
        NSString *logFilePath = [documentsDirectory stringByAppendingPathComponent:fileName];
        if ([dataSource writeToFile:logFilePath atomically:YES]) {
            NSLog(@"写入成功");
        };

        [myTableView reloadData];

        //向左轻扫做的事情
        
    }
    
    if (swipe.direction == UISwipeGestureRecognizerDirectionRight)
        
    { 
        CGPoint location = [swipe locationInView:myTableView];
        NSIndexPath *indexPath = [myTableView indexPathForRowAtPoint:location];
        
        NSDictionary *dic=dataSource[indexPath.row];
        NSMutableDictionary *adic=[[NSMutableDictionary alloc]initWithDictionary:dic];
        
        [adic setObject:@"YES" forKey:saveFinishKey];
        
        [dataSource replaceObjectAtIndex:indexPath.row withObject:adic];
        
        [LDefault setObject:dataSource forKey:saveKey];
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *fileName =@"鑫任务的备份.plist";
        NSString *logFilePath = [documentsDirectory stringByAppendingPathComponent:fileName];
        if ([dataSource writeToFile:logFilePath atomically:YES]) {
            NSLog(@"写入成功");
        };

        
        [myTableView reloadData];
        
        //向右轻扫做的事情 
        
    }
}



- (void)navRightButtonClick11{
    
}

- (void)navRightButtonClick{
    [self setNavRightButtonTitle:@"粘贴" selector:@selector(navRightButtonClick1)];
    [cutArr removeAllObjects];
    for (int i=0; i<yesArr.count; i++) {
        [cutArr addObject:[dataSource objectAtIndex:[[yesArr objectAtIndex:i] integerValue]]];
    }
    
    for (int i=0; i<yesArr.count; i++) {
        [dataSource removeObjectAtIndex:[[yesArr objectAtIndex:i] integerValue]];
    }
    
    [LDefault setObject:dataSource forKey:saveKey];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *fileName =@"鑫任务的备份.plist";
    NSString *logFilePath = [documentsDirectory stringByAppendingPathComponent:fileName];
    if ([dataSource writeToFile:logFilePath atomically:YES]) {
        NSLog(@"写入成功");
    };

    [yesArr removeAllObjects];
    
    [myTableView reloadData];
}

- (void)navRightButtonClick1{
    [self setNavRightButtonTitle:@"" selector:@selector(navRightButtonClick11)];

    for (int i=0; i<cutArr.count; i++) {
        NSMutableDictionary *dic=[[NSMutableDictionary alloc]initWithDictionary:[cutArr objectAtIndex:i]];
        [dic setObject:Lstring(nowCengIndex) forKey:saveCengJiKey];
        [dic setObject:nowFuQin forKey:saveFuQinKey];
        [dataSource addObject:dic];
        
    }
    
    [LDefault setObject:dataSource forKey:saveKey];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *fileName =@"鑫任务的备份.plist";
    NSString *logFilePath = [documentsDirectory stringByAppendingPathComponent:fileName];
    if ([dataSource writeToFile:logFilePath atomically:YES]) {
        NSLog(@"写入成功");
    };

    [myTableView reloadData];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark ==================================================
#pragma mark == 【网络】与【数据处理】
#pragma mark ==================================================
- (void)KKRequestRequestFinished:(NSDictionary *)requestResult
                  httpInfomation:(NSDictionary *)httpInfomation
               requestIdentifier:(NSString *)requestIdentifier
{
    [MBProgressHUD hideAllHUDsForView:Window0 animated:YES];
    if ([requestIdentifier isEqualToString: CMDsend]) {
        [self unobserveKKRequestNotificaiton:requestIdentifier];
        if (requestResult && [requestResult isKindOfClass:[NSDictionary class]]) {
            NSString *code = [requestResult stringValueForKey:@"retcode"];
//            NSString *data = [requestResult objectForKey:@"data"];
            NSString *msg = [requestResult objectForKey:@"message"];
            if ([code isEqualToString:@"0"]) {
                KKShowNoticeMessage(@"备份成功");

            }else{
                KKShowNoticeMessage(msg);

            }
            
        }else{
            KKShowNoticeMessage(@"网络错误，请检查网络");
            
        }
    }
    
    if ([requestIdentifier isEqualToString: CMD_RegistGetToken]) {
        [self unobserveKKRequestNotificaiton:requestIdentifier];
        if (requestResult && [requestResult isKindOfClass:[NSDictionary class]]) {
                        NSString *code = [requestResult stringValueForKey:@"retcode"];
                        NSString *data = [requestResult objectForKey:@"data"];
                        NSString *msg = [requestResult objectForKey:@"message"];
                        if ([code isEqualToString:@"0"]) {
                            
                            KKShowNoticeMessage(@"恢复成功");
                            
                            [LDefault setObject:[[self dictionaryWithJsonString:data] objectForKey:@"key"] forKey:saveKey];
                            [self reloadUI3];
                            
                        }else{
                            KKShowNoticeMessage(msg);

                        }
            
        }else{
                        KKShowNoticeMessage(@"网络错误，请检查网络");
            
        }
    }
    
    
}

- (void)deleByString:(NSString *)delString{
    NSArray *arr=[LDefault objectForKey:saveKey];
    NSMutableArray *array=[[NSMutableArray alloc]initWithArray:arr];
    NSMutableArray *array1=[[NSMutableArray alloc]initWithArray:arr];
    
    for (int i=0; i<array1.count; i++) {
        NSDictionary *dic=[array1 objectAtIndex:i];
        
        NSString *bianLiFuQin=[dic objectForKey:saveFuQinKey];
        
        if ([bianLiFuQin isEqualToString:delString]) {
            for (int j=0; j<array.count; j++) {
                
                NSDictionary *aDic=array[j];
                if ([[aDic objectForKey:saveContentKey]isEqualToString:[dic objectForKey:saveContentKey]]) {
                    [array removeObject:aDic];
                }
            }
            [delMuArr addObject:[dic objectForKey:saveContentKey]];
        }
    }
    [delMuArr removeObject:delString];
    [LDefault setObject:array forKey:saveKey];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *fileName =@"鑫任务的备份.plist";
    NSString *logFilePath = [documentsDirectory stringByAppendingPathComponent:fileName];
     if ([array writeToFile:logFilePath atomically:YES]) {
        NSLog(@"写入成功");
    };

}

- (void)showTwo{
    UIButton *rightButton01 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 44)];
    [rightButton01 addTarget:self action:@selector(navRight01ButtonClick) forControlEvents:UIControlEventTouchUpInside];
    rightButton01.backgroundColor = [UIColor clearColor];
    rightButton01.exclusiveTouch = YES;//关闭多点
    [rightButton01 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [rightButton01 setTitle:@"删除" forState:UIControlStateNormal];
    //    UIImage *image1 = KKThemeImage(@"btn_NavAdd");
    //    [rightButton01 setImage:image1 forState:UIControlStateNormal];
    UIBarButtonItem *rightItem01 = [[UIBarButtonItem alloc] initWithCustomView:rightButton01];
    //    rightButton01.frame = CGRectMake(0, 0, image1.size.width+30, 44);
    
    UIButton *rightButton02 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0,50, 44)];
    [rightButton02 addTarget:self action:@selector(navRightButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [rightButton02 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [rightButton02 setTitle:@"剪切" forState:UIControlStateNormal];
    rightButton02.backgroundColor = [UIColor clearColor];
    rightButton02.exclusiveTouch = YES;//关闭多点
    //    UIImage *image2 = KKThemeImage(@"btn_NavSearch");
    //    [rightButton02 setImage:image2 forState:UIControlStateNormal];
    UIBarButtonItem *rightItem02 = [[UIBarButtonItem alloc] initWithCustomView:rightButton02];
    //    rightButton02.frame = CGRectMake(0, 0, image2.size.width, 44);
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
    {
        UIBarButtonItem *negativeSeperator = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        negativeSeperator.width = -10;
        [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:negativeSeperator,rightItem01,rightItem02, nil] animated:NO];
    }
    else
    {
        [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:rightItem01,rightItem02, nil] animated:NO];
    }
    
    
}

- (void)navRight01ButtonClick{
    NSArray *arr=[LDefault objectForKey:saveKey];
    NSMutableArray *array=[[NSMutableArray alloc]initWithArray:arr];
    
    NSInteger tt=0;
    NSInteger aa=0;
    for (int i=0; i<yesArr.count; i++) {//有无子任务
        NSInteger inde=[[yesArr objectAtIndex:i] integerValue];
        NSDictionary *adic=[dataSource objectAtIndex:inde];
        if ([[adic objectForKey:saveZiLeiGeShuKey] integerValue]>0) {
            tt=tt+1;
        }
        if ([[adic objectForKey:saveZiLeiGeShuKey] integerValue]==0) {
            aa=aa+1;
        }
    }
    
    if (aa>0&&tt>0) {
        KKShowNoticeMessage(@"请分开选择有无子任务的任务进行处理");
        return;
    }
    
    if (tt>0) {//有子任务
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"确认" message:@"确认删除此任务及其所有子任务吗" delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是",nil];
        [[alertView textFieldAtIndex:0] setKeyboardType:UIKeyboardTypeNumberPad];
        [alertView show];

    }else{//无子任务
        
        NSArray *tYesArr=yesArr;
        for (int i=0; i<tYesArr.count; i++) {
            
            [array removeObjectAtIndex:[[tYesArr objectAtIndex:i] integerValue]];
            
            [LDefault setObject:array forKey:saveKey];
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
            NSString *documentsDirectory = [paths objectAtIndex:0];
            NSString *fileName =@"鑫任务的备份.plist";
            NSString *logFilePath = [documentsDirectory stringByAppendingPathComponent:fileName];
            if ([array writeToFile:logFilePath atomically:YES]) {
                NSLog(@"写入成功");
            };

        }

        [yesArr removeAllObjects];
    }
    
    [self reloadUI3];
    [self setNavRightButtonTitle:@"" selector:@selector(NavLeftButtonClick1)];

}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSLog(@"%ld",(long)buttonIndex);
    if (buttonIndex==1) {
        for (int j=0; j<yesArr.count; j++) {
            
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
            NSString *documentsDirectory = [paths objectAtIndex:0];
            NSString *fileName =@"鑫任务的备份.plist";
            NSString *logFilePath = [documentsDirectory stringByAppendingPathComponent:fileName];
            
            NSArray *arr=nil;;

            NSFileManager *fileManager = [NSFileManager defaultManager];
            if([fileManager fileExistsAtPath:logFilePath]){
                NSMutableArray *data1 = [[NSMutableArray alloc] initWithContentsOfFile:logFilePath];
                arr=data1;
            }

            
            NSMutableArray *array=[[NSMutableArray alloc]initWithArray:arr];
            NSMutableArray *array1=[[NSMutableArray alloc]initWithArray:arr];
            
            NSDictionary *tempEditDic=[array1 objectAtIndex:[[yesArr objectAtIndex:j] integerValue]];
            
            [array removeObjectAtIndex:[[yesArr objectAtIndex:j] integerValue]];
            
            for (int i=0; i<array1.count; i++) {
                NSDictionary *dic=[array1 objectAtIndex:i];
                
                //要删除的content
                NSString *shanString=[tempEditDic objectForKey:saveContentKey];
                //里面所有的父亲
                NSString *bianLiFuQin=[dic objectForKey:saveFuQinKey];
                //如果相同 就删除 以他为父亲的人 把他当成父亲 存起来
                if ([shanString isEqualToString:bianLiFuQin]) {
                    
                    [delMuArr addObject:[dic objectForKey:saveContentKey]];
                    
                    for (int j=0; j<array.count; j++) {
                        NSDictionary *aDic=array[j];
                        if ([[aDic objectForKey:saveContentKey]isEqualToString:[dic objectForKey:saveContentKey]]) {
                            [array removeObject:aDic];
                        }
                    }
                    
                }
            }
            
            [LDefault setObject:array forKey:saveKey];
            NSArray *paths1 = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
            NSString *documentsDirectory1 = [paths1 objectAtIndex:0];
            NSString *fileName1 =@"鑫任务的备份.plist";
            NSString *logFilePath1 = [documentsDirectory1 stringByAppendingPathComponent:fileName1];
            
            
            NSFileManager *fileManager11 = [NSFileManager defaultManager];
            if([fileManager11 fileExistsAtPath:logFilePath1]){
                NSError *err=nil;
                [fileManager11 removeItemAtPath:logFilePath1 error:&err];
                
            }

            
            if ([array writeToFile:logFilePath1 atomically:YES]) {
                NSLog(@"写入成功");
            };

            while (delMuArr.count>0) {
                [self deleByString:delMuArr[0]];
            }
        }
        
    }
    [yesArr removeAllObjects];
    [self reloadUI3];
    
}



@end
