//
//  KKExtension.m
//  KKLibrary
//
//  Created by bear on 13-6-15.
//  Copyright (c) 2013年 kekestudio. All rights reserved.
//

#import "KKExtension.h"
#import <AddressBook/AddressBook.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVFoundation.h>
#import <MapKit/MapKit.h>
#import "JSONKit.h"
#import "AESCrypt.h"

@implementation KKAuthorizedManager

/*
 检查是否授权【通讯录】
 #import <AddressBook/AddressBook.h>
 */
+ (BOOL)isAddressBookAuthorized_ShowAlert:(BOOL)showAlert{
    
    BOOL Authorized = NO;
    
    ABAuthorizationStatus author = ABAddressBookGetAuthorizationStatus();
    
    //用户尚未做出授权选择
    if (author == kABAuthorizationStatusNotDetermined) {
        __block BOOL accessGranted = NO;
        // 初始化并创建通讯录对象，记得释放内存
        ABAddressBookRef addressBook = nil;
        if (&ABAddressBookRequestAccessWithCompletion != NULL) { // we're on iOS 6
                                                                 //等待同意后向下执行
            dispatch_semaphore_t sema = dispatch_semaphore_create(0);
            ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
                accessGranted = granted;
                dispatch_semaphore_signal(sema);
            });
            dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
            dispatch_release(sema);
        }
        else { // we're on iOS 5 or older
            accessGranted = YES;
        }
        Authorized = accessGranted;
    }
    //其他原因未被授权——可能是家长控制权限
    else if (author == kABAuthorizationStatusRestricted) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (showAlert) {
                //app名称
                NSString *app_Name = @"";
                app_Name = [[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"CFBundleDisplayName"];
                if (!app_Name) {
                    app_Name = APP_NAME;
                }
                NSString *message = [NSString stringWithFormat:@"《%@》%@%@%@",app_Name,KILocalization(@"没有权限访问您的通讯录，请在 设置--→隐私--→通讯录 里面为"),app_Name,KILocalization(@"开启权限。")];
                
                KKAlertView *alertView = [[KKAlertView alloc] initWithTitle:nil subTitle:nil message:message delegate:self buttonTitles:@"确定",nil];
                [alertView show];
                [alertView release];
            }
        });
        
        Authorized = NO;
    }
    //用户已经明确拒绝——拒绝访问
    else if (author == kABAuthorizationStatusDenied){
        dispatch_async(dispatch_get_main_queue(), ^{
            if (showAlert) {
                // app名称
                NSString *app_Name = @"";
                app_Name = [[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"CFBundleDisplayName"];
                if (!app_Name) {
                    app_Name = APP_NAME;
                }
                NSString *message = [NSString stringWithFormat:@"《%@》%@%@%@",app_Name,KILocalization(@"没有权限访问您的通讯录，请在 设置--→隐私--→通讯录 里面为"),app_Name,KILocalization(@"开启权限。")];
                
                KKAlertView *alertView = [[KKAlertView alloc] initWithTitle:nil subTitle:nil message:message delegate:self buttonTitles:@"确定",nil];
                [alertView show];
                [alertView release];
            }
        });
        Authorized = NO;
    }
    //用户已经授权同意——同意访问
    else if (author == kABAuthorizationStatusAuthorized) {
        Authorized = YES;
    }
    else {
        Authorized = NO;
    }
    
    return Authorized;
}

/*
 检查是否授权【相册】
 #import <AssetsLibrary/AssetsLibrary.h>
 */
+ (BOOL)isAlbumAuthorized_ShowAlert:(BOOL)showAlert{
    
    BOOL Authorized = NO;
    
    ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
    
    //用户尚未做出授权选择
    if (author == ALAuthorizationStatusNotDetermined) {
        Authorized = NO;
    }
    //其他原因未被授权——可能是家长控制权限
    else if (author == ALAuthorizationStatusRestricted) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (showAlert) {
                //app名称
                NSString *app_Name = @"";
                app_Name = [[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"CFBundleDisplayName"];
                if (!app_Name) {
                    app_Name = APP_NAME;
                }
                NSString *message = [NSString stringWithFormat:@"《%@》%@《%@》%@",app_Name,KILocalization(@"没有权限访问您的手机相册，请在 设置--→隐私--→照片 里面为"),app_Name,KILocalization(@"开启权限。")];
                
                KKAlertView *alertView = [[KKAlertView alloc] initWithTitle:nil subTitle:nil message:message delegate:self buttonTitles:@"确定",nil];
                [alertView show];
                [alertView release];
            }
        });
        
        Authorized = NO;
    }
    //用户已经明确拒绝——拒绝访问
    else if (author == ALAuthorizationStatusDenied){
        dispatch_async(dispatch_get_main_queue(), ^{
            if (showAlert) {
                // app名称
                NSString *app_Name = @"";
                app_Name = [[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"CFBundleDisplayName"];
                if (!app_Name) {
                    app_Name = APP_NAME;
                }
                NSString *message = [NSString stringWithFormat:@"《%@》%@《%@》%@",app_Name,KILocalization(@"没有权限访问您的手机相册，请在 设置--→隐私--→照片 里面为"),app_Name,KILocalization(@"开启权限。")];
                
                KKAlertView *alertView = [[KKAlertView alloc] initWithTitle:nil subTitle:nil message:message delegate:self buttonTitles:@"确定",nil];
                [alertView show];
                [alertView release];
            }
        });
        Authorized = NO;
    }
    //用户已经授权同意——同意访问
    else if (author == ALAuthorizationStatusAuthorized) {
        Authorized = YES;
    }
    else {
        Authorized = NO;
    }
    
    return Authorized;
}

/*
 检查是否授权【相机】
 #import <AVFoundation/AVFoundation.h>
 */
+ (BOOL)isCameraAuthorized_ShowAlert:(BOOL)showAlert{
    
    BOOL Authorized = NO;
    
    AVAuthorizationStatus author = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    
    //用户尚未做出授权选择
    if (author == AVAuthorizationStatusNotDetermined) {
        __block BOOL accessGranted = NO;
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            accessGranted = granted;
            dispatch_semaphore_signal(sema);
        }];
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
        dispatch_release(sema);
        Authorized = accessGranted;
    }
    //其他原因未被授权——可能是家长控制权限
    else if (author == AVAuthorizationStatusRestricted) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (showAlert) {
                //app名称
                NSString *app_Name = @"";
                app_Name = [[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"CFBundleDisplayName"];
                if (!app_Name) {
                    app_Name = APP_NAME;
                }
                NSString *message = [NSString stringWithFormat:@"《%@》%@《%@》%@",app_Name,KILocalization(@"没有权限访问您的相机，请在 设置--→隐私--→相机 里面为"),app_Name,KILocalization(@"开启权限。")];
                
                KKAlertView *alertView = [[KKAlertView alloc] initWithTitle:nil subTitle:nil message:message delegate:self buttonTitles:@"确定",nil];
                [alertView show];
                [alertView release];
            }
        });
        
        Authorized = NO;
    }
    //用户已经明确拒绝——拒绝访问
    else if (author == AVAuthorizationStatusDenied){
        dispatch_async(dispatch_get_main_queue(), ^{
            if (showAlert) {
                // app名称
                NSString *app_Name = @"";
                app_Name = [[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"CFBundleDisplayName"];
                if (!app_Name) {
                    app_Name = APP_NAME;
                }
                NSString *message = [NSString stringWithFormat:@"《%@》%@《%@》%@",app_Name,KILocalization(@"没有权限访问您的相机，请在 设置--→隐私--→相机 里面为"),app_Name,KILocalization(@"开启权限。")];
                
                KKAlertView *alertView = [[KKAlertView alloc] initWithTitle:nil subTitle:nil message:message delegate:self buttonTitles:@"确定",nil];
                [alertView show];
                [alertView release];
            }
        });
        Authorized = NO;
    }
    //用户已经授权同意——同意访问
    else if (author == AVAuthorizationStatusAuthorized) {
        Authorized = YES;
    }
    else {
        Authorized = NO;
    }
    
    return Authorized;
}


/*
 检查是否授权【地理位置】
 #import <MapKit/MapKit.h>
 */
+ (BOOL)isLocationAuthorized_ShowAlert:(BOOL)showAlert{
    
    BOOL Authorized = NO;
    
    if (![CLLocationManager locationServicesEnabled]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (showAlert) {
                NSString *message = KILocalization(@"手机定位服务暂时不可用，请检查 设置--→隐私--→定位服务 是否已经开启");
                KKAlertView *alertView = [[KKAlertView alloc] initWithTitle:nil subTitle:nil message:message delegate:self buttonTitles:@"确定",nil];
                [alertView show];
                [alertView release];
            }
        });
        Authorized = NO;
    }
    else{
        CLAuthorizationStatus author = [CLLocationManager authorizationStatus];
        
        //用户尚未做出授权选择
        if (author == kCLAuthorizationStatusNotDetermined) {
            Authorized = NO;
        }
        //其他原因未被授权——可能是家长控制权限
        else if (author == kCLAuthorizationStatusRestricted) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (showAlert) {
                    //app名称
                    NSString *app_Name = @"";
                    app_Name = [[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"CFBundleDisplayName"];
                    if (!app_Name) {
                        app_Name = APP_NAME;
                    }
                    NSString *message = [NSString stringWithFormat:@"《%@》%@《%@》%@",app_Name,KILocalization(@"没有权限访问地理位置，请在 设置--→隐私--→定位服务 里面为"),app_Name,KILocalization(@"开启权限。")];
                    
                    KKAlertView *alertView = [[KKAlertView alloc] initWithTitle:nil subTitle:nil message:message delegate:self buttonTitles:@"确定",nil];
                    [alertView show];
                    [alertView release];
                }
            });
            
            Authorized = NO;
        }
        //用户已经明确拒绝——拒绝访问
        else if (author == kCLAuthorizationStatusDenied){
            dispatch_async(dispatch_get_main_queue(), ^{
                if (showAlert) {
                    // app名称
                    NSString *app_Name = @"";
                    app_Name = [[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"CFBundleDisplayName"];
                    if (!app_Name) {
                        app_Name = APP_NAME;
                    }
                    NSString *message = [NSString stringWithFormat:@"《%@》%@《%@》%@",app_Name,KILocalization(@"没有权限访问地理位置，请在 设置--→隐私--→定位服务 里面为"),app_Name,KILocalization(@"开启权限。")];
                    
                    KKAlertView *alertView = [[KKAlertView alloc] initWithTitle:nil subTitle:nil message:message delegate:self buttonTitles:@"确定",nil];
                    [alertView show];
                    [alertView release];
                }
            });
            Authorized = NO;
        }
        //用户已经授权同意——同意访问【始终】
        else if (author == kCLAuthorizationStatusAuthorizedAlways) {
            Authorized = YES;
        }
        //用户已经授权同意——同意访问【使用期间】
        else if (author == kCLAuthorizationStatusAuthorizedWhenInUse) {
            Authorized = YES;
        }
        //用户已经授权同意——同意访问
        else if (author == kCLAuthorizationStatusAuthorized) {
            Authorized = YES;
        }
        else {
            Authorized = NO;
        }
    }
    
    return Authorized;
}

/*
 检查是否授权【麦克风】
 #import <AVFoundation/AVFoundation.h>
 */
+ (BOOL)isMicrophoneAuthorized_ShowAlert:(BOOL)showAlert{
    
    __block BOOL Authorized = NO;
    
    AVAudioSession *avSession = [AVAudioSession sharedInstance];
    
    if ([avSession respondsToSelector:@selector(requestRecordPermission:)]) {
        
        
        // 初始化并创建通讯录对象，记得释放内存
        ABAddressBookRef addressBook = nil;
        ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
        });
        
        __block BOOL accessGranted = NO;
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        [avSession requestRecordPermission:^(BOOL available) {
            accessGranted = available;
            if (!available) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (showAlert) {
                        //app名称
                        NSString *app_Name = @"";
                        app_Name = [[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"CFBundleDisplayName"];
                        if (!app_Name) {
                            app_Name = APP_NAME;
                        }
                        NSString *message = [NSString stringWithFormat:@"《%@》%@《%@》%@",app_Name,KILocalization(@"没有权限访问您的麦克风，请在 设置--→隐私--→麦克风 里面为"),app_Name,KILocalization(@"开启权限。")];
                        
                        KKAlertView *alertView = [[KKAlertView alloc] initWithTitle:nil subTitle:nil message:message delegate:self buttonTitles:@"确定",nil];
                        [alertView show];
                        [alertView release];
                    }
                });
            }
            dispatch_semaphore_signal(sema);
        }];
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
        dispatch_release(sema);
        Authorized = accessGranted;
    }
    return Authorized;
}

/*
 检查是否授权【通知中心】
 */
+ (BOOL)isNotificationAuthorized{
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
    {
        UIUserNotificationType types = [[UIApplication sharedApplication] currentUserNotificationSettings].types;
        return (types & UIRemoteNotificationTypeAlert);
    }
    else
    {
        UIRemoteNotificationType types = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
        return (types & UIRemoteNotificationTypeAlert);
    }
}



@end



@implementation KKExtension

+ (id)getRootViewController {
    UIWindow *window = ((UIWindow*)[[[UIApplication sharedApplication] windows] objectAtIndex:0]);
    for (UIView *subView in [window subviews]){
        UIResponder *responder = [subView nextResponder];
        if([responder isKindOfClass:[UIViewController class]]) {
            return ((UIViewController *) responder);
        }
    }
    return nil;
}

@end



#pragma mark ==================================================
#pragma mark == NSObject
#pragma mark ==================================================
@implementation NSObject (KKNSObjectExtension)

NSString * const NotificaitonThemeDidChange = @"NotificaitonThemeDidChange";
NSString * const NotificaitonLocalizationDidChange = @"NotificaitonLocalizationDidChange";
#define  OpenURL(url)   [[UIApplication sharedApplication] openURL:url];



- (void)vibrateDevice {
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}

- (void)observeNotificaiton:(NSString *)name {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleNotification:)
                                                 name:name
                                               object:nil];
}

- (void)observeNotificaiton:(NSString *)name selector:(SEL)selector {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:selector
                                                 name:name
                                               object:nil];
}

- (void)unobserveNotification:(NSString *)name {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:name
                                                  object:nil];
}

- (void)unobserveAllNotification {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)postNotification:(NSString *)name {
    [self postNotification:name object:nil];
}

- (void)postNotification:(NSString *)name object:(id)object {
    [[NSNotificationCenter defaultCenter] postNotificationName:name object:object];
}

- (void)postNotification:(NSString *)name object:(id)object userInfo:(NSDictionary *)userInfo {
    [[NSNotificationCenter defaultCenter] postNotificationName:name object:object userInfo:userInfo];
}

- (void)handleNotification:(NSNotification *)noti {
    if ([self respondsToSelector:@selector(handleNotification:object:userInfo:)]) {
        [self handleNotification:noti.name object:noti.object userInfo:noti.userInfo];
    }
}

- (void)handleNotification:(NSString *)name object:(id)object userInfo:(NSDictionary *)userInfo {
    
}

- (void)observeThemeChangeNotificaiton {
    [self changeTheme];
    [self observeNotificaiton:NotificaitonThemeDidChange selector:@selector(changeTheme)];
}

- (void)unobserveThemeChangeNotificaiton {
    [self unobserveNotification:NotificaitonThemeDidChange];
}

- (void)changeTheme {
    //在ViewController中重写
}

- (void)observeLocalizationChangeNotification {
    [self changeLocalization];
    [self observeNotificaiton:NotificaitonLocalizationDidChange selector:@selector(changeLocalization)];
}

- (void)unobserveLocalizationChangeNotification {
    [self unobserveNotification:NotificaitonLocalizationDidChange];
}

- (void)changeLocalization {
    //在ViewController中重写
}

- (BOOL)isArray {
    if ([self isKindOfClass:[NSArray class]]) {
        return YES;
    }
    return NO;
}

- (BOOL)isDictionary {
    if ([self isKindOfClass:[NSDictionary class]]) {
        return YES;
    }
    return NO;
}

- (BOOL)isString{
    if ([self isKindOfClass:[NSString class]]) {
        return YES;
    }
    return NO;
}

- (BOOL)isNotEmptyArray {
    if (self != nil && [self isArray] && [(NSArray *)self count] > 0) {
        return YES;
    }
    return NO;
}

- (BOOL)isNotEmptyDictionary {
    if (self != nil && [self isDictionary] && [(NSDictionary *)self count] > 0) {
        return YES;
    }
    return NO;
}

- (void)openURL:(NSURL *)url {
    OpenURL(url);
}

- (void)sendMail:(NSString *)mail {
    NSString *url = [NSString stringWithFormat:@"mailto://%@", mail];
    [self openURL:[NSURL URLWithString:url]];
}

- (void)sendSMS:(NSString *)number {
    NSString *url = [NSString stringWithFormat:@"sms://%@", number];
    [self openURL:[NSURL URLWithString:url]];
}

- (void)callNumber:(NSString *)number {
    NSString *url = [NSString stringWithFormat:@"tel://%@", number];
    [self openURL:[NSURL URLWithString:url]];
}

@end

#pragma mark ==================================================
#pragma mark == NSArray
#pragma mark ==================================================
@implementation NSArray (KKNSArrayExtension)

+ (BOOL)isArrayNotEmpty:(id)array{
    if (array && [array isKindOfClass:[NSArray class]] && [array count]>0) {
        return YES;
    }
    else{
        return NO;
    }
}

+ (BOOL)isArrayEmpty:(id)array{
    return ![NSArray isArrayNotEmpty:array];
}

- (BOOL)containsStringValue:(NSString*)aString{
    
    BOOL contains = NO;
    
    for (int i = 0; i<[self count]; i++) {
        id indexString = [self objectAtIndex:i];
        
        if ([indexString isKindOfClass:[NSNumber class]]) {
            if ([aString integerValue] == [indexString integerValue]) {
                contains = YES;
                break;
            }
        }
        else if ([indexString isKindOfClass:[NSString class]]) {
            if ([indexString isEqualToString:aString]) {
                contains = YES;
                break;
            }
        }
    }
    
    return contains;
}

/**
 @brief 转换成json字符串
 @discussion
 */
- (NSString*)translateToJSONString{
    NSString *jsonKitString = [self JSONString];
    return jsonKitString;

//    NSError *error = nil;
//    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self
//                                                       options:NSJSONWritingPrettyPrinted
//                                                         error:&error];
//    NSString *jsonString = [[NSString alloc] initWithData:jsonData
//                                                 encoding:NSUTF8StringEncoding];
//    return [jsonString autorelease];
}

/**
 @brief json字符串转换成对象
 @discussion
 */
+ (NSArray*)arrayFromJSONData:(NSData*)aJsonData{
    if (aJsonData && [aJsonData isKindOfClass:[NSData class]]) {
        NSError *error = nil;
        NSArray *jsonObject = [NSJSONSerialization JSONObjectWithData:aJsonData
                                                                   options:NSJSONReadingMutableContainers
                                                                     error:&error];
        if (jsonObject != nil && error == nil && [jsonObject isKindOfClass:[NSArray class]]){
            return jsonObject;
        }else{
            // 解析错误
            return nil;
        }
    }
    else{
        // 解析错误
        return nil;
    }
}

