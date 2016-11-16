//
//  KKAlertView.m
//  CEDongLi
//
//  Created by beartech on 15/11/1.
//  Copyright (c) 2015年 KeKeStudio. All rights reserved.
//

#import "KKAlertView.h"

#define ButtonTitleFont [UIFont boldSystemFontOfSize:16]
#define TextMinHeight 50

@interface KKAlertView ()<UITextViewDelegate>{
    id<KKAlertViewDelegate> _myDelegate;
    Class delegateClass;

}

@property (nonatomic,retain)UIButton *backgroundBlackButton;
@property (nonatomic,retain)UIView *myBackgroundView;
@property (nonatomic,retain)UILabel *myTitleLabel;
@property (nonatomic,retain)UILabel *mySubTitleLabel;
@property (nonatomic,retain)UITextView *myMessageTextView;
@property (nonatomic,retain)NSMutableArray *buttonTitlesArray;

@property (nonatomic,assign)id<KKAlertViewDelegate> myDelegate;


@property (nonatomic,copy)NSString *myTitleString;
@property (nonatomic,copy)NSString *mySubTitleString;
@property (nonatomic,copy)NSString *myMessageString;

@end

@implementation KKAlertView
@synthesize backgroundBlackButton,myBackgroundView,myTitleLabel,mySubTitleLabel,myMessageTextView;
@synthesize buttonTitlesArray;
@synthesize myDelegate = _myDelegate;
@synthesize myTitleString,mySubTitleString,myMessageString;
@synthesize information;

- (void)dealloc{
    [backgroundBlackButton release];
    [myBackgroundView release];
    [myTitleLabel release];
    [mySubTitleLabel release];
    [myMessageTextView release];
    [buttonTitlesArray release];
    
    [myTitleString release];
    [mySubTitleString release];
    [myMessageString release];
    
    [information release];
#ifdef DEBUG
    NSLog(@"========== %@ dealloc",NSStringFromClass([self class]));
#endif
    [super dealloc];
}


- (instancetype)initWithTitle:(NSString *)title subTitle:(NSString*)subTitle message:(NSString *)message delegate:(id /**<>*/)delegate buttonTitles:(NSString *)buttonTitles, ... {
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        self.backgroundColor = [UIColor clearColor];
        
        buttonTitlesArray = [[NSMutableArray alloc] init];
        
        va_list args;
        va_start(args, buttonTitles);
        if (buttonTitles) {
            [buttonTitlesArray addObject:[NSString stringWithFormat:@"%@",buttonTitles]];

            NSString *otherString;
            while ( (otherString = va_arg(args, NSString*)) ) {
                //依次取得各参数
                [buttonTitlesArray addObject:[NSString stringWithFormat:@"%@",otherString]];
            }
        }
        va_end(args);
        
        [self setDelegate:delegate];
        myTitleString = [title copy];
        mySubTitleString = [subTitle copy];
        myMessageString = [message copy];
        
        
        backgroundBlackButton = [[UIButton alloc] initWithFrame:self.bounds];
        backgroundBlackButton.backgroundColor = [UIColor blackColor];
        backgroundBlackButton.exclusiveTouch = YES;
        [backgroundBlackButton addTarget:self action:@selector(backgroundButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:backgroundBlackButton];
        
        myBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(50, 0, self.frame.size.width-100, 1000)];
        myBackgroundView.backgroundColor = [UIColor whiteColor];
        [myBackgroundView setCornerRadius:8.0];
        myBackgroundView.userInteractionEnabled = YES;
        [self addSubview:myBackgroundView];
        
        
        //标题
        myTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 10, 10)];
        [myTitleLabel clearBackgroundColor];
        myTitleLabel.font = [UIFont boldSystemFontOfSize:16];
        myTitleLabel.textColor = [UIColor darkTextColor];
        myTitleLabel.textAlignment = NSTextAlignmentCenter;
        myTitleLabel.numberOfLines = 0;
        myTitleLabel.text = myTitleString;
        [myBackgroundView addSubview:myTitleLabel];
        
        //副标题
        mySubTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 10, 10)];
        [mySubTitleLabel clearBackgroundColor];
        mySubTitleLabel.font = [UIFont systemFontOfSize:13];
        mySubTitleLabel.textColor = [UIColor grayColor];
        mySubTitleLabel.numberOfLines = 0;
        mySubTitleLabel.textAlignment = NSTextAlignmentCenter;
        mySubTitleLabel.text = mySubTitleString;
        [myBackgroundView addSubview:mySubTitleLabel];
        
        
        //文字
        myMessageTextView = [[UITextView alloc] initWithFrame:CGRectMake(10, 10, 10, 10)];
        myMessageTextView.backgroundColor = [UIColor clearColor];
        myMessageTextView.delegate = self;
        myMessageTextView.textColor = [UIColor colorWithRed:0.49f green:0.49f blue:0.49f alpha:1.00f];
        myMessageTextView.font = [UIFont systemFontOfSize:15];
        myMessageTextView.text = myMessageString;
        [myBackgroundView addSubview:myMessageTextView];
        

        [self reload];
    }
    return self;
}

