//
//  LUITabBarController.m
//  MyBaseProject
//
//  Created by Bear on 16/3/4.
//  Copyright (c) 2016年 Bear. All rights reserved.
//

#import "LUITabBarController.h"


@implementation LUITabBarController

+ (void)LUITabBarController:(NSArray *)viewControllerArr titleArr:(NSArray *)titleArr imageArr:(NSArray *)imageArr{
    UITabBarController *tabBar=[[UITabBarController alloc]init];
    //选中的颜色
    tabBar.tabBar.tintColor=[UIColor colorWithRed:0.6 green:0.93 blue:0.54 alpha:1];

    for (int i=0; i<viewControllerArr.count; i++) {
        
        UIViewController *viewController1 = [viewControllerArr objectAtIndex:i];
        viewController1.tabBarItem.title=[titleArr objectAtIndex:i];
        viewController1.title=[titleArr objectAtIndex:i];
        [viewController1.tabBarItem setImage:[UIImage imageNamed:[imageArr objectAtIndex:i]]];
        
        UINavigationController *nav1=[[UINavigationController alloc]init];
        nav1.viewControllers=@[viewController1];
        [tabBar addChildViewController:nav1];
        [nav1 release];

    }
    [UIApplication sharedApplication].keyWindow.rootViewController=tabBar;
    
    [tabBar release];

}
@end