/**
 @brief json字符串转换成对象
 @discussion
 */
+ (NSArray*)arrayFromJSONString:(NSString*)aJsonString{
    
//    NSObject *object = [aJsonString objectFromJSONString];
//    if (object && [object isKindOfClass:[NSArray class]]) {
//        return (NSArray*)object;
//    }
//    else{
//        return nil;
//    }

    if (aJsonString && [aJsonString isKindOfClass:[NSString class]]) {
        
        NSData *jsonData = [aJsonString dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error = nil;
        NSArray *jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                   options:NSJSONReadingMutableContainers
                                                                     error:&error];
        if (jsonObject != nil && error == nil && [jsonObject isKindOfClass:[NSArray class]]){
            return jsonObject;
        }else{
            // 解析错误
            return nil;
        }
    }
    else{
        // 解析错误
        return nil;
    }
}

@end


#pragma mark ==================================================
#pragma mark == NSData
#pragma mark ==================================================
#import <CommonCrypto/CommonDigest.h>
static char encodingTable[64] = {
    'A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P',
    'Q','R','S','T','U','V','W','X','Y','Z','a','b','c','d','e','f',
    'g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v',
    'w','x','y','z','0','1','2','3','4','5','6','7','8','9','+','/' };

@implementation NSData (KKNSDataExtension)

- (NSString *)md5 {
    if (!self) {
        return nil;
    }
    void *cData = malloc([self length]);
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    [self getBytes:cData length:[self length]];
    CC_MD5(cData, (CC_LONG)[self length], result);
    
    NSMutableString *outString = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH*2];
    
    for(int i=0; i<CC_MD5_DIGEST_LENGTH; i++) {
        [outString appendFormat:@"%02x", result[i]];
    }
    return outString;
}

- (NSString *)base64Encoded {
	const unsigned char	*bytes = [self bytes];
	NSMutableString *result = [NSMutableString stringWithCapacity:[self length]];
	unsigned long ixtext = 0;
	unsigned long lentext = [self length];
	long ctremaining = 0;
	unsigned char inbuf[3], outbuf[4];
	unsigned short i = 0;
	unsigned short charsonline = 0, ctcopy = 0;
	unsigned long ix = 0;
	
	while(YES) {
		ctremaining = lentext - ixtext;
		if( ctremaining <= 0 ) break;
		
		for( i = 0; i < 3; i++ ) {
			ix = ixtext + i;
			if( ix < lentext ) inbuf[i] = bytes[ix];
			else inbuf [i] = 0;
		}
		
		outbuf [0] = (inbuf [0] & 0xFC) >> 2;
		outbuf [1] = ((inbuf [0] & 0x03) << 4) | ((inbuf [1] & 0xF0) >> 4);
		outbuf [2] = ((inbuf [1] & 0x0F) << 2) | ((inbuf [2] & 0xC0) >> 6);
		outbuf [3] = inbuf [2] & 0x3F;
		ctcopy = 4;
		
		switch( ctremaining ) {
			case 1:
				ctcopy = 2;
				break;
			case 2:
				ctcopy = 3;
				break;
		}
		
		for( i = 0; i < ctcopy; i++ ) {
            [result appendFormat:@"%c", encodingTable[outbuf[i]]];
        }
		
		for( i = ctcopy; i < 4; i++ ) {
            [result appendString:@"="];
        }
		
		ixtext += 3;
		charsonline += 4;
	}
	
	return [NSString stringWithString:result];
}

- (NSData *)base64Decoded {
	const unsigned char	*bytes = [self bytes];
	NSMutableData *result = [NSMutableData dataWithCapacity:[self length]];
	
	unsigned long ixtext = 0;
	unsigned long lentext = [self length];
	unsigned char ch = 0;
	unsigned char inbuf[4] = {0, 0, 0, 0};
	unsigned char outbuf[3] = {0, 0, 0};
	short i = 0, ixinbuf = 0;
	BOOL flignore = NO;
	BOOL flendtext = NO;
	
	while( YES ) {
		if( ixtext >= lentext ) break;
		ch = bytes[ixtext++];
		flignore = NO;
		
		if( ( ch >= 'A' ) && ( ch <= 'Z' ) ) ch = ch - 'A';
		else if( ( ch >= 'a' ) && ( ch <= 'z' ) ) ch = ch - 'a' + 26;
		else if( ( ch >= '0' ) && ( ch <= '9' ) ) ch = ch - '0' + 52;
		else if( ch == '+' ) ch = 62;
		else if( ch == '=' ) flendtext = YES;
		else if( ch == '/' ) ch = 63;
		else flignore = YES;
		
		if( ! flignore ) {
			short ctcharsinbuf = 3;
			BOOL flbreak = NO;
			
			if( flendtext ) {
				if( ! ixinbuf ) break;
				if( ( ixinbuf == 1 ) || ( ixinbuf == 2 ) ) ctcharsinbuf = 1;
				else ctcharsinbuf = 2;
				ixinbuf = 3;
				flbreak = YES;
			}
			
			inbuf [ixinbuf++] = ch;
			
			if( ixinbuf == 4 ) {
				ixinbuf = 0;
				outbuf [0] = ( inbuf[0] << 2 ) | ( ( inbuf[1] & 0x30) >> 4 );
				outbuf [1] = ( ( inbuf[1] & 0x0F ) << 4 ) | ( ( inbuf[2] & 0x3C ) >> 2 );
				outbuf [2] = ( ( inbuf[2] & 0x03 ) << 6 ) | ( inbuf[3] & 0x3F );
				
				for( i = 0; i < ctcharsinbuf; i++ )
					[result appendBytes:&outbuf[i] length:1];
			}
			
			if( flbreak )  break;
		}
	}
	return [NSData dataWithData:result];
}

////将图片压缩到指定大小 imageArray UIImage数组，imageDataSize 图片数据大小(单位KB)，比如100KB
+ (void)convertImage:(NSArray*)imageArray toDataSize:(CGFloat)imageDataSize
convertImageOneCompleted:(KKImageConvertImageOneCompletedBlock)completedOneBlock
KKImageConvertImageAllCompletedBlock:(KKImageConvertImageAllCompletedBlock)completedAllBlock{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        
        for (NSInteger i=0; i<[imageArray count]; i++) {
            
            //原始图片==================================================
            UIImage *originalImage_in = [[[imageArray objectAtIndex:i] copy] autorelease];
            NSData *originalImageData_in = UIImageJPEGRepresentation(originalImage_in,1);
            CGFloat sizeKB = [originalImageData_in length]/1024.00;
            
            for (float i=1.0;sizeKB>imageDataSize;) {
                i=i-0.1;
                if (i<0) {
                    break;
                }
                originalImage_in = [originalImage_in convertImageToScale:i];
                originalImageData_in = UIImageJPEGRepresentation(originalImage_in,1);
                sizeKB = [originalImageData_in length]/1024.00;
            }
            
            //主线程
            dispatch_async(dispatch_get_main_queue(), ^{
                completedOneBlock(originalImageData_in,i);
            });
            
        }
        
        //主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            completedAllBlock();
        });
    });
    
}

@end

#pragma mark ==================================================
#pragma mark == NSMutableData
#pragma mark ==================================================

@implementation NSMutableData(KKStudioExtensionAddPostData)
/**
 当网络请求为POST方法上传文件的时候使用。参数拼接在body里面。
 其他情况，请不要用.可使用下面的：- (void) addPostKey:(NSString*)key value:(NSString*)value;
 */
- (void) addPostKeyForFileUpload:(NSString*)key value:(NSString*)value{
    
    if (!value && ![value isKindOfClass:[NSString class]]) {
        return;
    }
    
    if (!key && ![key isKindOfClass:[NSString class]]) {
        return;
    }
    
    //分界线 --
    NSString *MPboundary=[[NSString alloc]initWithFormat:@"--%@",NSMutableURLRequest_Boundary];
    
    //添加分界线，换行
    NSString *spaceLine = [NSString stringWithFormat:@"%@\r\n",MPboundary];
    [self appendData:[spaceLine dataUsingEncoding:NSUTF8StringEncoding]];
    //添加字段名称，换行
    NSString *disposition = [NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n",key];
    [self appendData:[disposition dataUsingEncoding:NSUTF8StringEncoding]];
    //添加字段的值
    NSString *valueString = [NSString stringWithFormat:@"\r\n%@\r\n",value];
    
    [self appendData:[valueString dataUsingEncoding:NSUTF8StringEncoding]];
    
    [MPboundary release];
    
}
/**
 当网络请求为POST方法上传文件的时候使用。文件拼接在body里面。
 其他情况，请不要用
 */
- (void) addPostDataForFileUpload:(NSData*)data forKey:(NSString*)key{
    if (!data && ![data isKindOfClass:[NSData class]]) {
        return;
    }
    
    if (!key && ![key isKindOfClass:[NSString class]]) {
        return;
    }
    
    //  设置头部
    NSData *leadingData = [[NSString stringWithFormat:@"--%@\r\nContent-Disposition: form-data; name=\"%@\"; filename=\"image.png\";\r\n Content-Type: image/png\r\n\r\n",NSMutableURLRequest_Boundary, key] dataUsingEncoding:NSUTF8StringEncoding];
    
    [self appendData:leadingData];
    
    //  数据
    [self appendData:[NSData dataWithData:data]];
    
    //  设置尾部
    NSData *trailingData = [[NSString stringWithFormat:@"\r\n--%@--\r\n", NSMutableURLRequest_Boundary] dataUsingEncoding:NSUTF8StringEncoding];
    [self appendData:trailingData];
}

/**
 当网络请求不是上传文件的时候使用。文件拼接在body里面。
 其他情况，请不要用。可使用上面的：- (void) addPostKeyForFileUpload:(NSString*)key value:(NSString*)value;
 */
- (void) addPostKey:(NSString*)key value:(NSString*)value{
    if (!value && ![value isKindOfClass:[NSString class]]) {
        return;
    }
    
    if (!key && ![key isKindOfClass:[NSString class]]) {
        return;
    }
    
    NSString *string = [[NSString alloc]initWithData:self encoding:NSUTF8StringEncoding];
    if ([string length]>0) {
        [self appendData:[[NSString stringWithFormat:@"&%@=%@",[key postValueEncodedString],[value postValueEncodedString]] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    else{
        [self appendData:[[NSString stringWithFormat:@"%@=%@",[key postValueEncodedString],[value postValueEncodedString]] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    [string release];
}

@end



#pragma mark ==================================================
#pragma mark == NSDate
#pragma mark ==================================================

@implementation NSDate (KKNSDateExtension)

- (NSUInteger)day {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter autorelease];
    return [[dateFormatter day:self] intValue];
}

- (NSUInteger)weekday {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter autorelease];
    return [[dateFormatter weekday:self] intValue];
}

- (NSUInteger)month {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter autorelease];
    return [[dateFormatter month:self] intValue];
}

- (NSUInteger)year {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter autorelease];
    return [[dateFormatter year:self] intValue];
}

- (NSUInteger)numberOfDaysInMonth {
#if __IPHONE_OS_VERSION_MAX_ALLOWED < __IPHONE_8_0
    return [[NSCalendar currentCalendar] rangeOfUnit:NSDayCalendarUnit
                                              inUnit:NSMonthCalendarUnit
                                             forDate:self].length;
#else
    return [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitDay
                                              inUnit:NSCalendarUnitMonth
                                             forDate:self].length;
#endif

}

- (NSUInteger)weeksOfMonth {
#if __IPHONE_OS_VERSION_MAX_ALLOWED < __IPHONE_8_0
    return [[NSCalendar currentCalendar] rangeOfUnit:NSWeekCalendarUnit
                                              inUnit:NSMonthCalendarUnit
                                             forDate:self].length;
#else
    return [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitWeekOfMonth
                                              inUnit:NSCalendarUnitMonth
                                             forDate:self].length;
#endif

}

- (NSDate *)previousDate {
    NSDateComponents *dateComp = [[NSDateComponents alloc] init];
    [dateComp setDay:-1];
    [dateComp autorelease];
    return [[NSCalendar currentCalendar] dateByAddingComponents:dateComp
                                                         toDate:self
                                                        options:0];
}

- (NSDate *)nextDate {
    NSDateComponents *dateComp = [[NSDateComponents alloc] init];
    [dateComp setDay:1];
    [dateComp autorelease];
    return [[NSCalendar currentCalendar] dateByAddingComponents:dateComp
                                                         toDate:self
                                                        options:0];
}

- (NSDate *)firstDayOfWeek {
    NSDate *date = nil;
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED < __IPHONE_8_0
    BOOL ok = [[NSCalendar currentCalendar] rangeOfUnit:NSWeekCalendarUnit
                                              startDate:&date
                                               interval:NULL
                                                forDate:self];
#else
    BOOL ok = [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitWeekOfMonth
                                              startDate:&date
                                               interval:NULL
                                                forDate:self];
#endif

    
    if (ok) {
        return date;
    }
    return nil;
}

- (NSDate *)lastDayOfWeek {
    return [[self firstDayOfNextWeek] previousDate];
}

- (NSDate *)firstDayOfNextWeek {
    NSDateComponents *dateComp = [[NSDateComponents alloc] init];
#if __IPHONE_OS_VERSION_MAX_ALLOWED < __IPHONE_8_0
    [dateComp setWeek:1];
#else
    [dateComp setWeekOfMonth:1];
#endif

    [dateComp autorelease];
    return [[[NSCalendar currentCalendar] dateByAddingComponents:dateComp
                                                          toDate:self
                                                         options:0] firstDayOfWeek];
}

- (NSDate *)lastDayOfNextWeek {
    return [[self firstDayOfNextWeek] lastDayOfWeek];
}

- (NSDate *)firstDayOfMonth {
    NSDate *date = nil;
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED < __IPHONE_8_0
    BOOL ok = [[NSCalendar currentCalendar] rangeOfUnit:NSMonthCalendarUnit
                                              startDate:&date
                                               interval:NULL
                                                forDate:self];
#else
    BOOL ok = [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitMonth
                                              startDate:&date
                                               interval:NULL
                                                forDate:self];
#endif

    if (ok) {
        return date;
    }
    return nil;
}

- (NSDate *)lastDayOfMonth {
    NSDate *date = nil;
    date = [[self firstDayOfNextMonth] previousDate];
    return date;
}

- (NSUInteger)weekdayOfFirstDayInMonth {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter autorelease];
    return [[dateFormatter weekday:[self firstDayOfMonth]] intValue];
}

- (NSDate *)firstDayOfPreviousMonth {
    NSDateComponents *dateComp = [[NSDateComponents alloc] init];
    [dateComp setMonth:-1];
    [dateComp autorelease];
    return [[[NSCalendar currentCalendar] dateByAddingComponents:dateComp
                                                          toDate:self
                                                         options:0] firstDayOfMonth];
}

- (NSDate *)firstDayOfNextMonth {
    NSDateComponents *dateComp = [[NSDateComponents alloc] init];
    [dateComp setMonth:1];
    [dateComp autorelease];
    return [[[NSCalendar currentCalendar] dateByAddingComponents:dateComp
                                                          toDate:self
                                                         options:0] firstDayOfMonth];
}

- (NSDate *)firstDayOfQuarter {
    NSDate *date = nil;
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED < __IPHONE_8_0
    BOOL ok = [[NSCalendar currentCalendar] rangeOfUnit:NSQuarterCalendarUnit
                                              startDate:&date
                                               interval:NULL
                                                forDate:self];
#else
    BOOL ok = [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitQuarter
                                              startDate:&date
                                               interval:NULL
                                                forDate:self];
#endif

    if (ok) {
        return date;
    }
    return nil;
}

- (NSDate *)lastDayOfQuarter {
    NSDateComponents *dateComp = [[NSDateComponents alloc] init];
    [dateComp setQuarter:1];
    [dateComp autorelease];
    return [[[NSCalendar currentCalendar] dateByAddingComponents:dateComp
                                                          toDate:self
                                                         options:0] lastDayOfMonth];
}

#pragma mark == NSDate 字符串方法
+ (NSString*)getStringWithFormatter:(NSString*)formatterString{
    if ((formatterString==nil) || ![formatterString isKindOfClass:[NSString class]]) {
        return nil;
    }
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:formatterString];
    NSString *nowDateString = [formatter stringFromDate:[NSDate date]];
    [formatter release];
    
    return nowDateString;
}


+ (NSString*)getStringFromOldDateString:(NSString*)oldDateString
                       withOldFormatter:(NSString*)oldFormatterString
                           newFormatter:(NSString*)newFormatterString {
    
    if (oldDateString==nil || (![oldDateString isKindOfClass:[NSString class]])) {
        return nil;
    }
    
    if (oldFormatterString==nil || (![oldFormatterString isKindOfClass:[NSString class]])) {
        return nil;
    }
    
    if (newFormatterString==nil || (![newFormatterString isKindOfClass:[NSString class]])) {
        return nil;
    }
    
    NSDate *oldDate = [NSDate getDateFromString:oldDateString dateFormatter:oldFormatterString];
    
    NSString *returnString = [NSDate getStringFromDate:oldDate dateFormatter:newFormatterString];
    
    return returnString;
}

+ (NSString*)getStringFromDate:(NSDate*)date dateFormatter:(NSString*)formatterString{
    
    if (formatterString==nil || (![formatterString isKindOfClass:[NSString class]])) {
        return nil;
    }
    
    if (date==nil || (![date isKindOfClass:[NSDate class]])) {
        return nil;
    }
    
    NSDateFormatter *formatter2 = [[NSDateFormatter alloc] init];
    [formatter2 setDateFormat:formatterString];
    NSString *returnString = [formatter2 stringFromDate:date];
    [formatter2 release];
    
    return returnString;
}

+ (NSDate*)getDateFromString:(NSString*)string dateFormatter:(NSString*)formatterString{
    
    if (formatterString==nil || (![formatterString isKindOfClass:[NSString class]])) {
        return nil;
    }
    
    if (string==nil || (![string isKindOfClass:[NSString class]])) {
        return nil;
    }
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:formatterString];
    NSDate *oldDate = [formatter dateFromString:string];
    [formatter release];
    
    return oldDate;
}

