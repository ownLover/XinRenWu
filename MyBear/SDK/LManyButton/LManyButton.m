//
//  LManyButton.m
//  EducationCenter
//
//  Created by Bear on 15/8/27.
//  Copyright (c) 2015年 Bear. All rights reserved.
//

#import "LManyButton.h"

@implementation LManyButton{
    NSInteger btnNumber;
}
@synthesize titleArr;
@synthesize nomalColor;
@synthesize selectedColor;
@synthesize underLine;
@synthesize btnArr;
@synthesize delegate;
@synthesize labLineVerticalArr;
@synthesize selectedBackgroundColor;
@synthesize normalBackgroundColor;

- (void)dealloc
{
    [labLineVerticalArr release];
    [btnArr release];
    [underLine release];
    [normalBackgroundColor release];
    [selectedBackgroundColor release];
    [nomalColor release];
    [selectedColor release];
    [titleArr release];
    [super dealloc];
}

- (instancetype)initWithFrame:(CGRect)frame nomalColor:(UIColor *)nomalC selectedColor:(UIColor *)selectedC titleArr:(NSArray *)titleA SelectedBackgroundColor:(UIColor *)aSelectedBackgroundColor normalBackgroundColor:(UIColor *)aNormalBackgroundColor{
    self = [super initWithFrame:frame];
    if (self) {
        labLineVerticalArr = [[NSMutableArray alloc]init];
        titleArr =[[NSMutableArray alloc]initWithArray:titleA];
        selectedColor=[selectedC copy];
        normalBackgroundColor=[aNormalBackgroundColor copy];
        selectedBackgroundColor=[aSelectedBackgroundColor copy];
        nomalColor=[nomalC copy];
        btnNumber=[titleArr count];
        btnArr =[[NSMutableArray alloc]init];
        [self initUI];
    }
    return self;

}

#pragma mark - 带图片
- (instancetype)initWithFrame:(CGRect)frame nomalColor:(UIColor *)nomalC selectedColor:(UIColor *)selectedC titleArr:(NSArray *)titleA imageArr:(NSArray *)imageArr{
    self = [super initWithFrame:frame];
    if (self) {
        labLineVerticalArr = [[NSMutableArray alloc]init];
        titleArr =[[NSMutableArray alloc]initWithArray:titleA];
        selectedColor=[selectedC copy];
        nomalColor=[nomalC copy];
        btnNumber=[titleArr count];
        btnArr =[[NSMutableArray alloc]init];
        [self initUIImage:imageArr];
    }
    return self;

}

- (instancetype)initWithFrame:(CGRect)frame nomalColor:(UIColor *)nomalC selectedColor:(UIColor *)selectedC titleArr:(NSArray *)titleA
{
    self = [super initWithFrame:frame];
    if (self) {
        labLineVerticalArr = [[NSMutableArray alloc]init];
        titleArr =[[NSMutableArray alloc]initWithArray:titleA];
        selectedColor=[selectedC copy];
        nomalColor=[nomalC copy]; 
        btnNumber=[titleArr count];
        btnArr =[[NSMutableArray alloc]init];
        [self initUI];
    }
    return self;
}


//有图的按钮
-(void)initUIImage:(NSArray *)imageArr{
//    self.backgroundColor=myBackgroundColor;
    for (int i=0; i<btnNumber; i++) {
        UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame=CGRectMake(self.frame.size.width/btnNumber*i+15, 5, self.frame.size.width/btnNumber-30, self.frame.size.height-10);
        [btn setTitle:[titleArr objectAtIndex:i]  forState:UIControlStateNormal];
//        [btn setBackgroundColor:myTextStatuGreenColor forState:UIControlStateNormal];
//        [btn setBackgroundColor:myTextStatuGreenColor forState:UIControlStateSelected];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [btn setCornerRadius:3];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [btn addTarget:self action:@selector(repeatBtnClick:forEvent:) forControlEvents:UIControlEventTouchDownRepeat];
        btn.titleLabel.font=[UIFont systemFontOfSize:15];
//        [btn setImage:KKThemeImage([imageArr objectAtIndex:i]) forState:UIControlStateNormal];
        [btn setButtonContentAlignment:ButtonContentAlignmentCenter ButtonContentLayoutModal:ButtonContentLayoutModalHorizontal ButtonContentTitlePosition:ButtonContentTitlePositionAfter SapceBetweenImageAndTitle:5 EdgeInsets:UIEdgeInsetsZero];
        btn.tag=1993+i;
        if (i==0) {
            btn.selected=YES;
        }
        [self addSubview:btn];
        [btnArr addObject:btn];
        
        if (i!=0) {
//             CGRectGetMinX(btn.frame)-15
            UILabel *labLineVertical=[[UILabel alloc]initWithFrame:CGRectMake(self.frame.size.width/btnNumber*i, self.frame.size.height/3, 1, self.frame.size.height/3)];
            labLineVertical.backgroundColor=[UIColor colorWithRed:0.86 green:0.87 blue:0.87 alpha:1];
            [self addSubview:labLineVertical];
            [labLineVertical release];
            [labLineVerticalArr addObject:labLineVertical];
        }
        
    }
    
    UILabel *labLineUp=[[UILabel alloc]initWithFrame:CGRectMake(0, 0,self.frame.size.width, 1)];
    labLineUp.backgroundColor=[UIColor colorWithRed:0.9 green:0.9 blue:0.91 alpha:1];
    labLineUp.tag=998;
    [self addSubview:labLineUp];
    [labLineUp release];
    
    UILabel *labLine=[[UILabel alloc]initWithFrame:CGRectMake(0, self.frame.size.height-1,self.frame.size.width, 1)];
    labLine.backgroundColor=[UIColor colorWithRed:0.9 green:0.9 blue:0.91 alpha:1];
    labLine.tag=999;
    [self addSubview:labLine];
    [labLine release];
    
    underLine=[[UILabel alloc]initWithFrame:CGRectMake(0, self.frame.size.height-0.5, self.frame.size.width/btnNumber, 0.5)];
    underLine.backgroundColor=selectedColor;
    [self addSubview:underLine];
}

