//
//  KKThemeManager.h
//  KKLibrary_Demo
//
//  Created by beartech on 14/12/1.
//  Copyright (c) 2014年 KeKeStudio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

UIKIT_EXTERN  NSString *const NotificationName_ThemeHasChanged;

#define KKThemeImage(key)         [KKThemeManager imageWithKey:key]
#define KKThemeImagePath(key)     [KKThemeManager imagePathWithKey:key]
#define KKThemeGifImagePath(key)  [KKThemeManager gifImagePathWithKey:key]
#define KKThemeColor(key)         [KKThemeManager colorWithKey:key]
#define KKThemeFont(key)          [KKThemeManager fontWithKey:key];


@interface KKThemeManager : NSObject

@property (nonatomic, copy) NSString *currentThemeName;
@property (nonatomic, retain) NSMutableDictionary *themeInformation;

+ (KKThemeManager *)sharedInstance;


+ (UIImage *)imageWithKey:(NSString *)key;

+ (NSString *)imagePathWithKey:(NSString *)key;

+ (NSString *)gifImagePathWithKey:(NSString *)key;


/*key对应的value的值格式：
 #RGB、#ARGB 、#RRGGBB 、#AARRGGBB 、R,G,B,A
 */
+ (UIColor *)colorWithKey:(NSString *)key;

@end