+ (NSString*)timeAwayFromNowWithOldDateString:(NSString*)oldDateString oldFormatterString:(NSString*)oldFormatterString defaultFormatterString:(NSString*)defaultFormatterString{
    
    if (oldDateString==nil || (![oldDateString isKindOfClass:[NSString class]])) {
        return nil;
    }
    
    if (oldFormatterString==nil || (![oldFormatterString isKindOfClass:[NSString class]])) {
        return nil;
    }
    
    if (defaultFormatterString==nil || (![defaultFormatterString isKindOfClass:[NSString class]])) {
        return nil;
    }
    
    //******************************************************************************************
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:oldFormatterString];
    NSDate *firstDate = [formatter dateFromString:oldDateString];
    [formatter release];
    
    NSTimeInterval before = [firstDate timeIntervalSince1970]*1;
    
    //******************************************************************************************
    
    NSTimeInterval after = [[NSDate date] timeIntervalSince1970]*1;
    
    //******************************************************************************************
    
    NSTimeInterval cha = after - before;
    
    if (cha <=0 ) {
        return @"刚刚";
    }
    else if ((0<cha) && (cha<60)) {
        return [NSString stringWithFormat:@"%d秒前",(int)roundf(cha)];
    }
    else if ((60<=cha) && (cha<3600)) {
        return [NSString stringWithFormat:@"%d分钟前",(int)roundf(cha/60)];
    }
    else if ((3600<=cha) && (cha<86400)) {
        return [NSString stringWithFormat:@"%d小时前",(int)roundf(cha/3600)];
    }
    else{
        return [self getStringWithFormatter:defaultFormatterString];
    }
}

+ (NSString*)timeAwayFromNowWithOldDate:(NSDate*)oldDate defaultFormatterString:(NSString*)defaultFormatterString{
    
    if (oldDate==nil || (![oldDate isKindOfClass:[NSDate class]])) {
        return nil;
    }
    
    if (defaultFormatterString==nil || (![defaultFormatterString isKindOfClass:[NSString class]])) {
        return nil;
    }
    
    NSTimeInterval before = [oldDate timeIntervalSince1970]*1;
    
    //******************************************************************************************
    
    NSTimeInterval after = [[NSDate date] timeIntervalSince1970]*1;
    
    //******************************************************************************************
    
    NSTimeInterval cha = after - before;
    
    if (cha <=0 ) {
        return @"刚刚";
    }
    else if ((0<cha) && (cha<60)) {
        return [NSString stringWithFormat:@"%d秒前",(int)roundf(cha)];
    }
    else if ((60<=cha) && (cha<3600)) {
        return [NSString stringWithFormat:@"%d分钟前",(int)roundf(cha/60)];
    }
    else if ((3600<=cha) && (cha<86400)) {
        return [NSString stringWithFormat:@"%d小时前",(int)roundf(cha/3600)];
    }
    else{
        return [self getStringWithFormatter:defaultFormatterString];
    }
}

+ (BOOL)isString:(NSString*)date1String01 earlierThanString:(NSString*)date1String02 formatter01:(NSString*)formatter01 formatter02:(NSString*)formatter02{
    
    if (date1String01==nil || (![date1String01 isKindOfClass:[NSString class]])) {
        return NO;
    }
    
    if (date1String02==nil || (![date1String02 isKindOfClass:[NSString class]])) {
        return NO;
    }
    
    if (formatter01==nil || (![formatter01 isKindOfClass:[NSString class]])) {
        return NO;
    }
    
    if (formatter02==nil || (![formatter02 isKindOfClass:[NSString class]])) {
        return NO;
    }
    
    
    NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
    [formatter1 setDateFormat:formatter01];
    NSDate *date1 = [formatter1 dateFromString:date1String01];
    [formatter1 release];
    
    NSDateFormatter *formatter2 = [[NSDateFormatter alloc] init];
    [formatter2 setDateFormat:formatter02];
    NSDate *date2 = [formatter2 dateFromString:date1String02];
    [formatter2 release];
    
    NSTimeInterval before = [date1 timeIntervalSince1970]*1;
    
    //******************************************************************************************
    
    NSTimeInterval after = [date2 timeIntervalSince1970]*1;
    
    //******************************************************************************************
    
    NSTimeInterval cha = after - before;
    
    
    if (cha>0) {
        return YES;
    }
    else {
        return NO;
    }
}

+ (BOOL)isString:(NSString*)date1String01 earlierThanDate:(NSDate*)date02 formatter01:(NSString*)formatter01 {
    
    if (date1String01==nil || (![date1String01 isKindOfClass:[NSString class]])) {
        return NO;
    }
    
    if (formatter01==nil || (![formatter01 isKindOfClass:[NSString class]])) {
        return NO;
    }
    
    if (date02==nil || (![date02 isKindOfClass:[NSDate class]])) {
        return NO;
    }
    
    
    NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
    [formatter1 setDateFormat:formatter01];
    NSDate *date1 = [formatter1 dateFromString:date1String01];
    [formatter1 release];
    
    NSTimeInterval before = [date1 timeIntervalSince1970]*1;
    
    //******************************************************************************************
    
    NSTimeInterval after = [date02 timeIntervalSince1970]*1;
    
    //******************************************************************************************
    
    NSTimeInterval cha = after - before;
    
    
    if (cha>0) {
        return YES;
    }
    else {
        return NO;
    }
}

+ (BOOL)isDate:(NSDate*)date01 earlierThanString:(NSString*)dateString02 formatter02:(NSString*)formatter02{
    
    if (dateString02==nil || (![dateString02 isKindOfClass:[NSString class]])) {
        return NO;
    }
    
    if (formatter02==nil || (![formatter02 isKindOfClass:[NSString class]])) {
        return NO;
    }
    
    if (date01==nil || (![date01 isKindOfClass:[NSString class]])) {
        return NO;
    }
    
    NSDateFormatter *formatter2 = [[NSDateFormatter alloc] init];
    [formatter2 setDateFormat:formatter02];
    NSDate *date2 = [formatter2 dateFromString:dateString02];
    [formatter2 release];
    
    NSTimeInterval before = [date01 timeIntervalSince1970]*1;
    
    //******************************************************************************************
    
    NSTimeInterval after = [date2 timeIntervalSince1970]*1;
    
    //******************************************************************************************
    
    NSTimeInterval cha = after - before;
    
    
    if (cha>0) {
        return YES;
    }
    else {
        return NO;
    }
}


+ (BOOL)isDate:(NSDate*)date01 earlierThanDate:(NSDate*)date02{
    
    if (date01==nil || (![date01 isKindOfClass:[NSDate class]])) {
        return NO;
    }
    
    if (date02==nil || (![date02 isKindOfClass:[NSDate class]])) {
        return NO;
    }
    
    NSTimeInterval before = [date01 timeIntervalSince1970]*1;
    
    NSTimeInterval after = [date02 timeIntervalSince1970]*1;
    
    
    NSTimeInterval cha = after - before;
    
    
    if (cha>0) {
        return YES;
    }
    else {
        return NO;
    }
}

/**
 判断时间是否超过一天了
 date01：需要判断的日期
 */
+ (BOOL)isDate:(NSDate*)date01 beforeNDays:(NSUInteger)days{    
    double cha = [[NSDate date] timeIntervalSince1970]-[date01 timeIntervalSince1970];
    if (cha>=24*60*60*days) {
        return YES;
    }
    else{
        return NO;
    }
}


/**
 判断时间是否超过N天了
 date01：需要判断的日期
 formatterString：date01的格式
 days：超过N天了
 */
+ (BOOL)isDateString:(NSString*)dateString formatter:(NSString*)formatterString afterNDay:(NSUInteger)days{
    NSString *dateStringNow = [self getStringWithFormatter:@"yyyyMMdd"];
    NSString *dateStringOld = [self getStringFromOldDateString:dateString withOldFormatter:formatterString newFormatter:@"yyyyMMdd"];
    NSInteger cha = [dateStringNow integerValue]-[dateStringOld integerValue];
    if (cha>=days) {
        return YES;
    }
    else{
        return NO;
    }
}


@end

#pragma mark ==================================================
#pragma mark ==NSDateFormatter
#pragma mark ==================================================

@implementation NSDateFormatter (KKNSDateFormatterExtension)

- (NSString *)weekday:(NSDate *)date {
    [self setDateFormat:@"c"];
    return [self stringFromDate:date];
}

- (NSString *)day:(NSDate *)date {
    [self setDateFormat:@"d"];
    return [self stringFromDate:date];
}

- (NSString *)month:(NSDate *)date {
    [self setDateFormat:@"M"];
    return [self stringFromDate:date];
}

- (NSString *)year:(NSDate *)date {
    [self setDateFormat:@"y"];
    return [self stringFromDate:date];
}


@end

#pragma mark ==================================================
#pragma mark ==NSDictionary
#pragma mark ==================================================
@implementation NSDictionary (KKNSDictionaryExtension)

+ (BOOL)isDictionaryNotEmpty:(id)dictionary{
    if (dictionary && [dictionary isKindOfClass:[NSDictionary class]] && [dictionary count]>0) {
        return YES;
    }
    else{
        return NO;
    }
}

+ (BOOL)isDictionaryEmpty:(id)dictionary{
    return ![NSDictionary isDictionaryNotEmpty:dictionary];
}


- (BOOL)boolValueForKey:(id)key {
    return [[self objectForKey:key] boolValue];
}

- (int)intValueForKey:(id)key {
    return [[self objectForKey:key] intValue];
}

- (NSInteger)integerValueForKey:(id)key {
    return [[self objectForKey:key] integerValue];
}

- (float)floatValueForKey:(id)key {
    return [[self objectForKey:key] floatValue];
}

- (double)doubleValueForKey:(id)key {
    return [[self objectForKey:key] doubleValue];
}

- (NSString *)stringValueForKey:(id)key {
    id value = [self objectForKey:key];
    if ([value isKindOfClass:[NSString class]]) {
        return (NSString*)value;
    }
    else if ([value isKindOfClass:[NSNumber class]]) {
        return [(NSNumber*)value stringValue];
    }
    else{
        return nil;
    }
}

- (NSString*)valuebleStringForKey:(id)aKey{
    
    if (aKey && ![aKey isKindOfClass:[NSNull class]]) {
        NSObject *object = [self objectForKey:aKey];
        if (object && ![object isKindOfClass:[NSNull class]]) {
            if ([object isKindOfClass:[NSNumber class]]) {
                return [(NSNumber*)object stringValue];
            }
            else if ([object isKindOfClass:[NSString class]]){
                return (NSString*)object;
            }
            else{
                return [[[NSString alloc] initWithFormat:@"%@", object] autorelease];
            }
        }
        else{
            return @"";
        }
    }
    else{
        return @"";
    }
}


- (id)valuableObjectForKey:(id)aKey{
    if (!self || !aKey) {
        return nil;
    }
    
    if ([[self objectForKey:aKey] isKindOfClass:[NSNumber class]]) {
        return [[self objectForKey:aKey] stringValue];
    }
    else if ([[self objectForKey:aKey] isKindOfClass:[NSNull class]] || ![self objectForKey:aKey]){
        return @"";
    }
    return [self objectForKey:aKey];
}

/**
 @brief 转换成json字符串
 @discussion
 */
- (NSString*)translateToJSONString{
    NSString *jsonKitString = [self JSONString];
    return jsonKitString;

//    NSError *error = nil;
//    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self
//                                                       options:NSJSONWritingPrettyPrinted
//                                                         error:&error];
//    NSString *jsonString = [[[NSString alloc] initWithData:jsonData
//                                                 encoding:NSUTF8StringEncoding] autorelease];
//    NSString *returnString = [jsonString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
//
//    if ([returnString isEqualToString:jsonKitString]) {
//        NSLog(@"YES");
//    }
//    return returnString;
}

/**
 @brief json字符串转换成对象
 @discussion
 */
+ (NSDictionary*)dictionaryFromJSONData:(NSData*)aJsonData{
    if (aJsonData && [aJsonData isKindOfClass:[NSData class]]) {
        
        NSError *error = nil;
        NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:aJsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&error];
        if (jsonObject != nil && error == nil && [jsonObject isKindOfClass:[NSDictionary class]]){
            return jsonObject;
        }else{
            // 解析错误
            return nil;
        }
    }
    else{
        // 解析错误
        return nil;
    }
}

/**
 @brief json字符串转换成对象
 @discussion
 */
+ (NSDictionary*)dictionaryFromJSONString:(NSString*)aJsonString{
    
//    NSObject *object = [aJsonString objectFromJSONString];
//    if (object && [object isKindOfClass:[NSDictionary class]]) {
//        return (NSDictionary*)object;
//    }
//    else{
//        return nil;
//    }

    if (aJsonString && [aJsonString isKindOfClass:[NSString class]]) {
        
        NSData *aJsonData = [aJsonString dataUsingEncoding:NSUTF8StringEncoding];
        
        NSError *error = nil;
        NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:aJsonData
                                                                   options:NSJSONReadingMutableContainers
                                                                     error:&error];
        if (jsonObject != nil && error == nil && [jsonObject isKindOfClass:[NSDictionary class]]){
            return jsonObject;
        }else{
            // 解析错误
            return nil;
        }
    }
    else{
        // 解析错误
        return nil;
    }
}

@end


#pragma mark ==================================================
#pragma mark ==UIFont
#pragma mark ==================================================
@implementation UIFont (KKUIFontExtension)

+ (CGSize)sizeOfFont:(UIFont*)aFont{
    NSString *string = @"我";
    return [string sizeWithFont:aFont maxWidth:1000];
}

@end


#pragma mark ==================================================
#pragma mark ==NSString
#pragma mark ==================================================
#import <CommonCrypto/CommonDigest.h>
@implementation NSString (KKNSStringExtension)

+ (BOOL)isStringNotEmpty:(id)string{
    if (string && [string isKindOfClass:[NSString class]] && [[string trimLeftAndRightSpace] length]>0) {
        return YES;
    }
    else{
        return NO;
    }
}

+ (BOOL)isStringEmpty:(id)string{
    return ![NSString isStringNotEmpty:string];
}

- (BOOL)isString {
    if ([self isKindOfClass:[NSString class]]) {
        return YES;
    }
    return NO;
}

/*字符串的真实长度（汉字2 英文1）*/
- (int)realLenth{
    int strlength = 0;
    char* p = (char*)[self cStringUsingEncoding:NSUnicodeStringEncoding];
    for (int i=0 ; i<[self lengthOfBytesUsingEncoding:NSUnicodeStringEncoding] ;i++) {
        if (*p) {
            p++;
            strlength++;
        }
        else {
            p++;
        }
    }
    return (strlength+1)/2;
}


- (NSString *)md5 {
    if (!self) {
        return nil;
    }
    const char *cStr = [self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result);
    
    NSMutableString *outString = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH*2];
    
    for(int i=0; i<CC_MD5_DIGEST_LENGTH; i++) {
        [outString appendFormat:@"%02x", result[i]];
    }
    return outString;
}

- (NSString *)sha1 {
    if (!self) {
        return nil;
    }
    const char *cStr = [self cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cStr length:self.length];
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    CC_SHA1(data.bytes, (CC_LONG)data.length, digest);
    
    NSMutableString *outString = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH];
    
    for (int i=0; i<CC_SHA1_DIGEST_LENGTH; i++) {
        [outString appendFormat:@"%02x", digest[i]];
    }
    return outString;
}

- (NSString *)base64Encoded {
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    return [data base64Encoded];
}

- (NSString *)base64Decoded {
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    return [[[NSString alloc] initWithData:[data base64Decoded] encoding:NSUTF8StringEncoding] autorelease];
}

- (NSString *)URLEncodedString {
    NSString *encodedString = (NSString *)
    CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                            (CFStringRef)self,
                                            (CFStringRef)@"!$&'()*+,-./:;=?@_~%#[]",
                                            NULL,
                                            kCFStringEncodingUTF8);
    return [encodedString autorelease];
}

- (NSString*)URLDecodedString {
	NSString *result = (NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault,
																						   (CFStringRef)self,
																						   CFSTR(""),
																						   kCFStringEncodingUTF8);
    [result autorelease];
	return result;
}

- (BOOL)isURL {
    NSPredicate *urlTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", URL_EXPRESSION];
    return [urlTest evaluateWithObject:self];
}


/*PostValueEncoded*/
- (NSString *)postValueEncodedString{
    return [(NSString *) CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)[[self mutableCopy] autorelease], NULL, CFSTR("￼=,!$&'()*+;@?\n\"<>#\t :/"), kCFStringEncodingUTF8) autorelease];
}

