//
//  KKViewController.m
//  LawBooksChinaiPad
//
//  Created by bear on 13-3-26.
//  Copyright (c) 2013年 bear. All rights reserved.
//

#import "KKViewController.h"
#import "KKExtension.h"
//#import "KKThemeManager.h"

#define NavigationBarButtonTitleFont [UIFont systemFontOfSize:16.5]

@interface KKViewController ()


@end

@implementation KKViewController
@synthesize endEditingWhenTouchBackground;

#pragma mark ==================================================
#pragma mark == 内存相关
#pragma mark ==================================================
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}


#pragma mark ==================================================
#pragma mark == 实例化
#pragma mark ==================================================
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesEnded:touches withEvent:event];
    if (endEditingWhenTouchBackground) {
        [self.view endEditing:YES];
    }
}

- (void)viewDidLoad{
    [super viewDidLoad];
    endEditingWhenTouchBackground = YES;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self checkInteractivePopGestureRecognizer];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (void)checkInteractivePopGestureRecognizer{
    if ([self.navigationController.viewControllers count]>0 &&
        [self.navigationController.viewControllers objectAtIndex:0]==self) {
        [self closeInteractivePopGestureRecognizer];
    }
    else{
        [self openInteractivePopGestureRecognizer];
    }
}

- (void)openInteractivePopGestureRecognizer{
    if ([[[UIDevice currentDevice] systemVersion] floatValue]>=7.0) {
        self.navigationController.interactivePopGestureRecognizer.delegate = (id<UIGestureRecognizerDelegate>)self;
    }
    // 开启 IOS7以后的系统自带的 导航控制器边缘滑动返回
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}

- (void)closeInteractivePopGestureRecognizer{
    if ([[[UIDevice currentDevice] systemVersion] floatValue]>=7.0) {
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    }
    // 开启 IOS7以后的系统自带的 导航控制器边缘滑动返回
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}


- (void)handleNotification:(NSString *)name object:(id)obejct userInfo:(NSDictionary *)userInfo {
    if ([name isEqualToString:NotificaitonThemeDidChange]) {
        if ([self respondsToSelector:@selector(changeTheme)]) {
            [self changeTheme];
        }
    } else if ([name isEqualToString:NotificaitonLocalizationDidChange]) {
        if ([self respondsToSelector:@selector(changeLocalization)]) {
            [self changeLocalization];
        }
    }
}

#pragma mark ****************************************
#pragma mark 默认导航返回样式
#pragma mark ****************************************
- (UIButton*)showNavigationDefaultBackButton_ForNavDismiss{
    return [self setNavLeftButtonImage:KKThemeImage(@"btn_NavBackDefault") highlightImage:nil selector:@selector(navigationControllerDismiss)];
}

- (UIButton*)showNavigationDefaultBackButton_ForNavPopBack{
    return [self setNavLeftButtonImage:KKThemeImage(@"btn_NavBackDefault") highlightImage:nil selector:@selector(navigationControllerPopBack)];
}

- (UIButton*)showNavigationDefaultBackButton_ForVCDismiss{
    return [self setNavLeftButtonImage:KKThemeImage(@"btn_NavBackDefault") highlightImage:nil selector:@selector(viewControllerDismiss)];
}

#pragma mark ****************************************
#pragma mark 返回事件
#pragma mark ****************************************
- (void)navigationControllerDismiss{
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)navigationControllerPopBack{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewControllerDismiss{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

#pragma mark ****************************************
#pragma mark 设置导航
#pragma mark ****************************************
- (UIButton*)setNavLeftButtonImage:(UIImage *)image
                    highlightImage:(UIImage *)highlightImage
                          selector:(SEL)selecter{
    
    //左导航
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, image.size.width+30, 44);
    [button setImage:image forState:UIControlStateNormal];
    [button setImage:highlightImage forState:UIControlStateHighlighted];
    [button addTarget:self action:selecter forControlEvents:UIControlEventTouchUpInside];
    button.exclusiveTouch = YES;//关闭多点
    button.backgroundColor = [UIColor clearColor];
    button.titleLabel.font = NavigationBarButtonTitleFont;
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
    {
        UIBarButtonItem *negativeSeperator = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        negativeSeperator.width = -15;
        self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:negativeSeperator,leftItem, nil];
        [negativeSeperator release];
    }
    else
    {
        self.navigationItem.leftBarButtonItem = leftItem;
    }
    [leftItem release];
    
    return button;
}

