//
//  KKExtension.h
//  KKLibrary
//
//  Created by bear on 13-6-15.
//  Copyright (c) 2013年 kekestudio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
//#import "JSONKit.h"

@interface KKAuthorizedManager : NSObject


/*
 检查是否授权【通讯录】
 #import <AddressBook/AddressBook.h>
 */
+ (BOOL)isAddressBookAuthorized_ShowAlert:(BOOL)showAlert;

/*
 检查是否授权【相册】
 #import <AssetsLibrary/AssetsLibrary.h>
 */
+ (BOOL)isAlbumAuthorized_ShowAlert:(BOOL)showAlert;

/*
 检查是否授权【相机】
 #import <AVFoundation/AVFoundation.h>
 */
+ (BOOL)isCameraAuthorized_ShowAlert:(BOOL)showAlert;


/*
 检查是否授权【地理位置】
 #import <MapKit/MapKit.h>
 */
+ (BOOL)isLocationAuthorized_ShowAlert:(BOOL)showAlert;

/*
 检查是否授权【麦克风】
 #import <AVFoundation/AVFoundation.h>
 */
+ (BOOL)isMicrophoneAuthorized_ShowAlert:(BOOL)showAlert;

/*
 检查是否授权【通知中心】
 */
+ (BOOL)isNotificationAuthorized;


@end


@interface KKExtension : NSObject

+ (id)getRootViewController;

@end


#pragma mark ==================================================
#pragma mark ==NSObject
#pragma mark ==================================================
#import <AudioToolbox/AudioToolbox.h>

Class object_getClass(id object);

extern NSString * const NotificaitonThemeDidChange;
extern NSString * const NotificaitonLocalizationDidChange;

@interface NSObject (KKNSObjectExtension)

/*震动设备*/
- (void)vibrateDevice;

/*注册成为指定消息的观察者*/
- (void)observeNotificaiton:(NSString *)name;

- (void)observeNotificaiton:(NSString *)name selector:(SEL)selector;

- (void)unobserveNotification:(NSString *)name;

- (void)unobserveAllNotification;

- (void)postNotification:(NSString *)name;

- (void)postNotification:(NSString *)name object:(id)object;

- (void)postNotification:(NSString *)name object:(id)object userInfo:(NSDictionary *)userInfo;

//主题&本地化相关
- (void)observeThemeChangeNotificaiton;

- (void)unobserveThemeChangeNotificaiton;

/*在ViewController中重写*/
- (void)changeTheme;

- (void)observeLocalizationChangeNotification;

- (void)unobserveLocalizationChangeNotification;

/*在ViewController中重写*/
- (void)changeLocalization;

/*重写这个方法，用于处理接收到的notification*/
- (void)handleNotification:(NSString *)name object:(id)object userInfo:(NSDictionary *)userInfo;

- (BOOL)isArray;

- (BOOL)isDictionary;

- (BOOL)isString;

- (BOOL)isNotEmptyArray;

- (BOOL)isNotEmptyDictionary;

/**
 @brief 跳出App到URL
 @discussion 跳出App到URL
 @param url 链接地址
 */
- (void)openURL:(NSURL *)url;

/**
 @brief 发邮件
 @discussion 跳转到系统邮件App
 @param mail 收件人邮件地址
 */
- (void)sendMail:(NSString *)mail;

/**
 @brief 发短信
 @discussion 跳转到系统短信App
 @param number 收信人手机号码
 */
- (void)sendSMS:(NSString *)number;

/**
 @brief 打电话
 @discussion 跳转到系统电话App
 @param number 对方手机号码
 */
- (void)callNumber:(NSString *)number;

@end


#pragma mark ==================================================
#pragma mark ==NSArray
#pragma mark ==================================================
@interface NSArray (KKNSArrayExtension)

/**
@brief 判断一个数组里面的元素，是否包含某个数字或者字符串
@discussion 这个数组里面的元素要是数字，或者字符串
@param aString 需要比较的字符串
*/
- (BOOL)containsStringValue:(NSString*)aString;

/**
 @brief 判断一个数组不为空
 @discussion 判断一个数组不为空
 @param array 需要判断的数组
 */
+ (BOOL)isArrayNotEmpty:(id)array;

/**
 @brief 判断一个数组为空
 @discussion 判断一个数组为空
 @param array 需要判断的数组
 */
+ (BOOL)isArrayEmpty:(id)array;

/**
 @brief 转换成json字符串
 discussion
 **/
- (NSString*)translateToJSONString;

/**
 @brief json字符串转换成对象
 discussion
 */
+ (NSArray*)arrayFromJSONData:(NSData*)aJsonData;

/**
 @brief json字符串转换成对象
 discussion
 */
+ (NSArray*)arrayFromJSONString:(NSString*)aJsonString;

@end


#pragma mark ==================================================
#pragma mark == NSData
#pragma mark ==================================================
//#import <CommonCrypto/CommonDigest.h>

