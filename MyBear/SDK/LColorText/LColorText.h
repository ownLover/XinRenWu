//
//  LColorText.h
//  EducationCenter
//
//  Created by Bear on 15/9/7.
//  Copyright (c) 2015年 Bear. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LColorText : NSObject
+(NSAttributedString *)TranslateForeText:(NSString *)foreText withColor:(UIColor *)foreColor withFont:(UIFont *)foreFont LastText:(NSString *)lastText withColor:(UIColor *)lastColor withFont:(UIFont *)lastFont;
@end
