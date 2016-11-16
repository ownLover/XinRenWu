//
//  KKDatePickerView.h
//  MyCalendar
//
//  Created by beartech on 13-4-13.
//
//

#import <UIKit/UIKit.h>

@protocol KKDatePickerViewDelegate;

@interface KKDatePickerView : UIView{
    UIDatePicker *datePicker;
    UILabel *titleLabel;
    
    Class delegateClass;
    id<KKDatePickerViewDelegate> _delegate;
}

@property (nonatomic,assign) id<KKDatePickerViewDelegate> delegate;
@property (nonatomic,retain) UIDatePicker *datePicker;
@property (nonatomic,retain) UILabel *titleLabel;
@property (nonatomic,copy) NSString *identifierKey;//标识符（外面传进来，代理会返回改值，用以区分）

+ (void)showInView:(UIView*)view
          delegate:(id<KKDatePickerViewDelegate>)delegate
    datePickerMode:(UIDatePickerMode)mode
           minDate:(NSDate*)minDate
           maxDate:(NSDate*)maxDate
          showDate:(NSDate*)showDate
     identifierKey:(NSString*)aIdentifierKey;

+ (void)showWithDelegate:(id<KKDatePickerViewDelegate>)delegate
          datePickerMode:(UIDatePickerMode)mode
                 minDate:(NSDate*)minDatex
                 maxDate:(NSDate*)maxDate
                showDate:(NSDate*)showDate
           identifierKey:(NSString*)aIdentifierKey;

+ (void)showInView:(UIView*)view
          delegate:(id<KKDatePickerViewDelegate>)delegate
    datePickerMode:(UIDatePickerMode)mode
     identifierKey:(NSString*)aIdentifierKey;

+ (void)showWithDelegate:(id<KKDatePickerViewDelegate>)delegate
          datePickerMode:(UIDatePickerMode)mode
           identifierKey:(NSString*)aIdentifierKey;

@end


@protocol KKDatePickerViewDelegate <NSObject>
@optional

- (void)KKDatePickerView:(KKDatePickerView*)datePickerView willDismissWithIdentifierKey:(NSString*)aIdentifierKey;

- (void)KKDatePickerView:(KKDatePickerView*)datePickerView selectedDate:(NSDate *)aDate identifierKey:(NSString*)aIdentifierKey;

- (void)KKDatePickerView:(KKDatePickerView*)datePickerView didFinishedWithDate:(NSDate *)aDate identifierKey:(NSString*)aIdentifierKey;


@end