typedef void(^KKImageConvertImageOneCompletedBlock)(NSData *imageData,NSInteger index);
typedef void(^KKImageConvertImageAllCompletedBlock)();

@interface NSData (KKNSDataExtension)

/**
 @brief md5 加密
 @discussion md5 加密
 */
- (NSString *)md5;

/**
 @brief base64 加密
 @discussion base64 加密
 */
- (NSString *)base64Encoded;

/**
 @brief base64 解密
 @discussion base64 解密
 */
- (NSData *)base64Decoded;

/**
 @brief 将图片压缩到指定大小
 @discussion 将图片压缩到指定大小
 @param imageArray UIImage数组
 @param imageDataSize 需要压缩到的图片数据大小范围值(单位KB)，比如100KB
 @param completedOneBlock 压缩一条数据完成回调block
 @param completedAllBlock 压缩所有数据完成回调block
 */
+ (void)convertImage:(NSArray*)imageArray
          toDataSize:(CGFloat)imageDataSize
convertImageOneCompleted:(KKImageConvertImageOneCompletedBlock)completedOneBlock
KKImageConvertImageAllCompletedBlock:(KKImageConvertImageAllCompletedBlock)completedAllBlock;
@end


#pragma mark ==================================================
#pragma mark == NSMutableData
#pragma mark ==================================================
#define NSMutableURLRequest_Boundary @"KKStudio"
@interface NSMutableData(KKStudioExtensionAddPostData)


/**
 @brief 当网络请求为POST方法上传文件的时候使用。参数拼接在body里面
 @discussion 其他情况，请不要用.可使用下面的：- (void) addPostKey:(NSString*)key value:(NSString*)value;
 param key:参数
 param value:值
 */
- (void) addPostKeyForFileUpload:(NSString*)key value:(NSString*)value;

/**
 @brief 当网络请求为POST方法上传文件的时候使用。文件拼接在body里面。
 @discussion 其他情况，请不要用.
 param key:参数
 param data:值
 */
- (void) addPostDataForFileUpload:(NSData*)data forKey:(NSString*)key;


/**
 @brief 当网络请求不是上传文件的时候使用。文件拼接在body里面。
 @discussion 其他情况，请不要用。可使用上面的：- (void) addPostKeyForFileUpload:(NSString*)key value:(NSString*)value;
 param key:参数
 param value:值
 */
- (void) addPostKey:(NSString*)key value:(NSString*)value;

@end


/*
 
 a: AM/PM (上午/下午)
 
 A: 0~86399999 (一天的第A微秒)
 
 c/cc: 1~7 (一周的第一天, 周天为1)
 
 ccc: Sun/Mon/Tue/Wed/Thu/Fri/Sat (星期几简写)
 
 cccc: Sunday/Monday/Tuesday/Wednesday/Thursday/Friday/Saturday (星期几全拼)
 
 d: 1~31 (月份的第几天, 带0)
 
 D: 1~366 (年份的第几天,带0)
 
 e: 1~7 (一周的第几天, 带0)
 
 E~EEE: Sun/Mon/Tue/Wed/Thu/Fri/Sat (星期几简写)
 
 EEEE: Sunday/Monday/Tuesday/Wednesday/Thursday/Friday/Saturday (星期几全拼)
 
 F: 1~5 (每月的第几周, 一周的第一天为周一)
 
 g: Julian Day Number (number of days since 4713 BC January 1) 未知
 
 G~GGG: BC/AD (Era Designator Abbreviated) 未知
 
 GGGG: Before Christ/Anno Domini 未知
 
 h: 1~12 (0 padded Hour (12hr)) 带0的时, 12小时制
 
 H: 0~23 (0 padded Hour (24hr))  带0的时, 24小时制
 
 k: 1~24 (0 padded Hour (24hr) 带0的时, 24小时制
 
 K: 0~11 (0 padded Hour (12hr)) 带0的时, 12小时制
 
 L/LL: 1~12 (0 padded Month)  第几月
 
 LLL: Jan/Feb/Mar/Apr/May/Jun/Jul/Aug/Sep/Oct/Nov/Dec 月份简写
 
 LLLL: January/February/March/April/May/June/July/August/September/October/November/December 月份全称
 
 m: 0~59 (0 padded Minute) 分钟
 
 M/MM: 1~12 (0 padded Month) 第几月
 
 MMM: Jan/Feb/Mar/Apr/May/Jun/Jul/Aug/Sep/Oct/Nov/Dec
 
 MMMM: January/February/March/April/May/June/July/August/September/October/November/December
 
 q/qq: 1~4 (0 padded Quarter) 第几季度
 
 qqq: Q1/Q2/Q3/Q4 季度简写
 
 qqqq: 1st quarter/2nd quarter/3rd quarter/4th quarter 季度全拼
 
 Q/QQ: 1~4 (0 padded Quarter) 同小写
 
 QQQ: Q1/Q2/Q3/Q4 同小写
 
 QQQQ: 1st quarter/2nd quarter/3rd quarter/4th quarter 同小写
 
 s: 0~59 (0 padded Second) 秒数
 
 S: (rounded Sub-Second) 未知
 
 u: (0 padded Year) 未知
 
 v~vvv: (General GMT Timezone Abbreviation) 常规GMT时区的编写
 
 vvvv: (General GMT Timezone Name) 常规GMT时区的名称
 
 w: 1~53 (0 padded Week of Year, 1st day of week = Sunday, NB: 1st week of year starts from the last Sunday of last year) 一年的第几周, 一周的开始为周日,第一周从去年的最后一个周日起算
 
 W: 1~5 (0 padded Week of Month, 1st day of week = Sunday) 一个月的第几周
 
 y/yyyy: (Full Year) 完整的年份
 
 yy/yyy: (2 Digits Year)  2个数字的年份
 
 Y/YYYY: (Full Year, starting from the Sunday of the 1st week of year) 这个年份未知干嘛用的
 
 YY/YYY: (2 Digits Year, starting from the Sunday of the 1st week of year) 这个年份未知干嘛用的
 
 z~zzz: (Specific GMT Timezone Abbreviation) 指定GMT时区的编写
 
 zzzz: (Specific GMT Timezone Name) Z: +0000 (RFC 822 Timezone) 指定GMT时区的名称
 
 */