- (void)setDelegate:(id<KKAlertViewDelegate>)aDelegate{
    _myDelegate = aDelegate;
    delegateClass = object_getClass(_myDelegate);
}

- (void)show{
//    UIWindow *window = ((UIWindow*)[[[UIApplication sharedApplication] windows] objectAtIndex:0]);
//    [window resignFirstResponder];
//    [window addSubview:self];
    [self retain];
    self.windowLevel = UIWindowLevelAlert;
    [self makeKeyAndVisible];

    backgroundBlackButton.alpha = 0;
    
    myBackgroundView.transform = CGAffineTransformMakeScale(0.01, 0.01);
    [UIView animateWithDuration:0.25 animations:^{
        myBackgroundView.transform = CGAffineTransformMakeScale(1, 1);
        backgroundBlackButton.alpha = 0.5;
    } completion:^(BOOL finished) {

    }];
}

- (void)hide{
    [UIView animateWithDuration:0.3 animations:^{
        myBackgroundView.transform = CGAffineTransformScale(self.transform, 1.0, 1.0);
        myBackgroundView.transform = CGAffineTransformScale(self.transform, 0.001, 0.001);
        backgroundBlackButton.alpha = 0;
    } completion:^(BOOL finished) {
//        [self removeFromSuperview];
        [self resignKeyWindow];
        [self release];
    }];
}

- (UIButton*)buttonAtIndex:(NSInteger)aIndex{
    UIView *view = [myBackgroundView viewWithTag:1100+aIndex];
    if ([view isKindOfClass:[UIButton class]]) {
        return (UIButton*)view;
    }
    else{
        return nil;
    }
}

- (UILabel*)titleLabel{
    return myTitleLabel;
}

- (UILabel*)subTitleLabel{
    return mySubTitleLabel;
}

- (UITextView*)messageTextView{
    return myMessageTextView;
}

- (void)reload{
    CGFloat Y = 0;
    //添加文字
    Y = [self setAllText];
    //添加按钮
    [self setAllButton:Y];
}

