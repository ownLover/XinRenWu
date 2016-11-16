//
//  KKDataPickerView.h
//  DayDayUp
//
//  Created by beartech on 15/7/6.
//  Copyright (c) 2015年 KeKeStudio. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol KKDataPickerViewDelegate;

@interface KKDataPickerView : UIView<UIPickerViewDataSource,UIPickerViewDelegate>{
    UIPickerView *dataPicker;
    UILabel *titleLabel;
    NSMutableArray *dataSource;

    id<KKDataPickerViewDelegate> _delegate;
}

@property (nonatomic,assign) id<KKDataPickerViewDelegate> delegate;
@property (nonatomic,retain) UIPickerView *dataPicker;
@property (nonatomic,retain) UILabel *titleLabel;
@property (nonatomic,retain) NSMutableArray *dataSource;
@property (nonatomic,copy) NSString *identifierKey;//标识符（外面传进来，代理会返回改值，用以区分）
@property (nonatomic,copy) NSString *textKey;//显示的文字的key,通过这个key从dataSource 里面的每个元素（字典）里面去取value

+ (void)showInView:(UIView*)view
          delegate:(id<KKDataPickerViewDelegate>)delegate
        dataSource:(NSArray*)aDataSource
        textKey:(NSString*)aTextKey
     identifierKey:(NSString*)aIdentifierKey;

+ (void)showWithDelegate:(id<KKDataPickerViewDelegate>)delegate
              dataSource:(NSArray*)aDataSource
                 textKey:(NSString*)aTextKey
           identifierKey:(NSString*)aIdentifierKey;

@end


@protocol KKDataPickerViewDelegate <NSObject>
@optional

- (void)KKDataPickerView:(KKDataPickerView*)dataPickerView willDismissWithIdentifierKey:(NSString*)aIdentifierKey;

- (void)KKDataPickerView:(KKDataPickerView*)dataPickerView selectedInformation:(id)aInformation identifierKey:(NSString*)aIdentifierKey;

- (void)KKDataPickerView:(KKDataPickerView*)dataPickerView didSelectedInformation:(id)aInformation identifierKey:(NSString*)aIdentifierKey;


@end