#pragma mark ==================================================
#pragma mark ==NSDate
#pragma mark ==================================================

#define KKDateFormatter01 @"yyyy-MM-dd HH:mm:ss"
#define KKDateFormatter02 @"yyyy-MM-dd HH:mm"
#define KKDateFormatter03 @"yyyy-MM-dd HH"
#define KKDateFormatter04 @"yyyy-MM-dd"
#define KKDateFormatter05 @"yyyy-MM"
#define KKDateFormatter06 @"MM-dd"
#define KKDateFormatter07 @"HH:mm"

@interface NSDate (KKNSDateExtension)

/*日前*/
- (NSUInteger)day;

/*星期几*/
- (NSUInteger)weekday;

/*月份*/
- (NSUInteger)month;

/*年份*/
- (NSUInteger)year;

/*获取当前月有多少天*/
- (NSUInteger)numberOfDaysInMonth;

/*获取当前月有多少周*/
- (NSUInteger)weeksOfMonth;

/*获取前一天（昨天）*/
- (NSDate *)previousDate;

/*获取下一天（明天）*/
- (NSDate *)nextDate;

/*获取当前周的第一天*/
- (NSDate *)firstDayOfWeek;

/*获取当前周的最后一天*/
- (NSDate *)lastDayOfWeek;

/*获取下周的第一天*/
- (NSDate *)firstDayOfNextWeek;

/*获取下周的最后一天*/
- (NSDate *)lastDayOfNextWeek;

/*获取当前月的第一天*/
- (NSDate *)firstDayOfMonth;

/*获取当前月的最后一天*/
- (NSDate *)lastDayOfMonth;

/*获取当前月的第一天是星期几*/
- (NSUInteger)weekdayOfFirstDayInMonth;

/*获取上月的第一天*/
- (NSDate *)firstDayOfPreviousMonth;

/*获取下月的第一天*/
- (NSDate *)firstDayOfNextMonth;

/*获取当前季度的第一天*/
- (NSDate *)firstDayOfQuarter;

/*获取当前季度的最后一天*/
- (NSDate *)lastDayOfQuarter;

#pragma mark == NSDate 字符串方法

//根据格式获取当前时间
+ (NSString*)getStringWithFormatter:(NSString*)formatterString;

/**
 oldDateString：旧日期字符串
 oldFormatterString： oldDateString的格式
 newFormatterString： 要返回的日期字符串的格式
 */
+ (NSString*)getStringFromOldDateString:(NSString*)oldDateString
                       withOldFormatter:(NSString*)oldFormatterString
                           newFormatter:(NSString*)newFormatterString;

/**
 date：日期
 formatterString： 要返回的日期字符串的格式
 */
+ (NSString*)getStringFromDate:(NSDate*)date dateFormatter:(NSString*)formatterString;

/**
 string：日期字符串
 formatterString： string的格式
 */
+ (NSDate*)getDateFromString:(NSString*)string dateFormatter:(NSString*)formatterString;

/**
 oldDateString：旧时间字符串
 oldFormatterString： oldDateString的格式
 defaultFormatterString： 要返回的日期字符串的格式
 返回 @"刚刚";@"%d秒前";@"%d分钟前";@"%d小时前";或者根据defaultFormatterString返回的字符串
 */
+ (NSString*)timeAwayFromNowWithOldDateString:(NSString*)oldDateString oldFormatterString:(NSString*)oldFormatterString defaultFormatterString:(NSString*)defaultFormatterString;

