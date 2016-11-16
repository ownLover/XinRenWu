//
//  LColorText.m
//  EducationCenter
//
//  Created by Bear on 15/9/7.
//  Copyright (c) 2015年 Bear. All rights reserved.
//

#import "LColorText.h"

@implementation LColorText
+(NSAttributedString *)TranslateForeText:(NSString *)foreText withColor:(UIColor *)foreColor withFont:(UIFont *)foreFont LastText:(NSString *)lastText withColor:(UIColor *)lastColor withFont:(UIFont *)lastFont{
    NSMutableAttributedString *string=[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@%@",foreText,lastText]];
    [string setAttributes:@{NSForegroundColorAttributeName:foreColor,NSFontAttributeName:foreFont} range:NSMakeRange(0, foreText.length)];
    [string setAttributes:@{NSForegroundColorAttributeName:lastColor,NSFontAttributeName:lastFont} range:NSMakeRange(foreText.length, lastText.length)];
    
    return [string autorelease];
}
@end
