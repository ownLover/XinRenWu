//
//  XinZengViewController.m
//  MyBear
//
//  Created by 紫平方 on 16/10/11.
//  Copyright © 2016年 bear. All rights reserved.
//

#import "XinZengViewController.h"

@interface XinZengViewController ()

@end

@implementation XinZengViewController{
    NSMutableArray *delMuArr;
}
@synthesize nowCeng;
@synthesize nowFuQin;
@synthesize selectIndex;
@synthesize isEdit;
@synthesize tempEditDic;
@synthesize oldFuqin;

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden=NO;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title=@"新增";
    delMuArr=[[NSMutableArray alloc]init];
    [self setNavLeftButtonTitle:@"返回" selector:@selector(NavLeftButtonClick)];
    
    [self setNavRightButtonTitle:@"保存" selector:@selector(NavRightButtonClickNavRightButtonClick)];
    
    [_tf setBorderColor:[UIColor whiteColor] width:1];
    _tf.backgroundColor=[UIColor blackColor];
    _tf.textColor=myTxColor;
    if (isEdit==YES) {
        [self showTwo];
        _tf.text=[tempEditDic objectForKey:saveContentKey];
        oldFuqin=[tempEditDic objectForKey:saveContentKey];
        self.title=@"编辑";
        
        
    }
    
    [_tf becomeFirstResponder];
}

- (void)navRight01ButtonClick{
    NSMutableDictionary *aDic=[[NSMutableDictionary alloc]initWithDictionary:tempEditDic];
    [aDic setObject:_tf.text forKey:saveContentKey];
    NSArray *arr=[LDefault objectForKey:saveKey];
    NSMutableArray *array=[[NSMutableArray alloc]initWithArray:arr];
    [array replaceObjectAtIndex:selectIndex withObject:aDic];
    
    for (int i=0; i<array.count; i++) {
        NSMutableDictionary *tDic=[[NSMutableDictionary alloc]initWithDictionary:[array objectAtIndex:i]];;
        NSString *fuqin=[tDic objectForKey:saveFuQinKey];
        if ([fuqin isEqualToString:oldFuqin]) {
            [tDic setObject:_tf.text forKey:saveFuQinKey];
            [array replaceObjectAtIndex:i withObject:tDic];
        }
    }
    
    [LDefault setObject:array forKey:saveKey];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *fileName =@"鑫任务的备份.plist";
    NSString *logFilePath = [documentsDirectory stringByAppendingPathComponent:fileName];
    
    if ([array writeToFile:logFilePath atomically:YES]) {
        NSLog(@"写入成功");
    };
    

    
    [self.navigationController popViewControllerAnimated:NO];

}

- (void)navRight02ButtonClick{
    //删除
    NSArray *arr=[LDefault objectForKey:saveKey];
    NSMutableArray *array=[[NSMutableArray alloc]initWithArray:arr];

    NSInteger tInt=0;
    for (int i=0; i<array.count; i++) {
        NSDictionary *dic=[array objectAtIndex:i];
        if ([[tempEditDic objectForKey:saveContentKey] isEqualToString:[dic objectForKey:saveFuQinKey]]) {
            tInt=tInt+1;
        }
         ;
    }
    
    if (tInt>0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"确认" message:@"确认删除此任务及其所有子任务吗" delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是",nil];
        [[alertView textFieldAtIndex:0] setKeyboardType:UIKeyboardTypeNumberPad];
        [alertView show];

    }else{
        [array removeObjectAtIndex:selectIndex];
        
        [LDefault setObject:array forKey:saveKey];
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *fileName =@"鑫任务的备份.plist";
        NSString *logFilePath = [documentsDirectory stringByAppendingPathComponent:fileName];
        
        if ([array writeToFile:logFilePath atomically:YES]) {
            NSLog(@"写入成功");
        };
        

        
        [self.navigationController popViewControllerAnimated:NO];
        

    }
        
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSLog(@"%ld",(long)buttonIndex);
    if (buttonIndex==1) {
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

        NSMutableArray *array=[[NSMutableArray alloc]initWithArray:arr];
        NSMutableArray *array1=[[NSMutableArray alloc]initWithArray:arr];
        
        [array removeObjectAtIndex:selectIndex];

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
        

        NSArray *paths1 = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
        NSString *documentsDirectory1 = [paths1 objectAtIndex:0];
        NSString *fileName1 =@"鑫任务的备份.plist";
        NSString *logFilePath1 = [documentsDirectory1 stringByAppendingPathComponent:fileName1];
        
        if ([array writeToFile:logFilePath1 atomically:YES]) {
            NSLog(@"写入成功");
        };
        

        
        while (delMuArr.count>0) {
            [self deleByString:delMuArr[0]];
        }
        
        

        [self.navigationController popViewControllerAnimated:NO];

    

    }
    
}

- (void)deleByString:(NSString *)delString{
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
    NSArray *paths1 = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsDirectory1 = [paths1 objectAtIndex:0];
    NSString *fileName1 =@"鑫任务的备份.plist";
    NSString *logFilePath1 = [documentsDirectory1 stringByAppendingPathComponent:fileName1];
    
    if ([array writeToFile:logFilePath1 atomically:YES]) {
        NSLog(@"写入成功");
    };
    
}