/**
 oldDate：旧时间
 defaultFormatterString： 要返回的日期字符串的格式
 返回 @"刚刚";@"%d秒前";@"%d分钟前";@"%d小时前";或者根据defaultFormatterString返回的字符串
 */
+ (NSString*)timeAwayFromNowWithOldDate:(NSDate*)oldDate defaultFormatterString:(NSString*)defaultFormatterString;

/**
 date1String01：时间字符串1
 date1String02：时间字符串2
 formatter01： date1String01的格式
 formatter02： date1String02的格式
 */
+ (BOOL)isString:(NSString*)date1String01 earlierThanString:(NSString*)date1String02 formatter01:(NSString*)formatter01 formatter02:(NSString*)formatter02;

/**
 date1String01：时间字符串1
 date02：时间2
 formatter02： date1String02的格式
 */
+ (BOOL)isString:(NSString*)date1String01 earlierThanDate:(NSDate*)date02 formatter01:(NSString*)formatter01;

/**
 date01：时间1
 date1String02：时间字符串2
 formatter02： date1String02的格式
 */
+ (BOOL)isDate:(NSDate*)date01 earlierThanString:(NSString*)dateString02 formatter02:(NSString*)formatter02;

/**
 date01：时间1
 date01：时间2
 */
+ (BOOL)isDate:(NSDate*)date01 earlierThanDate:(NSDate*)date02;

/**
 判断时间是否超过N天了
 date01：需要判断的日期
 days：超过N天了
 */
+ (BOOL)isDate:(NSDate*)date01 beforeNDays:(NSUInteger)days;

/**
 判断时间是否超过N天了
 date01：需要判断的日期
 formatterString：date01的格式
 days：超过N天了
 */
+ (BOOL)isDateString:(NSString*)dateString formatter:(NSString*)formatterString afterNDay:(NSUInteger)days;

@end


#pragma mark ==================================================
#pragma mark ==NSDateFormatter
#pragma mark ==================================================

@interface NSDateFormatter (KKNSDateFormatterExtension)

/**
 返回：星期几
 */
- (NSString *)weekday:(NSDate *)date;

/**
 返回：几日
 */
- (NSString *)day:(NSDate *)date;

/**
 返回：几月
 */
- (NSString *)month:(NSDate *)date;

/**
 返回：多少年
 */
- (NSString *)year:(NSDate *)date;


@end

#pragma mark ==================================================
#pragma mark ==NSDictionary
#pragma mark ==================================================

@interface NSDictionary (KKNSDictionaryExtension)

+ (BOOL)isDictionaryNotEmpty:(id)dictionary;

+ (BOOL)isDictionaryEmpty:(id)dictionary;

/**
 从字典里获取BOOL值
 */
- (BOOL)boolValueForKey:(id)key;

/**
 从字典里获取int值
 */
- (int)intValueForKey:(id)key;

/**
 从字典里获取NSInteger值
 */
- (NSInteger)integerValueForKey:(id)key;

/**
 从字典里获取float值
 */
- (float)floatValueForKey:(id)key;

/**
 从字典里获取double值
 */
- (double)doubleValueForKey:(id)key;

/**
 从字典里获取有价值的String对象,可能返回nil
 */
- (NSString *)stringValueForKey:(id)key;

/**
 从字典里获取有价值的String对象,不可能返回nil
 */
- (NSString*)valuebleStringForKey:(id)aKey;

/**
 从字典里获取有价值的对象
 如果自己是nil或者key是nil,则返回值为nil，否则都会有返回值（至少都是@“”）,
 */
- (id)valuableObjectForKey:(id)aKey;

/**
 @brief 转换成json字符串
 discussion
 */
- (NSString*)translateToJSONString;

/**
 @brief json字符串转换成对象
 discussion
 */
+ (NSDictionary*)dictionaryFromJSONData:(NSData*)aJsonData;

/**
 @brief json字符串转换成对象
 discussion
 */
+ (NSDictionary*)dictionaryFromJSONString:(NSString*)aJsonString;

@end

#pragma mark ==================================================
#pragma mark ==UIFont
#pragma mark ==================================================
@interface UIFont (KKUIFontExtension)

+ (CGSize)sizeOfFont:(UIFont*)aFont;

@end

#pragma mark ==================================================
#pragma mark ==NSString
#pragma mark ==================================================
//#import <CommonCrypto/CommonDigest.h>
/* bear */
#define URL_EXPRESSION @"[hH][tT][tT][pP][sS]?://[a-zA-Z0-9+\\-*/`!@#$%^&()_~,.?<>:;\"\'\\[\\]\\{\\}_=|€£¥•‰]*"

/* 杨峰 */
//#define URL_EXPRESSION @"((https?|ftp|gopher|telnet|file|notes|ms-help):((//)|(\\\\))+[\\w\\d:#@%/;$()~_?\\+-=\\\\.&]*"