- (NSString *)trimWhitespace {
    NSString *string = [self stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
    return [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (NSString *)trimHTMLTag {
    
    NSString *html = [self stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@"  "];
    html = [html stringByReplacingOccurrencesOfString:@"<br>" withString:@"\n"];
    
    NSScanner *scanner = [NSScanner scannerWithString:html];
    NSString *text = nil;
    
    while (![scanner isAtEnd]) {
        [scanner scanUpToString:@"<" intoString:NULL];
        [scanner scanUpToString:@">" intoString:&text];
        
        NSString *replaceString = [NSString stringWithFormat:@"%@>", text];
        if ([replaceString hasPrefix:@"<KK{"]) {
            continue;
        }
        else{
            html = [html stringByReplacingOccurrencesOfString:replaceString
                                                   withString:@""];
        }
    }
    return [html trimLeftAndRightSpace];
}

- (BOOL)isEmail {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:self];
}

//- (BOOL)isURL {
//    NSString *urlRegex = @"^((https|http|ftp|rtsp|mms)?://)"
//    "?(([0-9a-z_!~*'().&=+$%-]+: )?[0-9a-z_!~*'().&=+$%-]+@)?" //ftp的user@
//    "(([0-9]{1,3}/.){3}[0-9]{1,3}" // IP形式的URL- 199.194.52.184
//    "|" // 允许IP和DOMAIN（域名）
//    "([0-9a-z_!~*'()-]+/.)*" // 域名- www.
//    "([0-9a-z][0-9a-z-]{0,61})?[0-9a-z]/." // 二级域名
//    "[a-z]{2,6})" // first level domain- .com or .museum
//    "(:[0-9]{1,4})?" // 端口- :80
//    "((/?)|" // a slash isn't required if there is no file name
//    "(/[0-9a-z_!~*'().;?:@&=+$,%#-]+)+/?)$";
//
//    NSPredicate *urlTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", urlRegex];
//    return [urlTest evaluateWithObject:self];
//}
//
//- (BOOL)isIP {
//    NSString *ipRegex = @"((^1([0-9]\\d{0,2}))|(^2([0-5\\d{0,2}])))";
//    NSPredicate *ipTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", ipRegex];
//    return [ipTest evaluateWithObject:self];
//}

- (BOOL)isMobilePhoneNumber {
    NSString *cellPhoneRegex = @"^(((\\+86)?)|((86)?))1(3[0-9]|4[0-9]|5[0-9]|8[0-9])[-]*\\d{4}[-]*\\d{4}$";
    NSPredicate *cellPhoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", cellPhoneRegex];
    return [cellPhoneTest evaluateWithObject:self];
}

- (BOOL)isTelePhoneNumber {
    NSString *phoneRegex= @"((^0(10|2[0-9]|\\d{2,3})){0,1}-{0,1}(\\d{6,8}|\\d{6,8})$)";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    return [phoneTest evaluateWithObject:self];
}

- (BOOL)isZipCode {
    NSString *zipCodeRegex = @"[1-9]\\d{5}$";
    NSPredicate *zipCodeTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", zipCodeRegex];
    return [zipCodeTest evaluateWithObject:self];
}

//- (BOOL)isHTMLTag {
//    NSString *htmlTagRegex = @"<(S*?)[^>]*>.*?|<.*? />";
//    NSPredicate *htmlTagText = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", htmlTagRegex];
//    return [htmlTagText evaluateWithObject:self];
//}

- (CGSize)sizeWithFont:(UIFont *)font maxWidth:(CGFloat)width lineBreakMode:(NSLineBreakMode)lineBreakMode{
    return [self sizeWithFont:font maxSize:CGSizeMake(width, CGFLOAT_MAX) lineBreakMode:lineBreakMode];
}

- (CGSize)sizeWithFont:(UIFont *)font maxWidth:(CGFloat)width {
    return [self sizeWithFont:font maxSize:CGSizeMake(width, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
}


- (CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)size {
    return [self sizeWithFont:font maxSize:size inset:UIEdgeInsetsMake(0, 0, 0, 0) lineBreakMode:NSLineBreakByWordWrapping];
}

- (CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)size lineBreakMode:(NSLineBreakMode)lineBreakMode{
    return [self sizeWithFont:font maxSize:size inset:UIEdgeInsetsMake(0, 0, 0, 0) lineBreakMode:lineBreakMode];
}


- (CGSize)sizeWithFont:(UIFont *)font maxWidth:(CGFloat)width inset:(UIEdgeInsets)inset {
    return [self sizeWithFont:font maxSize:CGSizeMake(width, CGFLOAT_MAX) inset:inset lineBreakMode:NSLineBreakByWordWrapping];
}

- (CGSize)sizeWithFont:(UIFont *)font maxWidth:(CGFloat)width inset:(UIEdgeInsets)inset lineBreakMode:(NSLineBreakMode)lineBreakMode{
    return [self sizeWithFont:font maxSize:CGSizeMake(width, CGFLOAT_MAX) inset:inset lineBreakMode:lineBreakMode];
}

- (CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)size inset:(UIEdgeInsets)inset lineBreakMode:(NSLineBreakMode)lineBreakMode{
    if (font == nil) {
        font = [UIFont systemFontOfSize:14.0f];
    }
    CGFloat width = size.width - inset.left - inset.right;
    CGFloat height = size.height - inset.top - inset.bottom;
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue]<=7.1) {
        size = [self sizeWithFont:font
                constrainedToSize:CGSizeMake(width, height)
                    lineBreakMode:lineBreakMode];
    }
    else{
        NSStringDrawingOptions options =  NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
        
        /// Make a copy of the default paragraph style
        NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
        /// Set line break mode
        paragraphStyle.lineBreakMode = lineBreakMode;
        /// Set text alignment
        paragraphStyle.alignment = NSTextAlignmentLeft;
        
        NSDictionary* Attributes2 = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName,NSParagraphStyleAttributeName,paragraphStyle, nil];
        [paragraphStyle release];
        
        CGRect rect0 = [self boundingRectWithSize:CGSizeMake(width, height) options:options attributes:Attributes2 context:nil];
        size = CGSizeMake(ceil(rect0.size.width), ceil(rect0.size.height));
    }
    
    return size;
}

- (CGFloat)heightWithFont:(UIFont *)font {
    CGSize size = [self sizeWithFont:font maxSize:CGSizeMake(300, 300)];
    return size.height;
}

//去掉字符串首尾的空格
-(NSString*)trimLeftAndRightSpace{
    if (self) {
        NSString* trimed = [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        return trimed;
    }
    else {
        return nil;
    }
}

//去掉字符串中的所有空格
-(NSString*)trimAllSpace{
    if (self) {
        NSString *trimed = [self stringByReplacingOccurrencesOfString:@" " withString:@""];
        return trimed;
    }
    else {
        return nil;
    }
    
}

//去掉数字
- (NSString*)trimNumber{
    if (self) {
        NSRegularExpression* regex = [NSRegularExpression regularExpressionWithPattern:@"[0-9]+" options:0 error:NULL];
        NSString* resultString = [regex stringByReplacingMatchesInString:self options:0 range:NSMakeRange(0, [self length]) withTemplate:@""];
        return resultString;
    }
    else {
        return nil;
    }
}

+ (NSString*)stringWithData:(NSData *)data{
    NSString* s = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return [s autorelease];
}


/*是否是整数*/
- (BOOL)isInteger{
    if (self) {
        NSScanner* scan = [NSScanner scannerWithString:self];
        NSInteger val;
        return [scan scanInteger:&val] && [scan isAtEnd];
    }
    else {
        return NO;
    }
}

/*是否是整数*/
- (BOOL)isValuableInteger{
    
    if ([self isInteger]) {
        
        NSString *AA = [NSString stringWithFormat:@"%ld",(long)[self integerValue]];
        //        NSString *BB = [NSString stringWithFormat:@"%ld",NSIntegerMax];
        
        if ([AA isEqualToString:self]) {
            return YES;
        }
        else{
            return NO;
        }
    }
    else{
        return NO;
    }
}

/*是否是浮点数*/
- (BOOL)isFloat{
    
    NSString *clearString = [self stringByReplacingOccurrencesOfString:@"." withString:@""];
    if (![clearString isInteger]) {
        return NO;
    }
    else{
        NSRange stringRange = NSMakeRange(0, [self length]);
        NSRegularExpression* pointRegular = [NSRegularExpression regularExpressionWithPattern:@"[.]"
                                                                                      options:NSRegularExpressionCaseInsensitive
                                                                                        error:nil];
        NSArray *matches = [pointRegular matchesInString:self  options:NSMatchingReportCompletion range:stringRange];
        
        if ([matches count]==1) {
            return YES;
        }
        else{
            return NO;
        }
        //        for (NSTextCheckingResult *match in matches) {
        //            NSRange numberRange = [match range];
        //            [attributedString addAttribute:(NSString *)kCTForegroundColorAttributeName
        //                                     value:(id)specialTextColor.CGColor
        //                                     range:numberRange];
        //        }
    }
}


+ (NSInteger)sizeOfStringForNSUTF8StringEncoding:(NSString*)aString{
    NSInteger result = 0;
    const char *tchar=[aString UTF8String];
    if (NULL == tchar) {
        return result;
    }
    result = strlen(tchar);
    return result;
}

+ (NSString*)subStringForNSUTF8StringEncodingWithSize:(NSInteger)size string:(NSString*)string{
    
    NSString *tempString = [NSString stringWithString:string];
    
    NSInteger tempStringSize = [NSString sizeOfStringForNSUTF8StringEncoding:tempString];
    if (tempStringSize <= size) {
        return tempString;
    }
    
    if (size>tempStringSize/2) {
        NSInteger index = [tempString length];
        while (1) {
            if ([NSString sizeOfStringForNSUTF8StringEncoding:tempString]<=size) {
                break;
            }
            else{
                index = index -1;
                tempString = [string substringWithRange:NSMakeRange(0, index)];
            }
        }
    }
    else{
        NSInteger index = 1;
        while (1) {
            tempString = [string substringWithRange:NSMakeRange(0, index)];
            if ([NSString sizeOfStringForNSUTF8StringEncoding:tempString]<size) {
                index = index + 1;
            }
            else{
                break;
            }
        }
    }
    
    return tempString;
}

+ (NSInteger)sizeOfStringForNSUnicodeStringEncoding:(NSString*)aString{
    int strlength = 0;
    char* p = (char*)[aString cStringUsingEncoding:NSUnicodeStringEncoding];
    for (int i=0 ; i<[aString lengthOfBytesUsingEncoding:NSUnicodeStringEncoding] ;i++) {
        if (*p) {
            p++;
            strlength++;
        }
        else {
            p++;
        }
    }
    return strlength;
}

+ (NSString*)subStringForNSUnicodeStringEncodingWithSize:(NSInteger)size string:(NSString*)string{
    
    NSString *tempString = [NSString stringWithString:string];
    
    NSInteger tempStringSize = [NSString sizeOfStringForNSUnicodeStringEncoding:tempString];
    if (tempStringSize <= size) {
        return tempString;
    }
    
    if (size>tempStringSize/2) {
        NSInteger index = [tempString length];
        while (1) {
            if ([NSString sizeOfStringForNSUnicodeStringEncoding:tempString]<=size) {
                break;
            }
            else{
                index = index -1;
                tempString = [string substringWithRange:NSMakeRange(0, index)];
            }
        }
    }
    else{
        NSInteger index = 1;
        while (1) {
            tempString = [string substringWithRange:NSMakeRange(0, index)];
            if ([NSString sizeOfStringForNSUnicodeStringEncoding:tempString]<size) {
                index = index + 1;
            }
            else{
                break;
            }
        }
    }
    
    return tempString;
}

+ (NSString*)stringWithInteger:(NSInteger)intValue{
    return [NSString stringWithFormat:@"%ld",(long)intValue];
}

+ (NSString*)stringWithFloat:(CGFloat)floatValue{
    return [NSString stringWithFormat:@"%f",floatValue];
}


+ (NSString*)stringWithDouble:(double)doubleValue{
    return [NSString stringWithFormat:@"%lf",doubleValue];
}


@end

#pragma mark ==================================================
#pragma mark ==UIColor
#pragma mark ==================================================
@implementation UIColor (KKUIColorExtension)
+ (NSString *)hexStringFromColor:(UIColor *)color{
    
    const CGFloat* rgba = CGColorGetComponents(color.CGColor);
    
    int rgbaCount = (int)CGColorGetNumberOfComponents(color.CGColor);
    
    CGFloat r, g, b,alpha;
    
    if (rgbaCount >3) {
        
        r = rgba[0];
        
        g = rgba[1];
        
        b = rgba[2];
        
        alpha = rgba[3];
        
        alpha = alpha;   //avoid warning
        
    }else{
        
        r = rgba[0];
        
        g = rgba[1];
        
        b = rgba[2];
        
    }
    
    
    
    // Convert to hex string between 0x00 and 0xFF
    
    return [NSString stringWithFormat:@"%02X%02X%02X",(int)(r * 255), (int)(g * 255), (int)(b * 255)];
    
}

+ (UIColor *) colorWithHexString: (NSString *) hexString {
    
    NSString *colorString = [[hexString stringByReplacingOccurrencesOfString: @"#"withString: @""] uppercaseString];
    
    CGFloat alpha, red, blue, green;
    
    switch ([colorString length]) {
            
        case 3: // #RGB
            
            alpha = 1.0f;
            
            red   = [self colorComponentFrom: colorString start: 0 length: 1];
            
            green = [self colorComponentFrom: colorString start: 1 length: 1];
            
            blue  = [self colorComponentFrom: colorString start: 2 length: 1];
            
            break;
            
        case 4: // #ARGB
            
            alpha = [self colorComponentFrom: colorString start: 0 length: 1];
            
            red   = [self colorComponentFrom: colorString start: 1 length: 1];
            
            green = [self colorComponentFrom: colorString start: 2 length: 1];
            
            blue  = [self colorComponentFrom: colorString start: 3 length: 1];
            
            break;
            
        case 6: // #RRGGBB
            
            alpha = 1.0f;
            
            red   = [self colorComponentFrom: colorString start: 0 length: 2];
            
            green = [self colorComponentFrom: colorString start: 2 length: 2];
            
            blue  = [self colorComponentFrom: colorString start: 4 length: 2];
            
            break;
            
        case 8: // #AARRGGBB
            
            alpha = [self colorComponentFrom: colorString start: 0 length: 2];
            
            red   = [self colorComponentFrom: colorString start: 2 length: 2];
            
            green = [self colorComponentFrom: colorString start: 4 length: 2];
            
            blue  = [self colorComponentFrom: colorString start: 6 length: 2];
            
            break;
            
        default:
            
            [NSException raise:@"Invalid color value" format: @"Color value %@ is invalid.  It should be a hex value of the form #RBG, #ARGB, #RRGGBB, or #AARRGGBB", hexString];
            
            break;
            
    }
    
    return [UIColor colorWithRed: red green: green blue: blue alpha: alpha];
    
}

+ (CGFloat) colorComponentFrom: (NSString *) string start: (NSUInteger) start length: (NSUInteger) length {
    
    NSString *substring = [string substringWithRange: NSMakeRange(start, length)];
    
    NSString *fullHex = length == 2 ? substring : [NSString stringWithFormat: @"%@%@", substring, substring];
    
    unsigned hexComponent;
    
    [[NSScanner scannerWithString: fullHex] scanHexInt: &hexComponent];
    
    return hexComponent / 255.0;
    
}

+ (UIColor *)hexColorToUIColor:(NSString*)hexColor{
    unsigned int red, green, blue;
    NSRange range;
    range.length =2;
    
    range.location =1;
    
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]]scanHexInt:&red];
    range.location =3;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]]scanHexInt:&green];
    range.location =5;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]]scanHexInt:&blue];
    
    return [UIColor colorWithRed:(float)(red/255.0f)green:(float)(green/255.0f)blue:(float)(blue/255.0f)alpha:1.0f];
    
}

+ (NSArray *)RGBAValue:(UIColor*)color{
    CGColorRef colorRef = [color CGColor];
    int numComponents = (int)CGColorGetNumberOfComponents(colorRef);
    NSMutableArray *arrary = [NSMutableArray array];
    
    if (numComponents == 4)
    {
        const CGFloat *components = CGColorGetComponents(colorRef);
        CGFloat R = components[0];
        CGFloat G = components[1];
        CGFloat B = components[2];
        CGFloat A = components[3];
        
        [arrary addObject:[NSNumber numberWithFloat:R]];
        [arrary addObject:[NSNumber numberWithFloat:G]];
        [arrary addObject:[NSNumber numberWithFloat:B]];
        [arrary addObject:[NSNumber numberWithFloat:A]];
    }
    
    
    
    return arrary;
}


@end

#pragma mark ==================================================
#pragma mark ==UIImage
#pragma mark ==================================================
CGFloat KKDegreesToRadians(CGFloat degrees) {return degrees * M_PI / 180;};
CGFloat KKRadiansToDegrees(CGFloat radians) {return radians * 180/M_PI;};

@implementation UIImage (KKUIImageExtension)

+ (NSString *) contentTypeForImageData:(NSData *)data{
    uint8_t c;
    [data getBytes:&c length:1];
    
    switch (c) {
        case 0xFF:
            return @"image/jpeg";
        case 0x89:
            return @"image/png";
        case 0x42:
            return @"image/bmp";
        case 0x47:
            return @"image/gif";
        case 0x49:
        case 0x4D:
            return @"image/tiff";
    }
    return nil;
}

+ (NSString *) contentTypeExtensionForImageData:(NSData *)data{
    uint8_t c;
    [data getBytes:&c length:1];
    
    switch (c) {
        case 0xFF:
            return UIImageExtensionType_JPG;
        case 0x89:
            return UIImageExtensionType_PNG;
        case 0x42:
            return UIImageExtensionType_BMP;
        case 0x47:
            return UIImageExtensionType_GIF;
        case 0x49:
        case 0x4D:
            return UIImageExtensionType_TIFF;
    }
    return @"";
}