- (UIButton*)setNavLeftButtonTitle:(NSString *)title
                          selector:(SEL)selecter{
    
    //左导航
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    CGSize size = [title sizeWithFont:NavigationBarButtonTitleFont maxWidth:ApplicationWidth];
    button.frame = CGRectMake(0, 0, size.width+28, 44);
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

    if (title) {
        [button setTitle:title forState:UIControlStateNormal];
        [button setTitle:title forState:UIControlStateHighlighted];
    }
    else{
        [button setTitle:nil forState:UIControlStateNormal];
        [button setTitle:nil forState:UIControlStateHighlighted];
    }
    
    button.titleLabel.font = NavigationBarButtonTitleFont;
    [button addTarget:self action:selecter forControlEvents:UIControlEventTouchUpInside];
    button.exclusiveTouch = YES;//关闭多点
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
    {
        UIBarButtonItem *negativeSeperator = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        negativeSeperator.width = -15;
        self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:negativeSeperator,leftItem, nil];
        [negativeSeperator release];
    }
    else
    {
        self.navigationItem.leftBarButtonItem = leftItem;
    }
    [leftItem release];
    
    return button;
}

- (UIButton*)setNavRightButtonImage:(UIImage *)image
                     highlightImage:(UIImage *)highlightImage
                           selector:(SEL)selecter{
    
    //左导航
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, image.size.width+30, 44);
    [button setImage:image forState:UIControlStateNormal];
    [button setImage:highlightImage forState:UIControlStateHighlighted];
    [button addTarget:self action:selecter forControlEvents:UIControlEventTouchUpInside];
    button.exclusiveTouch = YES;//关闭多点
    button.backgroundColor = [UIColor clearColor];
    button.titleLabel.font = NavigationBarButtonTitleFont;
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
    {
        UIBarButtonItem *negativeSeperator = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        negativeSeperator.width = -15;
        self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:negativeSeperator,leftItem, nil];
        [negativeSeperator release];
    }
    else
    {
        self.navigationItem.rightBarButtonItem = leftItem;
    }
    [leftItem release];
    
    return button;
}

- (UIButton*)setNavRightButtonTitle:(NSString *)title
                           selector:(SEL)selecter{
    
    //左导航
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    CGSize size = [title sizeWithFont:NavigationBarButtonTitleFont maxWidth:ApplicationWidth];
    button.frame = CGRectMake(0, 0, size.width+28, 44);
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

    if (title) {
        [button setTitle:title forState:UIControlStateNormal];
        [button setTitle:title forState:UIControlStateHighlighted];
    }
    else{
        [button setTitle:nil forState:UIControlStateNormal];
        [button setTitle:nil forState:UIControlStateHighlighted];
    }
    
    button.titleLabel.font = NavigationBarButtonTitleFont;
    [button addTarget:self action:selecter forControlEvents:UIControlEventTouchUpInside];
    button.exclusiveTouch = YES;//关闭多点
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
    {
        UIBarButtonItem *negativeSeperator = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        negativeSeperator.width = -15;
        self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:negativeSeperator,leftItem, nil];
        [negativeSeperator release];
    }
    else
    {
        self.navigationItem.rightBarButtonItem = leftItem;
    }
    [leftItem release];
    
    return button;
}


- (UIButton*)setNavLeftButtonForFixedSpaceWithSize:(CGSize)size{
    //左导航
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, (44-size.height)/2.0, size.width, size.height);
    button.exclusiveTouch = YES;//关闭多点
    button.backgroundColor = [UIColor clearColor];
    button.titleLabel.font = NavigationBarButtonTitleFont;
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
    {
        UIBarButtonItem *negativeSeperator = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        negativeSeperator.width = -15;
        self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:negativeSeperator,leftItem, nil];
        [negativeSeperator release];
    }
    else
    {
        self.navigationItem.leftBarButtonItem = leftItem;
    }
    [leftItem release];
    
    return button;
}

- (UIButton*)setNavRightButtonForFixedSpaceWithWithSize:(CGSize)size{
    //右导航
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, (44-size.height)/2.0, size.width, size.height);
    button.exclusiveTouch = YES;//关闭多点
    button.backgroundColor = [UIColor clearColor];
    button.titleLabel.font = NavigationBarButtonTitleFont;
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
    {
        UIBarButtonItem *negativeSeperator = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        negativeSeperator.width = -15;
        self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:negativeSeperator,leftItem, nil];
        [negativeSeperator release];
    }
    else
    {
        self.navigationItem.rightBarButtonItem = leftItem;
    }
    [leftItem release];
    
    return button;
}


- (void)closeNavigationBarTranslucent{
    //#if defined(__IPHONE_7_0)
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
    {
        self.navigationController.navigationBar.translucent = NO;
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.automaticallyAdjustsScrollViewInsets = NO;
        self.edgesForExtendedLayout = UIRectEdgeNone;
#if __IPHONE_OS_VERSION_MAX_ALLOWED <= __IPHONE_7_0
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackTranslucent];
#else
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
#endif
        
    }
    else{
        self.navigationController.navigationBar.translucent = NO;
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    }
    
    //#endif
    
    if ([self.navigationController.navigationBar respondsToSelector:@selector( setBackgroundImage:forBarMetrics:)]){
        NSString *navImageName = nil;
        if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
            navImageName = @"navBarBackgroud7"; // 高度64px, 44+20
        }else {
            navImageName = @"navBarBackgroud"; //高度44px
        }
        [self.navigationController.navigationBar setBackgroundImage:KKThemeImage(navImageName) forBarMetrics:UIBarMetricsDefault];
    }
}

