//
//  KKRefreshFooterDraggingView.h
//  TableViewRefreshDemo
//
//  Created by bear on 13-6-27.
//  Copyright (c) 2013年 可可工作室. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

typedef enum{
	KKFDraggingRefreshState_Pulling = 0,
	KKFDraggingRefreshState_Normal = 1,
	KKFDraggingRefreshState_Loading = 2,
} KKFDraggingRefreshState;

typedef enum{
    KKFDraggingRefreshImageStyle_Default = 0,
    KKFDraggingRefreshImageStyle_Black = 1,
    KKFDraggingRefreshImageStyle_Blue = 2,
    KKFDraggingRefreshImageStyle_Gray = 3,
    KKFDraggingRefreshImageStyle_White = 4,
} KKFDraggingRefreshImageStyle;

@protocol KKRefreshFooterDraggingViewDelegate;


@interface KKRefreshFooterDraggingView : UIView{

    id _delegate;
    Class delegateClass;

    KKFDraggingRefreshState _state;
    UILabel *_statusLabel;
    UIImageView *_arrowImageView;
    UIActivityIndicatorView *_activityView;
    
    NSString *_statusTextForPulling;
    NSString *_statusTextForNormal;
    NSString *_statusTextForLoading;
    UIImage  *_refreshImageCustomer;
    KKFDraggingRefreshImageStyle _refreshImageStyle;
}

@property(nonatomic,assign) id <KKRefreshFooterDraggingViewDelegate> delegate;

@property (nonatomic,assign)KKFDraggingRefreshState state;
@property (nonatomic,retain)UILabel *statusLabel;
@property (nonatomic,retain)UIImageView *arrowImageView;
@property (nonatomic,retain)UIActivityIndicatorView *activityView;

/*用于外部自定义样式*/
@property (nonatomic,retain)NSString *statusTextForPulling;//松开即可刷新...
@property (nonatomic,retain)NSString *statusTextForNormal;//下拉可以刷新...
@property (nonatomic,retain)NSString *statusTextForLoading;//更新中...
@property (nonatomic,retain)UIImage  *refreshImageCustomer;
@property (nonatomic,assign)KKFDraggingRefreshImageStyle refreshImageStyle;

- (void)refreshScrollViewDidScroll:(UIScrollView *)scrollView;
- (void)refreshScrollViewDidEndDragging:(UIScrollView *)scrollView;

@end




#pragma mark ==================================================
#pragma mark == KKRefreshFooterDraggingViewDelegate
#pragma mark ==================================================
@protocol KKRefreshFooterDraggingViewDelegate

@optional

//触发刷新加载数据
- (void)refreshTableFooterDraggingViewDidTriggerRefresh:(KKRefreshFooterDraggingView*)view;

@end





#pragma mark ==================================================
#pragma mark == UIScrollView扩展
#pragma mark ==================================================
#import <objc/runtime.h>
@interface UIScrollView (KKUIScrollViewFooterDExtension)

/*开启 加载更多*/
- (void)showRefreshFooterDraggingWithDelegate:(id<KKRefreshFooterDraggingViewDelegate>)aDelegate;

/*关闭 加载更多*/
- (void)hideRefreshFooterDragging;

/*开始 加载更多*/
- (void)startRefreshFooterDragging;

/*停止 加载更多*/
- (void)stopRefreshFooterDragging:(NSString*)aText;
- (void)stopRefreshFooterDragging;

@property (nonatomic, retain, readonly) KKRefreshFooterDraggingView *refreshFooterDragging;
@property (nonatomic, retain, readonly) NSNumber *haveFooterDragging;

@end















