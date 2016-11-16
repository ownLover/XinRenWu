//
//  SettingViewController.m
//  MyBear
//
//  Created by 紫平方 on 16/10/10.
//  Copyright © 2016年 bear. All rights reserved.
//

#import "SettingViewController.h"

@interface SettingViewController ()

@end

@implementation SettingViewController
@synthesize myTableView;
@synthesize information;
@synthesize dataSource;


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"设置" ;
    // Do any additional setup after loading the view from its nib.
    dataSource=[[NSMutableArray alloc]init];
    [dataSource addObject:@"备份"];
    [dataSource addObject:@"恢复"];
    myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ApplicationWidth, ApplicationHeight-44)];
    myTableView.delegate = self;
    myTableView.dataSource = self;
    //myTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [myTableView setTableFooterView:[[UIView alloc]init]];
    myTableView.backgroundColor=myBgColor;
    [self.view addSubview:myTableView];

}

#pragma mark ========================================
#pragma mark ==UITableView
#pragma mark ========================================
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier01=@"cell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier01];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier01];
    }
    cell.textLabel.text=dataSource[indexPath.row];
    cell.textLabel.textColor=myTxColor;
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
    cell.selectedBackgroundView.backgroundColor = myBackgroundColor;
    cell.backgroundColor=myBgColor;
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *stering=dataSource[indexPath.row];
    if ([stering isEqualToString:@"清空任务"]) {
        [LDefault removeObjectForKey:saveKey];
        [self.navigationController popViewControllerAnimated:YES];
    }
    if ([stering isEqualToString:@"清除已完成"]) {
        NSArray *arr=[LDefault objectForKey:saveKey];
        NSMutableArray *array=[[NSMutableArray alloc]initWithArray:arr];
        for (int i=0; i<array.count; i++) {
            NSDictionary *adic=array[i];
            NSString *ifstring = [adic objectForKey:saveFinishKey];
            if ([ifstring isEqualToString:@"YES"]) {
                [array removeObject:adic];
            }
        }
        [LDefault setObject:array forKey:saveKey];
        [self.navigationController popViewControllerAnimated:YES];
        
    }
    if ([stering isEqualToString:@"备份"]) {
        [self observeKKRequestNotificaiton:CMDsend];
        NSString *str = [self dictionaryToJson:@{@"key":[LDefault objectForKey:saveKey]}];
        [[Net defaultSender]post:str];
    }
    if ([stering isEqualToString:@"恢复"]) {
        [self observeKKRequestNotificaiton:CMD_RegistGetToken];
        
        [[Net defaultSender]getToken];
        
    }
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



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

//- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return YES;
//}
//
//- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return UITableViewCellEditingStyleDelete;
//}
//
//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (editingStyle == UITableViewCellEditingStyleDelete) {
//
//    }
//}
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
//                [self reloadUI3];
                
            }else{
                KKShowNoticeMessage(msg);
                
            }
            
        }else{
            KKShowNoticeMessage(@"网络错误，请检查网络");
            
        }
    }
    
    
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

@end