- (UIImage *)flip:(BOOL)isHorizontal {
    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
    //2014-10-20 bear
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
//    if (UIGraphicsBeginImageContextWithOptions != NULL) {
//        UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
//    } else {
//        UIGraphicsBeginImageContext(rect.size);
//    }
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextClipToRect(ctx, rect);
    if (isHorizontal) {
        CGContextRotateCTM(ctx, M_PI);
        CGContextTranslateCTM(ctx, -rect.size.width, -rect.size.height);
    }
    CGContextDrawImage(ctx, rect, self.CGImage);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (UIImage *)flipVertical {
    return [self flip:NO];
}

- (UIImage *)flipHorizontal {
    return [self flip:YES];
}

- (UIImage *)resizeTo:(CGSize)size {
    return [self resizeToWidth:size.width height:size.height];
}

- (UIImage *)resizeToWidth:(CGFloat)width height:(CGFloat)height {
    CGSize size = CGSizeMake(width, height);
    //2014-10-20 bear
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
//    if (UIGraphicsBeginImageContextWithOptions != NULL) {
//        UIGraphicsBeginImageContextWithOptions(size, NO, 0);
//    } else {
//        UIGraphicsBeginImageContext(size);
//    }
    [self drawInRect:CGRectMake(0, 0, width, height)];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (UIImage *)scaleWithWidth:(CGFloat)width {
    CGSize imageSize = [self size];
    CGFloat scale = imageSize.width / width;
    CGFloat height = imageSize.height / scale;
    return [self resizeToWidth:width height:height];
}

- (UIImage *)scaleWithHeight:(CGFloat)heigh {
    CGSize imageSize = [self size];
    CGFloat scale = imageSize.height / heigh;
    CGFloat width = imageSize.width / scale;
    return [self resizeToWidth:width height:heigh];
}

- (UIImage *)cropImageWithX:(CGFloat)x y:(CGFloat)y width:(CGFloat)width height:(CGFloat)height {
    CGRect rect = CGRectMake(x, y, width, height);
    CGImageRef imageRef = CGImageCreateWithImageInRect(self.CGImage, rect);
    UIImage *image = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    return image;
}

- (UIImage *)decodedImage {
    CGImageRef imageRef = self.CGImage;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL,
                                                 CGImageGetWidth(imageRef),
                                                 CGImageGetHeight(imageRef),
                                                 8,
                                                 // Just always return width * 4 will be enough
                                                 CGImageGetWidth(imageRef) * 4,
                                                 // System only supports RGB, set explicitly
                                                 colorSpace,
                                                 // Makes system don't need to do extra conversion when displayed.
                                                 // NOTE: here we remove the alpha channel for performance. Most of the time, images loaded
                                                 //       from the network are jpeg with no alpha channel. As a TODO, finding a way to detect
                                                 //       if alpha channel is necessary would be nice.
                                                 kCGImageAlphaNoneSkipLast | kCGBitmapByteOrder32Little);
    CGColorSpaceRelease(colorSpace);
    if (!context) return nil;
    
    CGRect rect = (CGRect){CGPointZero,{CGImageGetWidth(imageRef), CGImageGetHeight(imageRef)}};
    CGContextDrawImage(context, rect, imageRef);
    CGImageRef decompressedImageRef = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
    
    UIImage *decompressedImage = [[UIImage alloc] initWithCGImage:decompressedImageRef scale:self.scale orientation:self.imageOrientation];
    CGImageRelease(decompressedImageRef);
    return [decompressedImage autorelease];
}

- (UIImage *)fixOrientation {
    if (self.imageOrientation == UIImageOrientationUp) return self;
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (self.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, self.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, self.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationUpMirrored:
            break;
    }
    
    switch (self.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationDown:
        case UIImageOrientationLeft:
        case UIImageOrientationRight:
            break;
    }
    CGContextRef ctx = CGBitmapContextCreate(NULL, self.size.width, self.size.height,
                                             CGImageGetBitsPerComponent(self.CGImage), 0,
                                             CGImageGetColorSpace(self.CGImage),
                                             CGImageGetBitmapInfo(self.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (self.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            CGContextDrawImage(ctx, CGRectMake(0,0,self.size.height,self.size.width), self.CGImage);
            break;
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,self.size.width,self.size.height), self.CGImage);
            break;
    }
    
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

- (UIImage *)decoded;{
    CGImageRef imageRef = self.CGImage;
    CGSize imageSize = CGSizeMake(CGImageGetWidth(imageRef), CGImageGetHeight(imageRef));
    CGRect imageRect = (CGRect){.origin = CGPointZero, .size = imageSize};
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGBitmapInfo bitmapInfo = CGImageGetBitmapInfo(imageRef);
    
    int infoMask = (bitmapInfo & kCGBitmapAlphaInfoMask);
    BOOL anyNonAlpha = (infoMask == kCGImageAlphaNone ||
                        infoMask == kCGImageAlphaNoneSkipFirst ||
                        infoMask == kCGImageAlphaNoneSkipLast);
    if (infoMask == kCGImageAlphaNone && CGColorSpaceGetNumberOfComponents(colorSpace) > 1) {
        bitmapInfo &= ~kCGBitmapAlphaInfoMask;
        bitmapInfo |= kCGImageAlphaNoneSkipFirst;
    } else if (!anyNonAlpha && CGColorSpaceGetNumberOfComponents(colorSpace) == 3) {
        bitmapInfo &= ~kCGBitmapAlphaInfoMask;
        bitmapInfo |= kCGImageAlphaPremultipliedFirst;
    }
    
    CGContextRef context = CGBitmapContextCreate(NULL,
                                                 imageSize.width,
                                                 imageSize.height,
                                                 CGImageGetBitsPerComponent(imageRef),
                                                 0,
                                                 colorSpace,
                                                 bitmapInfo);
    CGColorSpaceRelease(colorSpace);
    
    if (!context) return self;
	
    CGContextDrawImage(context, imageRect, imageRef);
    CGImageRef decompressedImageRef = CGBitmapContextCreateImage(context);
	
    CGContextRelease(context);
	
    UIImage *decompressedImage = [UIImage imageWithCGImage:decompressedImageRef
                                                     scale:self.scale
                                               orientation:self.imageOrientation];
    CGImageRelease(decompressedImageRef);
    return decompressedImage;
}

- (UIImage *)addMark:(NSString *)mark textColor:(UIColor *)textColor font:(UIFont *)font point:(CGPoint)point {
    CGSize size = self.size;
    //2014-10-20 bear
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
//    if (UIGraphicsBeginImageContextWithOptions != NULL) {
//        UIGraphicsBeginImageContextWithOptions(size, NO, 0);
//    } else {
//        UIGraphicsBeginImageContext(size);
//    }
    
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    if (textColor == nil) {
        textColor = [UIColor whiteColor];
    }
    
    [textColor setFill];
    
    if (font == nil) {
        font = [UIFont systemFontOfSize:14.0f];
    }
    
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED <= __IPHONE_7_0
    [mark drawAtPoint:point
             forWidth:self.size.width
             withFont:font
        lineBreakMode:NSLineBreakByCharWrapping];
#else
    NSDictionary* Attributes2 = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, textColor,NSForegroundColorAttributeName, nil];
    [mark drawInRect:CGRectMake(point.x, point.y, self.size.width, self.size.height) withAttributes:Attributes2];

#endif

    
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (UIImage *)addCreateTime {
    NSDate *date = [NSDate date];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString = [df stringFromDate:date];
    [df release];
    
    
    CGSize size = [dateString sizeWithFont:[UIFont boldSystemFontOfSize:16.0f] maxSize:CGSizeMake(self.size.width, CGFLOAT_MAX)];
    
    return [self addMark:dateString
               textColor:[UIColor blackColor]
                    font:[UIFont boldSystemFontOfSize:16.0f]
                   point:CGPointMake(self.size.width-size.width-10, self.size.height-size.height-10)];
    
}

-(UIImage *)imageAtRect:(CGRect)rect{
	
	CGImageRef imageRef = CGImageCreateWithImageInRect([self CGImage], rect);
	UIImage* subImage = [UIImage imageWithCGImage: imageRef];
	CGImageRelease(imageRef);
	
	return subImage;
	
}

- (UIImage *)imageByScalingProportionallyToMinimumSize:(CGSize)targetSize {
	
	UIImage *sourceImage = self;
	UIImage *newImage = nil;
	
	CGSize imageSize = sourceImage.size;
	CGFloat width = imageSize.width;
	CGFloat height = imageSize.height;
	
	CGFloat targetWidth = targetSize.width;
	CGFloat targetHeight = targetSize.height;
	
	CGFloat scaleFactor = 0.0;
	CGFloat scaledWidth = targetWidth;
	CGFloat scaledHeight = targetHeight;
	
	CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
	
	if (CGSizeEqualToSize(imageSize, targetSize) == NO) {
		
		CGFloat widthFactor = targetWidth / width;
		CGFloat heightFactor = targetHeight / height;
		
		if (widthFactor > heightFactor)
			scaleFactor = widthFactor;
		else
			scaleFactor = heightFactor;
		
		scaledWidth  = width * scaleFactor;
		scaledHeight = height * scaleFactor;
		
		// center the image
		
		if (widthFactor > heightFactor) {
			thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
		} else if (widthFactor < heightFactor) {
			thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
		}
	}
	
	
	// this is actually the interesting part:
	
	UIGraphicsBeginImageContext(targetSize);
	
	CGRect thumbnailRect = CGRectZero;
	thumbnailRect.origin = thumbnailPoint;
	thumbnailRect.size.width  = scaledWidth;
	thumbnailRect.size.height = scaledHeight;
	
	[sourceImage drawInRect:thumbnailRect];
	
	newImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	if(newImage == nil) NSLog(@"could not scale image");
	
	
	return newImage ;
}

- (UIImage *)imageByScalingProportionallyToSize:(CGSize)targetSize {
	
	UIImage *sourceImage = self;
	UIImage *newImage = nil;
	
	CGSize imageSize = sourceImage.size;
	CGFloat width = imageSize.width;
	CGFloat height = imageSize.height;
	
	CGFloat targetWidth = targetSize.width;
	CGFloat targetHeight = targetSize.height;
	
	CGFloat scaleFactor = 0.0;
	CGFloat scaledWidth = targetWidth;
	CGFloat scaledHeight = targetHeight;
	
	CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
	
	if (CGSizeEqualToSize(imageSize, targetSize) == NO) {
		
		CGFloat widthFactor = targetWidth / width;
		CGFloat heightFactor = targetHeight / height;
		
		if (widthFactor < heightFactor)
			scaleFactor = widthFactor;
		else
			scaleFactor = heightFactor;
		
		scaledWidth  = width * scaleFactor;
		scaledHeight = height * scaleFactor;
		
		// center the image
		
		if (widthFactor < heightFactor) {
			thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
		} else if (widthFactor > heightFactor) {
			thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
		}
	}
	
	
	// this is actually the interesting part:
	
	UIGraphicsBeginImageContext(targetSize);
	
	CGRect thumbnailRect = CGRectZero;
	thumbnailRect.origin = thumbnailPoint;
	thumbnailRect.size.width  = scaledWidth;
	thumbnailRect.size.height = scaledHeight;
	
	[sourceImage drawInRect:thumbnailRect];
	
	newImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	if(newImage == nil) NSLog(@"could not scale image");
	
	
	return newImage ;
}

- (UIImage *)imageByScalingToSize:(CGSize)targetSize {
	
	UIImage *sourceImage = self;
	UIImage *newImage = nil;
	
	//   CGSize imageSize = sourceImage.size;
	//   CGFloat width = imageSize.width;
	//   CGFloat height = imageSize.height;
	
	CGFloat targetWidth = targetSize.width;
	CGFloat targetHeight = targetSize.height;
	
	//   CGFloat scaleFactor = 0.0;
	CGFloat scaledWidth = targetWidth;
	CGFloat scaledHeight = targetHeight;
	
	CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
	
	// this is actually the interesting part:
	
	UIGraphicsBeginImageContext(targetSize);
	
	CGRect thumbnailRect = CGRectZero;
	thumbnailRect.origin = thumbnailPoint;
	thumbnailRect.size.width  = scaledWidth;
	thumbnailRect.size.height = scaledHeight;
	
	[sourceImage drawInRect:thumbnailRect];
	
	newImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	if(newImage == nil) NSLog(@"could not scale image");
	
	
	return newImage ;
}

- (UIImage *)imageRotatedByRadians:(CGFloat)radians{
	return [self imageRotatedByDegrees:KKRadiansToDegrees(radians)];
}

- (UIImage *)imageRotatedByDegrees:(CGFloat)degrees{
	// calculate the size of the rotated view's containing box for our drawing space
	UIView *rotatedViewBox = [[UIView alloc] initWithFrame:CGRectMake(0,0,self.size.width, self.size.height)];
	CGAffineTransform t = CGAffineTransformMakeRotation(KKDegreesToRadians(degrees));
	rotatedViewBox.transform = t;
	CGSize rotatedSize = rotatedViewBox.frame.size;
	[rotatedViewBox release];
	
	// Create the bitmap context
	UIGraphicsBeginImageContext(rotatedSize);
	CGContextRef bitmap = UIGraphicsGetCurrentContext();
	
	// Move the origin to the middle of the image so we will rotate and scale around the center.
	CGContextTranslateCTM(bitmap, rotatedSize.width/2, rotatedSize.height/2);
	
	//   // Rotate the image context
	CGContextRotateCTM(bitmap, KKDegreesToRadians(degrees));
	
	// Now, draw the rotated/scaled image into the context
	CGContextScaleCTM(bitmap, 1.0, -1.0);
	CGContextDrawImage(bitmap, CGRectMake(-self.size.width / 2, -self.size.height / 2, self.size.width, self.size.height), [self CGImage]);
	
	UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return newImage;
	
}

- (UIImage*)convertImageToScale:(double)scale{
    CGSize newImageSize = CGSizeMake(self.size.width * scale, self.size.height * scale);
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContextWithOptions(newImageSize, 1.0, 1.0);
//    UIGraphicsBeginImageContext(newImageSize);
    // 绘制改变大小的图片
    [self drawInRect:CGRectMake(0,0, newImageSize.width, newImageSize.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage =UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    //返回新的改变大小后的图片
    return scaledImage;
}

@end


#pragma mark ==================================================
#pragma mark ==UIImageView
#pragma mark ==================================================
#import <ImageIO/ImageIO.h>

@implementation UIImageView (Extension)

- (void)showImageData:(NSData*)imageData{
    if ([[UIImage contentTypeExtensionForImageData:imageData] isEqualToString:UIImageExtensionType_GIF]) {
        NSMutableArray *frames = nil;
        CGImageSourceRef src = CGImageSourceCreateWithData((CFDataRef)imageData, NULL);
        double total = 0;
        CGFloat width = 0;
        CGFloat height = 0;
        
        NSTimeInterval gifAnimationDuration;
        if (src) {
            size_t l = CGImageSourceGetCount(src);
            if (l >= 1){
                frames = [NSMutableArray arrayWithCapacity: l];
                for (size_t i = 0; i < l; i++) {
                    CGImageRef img = CGImageSourceCreateImageAtIndex(src, i, NULL);
                    NSDictionary *dict = (NSDictionary *)CGImageSourceCopyPropertiesAtIndex(src, 0, NULL);
                    if (dict){
                        width = [[dict objectForKey: (NSString*)kCGImagePropertyPixelWidth] floatValue];
                        height = [[dict objectForKey: (NSString*)kCGImagePropertyPixelHeight] floatValue];
                        NSDictionary *tmpdict = [dict objectForKey: (NSString*)kCGImagePropertyGIFDictionary];
                        total += [[tmpdict objectForKey: (NSString*)kCGImagePropertyGIFDelayTime] doubleValue] * 100;
                        [dict release];
                    }
                    if (img) {
                        [frames addObject: [UIImage imageWithCGImage: img]];
                        CGImageRelease(img);
                    }
                }
                gifAnimationDuration = total / 100;
                
                CGRect oldFrame = self.frame;
                self.frame = CGRectMake(oldFrame.origin.x, oldFrame.origin.y, width, height);
                self.center = CGPointMake(oldFrame.origin.x+width/2.0, height/2.0);
                self.animationImages = frames;
                self.animationDuration = gifAnimationDuration;
                [self startAnimating];
            }
            
            CFRelease(src);
        }
    }
    else{
        self.image = [UIImage imageWithData:imageData];
        [self stopAnimating];
    }
}

- (void)showImageData:(NSData*)imageData inFrame:(CGRect)rect{
    if ([[UIImage contentTypeExtensionForImageData:imageData] isEqualToString:UIImageExtensionType_GIF]) {
        NSMutableArray *frames = nil;
        CGImageSourceRef src = CGImageSourceCreateWithData((CFDataRef)imageData, NULL);
        
        //        NSDictionary *gifProperties = [[NSDictionary dictionaryWithObject:[NSDictionary dictionaryWithObject:[NSNumber numberWithInt:0] forKey:(NSString *)kCGImagePropertyGIFLoopCount]
        //													 forKey:(NSString *)kCGImagePropertyGIFDictionary] retain];
        //        gif = CGImageSourceCreateWithURL((CFURLRef)[NSURL fileURLWithPath:_filePath], (CFDictionaryRef)gifProperties);
        //        CGImageSourceRef src = CGImageSourceCreateWithData((CFDataRef)imageData, (CFDictionaryRef)gifProperties);
        
        double total = 0;
//        CGFloat width = 0;
//        CGFloat height = 0;
        
        NSTimeInterval gifAnimationDuration;
        if (src) {
            size_t l = CGImageSourceGetCount(src);
            if (l >= 1){
                frames = [NSMutableArray arrayWithCapacity: l];
                for (size_t i = 0; i < l; i++) {
                    CGImageRef img = CGImageSourceCreateImageAtIndex(src, i, NULL);
                    NSDictionary *dict = (NSDictionary *)CGImageSourceCopyPropertiesAtIndex(src, 0, NULL);
                    if (dict){
//                        width = [[dict objectForKey: (NSString*)kCGImagePropertyPixelWidth] floatValue];
//                        height = [[dict objectForKey: (NSString*)kCGImagePropertyPixelHeight] floatValue];
                        NSDictionary *tmpdict = [dict objectForKey: (NSString*)kCGImagePropertyGIFDictionary];
                        total += [[tmpdict objectForKey: (NSString*)kCGImagePropertyGIFDelayTime] doubleValue] * 100;
                        [dict release];
                    }
                    if (img) {
                        [frames addObject: [UIImage imageWithCGImage: img]];
                        CGImageRelease(img);
                    }
                }
                gifAnimationDuration = total / 100;
                
                self.frame = rect;
                
                //                CGFloat rectHeight = rect.size.height;
                //                self.frame = CGRectMake(rect.origin.x, rect.origin.y, (rectHeight/height)*width, rectHeight);
                //                self.center = CGPointMake(rect.origin.x+(rectHeight/height)*width/2.0, rectHeight/2.0);
                self.animationImages = frames;
                self.animationDuration = gifAnimationDuration;
                [self startAnimating];
            }
            CFRelease(src);
        }
    }
    else{
        self.frame = rect;
        self.image = [UIImage imageWithData:imageData];
    }
}

@end

#pragma mark ==================================================
#pragma mark ==UIScrollView
#pragma mark ==================================================
//@implementation UIScrollView (KKUIScrollViewExtension)
//
//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    if(!self.dragging)
//    {
//        [[self nextResponder] touchesBegan:touches withEvent:event];
//    }
//    [super touchesBegan:touches withEvent:event];
//}
//-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    if(!self.dragging)
//    {
//        [[self nextResponder] touchesMoved:touches withEvent:event];
//    }
//    [super touchesMoved:touches withEvent:event];
//}
//
//- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    if(!self.dragging)
//    {
//        [[self nextResponder] touchesEnded:touches withEvent:event];
//    }
//    [super touchesEnded:touches withEvent:event];
//}
//
//
//@end


#pragma mark ==================================================
#pragma mark ==UITableView
#pragma mark ==================================================
@implementation UITableView (Extesion)

- (void)setBackgroundImage:(UIImage *)image {
    static NSUInteger BACKGROUND_IMAGE_VIEW_TAG = 91798;
    UIImageView *imageView = (UIImageView *)[self viewWithTag:BACKGROUND_IMAGE_VIEW_TAG];
    if (imageView == nil) {
        imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        [imageView setTag:BACKGROUND_IMAGE_VIEW_TAG];
        [self setBackgroundView:imageView];
        
        
        [imageView release];
    }
    [imageView setImage:image];
}

- (void)setBackgroundColor:(UIColor *)color {
    static NSUInteger BACKGROUND_VIEW_TAG = 91799;
    UIView *backgroundView = [self viewWithTag:BACKGROUND_VIEW_TAG];
    if (backgroundView == nil) {
        backgroundView = [[UIView alloc] initWithFrame:self.bounds];
        [backgroundView setTag:BACKGROUND_VIEW_TAG];
        [self setBackgroundView:backgroundView];
        [backgroundView release];
    }
    [backgroundView setBackgroundColor:color];
}

- (void)setSeparatorImage:(UIImage *)image {
    UIColor *separatorColor = [UIColor colorWithPatternImage:image];
    [self setSeparatorColor:separatorColor];
}

- (TableViewCellPositionType)tableViewCellPositionTypeForIndexPath:(NSIndexPath*)indexPath{
    
    TableViewCellPositionType position;
    if (indexPath.row==0) {
        //0行 总共0行
        if (indexPath.row==[self numberOfRowsInSection:indexPath.section]-1) {
            position = TableViewCellPositionType_Single;
        }
        else{
            position = TableViewCellPositionType_Min;
        }
    }
    else{
        //中间行
        if (indexPath.row!=[self numberOfRowsInSection:indexPath.section]-1) {
            position = TableViewCellPositionType_Middle;
        }
        //最后行
        else{
            position = TableViewCellPositionType_Max;
        }
    }
    return position;
}

@end


#pragma mark ==================================================
#pragma mark ==UITableViewCell
#pragma mark ==================================================
@implementation UITableViewCell (Extesion)

- (void)setBackgroundViewColor:(UIColor *)color {
    [self clearBackgroundColor];
    [self.contentView clearBackgroundColor];

    if (color == nil) {
        color = [UIColor whiteColor];
    }
    
    if (self.backgroundView == nil) {
        UIView *backgroundView = [[UIView alloc] initWithFrame:self.contentView.bounds];
        [backgroundView setOpaque:YES];
        [self setBackgroundView:backgroundView];
        [backgroundView release];
        backgroundView = nil;
    }
    [self.backgroundView setBackgroundColor:color];
}

- (void)setBackgroundViewImage:(UIImage *)image  {
    [self clearBackgroundColor];
    [self.contentView clearBackgroundColor];

    if (image == nil) {
        [self setBackgroundViewColor:nil];
        return ;
    }
    
    if (![self.backgroundView isMemberOfClass:[UIImageView class]]) {
        [self.backgroundView removeFromSuperview];
    }
    
    UIImageView *imageView = (UIImageView *)[self backgroundView];
    
    if (imageView == nil) {
        imageView = [[UIImageView alloc] initWithFrame:self.contentView.bounds];
        [self setBackgroundView:imageView];
        [imageView release];
    }
    
    [imageView setImage:image];
}

- (void)setSelectedBackgroundViewColor:(UIColor *)color {
    [self clearBackgroundColor];
    [self.contentView clearBackgroundColor];

    if (color == nil) {
        color = [UIColor whiteColor];
    }
    
    UIView *selectedBackgroundView = [[UIView alloc] initWithFrame:self.bounds];
    [selectedBackgroundView setOpaque:YES];
    [self setSelectedBackgroundView:selectedBackgroundView];
    [selectedBackgroundView release];
    selectedBackgroundView = nil;
    [self.selectedBackgroundView setBackgroundColor:color];
}

- (void)setSelectedBackgroundViewImage:(UIImage *)image {
    [self clearBackgroundColor];
    [self.contentView clearBackgroundColor];

    if (image == nil) {
        [self setSelectedBackgroundViewColor:nil];
        return ;
    }
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.contentView.bounds];
    [imageView setImage:image];
    [self setSelectedBackgroundView:imageView];
    [imageView release];
    imageView = nil;
}


@end


#pragma mark ==================================================
#pragma mark ==UITextField
#pragma mark ==================================================
#import <objc/objc.h>
#import <objc/runtime.h>

@implementation UITextField (KKUITextFieldExtension)

- (void)setPlaceholderColor:(UIColor *)color {
    if (color == nil) {
        color = [UIColor grayColor];
    }
    [self setValue:color forKeyPath:@"_placeholderLabel.textColor"];
}

- (void)setBackgroundImage:(UIImage *)image {
    [self setBackgroundImage:image stretchWithX:0 stretchWithY:0];
}

- (void)setBackgroundImage:(UIImage *)image stretchWithX:(NSInteger)x stretchWithY:(NSInteger)y{
    [self setBorderStyle:UITextBorderStyleNone];
    [self setBackground:[image stretchableImageWithLeftCapWidth:x topCapHeight:y]];
}

- (void)setDisabledBackgroundImage:(UIImage *)image stretchWithX:(NSInteger)x stretchWithY:(NSInteger)y {
    [self setBorderStyle:UITextBorderStyleNone];
    [self setDisabledBackground:[image stretchableImageWithLeftCapWidth:x topCapHeight:y]];
}

- (void)setLeftLabelTitle:(NSString *)text textColor:(UIColor *)textColor width:(CGFloat)width {
    [self setLeftLabelTitle:text
                  textColor:textColor
                   textFont:nil
                      width:width
            backgroundColor:nil];
}

- (void)setLeftLabelTitle:(NSString *)text
                textColor:(UIColor *)textColor
                 textFont:(UIFont *)font
                    width:(CGFloat)width
          backgroundColor:(UIColor *)backgroundColor {
    [self labelWithText:text
                 isLeft:YES
              textColor:textColor
               textFont:font
                  width:width
        backgroundColor:backgroundColor];
}

- (void)setRightLabelTitle:(NSString *)text
                 textColor:(UIColor *)textColor
                  textFont:(UIFont *)font
                     width:(CGFloat)width
           backgroundColor:(UIColor *)backgroundColor {
    [self labelWithText:text
                 isLeft:NO
              textColor:textColor
               textFont:font
                  width:width
        backgroundColor:backgroundColor];
}

- (UILabel *)labelWithText:(NSString *)text
                    isLeft:(BOOL)isLeft
                 textColor:(UIColor *)textColor
                  textFont:(UIFont *)font
                     width:(CGFloat)width
           backgroundColor:(UIColor *)backgroundColor {
    
    static NSUInteger leftLabelTag = 0;
    static NSUInteger rightLabelTag = 0;
    if (leftLabelTag == 0) {
        leftLabelTag = [self hash]+1;
    }
    if (rightLabelTag == 0) {
        rightLabelTag = [self hash]+2;
    }
    
    NSUInteger tag = rightLabelTag;
    
    if (isLeft) {
        tag = leftLabelTag;
    }
    
    UILabel *label = (UILabel *)[self viewWithTag:tag];
    if (label == nil) {
        label = [[UILabel alloc] init];
        [label setTag:tag];
        if (isLeft) {
            [self setLeftViewMode:UITextFieldViewModeAlways];
            [self setLeftView:label];
        } else {
            [self setRightViewMode:UITextFieldViewModeAlways];
            [self setRightView:label];
        }
        [label release];
        
        [label setAutoresizingMask:UIViewAutoresizingFlexibleWidth
         |UIViewAutoresizingFlexibleLeftMargin
         |UIViewAutoresizingFlexibleRightMargin];
        
    }
    
    if (font == nil) {
        font = self.font;
    }
    
    if (textColor == nil) {
        textColor = self.textColor;
    }
    
    if (backgroundColor == nil) {
        backgroundColor = [UIColor redColor];
    }
    
    [label setFrame:CGRectMake(0, 0, width, CGRectGetHeight(self.bounds))];
    [label setTextAlignment:NSTextAlignmentRight];
    [label setFont:font];
    [label setTextColor:textColor];
    [label setBackgroundColor:backgroundColor];
    [label setText:text];
    
    return label;
}

- (void)setMaxTextLenth:(int)length
{
    objc_setAssociatedObject(self, @"kLimitTextFieldMaxLengthKey", [NSNumber numberWithInt:length], OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self addTarget:self action:@selector(textFieldTextLengthLimit:) forControlEvents:UIControlEventEditingChanged];
}

- (void)textFieldTextLengthLimit:(id)sender
{
    NSNumber *lengthNumber = objc_getAssociatedObject(self, @"kLimitTextFieldMaxLengthKey");
    int length = [lengthNumber intValue];
    if(self.text.length > length){
        self.text = [self.text substringToIndex:length];
    }
}


@end


//#pragma mark ==================================================
//#pragma mark ==UITextView
//#pragma mark ==================================================
//#import <objc/objc.h>
//#import <objc/runtime.h>
//static NSString *kLimitTextViewMaxLengthKey = @"kLimitTextViewMaxLengthKey";
//
//@implementation UITextView (KKUIUITextViewExtension)
//
//- (void)dealloc{
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidChangeNotification object:nil];
//    [super dealloc];
//}
//
//- (void)setMaxTextLenth:(int)length{
//    objc_setAssociatedObject(self, (const void *)(kLimitTextViewMaxLengthKey), [NSNumber numberWithInt:length], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextLengthLimit) name:UITextViewTextDidChangeNotification object:nil];
//}
//
//
//- (void)textFieldTextLengthLimit{
//    NSNumber *lengthNumber = objc_getAssociatedObject(self, (const void *)(kLimitTextViewMaxLengthKey));
//    int length = [lengthNumber intValue];
//    if(self.text.length > length){
//        self.text = [self.text substringToIndex:length];
//    }
//}
//
//@end


#pragma mark ==================================================
#pragma mark ==UIView
#pragma mark ==================================================
#define activityViewTag 1010110
#import <objc/runtime.h>

@implementation UIView (KKUIViewExtension)
@dynamic tagInfo;

- (void)setTagInfo:(id)tagInfo{
    objc_setAssociatedObject(self, @"tagInfo", tagInfo, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (id)tagInfo {
    return objc_getAssociatedObject(self, @"tagInfo");
}

- (UIImage *)snapshot {
    //2014-10-20 bear
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 0);
//    if (UIGraphicsBeginImageContextWithOptions != NULL) {
//        UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 0);
//    } else {
//        UIGraphicsBeginImageContext(self.bounds.size);
//    }
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (void)clearBackgroundColor {
    [self setBackgroundColor:[UIColor clearColor]];
}

- (void)setBackgroundImage:(UIImage *)image {
    UIColor *color = [UIColor colorWithPatternImage:image];
    [self setBackgroundColor:color];
}

- (void)setIndex:(NSInteger)index {
    if (self.superview != nil) {
        [self.superview insertSubview:self atIndex:index];
    }
}

- (void)bringToFront {
    if (self.superview != nil) {
        [self.superview bringSubviewToFront:self];
    }
}

- (void)sendToBack {
    if (self.superview != nil) {
        [self.superview sendSubviewToBack:self];
    }
}

- (void)setBorderColor:(UIColor *)color width:(CGFloat)width {
    [self.layer setBorderWidth:width];
    [self.layer setBorderColor:color.CGColor];
}

- (void)setCornerRadius:(CGFloat)radius {
    [self.layer setMasksToBounds:YES];
    [self.layer setCornerRadius:radius];
}

- (void)setShadowColor:(UIColor *)color opacity:(CGFloat)opacity offset:(CGSize)offset blurRadius:(CGFloat)blurRadius {
    [self.layer setShadowColor:color.CGColor];
    [self.layer setShadowOpacity:opacity];
    [self.layer setShadowOffset:offset];
    [self.layer setShadowRadius:blurRadius];
}

- (UIActivityIndicatorView *)activityIndicatorView {
    UIActivityIndicatorView *view = (UIActivityIndicatorView *)[self viewWithTag:activityViewTag];
    if (view == nil) {
        view = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [view setTag:activityViewTag];
        CGFloat width = 100;
        CGFloat height = 100;
        CGFloat x = (CGRectGetWidth(self.frame) - width) / 2;
        CGFloat y = (CGRectGetHeight(self.frame) - height) / 2;
        [view setFrame:CGRectMake(x, y, width, height)];
        [self addSubview:view];
        [view release];
    }
    return view;
}

- (UIViewController *)viewController {
    return (UIViewController *)[self traverseResponderChainForUIViewController];
}

- (id)traverseResponderChainForUIViewController {
    id nextResponder = [self nextResponder];
    if ([nextResponder isKindOfClass:[UIViewController class]]) {
        return nextResponder;
    } else if ([nextResponder isKindOfClass:[UIView class]]) {
        return [nextResponder traverseResponderChainForUIViewController];
    } else {
        return nil;
    }
}

- (id)initWithFrame:(CGRect)frame startHexColor:(NSString*)startHexColor endHexColor:(NSString*)endHexColor{
    self = [self initWithFrame:frame];
    if (self) {
        if (startHexColor && endHexColor) {
            CAGradientLayer *gLayer = [CAGradientLayer layer];
            gLayer.frame = self.bounds;
            gLayer.colors =     [NSArray arrayWithObjects:
                                 (id)[UIColor hexColorToUIColor:startHexColor].CGColor,
                                 (id)[UIColor hexColorToUIColor:endHexColor].CGColor, nil];
            [self.layer insertSublayer:gLayer atIndex:0];
        }
        else{
            self.backgroundColor = [UIColor darkGrayColor];
        }
    }
    return self;
}

- (void)setBackgroundColorFromColor:(UIColor*)startUIColor toColor:(UIColor*)endUIColor direction:(UIViewGradientColorDirection)direction{
    
    if (! (startUIColor && endUIColor)) {
        return;
    }
    
    if ([[self.layer sublayers] count]>0 &&  [[[self.layer sublayers] objectAtIndex:0] isKindOfClass:[CAGradientLayer class]]) {
        [[[self.layer sublayers] objectAtIndex:0] removeFromSuperlayer];
    }

    
    CAGradientLayer *gLayer = [CAGradientLayer layer];
    gLayer.colors =     [NSArray arrayWithObjects:
                         (id)startUIColor.CGColor,
                         (id)endUIColor.CGColor, nil];
    
    if (direction==UIViewGradientColorDirection_TopBottom) {
        gLayer.frame = self.bounds;
    }
    else if (direction==UIViewGradientColorDirection_BottomTop){
        gLayer.frame = self.bounds;
        [gLayer setValue:[NSNumber numberWithDouble:M_PI] forKeyPath:@"transform.rotation.z"];
    }
    else if (direction==UIViewGradientColorDirection_LeftRight){
        gLayer.frame = CGRectMake(-(self.frame.size.height/2.0-self.frame.size.width/2.0), self.frame.size.height/2.0-self.frame.size.width/2.0, self.bounds.size.height, self.bounds.size.width);
        [gLayer setValue:[NSNumber numberWithDouble:-M_PI/2] forKeyPath:@"transform.rotation.z"];
    }
    else if (direction==UIViewGradientColorDirection_RightLeft){
        gLayer.frame = CGRectMake(-(self.frame.size.height/2.0-self.frame.size.width/2.0), self.frame.size.height/2.0-self.frame.size.width/2.0, self.bounds.size.height, self.bounds.size.width);
        [gLayer setValue:[NSNumber numberWithDouble:M_PI/2] forKeyPath:@"transform.rotation.z"];
    }
    else{
        gLayer.frame = self.bounds;
        [gLayer setValue:[NSNumber numberWithDouble:M_PI/2] forKeyPath:@"transform.rotation.z"];
    }
    
    [self.layer insertSublayer:gLayer atIndex:0];
    [gLayer setNeedsDisplay];
}

-(UIImage *)getImageFromSelf{
    UIGraphicsBeginImageContext(self.bounds.size);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

//=================设置遮罩相关=================
@dynamic bezierPath;

- (void)setBezierPath:(UIBezierPath *)bezierPath{
    objc_setAssociatedObject(self, @"bezierPath", bezierPath, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (UIBezierPath *)bezierPath {
    return objc_getAssociatedObject(self, @"bezierPath");
}

- (void)setMaskWithPath:(UIBezierPath*)path {
    [self setBezierPath:path];
    [self setMaskWithPath:path withBorderColor:nil borderWidth:0];
}

- (void)setMaskWithPath:(UIBezierPath*)path withBorderColor:(UIColor*)borderColor borderWidth:(float)borderWidth{
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.path = [path CGPath];
    maskLayer.fillColor = [[UIColor whiteColor] CGColor];
    maskLayer.frame = self.bounds;
    self.layer.mask = maskLayer;
    
    if (borderColor && borderWidth>0) {
        NSMutableArray *oldLayers = [NSMutableArray array];
        for (CALayer *layer in [self.layer sublayers]) {
            if ([layer isKindOfClass:[CAShapeLayer class]]) {
                [oldLayers addObject:layer];
            }
        }
        
        for (NSInteger i=0; i<[oldLayers count]; i++) {
            CALayer *layer = (CALayer*)[oldLayers objectAtIndex:i];
            [layer removeFromSuperlayer];
        }
        
        CAShapeLayer *maskBorderLayer = [[CAShapeLayer alloc] init];
        maskBorderLayer.path = [path CGPath];
        maskBorderLayer.fillColor = [[UIColor clearColor] CGColor];
        maskBorderLayer.strokeColor = [borderColor CGColor];
        maskBorderLayer.lineWidth = borderWidth;
        [self.layer addSublayer:maskBorderLayer];
        [maskBorderLayer release];
    }
}

- (BOOL)containsPoint:(CGPoint)point{
    return [[self bezierPath] containsPoint:point];
}
//=================设置遮罩相关=================


@end


#pragma mark ==================================================
#pragma mark ==UIBezierPath
#pragma mark ==================================================
@implementation UIBezierPath (UIBezierPathExtension)

+ (UIBezierPath *)chatBoxRightShape:(CGRect)originalFrame{
    
    CGRect frame = originalFrame;
    CGFloat width = frame.size.width;
    CGFloat height = frame.size.height;
    CGFloat CornerRadius = 8;
    CGFloat arrowWidth = 10;
    
    UIBezierPath* bezierPath = [UIBezierPath bezierPath];
    //    bezierPath.lineCapStyle = kCGLineCapRound; //线条拐角
    //    bezierPath.lineJoinStyle = kCGLineCapRound; //终点处理
    
    //左上角
    [bezierPath moveToPoint: CGPointMake(0, CornerRadius)];
    [bezierPath addArcWithCenter:CGPointMake(CornerRadius, CornerRadius) radius:CornerRadius startAngle:(1.0*M_PI) endAngle:(1.5*M_PI) clockwise:YES];
    [bezierPath addLineToPoint: CGPointMake(CornerRadius, 0)];
    
    //右上角
    [bezierPath addLineToPoint: CGPointMake(width-arrowWidth-CornerRadius, 0)];
    [bezierPath addArcWithCenter:CGPointMake(width-arrowWidth-CornerRadius, CornerRadius) radius:CornerRadius startAngle:(1.5*M_PI) endAngle:(0*M_PI) clockwise:YES];
    [bezierPath addLineToPoint: CGPointMake(width-arrowWidth, CornerRadius)];
    
    //三角
    [bezierPath addLineToPoint: CGPointMake(width-arrowWidth, CornerRadius+CornerRadius)];
    
    [bezierPath addLineToPoint: CGPointMake(width-0.5, CornerRadius+CornerRadius+arrowWidth/2.0-0.5)];
    [bezierPath addLineToPoint: CGPointMake(width-0.5, CornerRadius+CornerRadius+arrowWidth/2.0+0.5)];

    //    [bezierPath addLineToPoint: CGPointMake(width-arrowWidth/4.0, CornerRadius+arrowWidth+arrowWidth/4.0)];
    //    [bezierPath addArcWithCenter:CGPointMake(width-arrowWidth/2.0, CornerRadius+arrowWidth+arrowWidth/2.0) radius:arrowWidth/2.0/1.414 startAngle:(1.75*M_PI) endAngle:(0.25*M_PI) clockwise:YES];
    //    [bezierPath addLineToPoint: CGPointMake(width-arrowWidth/4.0, CornerRadius+arrowWidth+arrowWidth*3/4.0)];
    [bezierPath addLineToPoint: CGPointMake(width-arrowWidth, CornerRadius+CornerRadius+arrowWidth)];
    
    //右下角
    [bezierPath addLineToPoint: CGPointMake(width-arrowWidth, height-CornerRadius)];
    [bezierPath addArcWithCenter:CGPointMake(width-CornerRadius-arrowWidth, height-CornerRadius) radius:CornerRadius startAngle:(0*M_PI) endAngle:(0.5*M_PI) clockwise:YES];
    [bezierPath addLineToPoint: CGPointMake(width-CornerRadius-arrowWidth, height)];
    
    //左下角
    [bezierPath addLineToPoint: CGPointMake(CornerRadius, height)];
    [bezierPath addArcWithCenter:CGPointMake(CornerRadius, height-CornerRadius) radius:CornerRadius startAngle:(0.5*M_PI) endAngle:(1.0*M_PI) clockwise:YES];
    [bezierPath addLineToPoint: CGPointMake(0, height-CornerRadius)];
    
    [bezierPath addLineToPoint: CGPointMake(0, CornerRadius)];
    
    [bezierPath closePath];
    
    return bezierPath;
    
}

+ (UIBezierPath *)chatBoxLeftShape:(CGRect)originalFrame{
    
    CGRect frame = originalFrame;
    CGFloat width = frame.size.width;
    CGFloat height = frame.size.height;
    CGFloat CornerRadius = 8;
    CGFloat arrowWidth = 10;
    
    UIBezierPath* bezierPath = [UIBezierPath bezierPath];
    //    bezierPath.lineCapStyle = kCGLineCapRound; //线条拐角
    //    bezierPath.lineJoinStyle = kCGLineCapRound; //终点处理
    
    //左上角
    [bezierPath moveToPoint: CGPointMake(arrowWidth, CornerRadius)];
    [bezierPath addArcWithCenter:CGPointMake(arrowWidth+CornerRadius, CornerRadius) radius:CornerRadius startAngle:(1.0*M_PI) endAngle:(1.5*M_PI) clockwise:YES];
    [bezierPath addLineToPoint: CGPointMake(arrowWidth+CornerRadius, 0)];
    
    //右上角
    [bezierPath addLineToPoint: CGPointMake(width-CornerRadius, 0)];
    [bezierPath addArcWithCenter:CGPointMake(width-CornerRadius, CornerRadius) radius:CornerRadius startAngle:(1.5*M_PI) endAngle:(0*M_PI) clockwise:YES];
    [bezierPath addLineToPoint: CGPointMake(width, CornerRadius)];
    
    //右下角
    [bezierPath addLineToPoint: CGPointMake(width, height-CornerRadius)];
    [bezierPath addArcWithCenter:CGPointMake(width-CornerRadius, height-CornerRadius) radius:CornerRadius startAngle:(0*M_PI) endAngle:(0.5*M_PI) clockwise:YES];
    [bezierPath addLineToPoint: CGPointMake(width-CornerRadius, height)];
    
    //左下角
    [bezierPath addLineToPoint: CGPointMake(arrowWidth+CornerRadius, height)];
    [bezierPath addArcWithCenter:CGPointMake(arrowWidth+CornerRadius, height-CornerRadius) radius:CornerRadius startAngle:(0.5*M_PI) endAngle:(1.0*M_PI) clockwise:YES];
    [bezierPath addLineToPoint: CGPointMake(arrowWidth, height-CornerRadius)];
    
    //三角
    [bezierPath addLineToPoint: CGPointMake(arrowWidth, CornerRadius+CornerRadius+arrowWidth)];
    [bezierPath addLineToPoint: CGPointMake(0.5, CornerRadius+CornerRadius+arrowWidth/2.0+0.5)];
    [bezierPath addLineToPoint: CGPointMake(0.5, CornerRadius+CornerRadius+arrowWidth/2.0-0.5)];
    [bezierPath addLineToPoint: CGPointMake(arrowWidth, CornerRadius+CornerRadius)];
    
    [bezierPath addLineToPoint: CGPointMake(arrowWidth, CornerRadius)];
    
    [bezierPath closePath];
    
    return bezierPath;
    
}

@end


#pragma mark ==================================================
#pragma mark ==UIWebView
#pragma mark ==================================================
@implementation UIWebView (KKUIWebViewExtension)

- (UIScrollView *)scrollViewForWebView{
    UIScrollView *scrollView = nil;
    
    if ([self respondsToSelector:@selector(scrollView)]) {
        scrollView = [self scrollView];
    } else {
        for (UIView *view in [self subviews]) {
            if ([view isKindOfClass:[UIScrollView class]]) {
                scrollView = (UIScrollView *)view;
                break;
            }
        }
    }
    
    return scrollView;
}


- (void)cleanHeaderFooterBackgroundView{
    self.backgroundColor = [UIColor clearColor];
    self.opaque = NO;
    for (UIView *subView in [self subviews])
    {
        if ([subView isKindOfClass:[UIScrollView class]])
        {
            for (UIView *shadowView in [subView subviews])
            {
                if ([shadowView isKindOfClass:[UIImageView class]])
                {
                    shadowView.hidden = YES;
                }
            }
        }
    }
}

/*
 
 Using this Category is easy, simply add this to the top of your file where
 you have a UIWebView:
 
 #import "UIWebView+Clean.h"
 
 Then, any time you want to throw away or deallocate a UIWebView instance, do
 the following before you throw it away:
 
 [self.webView cleanForDealloc];
 self.webView = nil;
 
 If you still have leak issues, read the notes at the bottom of this class,
 they  may help you.
 
 */


- (void) cleanForDealloc{
    /*
     
     There are several theories and rumors about UIWebView memory leaks, and how
     to properly handle cleaning a UIWebView instance up before deallocation. This
     method implements several of those recommendations.
     
     #1: Various developers believe UIWebView may not properly throw away child
     objects & views without forcing the UIWebView to load empty content before
     dealloc.
     
     Source: http://stackoverflow.com/questions/648396/does-uiwebview-leak-memory
     
     */
    [self loadHTMLString:@"" baseURL:nil];
    
    /*
     
     #2: Others claim that UIWebView's will leak if they are loading content
     during dealloc.
     
     Source: http://stackoverflow.com/questions/6124020/uiwebview-leaking
     
     */
    [self stopLoading];
    
    /*
     
     #3: Apple recommends setting the delegate to nil before deallocation:
     "Important: Before releasing an instance of UIWebView for which you have set
     a delegate, you must first set the UIWebView delegate property to nil before
     disposing of the UIWebView instance. This can be done, for example, in the
     dealloc method where you dispose of the UIWebView."
     
     Source: UIWebViewDelegate class reference
     
     */
    self.delegate = nil;
    
    
    /*
     
     #4: If you're creating multiple child views for any given view, and you're
     trying to deallocate an old child, that child is pointed to by the parent
     view, and won't actually deallocate until that parent view dissapears. This
     call below ensures that you are not creating many child views that will hang
     around until the parent view is deallocated.
     */
    
    [self removeFromSuperview];
    
    /*
     
     Further Help with UIWebView leak problems:
     
     #1: Consider implementing the following in your UIWebViewDelegate:
     
     - (void) webViewDidFinishLoad:(UIWebView *)webView
     {
     //source: http://blog.techno-barje.fr/post/2010/10/04/UIWebView-secrets-part1-memory-leaks-on-xmlhttprequest/
     [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"WebKitCacheModelPreferenceKey"];
     }
     
     #2: If you can, avoid returning NO in your UIWebViewDelegate here:
     
     - (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
     {
     //this source says don't do this: http://stackoverflow.com/questions/6421813/lots-of-uiwebview-memory-leaks
     //return NO;
     return YES;
     }
     
     #3: Some leaks appear to be fixed in IOS 4.1
     Source: http://stackoverflow.com/questions/3857519/memory-leak-while-using-uiwebview-load-request-in-ios4-0
     
     #4: When you create your UIWebImageView, disable link detection if possible:
     
     webView.dataDetectorTypes = UIDataDetectorTypeNone;
     
     (This is also the "Detect Links" checkbox on a UIWebView in Interfacte Builder.)
     
     Sources:
     http://www.iphonedevsdk.com/forum/iphone-sdk-development/46260-how-free-memory-after-uiwebview.html
     http://www.iphonedevsdk.com/forum/iphone-sdk-development/29795-uiwebview-how-do-i-stop-detecting-links.html
     http://blog.techno-barje.fr/post/2010/10/04/UIWebView-secrets-part2-leaks-on-release/
     
     #5: Consider cleaning the NSURLCache every so often:
     
     [[NSURLCache sharedURLCache] removeAllCachedResponses];
     [[NSURLCache sharedURLCache] setDiskCapacity:0];
     [[NSURLCache sharedURLCache] setMemoryCapacity:0];
     
     Source: http://blog.techno-barje.fr/post/2010/10/04/UIWebView-secrets-part2-leaks-on-release/
     
     Be careful with this, as it may kill cache objects for currently executing URL
     requests for your application, if you can't cleanly clear the whole cache in
     your app in some place where you expect zero URLRequest to be executing, use
     the following instead after you are done with each request (note that you won't
     be able to do this w/ UIWebView's internal request objects..):
     
     [[NSURLCache sharedURLCache] removeCachedResponseForRequest:request];
     
     Source: http://stackoverflow.com/questions/6542114/clearing-a-webviews-cache-for-local-files
     
     */
}

- (void)loadJSFileName:(NSString *)fileName{
    NSString *path = [[ NSBundle mainBundle] pathForResource:fileName ofType:@"js"];
    NSString *jsCode = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    [self stringByEvaluatingJavaScriptFromString:jsCode];
}

- (NSInteger)highlightAllOccurencesOfString:(NSString *)query{
    [self loadJSFileName:@"KKWebViewSearch"];
    
    NSString *startSearch = [NSString stringWithFormat:@"search('%@')",query];
    [self stringByEvaluatingJavaScriptFromString:startSearch];
    
    return [self numSearchResults];
}

- (void)nextSearchResult{
    [self stringByEvaluatingJavaScriptFromString:@"highlightNext()"];
}

- (void)previousSearchResult{
    [self stringByEvaluatingJavaScriptFromString:@"highlightPrevious()"];
}

- (int)numSearchResults{
    return [[self stringByEvaluatingJavaScriptFromString:@"numResults()"] intValue];
}

- (int)currentSearchResultIndex{
    return ([[self stringByEvaluatingJavaScriptFromString:@"idx"] intValue] + 1);
}

- (void)removeAllHighlights{
    [self stringByEvaluatingJavaScriptFromString:@"removeAllHighlights()"];
}

@end

#pragma mark ==================================================
#pragma mark ==NSBundle
#pragma mark ==================================================
#import <mach/mach.h>
#import <mach/mach_host.h>

@implementation NSBundle (KKNSBundleExtension)

/*Bundle相关*/
+ (NSString *)bundleIdentifier {
    return [[NSBundle mainBundle] bundleIdentifier];
}

+ (NSString *)bundleName {
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"];
}

+ (NSString *)bundleBuildVersion {
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
}

+ (NSString *)bundleVersion {
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
}

+ (float)bundleMiniumOSVersion {
    return [[[[NSBundle mainBundle] infoDictionary] objectForKey:@"MinimumOSVersion"] floatValue];
}

+ (NSString *)bundlePath {
    return [[NSBundle mainBundle] bundlePath];
}

/*编译信息相关*/
+ (int)buildXcodeVersion {
    return [[[[NSBundle mainBundle] infoDictionary] objectForKey:@"DTXcode"] intValue];
}

+ (BOOL)isOpenPushNotification{
#if __IPHONE_OS_VERSION_MAX_ALLOWED < __IPHONE_8_0
    UIRemoteNotificationType types = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
    return (types);
#else
    return [[UIApplication sharedApplication] isRegisteredForRemoteNotifications];
#endif
}


/*路径相关*/
+ (NSString *)homeDirectory {
    return NSHomeDirectory();
}

+ (NSString *)documentDirectory {
    return [NSString stringWithFormat:@"%@/Documents", NSHomeDirectory()];
}

+ (NSString *)libaryDirectory {
    return [NSString stringWithFormat:@"%@/Library", NSHomeDirectory()];
}

+ (NSString *)tmpDirectory {
    return [NSString stringWithFormat:@"%@/tmp", NSHomeDirectory()];
}

+ (NSString *)temporaryDirectory {
    return NSTemporaryDirectory();
}

+ (NSString *)cachesDirectory {
    return [NSString stringWithFormat:@"%@/Library/Caches", NSHomeDirectory()];
}

/*检查新版本  开始*/
+ (void)checkAppVersionWithAppid:(NSString *)appid needShowNewVersionMessage:(BOOL)needShow completed:(CheckAppVersionCompletedBlock)completedBlock{
    
    NSString *urlPath = [NSString stringWithFormat:@"http://itunes.apple.com/lookup?id=%@", appid];
    NSURL *url = [NSURL URLWithString:urlPath];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"GET"];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if ([data length]>0 && !error ) {
            NSDictionary *appInfo = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            NSDictionary *result = nil;
            if ([appInfo valueForKey:@"results"]) {
                NSArray *arrary = [appInfo valueForKey:@"results"];
                if (arrary && [arrary count]>0) {
                    result = [arrary objectAtIndex:0];
                }
            }
            
            if (result) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSString *versionsInAppStore = [result valueForKey:@"version"];
                    if (versionsInAppStore) {
                        if ([[NSBundle bundleVersion] compare:versionsInAppStore options:NSNumericSearch] == NSOrderedAscending) {
                            
                            if (needShow) {
                                [NSBundle showAlertWithAppStoreVersion:versionsInAppStore
                                                               appleID:appid
                                                           description:[result valueForKey:@"description"]
                                                            updateInfo:[result valueForKey:@"releaseNotes"]];
                            }
                            if(completedBlock){
                                completedBlock(YES,versionsInAppStore,appid,[result valueForKey:@"description"],[result valueForKey:@"releaseNotes"]);
                            }
                        }
                        else {
                            if(completedBlock){
                                completedBlock(NO,versionsInAppStore,appid,[result valueForKey:@"description"],[result valueForKey:@"releaseNotes"]);
                            }
                        }
                    }
                    else {
                        if(completedBlock){
                            completedBlock(NO,versionsInAppStore,appid,[result valueForKey:@"description"],[result valueForKey:@"releaseNotes"]);
                        }
                    }
                });
            }
            else{
                dispatch_async(dispatch_get_main_queue(), ^{

                    if(completedBlock){
                        completedBlock(NO,nil,appid,nil,nil);
                    }
                });
            }
        }
        else{
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if(completedBlock){
                    completedBlock(NO,nil,appid,nil,nil);
                }
            });
        }
    }];
    [queue release];
}