- (void)openNavigationBarTranslucent{
    //#if defined(__IPHONE_7_0)
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
    {
        self.navigationController.navigationBar.translucent = YES;
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.automaticallyAdjustsScrollViewInsets = NO;
        self.edgesForExtendedLayout = UIRectEdgeNone;
#if __IPHONE_OS_VERSION_MAX_ALLOWED <= __IPHONE_7_0
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackTranslucent];
#else
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
#endif
    }
    else{
        self.navigationController.navigationBar.translucent = YES;
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    }
    //#endif
    
    if ([self.navigationController.navigationBar respondsToSelector:@selector( setBackgroundImage:forBarMetrics:)]){
        NSString *navImageName = nil;
        if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
            navImageName = @"navBarBackgroud7Alpha"; // 高度64px, 44+20
        }else {
            navImageName = @"navBarBackgroudAlpha"; //高度44px
        }
        [self.navigationController.navigationBar setBackgroundImage:KKThemeImage(navImageName) forBarMetrics:UIBarMetricsDefault];
    }
}



#pragma mark ****************************************
#pragma mark Keyboard 监听
#pragma mark ****************************************
- (void)addKeyboardNotification{
    //监听键盘高度的变换
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    // 键盘高度变化通知，ios5.0新增的
#ifdef __IPHONE_5_0
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (version >= 5.0) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillChangeFrameNotification object:nil];
    }
#endif
}

- (void)removeKeyboardNotification{
    //监听键盘高度的变换
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    // 键盘高度变化通知，ios5.0新增的
#ifdef __IPHONE_5_0
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (version >= 5.0) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
    }
#endif
}

- (void)keyboardWillShow:(NSNotification *)notification {
    
    /*
     Reduce the size of the text view so that it's not obscured by the keyboard.
     Animate the resize so that it's in sync with the appearance of the keyboard.
     */
    
    NSDictionary *userInfo = [notification userInfo];
    
    // Get the origin of the keyboard when it's displayed.
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    // Get the top of the keyboard as the y coordinate of its origin in self's view's coordinate system. The bottom of the text view's frame should align with the top of the keyboard's final position.
    CGRect keyboardRect = [aValue CGRectValue];
    
    // Get the duration of the animation.
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    // Animate the resize of the text view's frame in sync with the keyboard's appearance.
    //    keyboradAnimationDuration = animationDuration;//键盘两种高度 216  252
    
    [self keyboardWillShowWithAnimationDuration:animationDuration keyBoardRect:keyboardRect];
}

- (void)keyboardWillShowWithAnimationDuration:(NSTimeInterval)animationDuration keyBoardRect:(CGRect)keyBoardRect{
    
}

- (void)keyboardWillHide:(NSNotification *)notification {
    
    NSDictionary* userInfo = [notification userInfo];
    
    // Get the origin of the keyboard when it's displayed.
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    // Get the top of the keyboard as the y coordinate of its origin in self's view's coordinate system. The bottom of the text view's frame should align with the top of the keyboard's final position.
    CGRect keyboardRect = [aValue CGRectValue];
    
    /*
     Restore the size of the text view (fill self's view).
     Animate the resize so that it's in sync with the disappearance of the keyboard.
     */
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    [self keyboardWillHideWithAnimationDuration:animationDuration keyBoardRect:keyboardRect];
}

- (void)keyboardWillHideWithAnimationDuration:(NSTimeInterval)animationDuration keyBoardRect:(CGRect)keyBoardRect{
    
}


#pragma mark ****************************************
#pragma mark 屏幕方向
#pragma mark ****************************************
//当前viewcontroller是否支持转屏
- (BOOL)shouldAutorotate NS_AVAILABLE_IOS(6_0){
    return NO;
}

//当前viewcontroller支持哪些转屏方向
- (NSUInteger)supportedInterfaceOrientations NS_AVAILABLE_IOS(6_0){
    return UIInterfaceOrientationPortrait;
//    return UIInterfaceOrientationMaskLandscape;
}

//当前viewcontroller默认的屏幕方向
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation NS_AVAILABLE_IOS(6_0){
    return UIInterfaceOrientationPortrait;
//    if ([[UIDevice currentDevice] orientation]==UIDeviceOrientationLandscapeLeft) {
//        return UIInterfaceOrientationLandscapeRight;
//    }
//    else if ([[UIDevice currentDevice] orientation]==UIDeviceOrientationLandscapeRight){
//        return UIInterfaceOrientationLandscapeLeft;
//    }
//    else{
//        return UIInterfaceOrientationLandscapeRight;
//    }
}
@end