/* 新浪 */
//#define URL_EXPRESSION @"([hH][tT][tT][pP][sS]?:\\/\\/[^ ,'\">\\]\\)]*[^\\. ,'\">\\]\\)])"

@interface NSString (KKNSStringExtension)

+ (BOOL)isStringNotEmpty:(id)string;

+ (BOOL)isStringEmpty:(id)string;

- (BOOL)isString;

/*字符串的真实长度（汉字2 英文1）*/
- (int)realLenth;

/*md5 加密*/
- (NSString *)md5;

/*sha1 加密*/
- (NSString *)sha1;

/*base64 加密*/
- (NSString *)base64Encoded;

/*base64 加密*/
- (NSString *)base64Decoded;

/*URLEncoded*/
- (NSString *)URLEncodedString;

/*URLDecoded*/
- (NSString*)URLDecodedString;

- (BOOL)isURL;

/*POST的参数值进行编码*/
- (NSString *)postValueEncodedString;

///*判断是否为空或者nil*/
//- (BOOL)isNotEmpty;

//去掉字符串中的所有空白（Tab、Space、换行......）
- (NSString *)trimWhitespace;

//去掉字符串首尾的空格
-(NSString*)trimLeftAndRightSpace;

/*去除空格*/
-(NSString*)trimAllSpace;

//去掉数字
- (NSString*)trimNumber;

/*去除html标签*/
- (NSString *)trimHTMLTag;

- (BOOL)isEmail;

//- (BOOL)isURL;
//
//- (BOOL)isIP;

- (BOOL)isMobilePhoneNumber;

- (BOOL)isTelePhoneNumber;

- (BOOL)isZipCode;

//- (BOOL)isHTMLTag;

- (CGSize)sizeWithFont:(UIFont *)font maxWidth:(CGFloat)width lineBreakMode:(NSLineBreakMode)lineBreakMode;

- (CGSize)sizeWithFont:(UIFont *)font maxWidth:(CGFloat)width;

- (CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)size;

- (CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)size lineBreakMode:(NSLineBreakMode)lineBreakMode;

- (CGSize)sizeWithFont:(UIFont *)font maxWidth:(CGFloat)width inset:(UIEdgeInsets)inset;

- (CGSize)sizeWithFont:(UIFont *)font maxWidth:(CGFloat)width inset:(UIEdgeInsets)inset lineBreakMode:(NSLineBreakMode)lineBreakMode;

- (CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)size inset:(UIEdgeInsets)inset lineBreakMode:(NSLineBreakMode)lineBreakMode;


- (CGFloat)heightWithFont:(UIFont *)font;

+ (NSString*)stringWithData:(NSData *)data;

/*是否是整数*/
- (BOOL)isInteger;

/*是否是整数*/
- (BOOL)isValuableInteger;

/*是否是浮点数*/
- (BOOL)isFloat;


//计算字符串所占用的字节数大小 编码方式：NSUTF8StringEncoding （一个汉字占3字节，一个英文占1字节）
+ (NSInteger)sizeOfStringForNSUTF8StringEncoding:(NSString*)aString;

//截取字符串到制定字节大小    编码方式：NSUTF8StringEncoding 
+ (NSString*)subStringForNSUTF8StringEncodingWithSize:(NSInteger)size string:(NSString*)string;

//计算字符串所占用的字节数大小 编码方式：NSUnicodeStringEncoding （一个汉字占2字节，一个英文占1字节）
+ (NSInteger)sizeOfStringForNSUnicodeStringEncoding:(NSString*)aString;

//截取字符串到制定字节大小    编码方式：NSUnicodeStringEncoding
+ (NSString*)subStringForNSUnicodeStringEncodingWithSize:(NSInteger)size string:(NSString*)string;

+ (NSString*)stringWithInteger:(NSInteger)intValue;

+ (NSString*)stringWithFloat:(CGFloat)floatValue;

+ (NSString*)stringWithDouble:(double)doubleValue;

@end

#pragma mark ==================================================
#pragma mark ==UIColor
#pragma mark ==================================================
@interface UIColor (KKUIColorExtension)

+ (NSString *)hexStringFromColor:(UIColor *)color;

+ (UIColor *)colorWithHexString: (NSString *) hexString;

+ (CGFloat)colorComponentFrom: (NSString *) string start: (NSUInteger) start length: (NSUInteger) length;

+ (UIColor *)hexColorToUIColor:(NSString*)hexColor;

+ (NSArray *)RGBAValue:(UIColor*)color;

@end

#pragma mark ==================================================
#pragma mark ==UIImage
#pragma mark ==================================================
@interface UIImage (KKUIImageExtension)
#define UIImageExtensionType_PNG  @"png"
#define UIImageExtensionType_BMP  @"bmp"
#define UIImageExtensionType_JPG  @"jpeg"
#define UIImageExtensionType_GIF  @"gif"
#define UIImageExtensionType_TIFF @"tiff"

