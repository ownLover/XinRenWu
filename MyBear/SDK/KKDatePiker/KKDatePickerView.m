//
//  KKDatePickerView.m
//  MyCalendar
//
//  Created by beartech on 13-4-13.
//
//

#import "KKDatePickerView.h"

@implementation KKDatePickerView
@synthesize identifierKey;
@synthesize delegate = _delegate;
@synthesize datePicker;
@synthesize titleLabel;
#define PickerHeight 216

#pragma mark ==================================================
#pragma mark == 初始化
#pragma mark ==================================================
- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        backButton.frame = self.bounds;
        backButton.backgroundColor = [UIColor clearColor];
        [backButton addTarget:self action:@selector(singleTap) forControlEvents:UIControlEventTouchDown];
        [self addSubview:backButton];
        
        datePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0,frame.size.height-PickerHeight, ((UIWindow*)[[[UIApplication sharedApplication] windows] objectAtIndex:0]).frame.size.width, PickerHeight)];
        [datePicker addTarget:self action:@selector(datePickerValueChanged) forControlEvents:UIControlEventValueChanged];
        datePicker.datePickerMode = UIDatePickerModeTime;
        [self setDate:[NSDate date]];
        [self addSubview:datePicker];
        
        [self setNavigationBarView];
        
        if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0){
            datePicker.backgroundColor = [UIColor whiteColor];
            titleLabel.textColor = [UIColor blackColor];
        }
        else{
            datePicker.backgroundColor = [UIColor blackColor];
            titleLabel.textColor = [UIColor whiteColor];
        }
    }
    return self;
}

- (void)dealloc{
    [datePicker release];
    [identifierKey release];
    [titleLabel release];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}

- (void)singleTap{
    [self leftButtonClicked];
}

- (void)setNavigationBarView{
    UIToolbar *toolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, CGRectGetMinY(datePicker.frame)-44, ((UIWindow*)[[[UIApplication sharedApplication] windows] objectAtIndex:0]).frame.size.width, 44)];
    toolBar.tintColor = nil;
//    toolBar.barStyle = UIBarStyleBlackTranslucent;
    toolBar.barStyle = UIBarStyleDefault;
    toolBar.translucent = YES;
    toolBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;

    //左按钮
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(leftButtonClicked)];
    leftButton.tintColor = [UIColor blackColor];
    //左空格
    UIBarButtonItem *leftflexible = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    //左空格
    titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(70, 0, 190, toolBar.frame.size.height)];
    titleLabel.font = [UIFont boldSystemFontOfSize:20];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.backgroundColor = [UIColor clearColor];
    [toolBar addSubview:titleLabel];

    //右空格
    UIBarButtonItem *rightflexible = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    //右按钮
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(rightButtonClicked)];
    rightButton.tintColor = [UIColor blackColor];
    
    toolBar.items = [NSArray arrayWithObjects:leftButton,leftflexible,rightflexible,rightButton, nil];
    [leftButton release];
    [leftflexible release];
    [rightflexible release];
    [rightButton release];
    [self addSubview:toolBar];
    [toolBar release];
}

- (void)setIndentifierKey:(NSString*)aKey{
    [identifierKey release];
    identifierKey = nil;
    identifierKey = [aKey copy];
}

- (void)changeDelegate:(id<KKDatePickerViewDelegate>)delegate{
    self.delegate = delegate;
    delegateClass = object_getClass(delegate);
}

- (void)datePickerValueChanged{
    [self reloadTitleLabel:datePicker.date];
}

- (void)setDate:(NSDate*)date{
    datePicker.date = date;
    [self reloadTitleLabel:datePicker.date];
}

- (void)reloadTitleLabel:(NSDate*)date{
    
    if (datePicker.datePickerMode==UIDatePickerModeTime) {
        NSString *stringYMD = [NSDate getStringFromDate:date dateFormatter:@"HH:mm"];
        titleLabel.text = stringYMD;
        titleLabel.font = [UIFont boldSystemFontOfSize:24];
    }
    else if (datePicker.datePickerMode==UIDatePickerModeDate){
        NSString *stringYMD = [NSDate getStringFromDate:date dateFormatter:@"yyyy-MM-dd EEE"];
        titleLabel.text = stringYMD;
        titleLabel.font = [UIFont boldSystemFontOfSize:20];
    }
    else if (datePicker.datePickerMode==UIDatePickerModeDateAndTime){
        NSString *stringYMD = [NSDate getStringFromDate:date dateFormatter:@"yyyy-MM-dd EEE HH:mm"];
        titleLabel.text = stringYMD;
        titleLabel.font = [UIFont boldSystemFontOfSize:16];
    }
    else if (datePicker.datePickerMode==UIDatePickerModeCountDownTimer){
        titleLabel.text = @"";
    }
    else{
        titleLabel.text = @"";
    }
    
    Class currentClass = object_getClass(self.delegate);
    if ((currentClass == delegateClass) && [self.delegate respondsToSelector:@selector(KKDatePickerView:selectedDate:identifierKey:)]) {
        [self.delegate KKDatePickerView:self selectedDate:datePicker.date identifierKey:identifierKey];
    }
}