//添加文字
- (CGFloat)setAllText{
    
    myTitleLabel.frame = CGRectZero;
    mySubTitleLabel.frame = CGRectZero;
    myMessageTextView.frame = CGRectZero;
    
    CGFloat Y = 0;
    
    //只有标题
    if ([NSString isStringNotEmpty:myTitleString] &&
        [NSString isStringEmpty:mySubTitleString] &&
        [NSString isStringEmpty:myMessageString]) {
        
        CGSize titleSize = [UIFont sizeOfFont:myTitleLabel.font];

        if (titleSize.height>=TextMinHeight) {
            Y = Y + 15;
            
            myTitleLabel.frame = CGRectMake(10, Y, myBackgroundView.frame.size.width-20, titleSize.height);
            myTitleLabel.text = myTitleString;
            Y = Y + titleSize.height;
            
            Y = Y + 15;
        }
        else{
            myTitleLabel.frame = CGRectMake(10, (80-titleSize.height)/2.0, myBackgroundView.frame.size.width-20, titleSize.height);
            myTitleLabel.text = myTitleString;
            
            Y = Y + 80;
        }
    }
    //只有副标题
    else if([NSString isStringEmpty:myTitleString] &&
            [NSString isStringNotEmpty:mySubTitleString] &&
            [NSString isStringEmpty:myMessageString]){
        
        CGSize subTitleSize = [UIFont sizeOfFont:mySubTitleLabel.font];

        if (subTitleSize.height>=TextMinHeight) {
            Y = Y + 15;
            
            mySubTitleLabel.frame = CGRectMake(10, Y, myBackgroundView.frame.size.width-20, subTitleSize.height);
            mySubTitleLabel.text = mySubTitleString;
            Y = Y + subTitleSize.height;
            
            Y = Y + 15;
        }
        else{
            mySubTitleLabel.frame = CGRectMake(10, (80-subTitleSize.height)/2.0, myBackgroundView.frame.size.width-20, subTitleSize.height);
            mySubTitleLabel.text = mySubTitleString;
            
            Y = Y + 80;
        }

    }
    //只有文字
    else if([NSString isStringEmpty:myTitleString] &&
            [NSString isStringEmpty:mySubTitleString] &&
            [NSString isStringNotEmpty:myMessageString]){
        
        CGSize messageSize = [myMessageTextView sizeThatFits:CGSizeMake(myBackgroundView.frame.size.width-20, MAXFLOAT)];
        
        if (messageSize.height>=TextMinHeight) {
            Y = Y + 15;
            
            myMessageTextView.frame = CGRectMake(10, Y, myBackgroundView.frame.size.width-20, MIN(messageSize.height, 250));
            myMessageTextView.text = myMessageString;
            Y = Y + MIN(messageSize.height, 250);
            
            Y = Y + 15;
        }
        else{
            myMessageTextView.frame = CGRectMake(10,  (80-messageSize.height)/2.0, myBackgroundView.frame.size.width-20, MIN(messageSize.height, 250));
            myMessageTextView.text = myMessageString;
            
            Y = Y + 80;
        }
    }
    //标题+副标题
    else if([NSString isStringNotEmpty:myTitleString] &&
            [NSString isStringNotEmpty:mySubTitleString] &&
            [NSString isStringEmpty:myMessageString]){
        
        Y = Y + 15;
        
        CGSize titleSize = [UIFont sizeOfFont:myTitleLabel.font];
        myTitleLabel.frame = CGRectMake(10, Y, myBackgroundView.frame.size.width-20, titleSize.height);
        myTitleLabel.text = myTitleString;
        Y = Y + titleSize.height;
        
        Y = Y + 10;

        CGSize subTitleSize = [UIFont sizeOfFont:mySubTitleLabel.font];
        mySubTitleLabel.frame = CGRectMake(10, Y, myBackgroundView.frame.size.width-20, subTitleSize.height);
        mySubTitleLabel.text = mySubTitleString;
        Y = Y + subTitleSize.height;
        
        Y = Y + 15;

    }
    //标题+文字
    else if([NSString isStringNotEmpty:myTitleString] &&
            [NSString isStringEmpty:mySubTitleString] &&
            [NSString isStringNotEmpty:myMessageString]){
        
        Y = Y + 15;
        
        CGSize titleSize = [UIFont sizeOfFont:myTitleLabel.font];
        myTitleLabel.frame = CGRectMake(10, Y, myBackgroundView.frame.size.width-20, titleSize.height);
        myTitleLabel.text = myTitleString;
        Y = Y + titleSize.height;
        
        Y = Y + 10;
        
        CGSize messageSize = [myMessageTextView sizeThatFits:CGSizeMake(myBackgroundView.frame.size.width-20, MAXFLOAT)];
        myMessageTextView.frame = CGRectMake(10, Y, myBackgroundView.frame.size.width-20, MIN(messageSize.height, 250));
        myMessageTextView.text = myMessageString;
        Y = Y + MIN(messageSize.height, 250);
        
        Y = Y + 15;

    }
    //副标题+文字
    else if([NSString isStringEmpty:myTitleString] &&
            [NSString isStringNotEmpty:mySubTitleString] &&
            [NSString isStringNotEmpty:myMessageString]){
        
        Y = Y + 15;
        
        CGSize subTitleSize = [UIFont sizeOfFont:mySubTitleLabel.font];
        mySubTitleLabel.frame = CGRectMake(10, Y, myBackgroundView.frame.size.width-20, subTitleSize.height);
        mySubTitleLabel.text = mySubTitleString;
        Y = Y + subTitleSize.height;
        
        Y = Y + 10;
        
        CGSize messageSize = [myMessageTextView sizeThatFits:CGSizeMake(myBackgroundView.frame.size.width-20, MAXFLOAT)];
        myMessageTextView.frame = CGRectMake(10, Y, myBackgroundView.frame.size.width-20, MIN(messageSize.height, 250));
        myMessageTextView.text = myMessageString;
        Y = Y + MIN(messageSize.height, 250);
        
        Y = Y + 15;
    }
    //标题+副标题+文字
    else if([NSString isStringNotEmpty:myTitleString] &&
            [NSString isStringNotEmpty:mySubTitleString] &&
            [NSString isStringNotEmpty:myMessageString]){
        
        Y = Y + 15;
        
        CGSize titleSize = [UIFont sizeOfFont:myTitleLabel.font];
        myTitleLabel.frame = CGRectMake(10, Y, myBackgroundView.frame.size.width-20, titleSize.height);
        myTitleLabel.text = myTitleString;
        Y = Y + titleSize.height;

        Y = Y + 10;

        CGSize subTitleSize = [UIFont sizeOfFont:mySubTitleLabel.font];
        mySubTitleLabel.frame = CGRectMake(10, Y, myBackgroundView.frame.size.width-20, subTitleSize.height);
        mySubTitleLabel.text = mySubTitleString;
        Y = Y + subTitleSize.height;
        
        Y = Y + 10;
        
        CGSize messageSize = [myMessageTextView sizeThatFits:CGSizeMake(myBackgroundView.frame.size.width-20, MAXFLOAT)];
        myMessageTextView.frame = CGRectMake(10, Y, myBackgroundView.frame.size.width-20, MIN(messageSize.height, 250));
        myMessageTextView.text = myMessageString;
        Y = Y + MIN(messageSize.height, 250);
        
        Y = Y + 15;
    }
    else{
        
    }
    
    return Y;
}