/*返回：
@"image/jpeg";
@"image/bmp";
@"image/png";
@"image/gif";
@"image/tiff";
*/
+ (NSString *) contentTypeForImageData:(NSData *)data;

/*返回：
 @"png"
 @"bmp"
 @"jpeg"
 @"gif"
 @"tiff"
 */
+ (NSString *) contentTypeExtensionForImageData:(NSData *)data;

/*垂直翻转*/
- (UIImage *)flipVertical;

/*水平翻转*/
- (UIImage *)flipHorizontal;

/*改变size*/
- (UIImage *)resizeTo:(CGSize)size;

- (UIImage *)resizeToWidth:(CGFloat)width height:(CGFloat)height;

/*等比例缩小图片至该宽度*/
- (UIImage *)scaleWithWidth:(CGFloat)width;

/*等比例缩小图片至该高度*/
- (UIImage *)scaleWithHeight:(CGFloat)heigh;

/*裁切*/
- (UIImage *)cropImageWithX:(CGFloat)x y:(CGFloat)y width:(CGFloat)width height:(CGFloat)height;

/*修正拍照图片方向*/
- (UIImage *)fixOrientation;

- (UIImage*)convertImageToScale:(double)scale;

- (UIImage *)imageAtRect:(CGRect)rect;
- (UIImage *)imageByScalingProportionallyToMinimumSize:(CGSize)targetSize;
- (UIImage *)imageByScalingProportionallyToSize:(CGSize)targetSize;
- (UIImage *)imageByScalingToSize:(CGSize)targetSize;
- (UIImage *)imageRotatedByRadians:(CGFloat)radians;
- (UIImage *)imageRotatedByDegrees:(CGFloat)degrees;

- (UIImage *)decoded;

- (UIImage *)addMark:(NSString *)mark textColor:(UIColor *)textColor font:(UIFont *)font point:(CGPoint)point;

- (UIImage *)addCreateTime;

@end

#pragma mark ==================================================
#pragma mark ==UIImageView
#pragma mark ==================================================
@interface UIImageView (Extension)

//可以自动识别图片类型 并支持显示Gif动态图片
- (void)showImageData:(NSData*)imageData;

//可以自动识别图片类型 并支持显示Gif动态图片
- (void)showImageData:(NSData*)imageData inFrame:(CGRect)rect;

@end

#pragma mark ==================================================
#pragma mark ==UIScrollView
#pragma mark ==================================================
//@interface UIScrollView (KKUIScrollViewExtension)
//
////scrollview追加touchesBegan点击事件
//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
//- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event;
//- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;
//
//
//@end

#pragma mark ==================================================
#pragma mark ==UITableView
#pragma mark ==================================================
typedef NS_ENUM(NSInteger, TableViewCellPositionType){
    TableViewCellPositionType_Single=0,//第0行(共1行)
    TableViewCellPositionType_Min=1,//第0行(共非1行)
    TableViewCellPositionType_Middle=2,//中间行(共非1行)
    TableViewCellPositionType_Max=3,//最后行(共非1行)
};

@interface UITableView (Extesion)

- (void)setBackgroundImage:(UIImage *)image;

- (void)setBackgroundColor:(UIColor *)color;

- (void)setSeparatorImage:(UIImage *)image;

- (TableViewCellPositionType)tableViewCellPositionTypeForIndexPath:(NSIndexPath*)indexPath;

@end

#pragma mark ==================================================
#pragma mark ==UITableViewCell
#pragma mark ==================================================
@interface UITableViewCell (Extesion)

- (void)setBackgroundViewColor:(UIColor *)color;

- (void)setBackgroundViewImage:(UIImage *)image;

- (void)setSelectedBackgroundViewColor:(UIColor *)color;

- (void)setSelectedBackgroundViewImage:(UIImage *)image;

@end


#pragma mark ==================================================
#pragma mark ==UITextField
#pragma mark ==================================================
@interface UITextField (KKUITextFieldExtension)

- (void)setPlaceholderColor:(UIColor *)color;

- (void)setBackgroundImage:(UIImage *)image;

- (void)setBackgroundImage:(UIImage *)image stretchWithX:(NSInteger)x stretchWithY:(NSInteger)y;

- (void)setDisabledBackgroundImage:(UIImage *)image stretchWithX:(NSInteger)x stretchWithY:(NSInteger)y;

- (void)setLeftLabelTitle:(NSString *)text textColor:(UIColor *)textColor width:(CGFloat)width;

- (void)setLeftLabelTitle:(NSString *)text
                textColor:(UIColor *)textColor
                 textFont:(UIFont *)font
                    width:(CGFloat)width
          backgroundColor:(UIColor *)backgroundColor;

- (void)setMaxTextLenth:(int)length;

@end

//#pragma mark ==================================================
//#pragma mark ==UITextView
//#pragma mark ==================================================
//@interface UITextView (KKUIUITextViewExtension)
//
//- (void)setMaxTextLenth:(int)length;
//
//@end