#pragma mark ==================================================
#pragma mark == 接口
#pragma mark ==================================================
+ (void)showInView:(UIView*)view
          delegate:(id<KKDatePickerViewDelegate>)delegate
    datePickerMode:(UIDatePickerMode)mode
           minDate:(NSDate*)minDate
           maxDate:(NSDate*)maxDate
          showDate:(NSDate*)showDate
     identifierKey:(NSString*)aIdentifierKey;
{
    
    KKDatePickerView *pickerView = [[KKDatePickerView alloc]initWithFrame:CGRectMake(0, view.frame.size.height, ((UIWindow*)[[[UIApplication sharedApplication] windows] objectAtIndex:0]).frame.size.width, view.frame.size.height)];
    pickerView.tag = 2006021272;
    [pickerView changeDelegate:delegate];
    pickerView.datePicker.datePickerMode = mode;
    [pickerView setIndentifierKey:aIdentifierKey];
    if (minDate && [minDate isKindOfClass:[NSDate class]]) {
        pickerView.datePicker.minimumDate = minDate;
    }
    if (maxDate && [maxDate isKindOfClass:[NSDate class]]) {
        pickerView.datePicker.maximumDate = maxDate;
    }
    if (showDate && [showDate isKindOfClass:[NSDate class]]) {
        pickerView.datePicker.date = showDate;
        [pickerView setDate:showDate];
    }
    [view addSubview:pickerView];
    [view bringSubviewToFront:pickerView];
    
    [UIView animateWithDuration:0.5 animations:^{
        pickerView.frame = CGRectOffset(pickerView.frame, 0, -view.frame.size.height);
    } completion:^(BOOL finished) {
        [pickerView release];
    }];

}

+ (void)showInView:(UIView*)view
          delegate:(id<KKDatePickerViewDelegate>)delegate
    datePickerMode:(UIDatePickerMode)mode
     identifierKey:(NSString*)aIdentifierKey;
{
    
    [KKDatePickerView showInView:view
                        delegate:delegate
                  datePickerMode:mode
                         minDate:nil
                         maxDate:nil
                        showDate:nil
                   identifierKey:aIdentifierKey];
}

+ (void)showWithDelegate:(id<KKDatePickerViewDelegate>)delegate
          datePickerMode:(UIDatePickerMode)mode
                 minDate:(NSDate*)minDate
                 maxDate:(NSDate*)maxDate
                showDate:(NSDate*)showDate
           identifierKey:(NSString*)aIdentifierKey;
{
    
    [KKDatePickerView showInView:((UIWindow*)[[[UIApplication sharedApplication] windows] objectAtIndex:0])
                        delegate:delegate
                  datePickerMode:mode
                         minDate:minDate
                         maxDate:maxDate
                        showDate:showDate
                   identifierKey:aIdentifierKey];
}

+ (void)showWithDelegate:(id<KKDatePickerViewDelegate>)delegate
          datePickerMode:(UIDatePickerMode)mode
           identifierKey:(NSString*)aIdentifierKey;
{
    
    [KKDatePickerView showInView:((UIWindow*)[[[UIApplication sharedApplication] windows] objectAtIndex:0])
                        delegate:delegate datePickerMode:mode
                   identifierKey:aIdentifierKey];
}

#pragma mark ==================================================
#pragma mark == PickerViewDelegate
#pragma mark ==================================================
- (void)leftButtonClicked{
    Class currentClass = object_getClass(self.delegate);
    if ((currentClass == delegateClass) && [self.delegate respondsToSelector:@selector(KKDatePickerView:willDismissWithIdentifierKey:)]) {
        [self.delegate KKDatePickerView:self willDismissWithIdentifierKey:identifierKey];
    }
    
    [UIView animateWithDuration:0.5 animations:^{
        self.frame = CGRectOffset(self.frame, 0, self.frame.size.height);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)rightButtonClicked{
    Class currentClass = object_getClass(self.delegate);
    if ((currentClass == delegateClass) && [self.delegate respondsToSelector:@selector(KKDatePickerView:didFinishedWithDate:identifierKey:)]) {
        [self.delegate KKDatePickerView:self didFinishedWithDate:datePicker.date identifierKey:identifierKey];
    }
    
    [self leftButtonClicked];
}

@end