+ (void)showAlertWithAppStoreVersion:(NSString *)appStoreVersion appleID:(NSString *)appleID description:(NSString *)description updateInfo:(NSString *)updateInfo {
    NSString *message = [NSString stringWithFormat:@"内容介绍:\n%@\n\n更新内容:\n%@", description, updateInfo];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"当前应用有新版本(%@)可以下载，是否前往更新？", appStoreVersion]
                                                        message:message
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:@"更新", nil];
    [alertView setTagInfo:appleID];
    [alertView show];
}

+ (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch ( buttonIndex ) {
        case 0:{
        } break;
        case 1:{
            NSString *urlPath = [NSString stringWithFormat:@"https://itunes.apple.com/app/id%@", alertView.tagInfo];
            NSURL *url = [NSURL URLWithString:urlPath];
            [[UIApplication sharedApplication] openURL:url];
        } break;
        default:
            break;
    }
}
/*检查新版本  结束*/

@end

#pragma mark ==================================================
#pragma mark ==NSNumber
#pragma mark ==================================================
@implementation NSNumber (KKNSNumberExtension)

//产生>= from 小于to 的随机数
+(NSInteger)randomIntegerBetween:(int)from and:(int)to{
    return (int)(from + (arc4random() % (to - from + 1)));
}

