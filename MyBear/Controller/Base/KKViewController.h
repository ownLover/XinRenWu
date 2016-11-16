//
//  KKViewController.h
//  LawBooksChinaiPad
//
//  Created by bear on 13-3-26.
//  Copyright (c) 2013年 bear. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KKExtension.h"
#import "KKThemeManager.h"
#import "KILocalizationManager.h"
#import "KKUserDefaultsManager.h"
//#import "KKWindowImageView.h"
//#import "KKDefine.h"
//#import "KKFileCacheManager.h"
//#import "UIButton+KKWebCache.h"
//#import "UIImageView+KKWebCache.h"
#import "MBProgressHUD.h"

@interface KKViewController : UIViewController{
    BOOL endEditingWhenTouchBackground;
}

@property (nonatomic,assign)BOOL endEditingWhenTouchBackground;


#pragma mark ****************************************
#pragma mark 默认导航返回样式
#pragma mark ****************************************
- (UIButton*)showNavigationDefaultBackButton_ForNavDismiss;

- (UIButton*)showNavigationDefaultBackButton_ForNavPopBack;

- (UIButton*)showNavigationDefaultBackButton_ForVCDismiss;

#pragma mark ****************************************
#pragma mark 返回事件
#pragma mark ****************************************
- (void)navigationControllerDismiss;

- (void)navigationControllerPopBack;

- (void)viewControllerDismiss;

#pragma mark ****************************************
#pragma mark 设置导航
#pragma mark ****************************************
- (UIButton*)setNavLeftButtonImage:(UIImage *)image
                    highlightImage:(UIImage *)highlightImage
                          selector:(SEL)selecter;

- (UIButton*)setNavLeftButtonTitle:(NSString *)title
                          selector:(SEL)selecter;

- (UIButton*)setNavRightButtonImage:(UIImage *)image
                     highlightImage:(UIImage *)highlightImage
                           selector:(SEL)selecter;

- (UIButton*)setNavRightButtonTitle:(NSString *)title
                           selector:(SEL)selecter;

- (UIButton*)setNavLeftButtonForFixedSpaceWithSize:(CGSize)size;

- (UIButton*)setNavRightButtonForFixedSpaceWithWithSize:(CGSize)size;

- (void)closeNavigationBarTranslucent;

- (void)openNavigationBarTranslucent;

#pragma mark ==================================================
#pragma mark == 键盘相关
#pragma mark ==================================================
/*监听键盘事件
 - (void)viewDidAppear:(BOOL)animated{
 [super viewDidAppear:animated];
 [self addKeyboardNotification];
 }
 */

- (void)addKeyboardNotification;
/*取消监听键盘事件
 - (void)viewWillDisappear:(BOOL)animated{
 [super viewWillDisappear:animated];
 [self removeKeyboardNotification];
 }
 */
- (void)removeKeyboardNotification;

/* 子类处理 */
- (void)keyboardWillShowWithAnimationDuration:(NSTimeInterval)animationDuration keyBoardRect:(CGRect)keyBoardRect;

/* 子类处理 */
- (void)keyboardWillHideWithAnimationDuration:(NSTimeInterval)animationDuration keyBoardRect:(CGRect)keyBoardRect;


@end
