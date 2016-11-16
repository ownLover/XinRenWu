//
//  BaseViewController.m
//  MyBaseProject
//
//  Created by Bear on 16/1/6.
//  Copyright (c) 2016年 Bear. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()
@property(nonatomic,strong)UIButton *centerBtn;

@end

@implementation BaseViewController
@synthesize centerBtn;

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    self.navigationController.navigationBar.hidden=YES;
//    self.tabBarController.tabBar.hidden=YES;

}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //    self.navigationController.navigationBar.hidden=NO;
//    self.tabBarController.tabBar.hidden=NO;

}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.view.backgroundColor=[UIColor blackColor];
    [self center];
    
}

- (void)nav{
    
    UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(15, 22, 40, 40)];
    [img setImage:Limage(@"wo")];
    [self.view addSubview:img];
    [img release];
    
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(img.frame), 22, 40, 40)];
    lab.font = Lfont(14);
//    lab.textColor = <##>;
    lab.text= @"看否" ;
    [self.view addSubview:lab];
    [lab release];
    
    CGFloat w=ApplicationWidth-15-40;
    NSArray *arr=@[@"通讯",@"搜索",@"更多"];
    for (int i=0;i<3; i++) {
        UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame=CGRectMake(w, 22, 40, 40);
//        [btn setTitle:<#(NSString *)#> forState:UIControlStateNormal];
//        [btn setBackgroundImage:Limage(@"wo") forState:UIControlStateNormal];
        w=w-15-40;
        btn.tag=100+i;
        [btn setTitle:arr[i] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(navBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.view addSubview:btn];
    }
    
}

- (void)navBtnClick:(UIButton *)btn{
    NSInteger index=btn.tag-100;
    if (index==0) {
        //关注
    }
    if (index==1) {
        //国际
    }
    if (index==2) {
        //直播中心
//        VideoCenterVC *viewController = [[VideoCenterVC alloc]init];
//        [self.navigationController pushViewController:viewController animated:YES];
//        [viewController release];
    }
    if (index==3) {
        //全部分类
//        AllClassVC *viewController = [[AllClassVC alloc]init];
//        [self.navigationController pushViewController:viewController animated:YES];
//        [viewController release];
    }
}


- (void)center{
    centerBtn=(UIButton *)[Window0 viewWithTag:999999999];
    if (!centerBtn) {
        centerBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        centerBtn.frame=CGRectMake((ApplicationWidth-60)/2, Screen_Height-60, 60, 60);
        [centerBtn setCornerRadius:30];
        [centerBtn setBackgroundColor:[UIColor colorWithRed:0.21 green:0.36 blue:0.49 alpha:1] forState:UIControlStateNormal];
        [centerBtn addTarget:self action:@selector(centerBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [centerBtn setBorderColor:[UIColor colorWithRed:0.89 green:0.73 blue:0.46 alpha:1] width:3];
        [centerBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        centerBtn.hidden=YES;
        centerBtn.tag=999999999;
        [Window0 addSubview:centerBtn];
        
    }

}

- (void)centerBtnClick{
    UITabBarController *tab = (UITabBarController*)[UIApplication sharedApplication].keyWindow.rootViewController;
    tab.selectedIndex=2;
    
}


- (void)isShowCenterBtn:(BOOL)isShow{
    centerBtn.hidden=!isShow;
}

- (NSMutableArray *)read{
    NSArray *paths11 = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsDirectory11 = [paths11 objectAtIndex:0];
    NSString *fileName11 =@"鑫任务的备份.plist";
    NSString *logFilePath11 = [documentsDirectory11 stringByAppendingPathComponent:fileName11];
    
    
    NSFileManager *fileManager11 = [NSFileManager defaultManager];
    if([fileManager11 fileExistsAtPath:logFilePath11]){
        NSMutableArray *data11 = [[NSMutableArray alloc] initWithContentsOfFile:logFilePath11];
        return data11;
    }else{
        return [[NSMutableArray alloc]init];
    }

}

- (void)save:(NSArray *)arr{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *fileName =@"鑫任务的备份.plist";
    NSString *logFilePath = [documentsDirectory stringByAppendingPathComponent:fileName];
    
    if ([arr writeToFile:logFilePath atomically:YES]) {
        NSLog(@"写入成功");
    };

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
