//
//  LManyButton.h
//  EducationCenter
//
//  Created by Bear on 15/8/27.
//  Copyright (c) 2015年 Bear. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LManyButtonDelegate <NSObject>

@optional
-(void)LManyButtonClick:(NSInteger)index;

- (void)LmanyButtonRepeatClick:(NSInteger)index;
@end

@interface LManyButton : UIView<LManyButtonDelegate>
@property(nonatomic,retain)NSMutableArray *titleArr;
@property(nonatomic,retain)UIColor *nomalColor;
@property(nonatomic,retain)UIColor *selectedColor;
@property(nonatomic,retain)UIColor *selectedBackgroundColor;
@property(nonatomic,retain)UIColor *normalBackgroundColor;
@property(nonatomic,retain)UILabel *underLine;
@property(nonatomic,retain)NSMutableArray *btnArr;
@property(nonatomic,retain)NSMutableArray *labLineVerticalArr;


@property(nonatomic,assign)id<LManyButtonDelegate>delegate;

/**按钮个数 常态颜色 选中颜色 按钮标题*/
- (instancetype)initWithFrame:(CGRect)frame nomalColor:(UIColor *)nomalC selectedColor:(UIColor *)selectedC titleArr:(NSArray *)titleA;

/**按钮个数 常态颜色 选中颜色  按钮标题 选中背景颜色 常态背景颜色*/
- (instancetype)initWithFrame:(CGRect)frame nomalColor:(UIColor *)nomalC selectedColor:(UIColor *)selectedC titleArr:(NSArray *)titleA SelectedBackgroundColor:(UIColor *)aSelectedBackgroundColor normalBackgroundColor:(UIColor *)aNormalBackgroundColor;

/**带图片*/
- (instancetype)initWithFrame:(CGRect)frame nomalColor:(UIColor *)nomalC selectedColor:(UIColor *)selectedC titleArr:(NSArray *)titleA imageArr:(NSArray *)imageArr;

- (void)changeLabLineVertical;

- (void)defaultClick:(NSInteger)aIndex;
@end