//添加按钮
- (void)setAllButton:(CGFloat)yOffset{

    CGFloat Y = yOffset;
    
    for (UIView *subView in [myBackgroundView subviews]) {
        if (subView.tag>=1100) {
            [subView removeFromSuperview];
        }
    }
    
    if ([buttonTitlesArray count]==0) {
        //按钮
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, Y-1, myBackgroundView.frame.size.width, 1)];
        line.backgroundColor = [UIColor colorWithRed:0.90f green:0.90f blue:0.90f alpha:1.00f];
        line.tag = 2200;
        [myBackgroundView addSubview:line];
        [line release];
        
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, Y, myBackgroundView.frame.size.width, 40)];
        button.titleLabel.font = ButtonTitleFont;
        button.tag = 1100;
        button.exclusiveTouch = YES;
        [button setBackgroundColor:[UIColor colorWithRed:0.89f green:0.89f blue:0.89f alpha:1.00f] forState:UIControlStateHighlighted];
        [button setTitle:@"OK" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithRed:0.20f green:0.18f blue:0.18f alpha:1.00f] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
        [myBackgroundView addSubview:button];
        [button release];
        Y = Y + 40;
        
        myBackgroundView.frame = CGRectMake(50, (self.frame.size.height-Y)/2.0, self.frame.size.width-100, Y);
    }
    else if ([buttonTitlesArray count]==1) {
        //按钮
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, Y-1, myBackgroundView.frame.size.width, 1)];
        line.backgroundColor = [UIColor colorWithRed:0.90f green:0.90f blue:0.90f alpha:1.00f];
        line.tag = 2200;
        [myBackgroundView addSubview:line];
        [line release];
        
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, Y, myBackgroundView.frame.size.width, 40)];
        button.exclusiveTouch = YES;
        button.titleLabel.font = ButtonTitleFont;
        [button setBackgroundColor:[UIColor colorWithRed:0.89f green:0.89f blue:0.89f alpha:1.00f] forState:UIControlStateHighlighted];
        [button setTitle:[buttonTitlesArray objectAtIndex:0] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithRed:0.20f green:0.18f blue:0.18f alpha:1.00f] forState:UIControlStateNormal];
        button.tag = 1100;
        [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [myBackgroundView addSubview:button];
        [button release];
        Y = Y + 40;
        
        myBackgroundView.frame = CGRectMake(50, (self.frame.size.height-Y)/2.0, self.frame.size.width-100, Y);
    }
    else if ([buttonTitlesArray count]==2){
        //按钮
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, Y-1, myBackgroundView.frame.size.width, 1)];
        line.backgroundColor = [UIColor colorWithRed:0.90f green:0.90f blue:0.90f alpha:1.00f];
        line.tag = 2200;
        [myBackgroundView addSubview:line];
        [line release];
        
        UIButton *button01 = [[UIButton alloc] initWithFrame:CGRectMake(0, Y, myBackgroundView.frame.size.width/2.0-0.5, 40)];
        button01.exclusiveTouch = YES;
        button01.titleLabel.font = ButtonTitleFont;
        [button01 setTitle:[buttonTitlesArray objectAtIndex:0] forState:UIControlStateNormal];
        [button01 setBackgroundColor:[UIColor colorWithRed:0.89f green:0.89f blue:0.89f alpha:1.00f] forState:UIControlStateHighlighted];
        [button01 setTitleColor:[UIColor colorWithRed:0.20f green:0.18f blue:0.18f alpha:1.00f] forState:UIControlStateNormal];
        button01.tag = 1100;
        [button01 addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [myBackgroundView addSubview:button01];
        [button01 release];
        
        UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(button01.frame), Y, 1, 40)];
        line1.backgroundColor = [UIColor colorWithRed:0.90f green:0.90f blue:0.90f alpha:1.00f];
        line1.tag = 2201;
        [myBackgroundView addSubview:line1];
        [line1 release];
        
        UIButton *button02 = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(button01.frame)+1, Y, myBackgroundView.frame.size.width/2.0-0.5, 40)];
        button02.titleLabel.font = ButtonTitleFont;
        [button02 setTitle:[buttonTitlesArray objectAtIndex:1] forState:UIControlStateNormal];
        [button02 setBackgroundColor:[UIColor colorWithRed:0.89f green:0.89f blue:0.89f alpha:1.00f] forState:UIControlStateHighlighted];
        [button02 setTitleColor:[UIColor colorWithRed:0.20f green:0.18f blue:0.18f alpha:1.00f] forState:UIControlStateNormal];
        button02.tag = 1101;
        button02.exclusiveTouch = YES;
        [button02 addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [myBackgroundView addSubview:button02];
        [button02 release];
        
        Y = Y + 40;
        
        myBackgroundView.frame = CGRectMake(50, (self.frame.size.height-Y)/2.0, self.frame.size.width-100, Y);
    }
    else {
        for (NSInteger i=0; i<[buttonTitlesArray count]; i++) {
            UIButton *button01 = [[UIButton alloc] initWithFrame:CGRectMake(0, Y, myBackgroundView.frame.size.width, 40)];
            button01.titleLabel.font = ButtonTitleFont;
            [button01 setTitle:[buttonTitlesArray objectAtIndex:i] forState:UIControlStateNormal];
            [button01 setBackgroundColor:[UIColor colorWithRed:0.89f green:0.89f blue:0.89f alpha:1.00f] forState:UIControlStateHighlighted];
            [button01 setTitleColor:[UIColor colorWithRed:0.20f green:0.18f blue:0.18f alpha:1.00f] forState:UIControlStateNormal];
            button01.tag = 1100+i;
            button01.exclusiveTouch = YES;
            [button01 addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
            [myBackgroundView addSubview:button01];
            [button01 release];
            Y = Y + 40;
            
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(button01.frame)-1, myBackgroundView.frame.size.width, 1)];
            line.backgroundColor = [UIColor colorWithRed:0.90f green:0.90f blue:0.90f alpha:1.00f];
            line.tag = 2200 + i;
            [myBackgroundView addSubview:line];
            [line release];
            
        }
        
        myBackgroundView.frame = CGRectMake(50, (self.frame.size.height-Y)/2.0, self.frame.size.width-100, Y);
    }
}

#pragma mark ==================================================
#pragma mark == UITextViewDelegate
#pragma mark ==================================================
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    return NO;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
    return NO;
}

- (void)textViewDidBeginEditing:(UITextView *)textView{

}

- (void)textViewDidEndEditing:(UITextView *)textView{

}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    return NO;
}

- (void)textViewDidChange:(UITextView *)textView{

}


#pragma mark ==================================================
#pragma mark == 事件
#pragma mark ==================================================
- (void)backgroundButtonClicked{
    Class currentClass = object_getClass(_myDelegate);
    if ((currentClass == delegateClass) && [_myDelegate respondsToSelector:@selector(KKAlertView_backgroundClicked:)]) {
        [_myDelegate KKAlertView_backgroundClicked:self];
    }
}

- (void)buttonClicked:(UIButton*)button{
    NSInteger index = button.tag - 1100;

    Class currentClass = object_getClass(_myDelegate);
    if ((currentClass == delegateClass) && [_myDelegate respondsToSelector:@selector(KKAlertView:clickedButtonAtIndex:)]) {
        [_myDelegate KKAlertView:self clickedButtonAtIndex:index];
    }
    [self hide];
}

@end