#pragma mark ==================================================
#pragma mark ==UIView
#pragma mark ==================================================
#define ApplicationFrame  [[UIScreen mainScreen] applicationFrame]
#define ApplicationSize   [[UIScreen mainScreen] applicationFrame].size
#define ApplicationWidth  [[UIScreen mainScreen] applicationFrame].size.width
#define ApplicationHeight [[UIScreen mainScreen] applicationFrame].size.height

#define ViewWidth(view)  view.bounds.size.width
#define ViewHeight(view) view.bounds.size.height
#define ViewCenter(view) CGPointMake(view.bounds.size.width/2.0, view.bounds.size.height/2.0)

@interface UIView (KKUIViewExtension)

@property (nonatomic,retain) id tagInfo;

/*快照*/
- (UIImage *)snapshot;

/*清除背景颜色*/
- (void)clearBackgroundColor;

/*设置背景图片*/
- (void)setBackgroundImage:(UIImage *)image;

/*设置View层顺序*/
- (void)setIndex:(NSInteger)index;

/*设置为最顶层View*/
- (void)bringToFront;

/*设置为最底层View*/
- (void)sendToBack;

/*设置边框颜色 和 边框宽度*/
- (void)setBorderColor:(UIColor *)color width:(CGFloat)width;

/*设置圆角*/
- (void)setCornerRadius:(CGFloat)radius;

/*设置外阴影*/
- (void)setShadowColor:(UIColor *)color opacity:(CGFloat)opacity offset:(CGSize)offset blurRadius:(CGFloat)blurRadius;

- (UIActivityIndicatorView *)activityIndicatorView;

- (UIViewController *)viewController;

typedef enum{
    UIViewGradientColorDirection_TopBottom = 1,//从上到下
    UIViewGradientColorDirection_BottomTop = 2,//从下到上
    UIViewGradientColorDirection_LeftRight = 3,//从左到右
    UIViewGradientColorDirection_RightLeft = 4,//从右到左
}UIViewGradientColorDirection;

//设置渐变色的View
- (void)setBackgroundColorFromColor:(UIColor*)startUIColor toColor:(UIColor*)endUIColor direction:(UIViewGradientColorDirection)direction;

//截图当前view成图片
-(UIImage *)getImageFromSelf;


//=================设置遮罩相关=================
@property (nonatomic,retain)UIBezierPath *bezierPath;
- (void)setMaskWithPath:(UIBezierPath*)path;
- (void)setMaskWithPath:(UIBezierPath*)path withBorderColor:(UIColor*)borderColor borderWidth:(float)borderWidth;
- (BOOL)containsPoint:(CGPoint)point;
//=================设置遮罩相关=================

@end

#pragma mark ==================================================
#pragma mark ==UIBezierPath
#pragma mark ==================================================
@interface UIBezierPath (UIBezierPathExtension)

+ (UIBezierPath *)chatBoxRightShape:(CGRect)originalFrame;

+ (UIBezierPath *)chatBoxLeftShape:(CGRect)originalFrame;

@end


#pragma mark ==================================================
#pragma mark ==UIWebView
#pragma mark ==================================================
@interface UIWebView (KKUIWebViewExtension)

- (UIScrollView *)scrollViewForWebView;

- (void)cleanHeaderFooterBackgroundView;

- (void) cleanForDealloc;

/** 检索并高亮查询的关键字
 param 查询关键字
 @return 查询到的关键字个数
 */
- (NSInteger)highlightAllOccurencesOfString:(NSString *)query;

/** 定位到下一个关键字并高亮 */
- (void)nextSearchResult;

/** 定位到上一个关键字并高亮 */
- (void)previousSearchResult;

/** 返回搜索的总记录数
 @return 总记录数
 */
- (int)numSearchResults;

/** 返回当前搜索结果的索引
 @return 索引
 */
- (int)currentSearchResultIndex;


/** 移除所有的高亮，并回到初始状态 */
- (void)removeAllHighlights;


@end

#pragma mark ==================================================
#pragma mark ==NSBundle
#pragma mark ==================================================
@interface NSBundle (KKNSBundleExtension)

/*Bundle相关*/
+ (NSString *)bundleIdentifier;
+ (NSString *)bundleBuildVersion;
+ (NSString *)bundleVersion;
+ (float)bundleMiniumOSVersion;
+ (NSString *)bundlePath;

/*编译信息相关*/
+ (int)buildXcodeVersion;

/*是否开启了推送通知*/
+ (BOOL)isOpenPushNotification;


/*路径相关*/
+ (NSString *)homeDirectory;
+ (NSString *)documentDirectory;
+ (NSString *)libaryDirectory;
+ (NSString *)tmpDirectory;
+ (NSString *)temporaryDirectory;
+ (NSString *)cachesDirectory;