/*是否是整数*/
- (BOOL)isInt{
    if (strcmp([self objCType], @encode(int)) == 0)
    {
        return YES;
    }
    else{
        return NO;
    }
}


/*是否是整数*/
- (BOOL)isInteger{
    if (strcmp([self objCType], @encode(long)) == 0)
    {
        return YES;
    }
    else{
        return NO;
    }
}

/*是否是浮点数*/
- (BOOL)isFloat{
    if (strcmp([self objCType], @encode(float)) == 0)
    {
        return YES;
    }
    else{
        return NO;
    }
}

/*是否是高精度浮点数*/
- (BOOL)isDouble{
    if (strcmp([self objCType], @encode(double)) == 0)
    {
        return YES;
    }
    else{
        return NO;
    }
}


@end


#pragma mark ==================================================
#pragma mark ==KKUISearchBarExtension
#pragma mark ==================================================
@implementation UISearchBar (KKUISearchBarExtension)

-(void)clearBackground{
    for (UIView *subView in [self subviews]) {
        for (UIView *subsubView in [subView subviews]) {
            if ([subsubView isKindOfClass:NSClassFromString(@"UISearchBarBackground")]) {
                [subsubView removeFromSuperview];
                break;
            }
            else{
                subsubView.backgroundColor = [UIColor clearColor];
            }
        }
        
        if ([subView isKindOfClass:NSClassFromString(@"UISearchBarBackground")]) {
            [subView removeFromSuperview];
            break;
        }
        else{
            subView.backgroundColor = [UIColor clearColor];
        }
    }
}

@end

#pragma mark ==================================================
#pragma mark ==KKNSNullExtension
#pragma mark ==================================================
@implementation NSNull (KKNSNullExtension)

- (BOOL)isEqualToString:(NSString*)string{
    return NO;
}

@end


#pragma mark ==================================================
#pragma mark ==KKUIScrollViewExtension
#pragma mark ==================================================
@implementation UIScrollView (KKUIScrollViewExtension)

- (void)scrollToTopWithAnimated:(BOOL)animated{
    [self setContentOffset:CGPointMake(0, 0) animated:animated];
}

- (void)scrollToBottomWithAnimated:(BOOL)animated{
    
    if (self.contentSize.height>self.bounds.size.height) {
        [self setContentOffset:CGPointMake(0, self.contentSize.height-self.bounds.size.height) animated:animated];
    }
    else{
        [self setContentOffset:CGPointMake(0, 0) animated:animated];
    }

//    [self performSelector:@selector(scrollToBottomWithAnimated_20151211:) withObject:[NSNumber numberWithBool:animated] afterDelay:0];
}

- (void)scrollToBottomWithAnimated_20151211:(NSNumber*)animated{
    if (self.contentSize.height>self.bounds.size.height) {
        [self setContentOffset:CGPointMake(0, self.contentSize.height-self.bounds.size.height) animated:[animated boolValue]];
    }
    else{
        [self setContentOffset:CGPointMake(0, 0) animated:[animated boolValue]];
    }
}


@end

#pragma mark ==================================================
#pragma mark ==KKNSNullExtension
#pragma mark ==================================================
#import <QuartzCore/QuartzCore.h>

@implementation UIButton (Extension)

- (void)setBackgroundColor:(UIColor *)backgroundColor forState:(UIControlState)controlState{
    UIView *view = [[UIView alloc]initWithFrame:self.bounds];
    view.backgroundColor = backgroundColor;
    
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, view.layer.contentsScale);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    [self setBackgroundImage:newImage forState:controlState];
    UIGraphicsEndImageContext();
    
    [view release];
}

- (void)setBackgroundImage:(UIImage *)image forState:(UIControlState)state contentMode:(UIViewContentMode)contentMode{
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:self.bounds];
    imageView.contentMode = contentMode;
    imageView.image = image;
    
    UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, NO, imageView.layer.contentsScale);
    [imageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    [self setBackgroundImage:newImage forState:state];
    UIGraphicsEndImageContext();
    
    [imageView release];
    
}


