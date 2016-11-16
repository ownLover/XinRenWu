//
//  KKRefreshFooterAutoView.h
//  TableViewRefreshDemo
//
//  Created by bear on 13-6-27.
//  Copyright (c) 2013年 可可工作室. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

typedef enum{
	KKFAutoRefreshState_Normal = 1,
	KKFAutoRefreshState_Loading = 2,
} KKFAutoRefreshState;

@protocol KKRefreshFooterAutoViewDelegate;

@interface KKRefreshFooterAutoView : UIView{
    id _delegate;
    Class delegateClass;

	KKFAutoRefreshState      _state;
	UILabel                 *_statusLabel;
	UIActivityIndicatorView *_activityView;
    
    NSString *_statusTextForNormal;
    NSString *_statusTextForLoading;
}

@property(nonatomic,assign) id <KKRefreshFooterAutoViewDelegate> delegate;

@property (nonatomic,assign)KKFAutoRefreshState state;
@property (nonatomic,retain)UILabel *statusLabel;
@property (nonatomic,retain)UIActivityIndicatorView *activityView;

/*用于外部自定义样式*/
@property (nonatomic,retain)NSString *statusTextForNormal;//下拉可以刷新...
@property (nonatomic,retain)NSString *statusTextForLoading;//更新中...

- (void)refreshScrollViewDidScroll:(UIScrollView *)scrollView;
- (void)refreshScrollViewDidEndDragging:(UIScrollView *)scrollView;

@end




#pragma mark ==================================================
#pragma mark == KKRefreshFooterAutoViewDelegate
#pragma mark ==================================================
@protocol KKRefreshFooterAutoViewDelegate

@optional
//触发刷新加载数据
- (void)refreshTableFooterAutoViewDidTriggerRefresh:(KKRefreshFooterAutoView*)view;

@end





#pragma mark ==================================================
#pragma mark == UIScrollView扩展
#pragma mark ==================================================
#import <objc/runtime.h>
@interface UIScrollView (KKUIScrollViewFooterAExtension)

/*开启 加载更多*/
- (void)showRefreshFooterAutoWithDelegate:(id<KKRefreshFooterAutoViewDelegate>)aDelegate;

/*关闭 加载更多*/
- (void)hideRefreshFooterAuto;

/*开始 加载更多*/
- (void)startRefreshFooterAuto;

/*停止 加载更多*/
- (void)stopRefreshFooterAuto;

@property (nonatomic, retain, readonly) KKRefreshFooterAutoView *refreshFooterAuto;
@property (nonatomic, retain, readonly) NSNumber *haveFooterAuto;

@end