typedef void(^CheckAppVersionCompletedBlock)(BOOL haveNewVersion,NSString *newVersion, NSString *appID,NSString *newVersionDescription,NSString *releaseNotes);
/*检查新版本*/
+ (void)checkAppVersionWithAppid:(NSString *)appid needShowNewVersionMessage:(BOOL)needShow completed:(CheckAppVersionCompletedBlock)completedBlock;


@end



#pragma mark ==================================================
#pragma mark ==NSNumber
#pragma mark ==================================================
@interface NSNumber (KKNSNumberExtension)

//产生>= from 小于to 的随机数
+(NSInteger)randomIntegerBetween:(int)from and:(int)to;

/*是否是整数*/
- (BOOL)isInt;

/*是否是整数*/
- (BOOL)isInteger;

/*是否是浮点数*/
- (BOOL)isFloat;

/*是否是高精度浮点数*/
- (BOOL)isDouble;

@end

#pragma mark ==================================================
#pragma mark ==KKUISearchBarExtension
#pragma mark ==================================================
@interface UISearchBar (KKUISearchBarExtension)

/**
 清除背景
 */
-(void)clearBackground;

@end

#pragma mark ==================================================
#pragma mark ==KKNSNullExtension
#pragma mark ==================================================
@interface NSNull (KKNSNullExtension)

- (BOOL)isEqualToString:(NSString*)string;

@end

#pragma mark ==================================================
#pragma mark ==KKUIScrollViewExtension
#pragma mark ==================================================
@interface UIScrollView (KKUIScrollViewExtension)

- (void)scrollToTopWithAnimated:(BOOL)animated;

- (void)scrollToBottomWithAnimated:(BOOL)animated;

@end

#pragma mark ==================================================
#pragma mark ==KKUIButtonExtension
#pragma mark ==================================================
typedef NS_ENUM(NSInteger, ButtonContentAlignment) {
    ButtonContentAlignmentLeft = 1,
    ButtonContentAlignmentCenter = 2,
    ButtonContentAlignmentRight = 3,
} ;

typedef NS_ENUM(NSInteger, ButtonContentLayoutModal) {
    ButtonContentLayoutModalVertical = 1,//垂直对齐
    ButtonContentLayoutModalHorizontal = 2,//水平对齐
} ;

typedef NS_ENUM(NSInteger, ButtonContentTitlePosition) {
    ButtonContentTitlePositionBefore = 1,//标题在图片的左边或者上边
    ButtonContentTitlePositionAfter = 2,//标题在图片的右边或者下边
} ;

@interface UIButton (Extension)

- (void)setBackgroundColor:(UIColor *)backgroundColor forState:(UIControlState)controlState;

- (void)setBackgroundImage:(UIImage *)image forState:(UIControlState)state contentMode:(UIViewContentMode)contentMode;

/**
 设置UIButton的图片和标题的对其方式
 contentAlignment //整体左、中、右对齐
 contentLayoutModal //图片与标题的布局方式，上下布局、左右并排布局
 contentTitlePosition //标题是否在图片的前面
 aSpace 图片与标题之间是否留间隙，间隙大小
 aEdgeInsets 整体靠左、靠右对其的时候，是否要紧靠边缘。当aEdgeInsets的left、right为0的时候就是紧靠边缘
*/
- (void)setButtonContentAlignment:(ButtonContentAlignment)contentAlignment
         ButtonContentLayoutModal:(ButtonContentLayoutModal)contentLayoutModal
       ButtonContentTitlePosition:(ButtonContentTitlePosition)contentTitlePosition
        SapceBetweenImageAndTitle:(CGFloat)aSpace
                       EdgeInsets:(UIEdgeInsets)aEdgeInsets;

@end



@interface NSObject (NSObjectFileTypeExtention)

+ (BOOL)isFileType_DOC:(NSString*)fileExtention;

+ (BOOL)isFileType_PPT:(NSString*)fileExtention;

+ (BOOL)isFileType_XLS:(NSString*)fileExtention;

+ (BOOL)isFileType_IMG:(NSString*)fileExtention;

+ (BOOL)isFileType_VIDEO:(NSString*)fileExtention;

+ (BOOL)isFileType_AUDIO:(NSString*)fileExtention;

+ (BOOL)isFileType_PDF:(NSString*)fileExtention;

+ (BOOL)isFileType_TXT:(NSString*)fileExtention;

+ (BOOL)isFileType_ZIP:(NSString*)fileExtention;

+ (void)showHTTPRequestMessage:(NSDictionary*)aHttpInformation;

+ (void)showNoticeMessage:(NSString*)aMessage;

//字符串加密
+ (NSString*)AESCrypt_String:(NSString*)string;

//时间格式化
+ (NSString*)dateTimestampFormat:(NSString*)oldDateTimestamp;

/**
 * 字节大小转换成显示字符串
 */
+ (NSString*)dataSizeFormat:(CGFloat)dataSize;

@end