- (void)showTwo{
    UIButton *rightButton01 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 44)];
    [rightButton01 addTarget:self action:@selector(navRight01ButtonClick) forControlEvents:UIControlEventTouchUpInside];
    rightButton01.backgroundColor = [UIColor clearColor];
    rightButton01.exclusiveTouch = YES;//关闭多点
    [rightButton01 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [rightButton01 setTitle:@"保存" forState:UIControlStateNormal];
//    UIImage *image1 = KKThemeImage(@"btn_NavAdd");
//    [rightButton01 setImage:image1 forState:UIControlStateNormal];
    UIBarButtonItem *rightItem01 = [[UIBarButtonItem alloc] initWithCustomView:rightButton01];
//    rightButton01.frame = CGRectMake(0, 0, image1.size.width+30, 44);
    
    UIButton *rightButton02 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0,50, 44)];
    [rightButton02 addTarget:self action:@selector(navRight02ButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [rightButton02 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [rightButton02 setTitle:@"删除" forState:UIControlStateNormal];
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

- (void)NavRightButtonClickNavRightButtonClick{
    if ([_tf.text isEqualToString:@""]) {
        KKShowNoticeMessage(@"请输入内容");
        return;
    }
    if (isEdit==YES) {
        
    }else{
        NSArray *arr=[self read];
        NSMutableArray *array=[[NSMutableArray alloc]initWithArray:arr];
        [array addObject:@{@"content":_tf.text,@"arr":[NSArray new],@"isFinish":@"NO"}];
        [self save:array];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)NavRightButtonClick{
    if ([_tf.text isEqualToString:@""]) {
        KKShowNoticeMessage(@"请输入内容");
        return;
    }
    
    if (isEdit==YES) {
        NSMutableDictionary *aDic=[[NSMutableDictionary alloc]initWithDictionary:tempEditDic];
        [aDic setObject:_tf.text forKey:saveContentKey];
        NSArray *arr=[LDefault objectForKey:saveKey];
        
        for (int i=0; i<arr.count; i++) {
            NSDictionary *addic=arr[i];
            NSString *stringqa=addic[saveContentKey];
            if ([stringqa isEqualToString:_tf.text]) {
                KKShowNoticeMessage(@"已存在相同的任务");
                return;
            }
        }
        
        NSMutableArray *array=[[NSMutableArray alloc]initWithArray:arr];
        [array replaceObjectAtIndex:selectIndex withObject:aDic];
        
        for (int i=0; i<array.count; i++) {
            NSMutableDictionary *tDic=[[NSMutableDictionary alloc]initWithDictionary:[array objectAtIndex:i]];;
            NSString *fuqin=[tDic objectForKey:saveFuQinKey];
            if ([fuqin isEqualToString:oldFuqin]) {
                [tDic setObject:_tf.text forKey:saveFuQinKey];
                [array replaceObjectAtIndex:i withObject:tDic];
            }
        }
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *fileName =@"鑫任务的备份.plist";
        NSString *logFilePath = [documentsDirectory stringByAppendingPathComponent:fileName];
        if ([array writeToFile:logFilePath atomically:YES]) {
            NSLog(@"写入成功");
        };
        

        [LDefault setObject:array forKey:saveKey];
    }else{
        NSArray *arr11=nil;;
        
        
        //缓存目录
        //    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        //    NSString *cachesDirectory = [paths objectAtIndex:0];
        //    //文件完整目录
        //    NSString *fileFullPath = [NSString stringWithFormat:@"%@/log.txt",cachesDirectory];
        
        
        NSArray *paths11 = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
        NSString *documentsDirectory11 = [paths11 objectAtIndex:0];
        NSString *fileName11 =@"鑫任务的备份.plist";
        NSString *logFilePath11 = [documentsDirectory11 stringByAppendingPathComponent:fileName11];
        
        
        NSFileManager *fileManager11 = [NSFileManager defaultManager];
        if([fileManager11 fileExistsAtPath:logFilePath11]){
            NSMutableArray *data11 = [[NSMutableArray alloc] initWithContentsOfFile:logFilePath11];
            arr11=data11;
        }
        NSMutableArray *array=[[NSMutableArray alloc]initWithArray:arr11];
        
        for (int i=0; i<array.count; i++) {
            NSDictionary *addic=array[i];
            NSString *stringqa=addic[saveContentKey];
            if ([stringqa isEqualToString:_tf.text]) {
                KKShowNoticeMessage(@"已存在相同的任务");
                return;
            }
        }

        
        NSInteger count=0;
        for (int i=0; i<array.count; i++) {
            NSDictionary *dic=[array objectAtIndex:i];
            NSString *str = [dic objectForKey:saveCengJiKey];
            if ([str isEqualToString:@"0"]) {
                count=count+1;
            }
        }
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *fileName =@"鑫任务的备份.plist";
        NSString *logFilePath = [documentsDirectory stringByAppendingPathComponent:fileName];
        
        
        if (array) {
            [array addObject:@{saveContentKey:_tf.text,saveChildKey:@[],saveFinishKey:@"NO",saveFuQinKey:nowFuQin,saveCengJiKey:Lstring(nowCeng),saveFuQinArrKey:@[]}];
            [LDefault setObject:array forKey:saveKey];
            
            if ([array writeToFile:logFilePath atomically:YES]) {
                NSLog(@"写入成功");
            };
            

        }else{
            [LDefault setObject:@[@{saveContentKey:_tf.text,saveChildKey:@[],saveFinishKey:@"NO",saveFuQinKey:nowFuQin,saveCengJiKey:Lstring(nowCeng),saveFuQinArrKey:@[]}] forKey:saveKey];
            
            if ([@[@{saveContentKey:_tf.text,saveChildKey:@[],saveFinishKey:@"NO",saveFuQinKey:nowFuQin,saveCengJiKey:Lstring(nowCeng),saveFuQinArrKey:@[]}] writeToFile:logFilePath atomically:YES]) {
                NSLog(@"写入成功");
            };
            

            
        }

        
    }
    
    
    
    
    
    [self.navigationController popViewControllerAnimated:NO];

    
}


- (void)NavLeftButtonClick{
    [self.navigationController popViewControllerAnimated:NO];
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
