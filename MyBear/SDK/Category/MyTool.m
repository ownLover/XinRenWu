//
//  MyTool.m
//  ONOChina
//
//  Created by Bear on 15/12/22.
//  Copyright (c) 2015年 Bear. All rights reserved.
//

#import "MyTool.h"

@implementation MyTool


@end


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
    //2014-10-20 刘波
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
    NSString *html = self;
    
    NSScanner *scanner = [NSScanner scannerWithString:html];
    NSString *text = nil;
    
    while (![scanner isAtEnd]) {
        [scanner scanUpToString:@"<" intoString:NULL];
        [scanner scanUpToString:@">" intoString:&text];
        
        html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>", text]
                                               withString:@""];
    }
    return [html trimWhitespace];
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