- (void)setButtonContentAlignment:(ButtonContentAlignment)contentAlignment
         ButtonContentLayoutModal:(ButtonContentLayoutModal)contentLayoutModal
       ButtonContentTitlePosition:(ButtonContentTitlePosition)contentTitlePosition
        SapceBetweenImageAndTitle:(CGFloat)aSpace
                       EdgeInsets:(UIEdgeInsets)aEdgeInsets{
    self.titleEdgeInsets = UIEdgeInsetsZero;
    self.imageEdgeInsets = UIEdgeInsetsZero;

    NSString *aTitle = self.titleLabel.text;
    
    CGSize titleSize = [aTitle sizeWithFont:self.titleLabel.font maxSize:CGSizeMake(self.frame.size.width, 1000)];
    
    CGSize aImageSize = self.imageView.frame.size;
    if (!self.imageView.image) {
        aImageSize = CGSizeZero;
    }
    
    
    // 取得imageView最初的center
    CGPoint startImageViewCenter = self.imageView.center;
    // 取得titleLabel最初的center
    CGPoint startTitleLabelCenter = self.titleLabel.center;
    
    // 找出titleLabel最终的center
    CGPoint endTitleLabelCenter = CGPointZero;
    // 找出imageView最终的center
    CGPoint endImageViewCenter = CGPointZero;
    
    
    //垂直对齐
    if (contentLayoutModal==ButtonContentLayoutModalVertical) {
        if (contentAlignment==ButtonContentAlignmentLeft) {
            if (contentTitlePosition==ButtonContentTitlePositionBefore) {
                // 找出titleLabel最终的center
                endTitleLabelCenter = CGPointMake(aEdgeInsets.left+MAX(titleSize.width, aImageSize.width)/2.0, (self.frame.size.height-titleSize.height-aImageSize.height-aSpace)/2.0+titleSize.height/2.0);
                // 找出imageView最终的center
                endImageViewCenter = CGPointMake(aEdgeInsets.left+MAX(titleSize.width, aImageSize.width)/2.0,  (self.frame.size.height-titleSize.height-aImageSize.height-aSpace)/2.0+titleSize.height+aSpace+aImageSize.height);
            }
            else if (contentTitlePosition==ButtonContentTitlePositionAfter){
                // 找出imageView最终的center
                endImageViewCenter = CGPointMake(aEdgeInsets.left+MAX(titleSize.width, aImageSize.width)/2.0,  (self.frame.size.height-titleSize.height-aImageSize.height-aSpace)/2.0+aImageSize.height/2.0);
                
                // 找出titleLabel最终的center
                endTitleLabelCenter = CGPointMake(aEdgeInsets.left+MAX(titleSize.width, aImageSize.width)/2.0, (self.frame.size.height-titleSize.height-aImageSize.height-aSpace)/2.0+aImageSize.height+aSpace+titleSize.height/2.0);
            }
            else{
                
            }
        }
        else if (contentAlignment==ButtonContentAlignmentCenter){
            if (contentTitlePosition==ButtonContentTitlePositionBefore) {
                // 找出titleLabel最终的center
                endTitleLabelCenter = CGPointMake((self.frame.size.width-MAX(titleSize.width, aImageSize.width))/2.0+MAX(titleSize.width, aImageSize.width)/2.0, (self.frame.size.height-titleSize.height-aImageSize.height-aSpace)/2.0+titleSize.height/2.0);
                // 找出imageView最终的center
                endImageViewCenter = CGPointMake((self.frame.size.width-MAX(titleSize.width, aImageSize.width))/2.0+MAX(titleSize.width, aImageSize.width)/2.0,  (self.frame.size.height-titleSize.height-aImageSize.height-aSpace)/2.0+titleSize.height+aSpace+aImageSize.height);
            }
            else if (contentTitlePosition==ButtonContentTitlePositionAfter){
                // 找出imageView最终的center
                endImageViewCenter = CGPointMake((self.frame.size.width-MAX(titleSize.width, aImageSize.width))/2.0+MAX(titleSize.width, aImageSize.width)/2.0,  (self.frame.size.height-titleSize.height-aImageSize.height-aSpace)/2.0+aImageSize.height/2.0);
                
                // 找出titleLabel最终的center
                endTitleLabelCenter = CGPointMake((self.frame.size.width-MAX(titleSize.width, aImageSize.width))/2.0+MAX(titleSize.width, aImageSize.width)/2.0, (self.frame.size.height-titleSize.height-aImageSize.height-aSpace)/2.0+aImageSize.height+aSpace+titleSize.height/2.0);
            }
            else{
                
            }
        }
        else if (contentAlignment==ButtonContentAlignmentRight){
            
            if (contentTitlePosition==ButtonContentTitlePositionBefore) {
                // 找出titleLabel最终的center
                endTitleLabelCenter = CGPointMake(self.frame.size.width-aEdgeInsets.right-MAX(titleSize.width, aImageSize.width)/2.0, (self.frame.size.height-titleSize.height-aImageSize.height-aSpace)/2.0+titleSize.height/2.0);
                // 找出imageView最终的center
                endImageViewCenter = CGPointMake(self.frame.size.width-aEdgeInsets.right-MAX(titleSize.width, aImageSize.width)/2.0,  (self.frame.size.height-titleSize.height-aImageSize.height-aSpace)/2.0+titleSize.height+aSpace+aImageSize.height);
            }
            else if (contentTitlePosition==ButtonContentTitlePositionAfter){
                // 找出imageView最终的center
                endImageViewCenter = CGPointMake(self.frame.size.width-aEdgeInsets.right-MAX(titleSize.width, aImageSize.width)/2.0,  (self.frame.size.height-titleSize.height-aImageSize.height-aSpace)/2.0+aImageSize.height/2.0);
                
                // 找出titleLabel最终的center
                endTitleLabelCenter = CGPointMake(self.frame.size.width-aEdgeInsets.right-MAX(titleSize.width, aImageSize.width)/2.0, (self.frame.size.height-titleSize.height-aImageSize.height-aSpace)/2.0+aImageSize.height+aSpace+titleSize.height/2.0);
            }
            else{
                
            }
        }
        else{
            
        }
    }
    //水平对齐
    else if (contentLayoutModal==ButtonContentLayoutModalHorizontal){
        if (contentAlignment==ButtonContentAlignmentLeft) {
            if (contentTitlePosition==ButtonContentTitlePositionBefore) {
                // 找出titleLabel最终的center
                endTitleLabelCenter = CGPointMake(aEdgeInsets.left+titleSize.width/2.0, self.frame.size.height/2.0);
                // 找出imageView最终的center
                endImageViewCenter = CGPointMake(aEdgeInsets.left+titleSize.width+aImageSize.width/2.0+aSpace, self.frame.size.height/2.0);
            }
            else if (contentTitlePosition==ButtonContentTitlePositionAfter){
                // 找出titleLabel最终的center
                endTitleLabelCenter = CGPointMake(aEdgeInsets.left+titleSize.width/2.0+aImageSize.width+aSpace, self.frame.size.height/2.0);
                // 找出imageView最终的center
                endImageViewCenter = CGPointMake(aEdgeInsets.left+aImageSize.width/2.0, self.frame.size.height/2.0);
            }
            else{
                
            }
        }
        else if (contentAlignment==ButtonContentAlignmentCenter){
            if (contentTitlePosition==ButtonContentTitlePositionBefore) {
                // 找出titleLabel最终的center
                endTitleLabelCenter = CGPointMake((self.frame.size.width-titleSize.width-aImageSize.width-aSpace)/2.0+titleSize.width/2.0, self.frame.size.height/2.0);
                // 找出imageView最终的center
                endImageViewCenter = CGPointMake((self.frame.size.width-titleSize.width-aImageSize.width-aSpace)/2.0+titleSize.width+aSpace+aImageSize.width/2.0, self.frame.size.height/2.0);
            }
            else if (contentTitlePosition==ButtonContentTitlePositionAfter){
                // 找出imageView最终的center
                endImageViewCenter = CGPointMake((self.frame.size.width-titleSize.width-aImageSize.width-aSpace)/2.0+aImageSize.width/2.0, self.frame.size.height/2.0);
                // 找出titleLabel最终的center
                endTitleLabelCenter = CGPointMake(endImageViewCenter.x+(aImageSize.width)/2.0+aSpace+titleSize.width/2.0, self.frame.size.height/2.0);
            }
            else{
                
            }
        }
        else if (contentAlignment==ButtonContentAlignmentRight){
            
            if (contentTitlePosition==ButtonContentTitlePositionBefore) {
                // 找出titleLabel最终的center
                endTitleLabelCenter = CGPointMake(self.frame.size.width-titleSize.width/2.0-aImageSize.width-aEdgeInsets.right-aSpace, self.frame.size.height/2.0);
                // 找出imageView最终的center
                endImageViewCenter = CGPointMake(self.frame.size.width-aEdgeInsets.right-aImageSize.width/2.0, self.frame.size.height/2.0);
            }
            else if (contentTitlePosition==ButtonContentTitlePositionAfter){
                // 找出imageView最终的center
                endImageViewCenter = CGPointMake(self.frame.size.width-aImageSize.width/2.0-titleSize.width-aEdgeInsets.right-aSpace, self.frame.size.height/2.0);
                // 找出titleLabel最终的center
                endTitleLabelCenter = CGPointMake(self.frame.size.width-aEdgeInsets.right-titleSize.width/2.0, self.frame.size.height/2.0);
            }
            else{
                
            }
        }
        else{
            
        }
    }
    else{
        
    }
    
    // 设置titleEdgeInsets
    CGFloat titleEdgeInsetsTop = endTitleLabelCenter.y-startTitleLabelCenter.y+self.titleEdgeInsets.top;
    CGFloat titleEdgeInsetsLeft = endTitleLabelCenter.x - startTitleLabelCenter.x+self.titleEdgeInsets.left;
    CGFloat titleEdgeInsetsBottom = -titleEdgeInsetsTop;
    CGFloat titleEdgeInsetsRight = -titleEdgeInsetsLeft;
    self.titleEdgeInsets = UIEdgeInsetsMake(titleEdgeInsetsTop, titleEdgeInsetsLeft, titleEdgeInsetsBottom, titleEdgeInsetsRight);
    
    
    // 设置imageEdgeInsets
    CGFloat imageEdgeInsetsTop = endImageViewCenter.y - startImageViewCenter.y+self.imageEdgeInsets.top;
    CGFloat imageEdgeInsetsLeft = endImageViewCenter.x - startImageViewCenter.x+self.imageEdgeInsets.left;
    CGFloat imageEdgeInsetsBottom = -imageEdgeInsetsTop;
    CGFloat imageEdgeInsetsRight = -imageEdgeInsetsLeft;
    self.imageEdgeInsets = UIEdgeInsetsMake(imageEdgeInsetsTop, imageEdgeInsetsLeft, imageEdgeInsetsBottom, imageEdgeInsetsRight);
}


@end

#pragma mark ==================================================
#pragma mark ==NSObjectExtension
#pragma mark ==================================================

@implementation NSObject (NSObjectFileTypeExtention)

+ (BOOL)isFileType_DOC:(NSString*)fileExtention{
    if ([[fileExtention lowercaseString] isEqualToString:@"doc"] ||
        [[fileExtention lowercaseString] isEqualToString:@"docx"]) {
        return YES;
    }
    else{
        return NO;
    }
}

+ (BOOL)isFileType_PPT:(NSString*)fileExtention{
    if ([[fileExtention lowercaseString] isEqualToString:@"ppt"] ||
        [[fileExtention lowercaseString] isEqualToString:@"pptx"]) {
        return YES;
    }
    else{
        return NO;
    }
}

+ (BOOL)isFileType_XLS:(NSString*)fileExtention{
    if ([[fileExtention lowercaseString] isEqualToString:@"xls"] ||
        [[fileExtention lowercaseString] isEqualToString:@"xlsx"] ||
        [[fileExtention lowercaseString] isEqualToString:@"csv"]) {
        return YES;
    }
    else{
        return NO;
    }
}

+ (BOOL)isFileType_IMG:(NSString*)fileExtention{
    if ([[fileExtention lowercaseString] isEqualToString:@"png"] ||
        [[fileExtention lowercaseString] isEqualToString:@"jpg"] ||
        [[fileExtention lowercaseString] isEqualToString:@"bmp"] ||
        [[fileExtention lowercaseString] isEqualToString:@"gif"] ||
        [[fileExtention lowercaseString] isEqualToString:@"jpeg"]) {
        return YES;
    }
    else{
        return NO;
    }
}

+ (BOOL)isFileType_VIDEO:(NSString*)fileExtention{
    if ([[fileExtention lowercaseString] isEqualToString:@"mov"] ||
        [[fileExtention lowercaseString] isEqualToString:@"mp4"] ||
        [[fileExtention lowercaseString] isEqualToString:@"flv"] ||
        [[fileExtention lowercaseString] isEqualToString:@"avi"] ||
        [[fileExtention lowercaseString] isEqualToString:@"mkv"] ||
        [[fileExtention lowercaseString] isEqualToString:@"rm"] ||
        [[fileExtention lowercaseString] isEqualToString:@"rmvb"] ||
        [[fileExtention lowercaseString] isEqualToString:@"mpeg"]) {
        return YES;
    }
    else{
        return NO;
    }
}

+ (BOOL)isFileType_AUDIO:(NSString*)fileExtention{
    if ([[fileExtention lowercaseString] isEqualToString:@"mp3"] ||
        [[fileExtention lowercaseString] isEqualToString:@"wma"] ||
        [[fileExtention lowercaseString] isEqualToString:@"wav"]) {
        return YES;
    }
    else{
        return NO;
    }
}

+ (BOOL)isFileType_PDF:(NSString*)fileExtention{
    if ([[fileExtention lowercaseString] isEqualToString:@"pdf"]) {
        return YES;
    }
    else{
        return NO;
    }
}

+ (BOOL)isFileType_TXT:(NSString*)fileExtention{
    if ([[fileExtention lowercaseString] isEqualToString:@"txt"]) {
        return YES;
    }
    else{
        return NO;
    }
}

+ (BOOL)isFileType_ZIP:(NSString*)fileExtention{
    if ([[fileExtention lowercaseString] isEqualToString:@"zip"] ||
        [[fileExtention lowercaseString] isEqualToString:@"rar"]) {
        return YES;
    }
    else{
        return NO;
    }
}

+ (void)showNoticeMessage:(NSString*)aMessage{
    if (aMessage && [aMessage isKindOfClass:[NSString class]] && [aMessage length]>0) {
        
        NSString *showMessage = aMessage;
        if ([aMessage isEqualToString:kAppServerError] && [[KKNetWorkObserver sharedInstance] status]==NotReachable) {
            showMessage = KILocalization(@"网络异常，请检查您的wifi或者数据环境");
        }
        
        //        [[TKAlertCenter defaultCenter] postAlertWithMessage:aMessage];
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:Window0 animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = showMessage;
        hud.margin = 10.f;
        hud.removeFromSuperViewOnHide = YES;
        [hud hide:YES afterDelay:2.0];
    }
}

+ (void)showHTTPRequestMessage:(NSDictionary*)aHttpInformation{
    if (aHttpInformation && [aHttpInformation isKindOfClass:[NSDictionary class]] && [aHttpInformation count]>0) {
        
        NSInteger resultCode = [[aHttpInformation valuebleStringForKey:httpResultCodeKey] integerValue];
        if (resultCode==0) {
            [NSObject showNoticeMessage:kAppServerError];
        }
        else{
            [NSObject showNoticeMessage:kAppRequestFailed];
        }
    }
}

+ (NSString*)AESCrypt_String:(NSString*)string{
    if ([NSString isStringEmpty:string]) {
        return @"";
    }
    
    //    NSString *date = [NSDate getStringWithFormatter:KKDateFormatter04];
    //    NSString *string01 = [NSString stringWithFormat:@"%@%@gou",RongLian_APPKEY,date];
    NSString *string01 = [NSString stringWithFormat:@"%@gou",RongLian_APPKEY];
    NSString *string02 = [string01 md5];
    NSString *string03 = [string02 substringToIndex:8];
    return [AESCrypt encrypt:string password:string03];
}

+ (NSString*)dateTimestampFormat:(NSString*)oldDateTimestamp{
    
    NSTimeInterval in_TimeInterval = [oldDateTimestamp doubleValue];
    NSDate *in_Date = [NSDate dateWithTimeIntervalSince1970:in_TimeInterval];
    
    //现在
    NSDate *now_Date = [NSDate date];
    NSTimeInterval now_TimeInterval = [now_Date timeIntervalSince1970];
    
    //今天
    NSDate *today_Date = [NSDate date];
    NSString *today_yyyymmdd = [NSDate getStringFromDate:today_Date dateFormatter:KKDateFormatter04];
    NSTimeInterval today_TimeInterval = [[NSDate getDateFromString:today_yyyymmdd dateFormatter:KKDateFormatter04] timeIntervalSince1970];
    
    //昨天
    NSDate *yestoday_Date = [[NSDate date] previousDate];
    NSString *yestoday_yyyymmdd = [NSDate getStringFromDate:yestoday_Date dateFormatter:KKDateFormatter04];
    NSTimeInterval yestoday_TimeInterval = [[NSDate getDateFromString:yestoday_yyyymmdd dateFormatter:KKDateFormatter04] timeIntervalSince1970];
    
    //前天
    NSDate *yestodayB_Date = [yestoday_Date previousDate];
    NSString *yestodayB_yyyymmdd = [NSDate getStringFromDate:yestodayB_Date dateFormatter:KKDateFormatter04];
    NSTimeInterval yestodayB_TimeInterval = [[NSDate getDateFromString:yestodayB_yyyymmdd dateFormatter:KKDateFormatter04] timeIntervalSince1970];
    
    //5分钟内  显示为 刚刚
    if (now_TimeInterval-in_TimeInterval < (5*60) ) {
        return [NSDate getStringFromDate:in_Date dateFormatter:@"HH:mm"];
    }
    else{
        //今天
        if (in_TimeInterval>=today_TimeInterval) {
            //            return [NSDate getStringFromDate:in_Date dateFormatter:@"a HH:mm"]; //上午：09:12
            return [NSDate getStringFromDate:in_Date dateFormatter:@"HH:mm"];
        }
        //昨天
        else if (yestoday_TimeInterval<=in_TimeInterval && in_TimeInterval<today_TimeInterval){
            return [NSDate getStringFromDate:in_Date dateFormatter:[NSString stringWithFormat:@"%@ HH:mm",KILocalization(@"昨天")]];
        }
        //前天
        else if (yestodayB_TimeInterval<=in_TimeInterval && in_TimeInterval<yestoday_TimeInterval){
            return [NSDate getStringFromDate:in_Date dateFormatter:[NSString stringWithFormat:@"%@ HH:mm",KILocalization(@"前天")]];
        }
        else{
            return [NSDate getStringFromDate:in_Date dateFormatter:@"MM月dd日"];
        }
    }
}

//字节大小转换成显示字符串
+ (NSString*)dataSizeFormat:(CGFloat)dataSize{
    if (dataSize<=0) {
        return @"未知大小";
    }
    else if (0<dataSize && dataSize<(1024.0)) {
        return [NSString stringWithFormat:@"%.0fByte",dataSize];
    }
    else if ((1024.0)<=dataSize && dataSize<(1024*1024.0)){
        return [NSString stringWithFormat:@"%.0fKB",dataSize/(1024.0)];
    }
    else if ((1024*1024.0)<=dataSize && dataSize<(1024*1024*1024.0)){
        return [NSString stringWithFormat:@"%.1fMB",dataSize/(1024*1024.0)];
    }
    else{
        return [NSString stringWithFormat:@"%.1fGB",dataSize/(1024*1024*1024.0)];
    }
}


@end