-(void)initUI{
    for (int i=0; i<btnNumber; i++) {
        UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame=CGRectMake(self.frame.size.width/btnNumber*i, 0, self.frame.size.width/btnNumber, self.frame.size.height);
        [btn setTitle:[titleArr objectAtIndex:i]  forState:UIControlStateNormal];
        [btn setBackgroundColor:normalBackgroundColor forState:UIControlStateNormal];
        [btn setBackgroundColor:selectedBackgroundColor forState:UIControlStateSelected];
        [btn setTitleColor:nomalColor forState:UIControlStateNormal];
        [btn setTitleColor:selectedColor forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [btn addTarget:self action:@selector(repeatBtnClick:forEvent:) forControlEvents:UIControlEventTouchDownRepeat];
        btn.titleLabel.font=[UIFont systemFontOfSize:15];
        btn.tag=1993+i;
        if (i==0) {
            btn.selected=YES;
        }
        [self addSubview:btn];
        [btnArr addObject:btn];
        
        if (i!=0) {
            UILabel *labLineVertical=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(btn.frame), self.frame.size.height/3, 1, self.frame.size.height/3)];
            labLineVertical.backgroundColor=[UIColor colorWithRed:0.86 green:0.87 blue:0.87 alpha:1];
            [self addSubview:labLineVertical];
            [labLineVertical release];
            [labLineVerticalArr addObject:labLineVertical];
        }
        
    }
    
    UILabel *labLineUp=[[UILabel alloc]initWithFrame:CGRectMake(0, 0,self.frame.size.width, 1)];
    labLineUp.backgroundColor=[UIColor colorWithRed:0.9 green:0.9 blue:0.91 alpha:1];
    labLineUp.tag=998;
    [self addSubview:labLineUp];
    [labLineUp release];
    
    UILabel *labLine=[[UILabel alloc]initWithFrame:CGRectMake(0, self.frame.size.height-1,self.frame.size.width, 1)];
    labLine.backgroundColor=[UIColor colorWithRed:0.9 green:0.9 blue:0.91 alpha:1];
    labLine.tag=999;
    [self addSubview:labLine];
    [labLine release];
    
    underLine=[[UILabel alloc]initWithFrame:CGRectMake(0, self.frame.size.height-0.5, self.frame.size.width/btnNumber, 0.5)];
    underLine.backgroundColor=selectedColor;
    [self addSubview:underLine];
}

- (void)changeLabLineVertical{
    for (UILabel *verLin in labLineVerticalArr) {
        verLin.bounds=CGRectMake(0, 0, 1, self.frame.size.height);
    }
    [self viewWithTag:999].hidden=YES;
    [self viewWithTag:998].hidden=YES;
}

- (void)repeatBtnClick:(UIButton *)button forEvent:(UIEvent *)event{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(btnClick:) object:button];
    if (delegate && [delegate respondsToSelector:@selector(LmanyButtonRepeatClick:)]) {
        [delegate LmanyButtonRepeatClick:button.tag-1993];        
    }
}

- (void)defaultClick:(NSInteger)aIndex{
    for (UIButton *btn in btnArr) {
        btn.selected=NO;
    }
    UIButton *button=[btnArr objectAtIndex:aIndex];
    button.selected=YES;
}

-(void)btnClick:(UIButton *)button{
    for (UIButton *btn in btnArr) {
        btn.selected=NO;
    }
    button.selected=YES;
    [UIView beginAnimations:nil context:nil];
    underLine.frame=CGRectMake(CGRectGetMinX(button.frame), self.frame.size.height-0.5, self.frame.size.width/btnNumber, 0.5);
    [UIView setAnimationDuration:0.5];
    [UIView commitAnimations];
    
    if (delegate && [delegate respondsToSelector:@selector(LManyButtonClick:)]) {
        [delegate LManyButtonClick:button.tag-1993];
    }    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
