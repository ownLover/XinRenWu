//
//  MyTool.h
//  ONOChina
//
//  Created by Bear on 15/12/22.
//  Copyright (c) 2015年 Bear. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface MyTool : NSObject

@end



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

//typedef enum{
//    UIViewGradientColorDirection_TopBottom = 1,//从上到下
//    UIViewGradientColorDirection_BottomTop = 2,//从下到上
//    UIViewGradientColorDirection_LeftRight = 3,//从左到右
//    UIViewGradientColorDirection_RightLeft = 4,//从右到左
//}UIViewGradientColorDirection;
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
#pragma mark ==NSString
#pragma mark ==================================================
//#import <CommonCrypto/CommonDigest.h>
/* 刘波 */
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
 @param imageArray: UIImage数组
 @param imageDataSize: 需要压缩到的图片数据大小范围值(单位KB)，比如100KB
 @param completedOneBlock: 压缩一条数据完成回调block
 @param completedAllBlock: 压缩所有数据完成回调block
 */
+ (void)convertImage:(NSArray*)imageArray
          toDataSize:(CGFloat)imageDataSize
convertImageOneCompleted:(KKImageConvertImageOneCompletedBlock)completedOneBlock
KKImageConvertImageAllCompletedBlock:(KKImageConvertImageAllCompletedBlock)completedAllBlock;
@end
