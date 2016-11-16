//
//  KKDataPickerView.m
//  DayDayUp
//
//  Created by beartech on 15/7/6.
//  Copyright (c) 2015年 KeKeStudio. All rights reserved.
//

#import "KKDataPickerView.h"

@implementation KKDataPickerView
@synthesize identifierKey,textKey;
@synthesize delegate = _delegate;
@synthesize dataPicker;
@synthesize titleLabel;
@synthesize dataSource;

//#define PickerHeight 216
#define PickerHeight 162

#pragma mark ==================================================
#pragma mark == 初始化
#pragma mark ==================================================
- (id)initWithFrame:(CGRect)frame
           delegate:(id<KKDataPickerViewDelegate>)aDelegate
         dataSource:(NSArray*)aDataSource
            textKey:(NSString*)aTextKey
      identifierKey:(NSString*)aIdentifierKey{
    self = [super initWithFrame:frame];
    if (self) {
        self.delegate = aDelegate;
        dataSource = [[NSMutableArray alloc] init];
        [dataSource addObjectsFromArray:aDataSource];
        
        textKey = [aTextKey copy];
        identifierKey = [aIdentifierKey copy];

        self.backgroundColor = [UIColor clearColor];
        
        UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        backButton.frame = self.bounds;
        backButton.backgroundColor = [UIColor clearColor];
        [backButton addTarget:self action:@selector(singleTap) forControlEvents:UIControlEventTouchDown];
        [self addSubview:backButton];
        
        dataPicker = [[UIPickerView alloc]initWithFrame:CGRectMake(0,frame.size.height-PickerHeight, ((UIWindow*)[[[UIApplication sharedApplication] windows] objectAtIndex:0]).frame.size.width, PickerHeight)];
        dataPicker.delegate = self;
        [self addSubview:dataPicker];
        
        [self setNavigationBarView];
        
        if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0){
            dataPicker.backgroundColor = [UIColor whiteColor];
            titleLabel.textColor = [UIColor blueColor];
        }
        else{
            dataPicker.backgroundColor = [UIColor blackColor];
            titleLabel.textColor = [UIColor whiteColor];
        }
    }
    return self;
}

- (void)dealloc{
    [dataPicker release];
    [identifierKey release];
    [textKey release];
    [titleLabel release];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}

- (void)singleTap{
    [self leftButtonClicked];
}

- (void)setNavigationBarView{
    
    UIView *navigationBarView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMinY(dataPicker.frame)-44, ApplicationWidth, 44)];
    navigationBarView.backgroundColor = [UIColor colorWithRed:0.97 green:0.97 blue:0.97 alpha:1];
    [self addSubview:navigationBarView];
    [navigationBarView release];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ApplicationWidth, 0.5)];
    line.backgroundColor = [UIColor lightGrayColor];
    [navigationBarView addSubview:line];
    [line release];
    
    NSString *leftTitle = @"取消";
    CGSize size = [leftTitle sizeWithFont:[UIFont systemFontOfSize:16.5] maxSize:CGSizeMake(1000, 1000)];
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, size.width+30, navigationBarView.frame.size.height)];
    [leftButton addTarget:self action:@selector(leftButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [leftButton setTitle:leftTitle forState:UIControlStateNormal];
    [leftButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    leftButton.titleLabel.font = [UIFont systemFontOfSize:16.5];
    [navigationBarView addSubview:leftButton];
    [leftButton release];
    
    //左空格
    titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(size.width+30, 0, ApplicationWidth-(size.width+30)*2.0, navigationBarView.frame.size.height)];
    titleLabel.font = [UIFont boldSystemFontOfSize:20];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.backgroundColor = [UIColor clearColor];
    [navigationBarView addSubview:titleLabel];
    
    
    NSString *rightTitle = @"确定";
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(ApplicationWidth-(size.width+30), 0, size.width+30, navigationBarView.frame.size.height)];
    [rightButton addTarget:self action:@selector(rightButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [rightButton setTitle:rightTitle forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    rightButton.titleLabel.font = [UIFont systemFontOfSize:16.5];
    [navigationBarView addSubview:rightButton];
    [rightButton release];
}


#pragma mark ==================================================
#pragma mark == 接口
#pragma mark ==================================================
+ (void)showInView:(UIView*)view
          delegate:(id<KKDataPickerViewDelegate>)delegate
        dataSource:(NSArray*)aDataSource
           textKey:(NSString*)aTextKey
     identifierKey:(NSString*)aIdentifierKey{
    
    KKDataPickerView *picker_View = (KKDataPickerView*)[view viewWithTag:2015070601];
    if (picker_View) {
        return;
    }
    
    KKDataPickerView *pickerView = [[KKDataPickerView alloc]initWithFrame:CGRectMake(0, view.frame.size.height, ((UIWindow*)[[[UIApplication sharedApplication] windows] objectAtIndex:0]).frame.size.width, view.frame.size.height)
                                                                 delegate:delegate
                                                               dataSource:aDataSource
                                                                  textKey:aTextKey
                                                            identifierKey:aIdentifierKey];
    pickerView.tag = 2015070601;
    [view addSubview:pickerView];
    [view bringSubviewToFront:pickerView];
    
    [UIView animateWithDuration:0.5 animations:^{
        pickerView.frame = CGRectOffset(pickerView.frame, 0, -view.frame.size.height);
    } completion:^(BOOL finished) {
        [pickerView release];
    }];

}

+ (void)showWithDelegate:(id<KKDataPickerViewDelegate>)delegate
              dataSource:(NSArray*)aDataSource
                 textKey:(NSString*)aTextKey
           identifierKey:(NSString*)aIdentifierKey{
    
    [KKDataPickerView showInView:((UIWindow*)[[[UIApplication sharedApplication] windows] objectAtIndex:0])
                        delegate:delegate
                      dataSource:aDataSource
                         textKey:aTextKey
                   identifierKey:aIdentifierKey];

}


#pragma mark ==================================================
#pragma mark == PickerViewDelegate
#pragma mark ==================================================
- (void)leftButtonClicked{
    if (_delegate && [_delegate respondsToSelector:@selector(KKDataPickerView:willDismissWithIdentifierKey:)]) {
        [_delegate KKDataPickerView:self willDismissWithIdentifierKey:identifierKey];
    }
    
    [UIView animateWithDuration:0.5 animations:^{
        self.frame = CGRectOffset(self.frame, 0, self.frame.size.height);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)rightButtonClicked{
    if (_delegate && [_delegate respondsToSelector:@selector(KKDataPickerView:didSelectedInformation:identifierKey:)]) {
        [_delegate KKDataPickerView:self didSelectedInformation:[dataSource objectAtIndex:[dataPicker selectedRowInComponent:0]] identifierKey:identifierKey];
    }
    
    [self leftButtonClicked];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return [dataSource count];
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    return dataPicker.frame.size.width;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 44;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    NSObject *obj = [dataSource objectAtIndex:row];
    if (obj && [obj isKindOfClass:[NSString class]]) {
        return (NSString*)obj;
    }
    else if (obj && [obj isKindOfClass:[NSDictionary class]]){
        return [(NSDictionary*)obj stringValueForKey:textKey];
    }
    else{
        return @"";
    }
}

//- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component NS_AVAILABLE_IOS(6_0){
//
//}

//- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
//    
//}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (_delegate && [_delegate respondsToSelector:@selector(KKDataPickerView:selectedInformation:identifierKey:)]) {
        [_delegate KKDataPickerView:self selectedInformation:[dataSource objectAtIndex:row] identifierKey:identifierKey];
    }
}


@end
