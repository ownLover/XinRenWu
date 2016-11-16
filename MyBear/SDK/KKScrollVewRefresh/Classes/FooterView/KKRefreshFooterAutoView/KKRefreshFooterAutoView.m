//
//  KKRefreshFooterAutoView.m
//  TableViewRefreshDemo
//
//  Created by bear on 13-6-27.
//  Copyright (c) 2013年 可可工作室. All rights reserved.
//

#import "KKRefreshFooterAutoView.h"
#define TEXT_COLOR   [UIColor whiteColor]
#define FLIP_ANIMATION_DURATION 0.18f


@interface KKRefreshFooterAutoView ()

- (id)initWithScrollView:(UIScrollView*)scrollView delegate:(id<KKRefreshFooterAutoViewDelegate>)aDelegate;

- (void)startLoadingMore;

- (void)refreshScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView;

@end

@implementation KKRefreshFooterAutoView
@synthesize delegate=_delegate;
@synthesize state = _state;
@synthesize statusLabel = _statusLabel;
@synthesize activityView = _activityView;

@synthesize statusTextForNormal = _statusTextForNormal;
@synthesize statusTextForLoading = _statusTextForLoading;

- (void)dealloc{
    [_statusLabel release];
    _statusLabel = nil;
    [_activityView release];
    _activityView = nil;
    
    [_statusTextForNormal release];
    _statusTextForNormal = nil;
    [_statusTextForLoading release];
    _statusTextForLoading = nil;    
    [super dealloc];
}

#pragma mark ==================================================
#pragma mark == 实例化
#pragma mark ==================================================
- (id)initWithScrollView:(UIScrollView*)scrollView delegate:(id<KKRefreshFooterAutoViewDelegate>)aDelegate{
    
    if(self = [super initWithFrame:CGRectMake(0, MAX(scrollView.contentSize.height, scrollView.frame.size.height), scrollView.frame.size.width, scrollView.frame.size.height)]) {

        _delegate = aDelegate;
        delegateClass = object_getClass(_delegate);

        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		self.backgroundColor = [UIColor colorWithRed:0.86f green:0.86f blue:0.86f alpha:1.00f];
        
        _statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, 15.0f, self.frame.size.width, 20.0f)];
        _statusLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _statusLabel.font = [UIFont systemFontOfSize:18.0f];
        _statusLabel.textColor = TEXT_COLOR;
        _statusLabel.backgroundColor = [UIColor clearColor];
        _statusLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_statusLabel];
		
        _activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        _activityView.frame = CGRectMake(105.0f, 15.0f, 20.0f, 20.0f);
        [self addSubview:_activityView];

		
		[self setState:KKFAutoRefreshState_Normal];
        
        [scrollView addSubview:self];
        [scrollView setValue:self forKey:@"refreshFooterAuto"];
    }
    return self;
}

#pragma mark ==================================================
#pragma mark == 自定义
#pragma mark ==================================================
- (void)setStatusTextForLoading:(NSString *)statusTextForLoading{
    [statusTextForLoading retain];
    [_statusTextForLoading release];
    _statusTextForLoading = nil;
    _statusTextForLoading = statusTextForLoading;
    [self reload];
}

- (void)setStatusTextForNormal:(NSString *)statusTextForNormal{
    [statusTextForNormal retain];
    [_statusTextForNormal release];
    _statusTextForNormal = nil;
    _statusTextForNormal = statusTextForNormal;
    [self reload];
}

- (void)reload{
    [self setState:_state];
}


#pragma mark ==================================================
#pragma mark == 手动刷新
#pragma mark ==================================================
- (void)startLoadingMore{
    if (_state == KKFAutoRefreshState_Loading) {
        return;
    }
    UIView *v = self.superview;
    if ([v isKindOfClass:[UIScrollView class]]) {
        UIScrollView *scrollView = (UIScrollView*)v;
        if (scrollView.contentSize.height>scrollView.frame.size.height) {
            if (scrollView.contentSize.height-scrollView.contentOffset.y<scrollView.frame.size.height) {
                
                Class currentClass = object_getClass(_delegate);
                if ((currentClass == delegateClass) && [_delegate respondsToSelector:@selector(refreshTableFooterAutoViewDidTriggerRefresh:)]) {
                    [self setState:KKFAutoRefreshState_Loading];
                    [_delegate refreshTableFooterAutoViewDidTriggerRefresh:self];
                    [UIView beginAnimations:nil context:NULL];
                    [UIView setAnimationDuration:0.3];
                    UIEdgeInsets edgeInsets = scrollView.contentInset;
                    [scrollView setContentInset:UIEdgeInsetsMake(edgeInsets.top, 0.0f,50.0f, 0.0f)];
                    [UIView commitAnimations];
                }
            }
            else{
                [self setState:KKFAutoRefreshState_Normal];
                [UIView beginAnimations:nil context:NULL];
                [UIView setAnimationDuration:0.3];
                UIEdgeInsets edgeInsets = scrollView.contentInset;
                [scrollView setContentInset:UIEdgeInsetsMake(edgeInsets.top, 0.0f,0.0f, 0.0f)];
                [UIView commitAnimations];
            }
        }
        else{
            if (scrollView.contentOffset.y>0) {
                
                Class currentClass = object_getClass(_delegate);
                if ((currentClass == delegateClass) && [_delegate respondsToSelector:@selector(refreshTableFooterAutoViewDidTriggerRefresh:)]) {
                    [self setState:KKFAutoRefreshState_Loading];
                    [_delegate refreshTableFooterAutoViewDidTriggerRefresh:self];
                    [UIView beginAnimations:nil context:NULL];
                    [UIView setAnimationDuration:0.3];
                    UIEdgeInsets edgeInsets = scrollView.contentInset;
                    [scrollView setContentInset:UIEdgeInsetsMake(edgeInsets.top,
                                                                 0.0f,
                                                                 scrollView.frame.size.height-scrollView.contentSize.height+50,
                                                                 0.0f)];
                    [UIView commitAnimations];
                }
            }
            else{
                [self setState:KKFAutoRefreshState_Normal];
                [UIView beginAnimations:nil context:NULL];
                [UIView setAnimationDuration:0.3];
                UIEdgeInsets edgeInsets = scrollView.contentInset;
                [scrollView setContentInset:UIEdgeInsetsMake(edgeInsets.top, 0.0f,0.0f, 0.0f)];
                [UIView commitAnimations];
            }
        }
        [scrollView setContentOffset:CGPointMake(0, MAX(scrollView.contentSize.height, scrollView.frame.size.height)) animated:YES];
    }
}

#pragma mark ==================================================
#pragma mark == 状态设置
#pragma mark ==================================================
- (void)setState:(KKFAutoRefreshState)aState{
	switch (aState) {
        case KKFAutoRefreshState_Normal:{
            NSString *showText = nil;
            if (_statusTextForNormal) {
                showText = _statusTextForNormal;
            }
            else{
                showText = @"加载更多...";
            }
            
            
            CGSize size = [_statusLabel.text sizeWithFont:_statusLabel.font maxSize:CGSizeMake(self.frame.size.width, 100)];
            
            _statusLabel.frame = CGRectMake((self.frame.size.width-size.width)/2.0, 15.0f, size.width, 20.0f);
            _statusLabel.text = showText;
			[_activityView stopAnimating];
			break;
        }
        case KKFAutoRefreshState_Loading:{
            NSString *showText = nil;
            if (_statusTextForLoading) {
                showText = _statusTextForLoading;
            }
            else{
                showText = @"加载中...";
            }
            
            CGSize size = [_statusLabel.text sizeWithFont:_statusLabel.font maxSize:CGSizeMake(self.frame.size.width, 100)];
            
            _activityView.frame = CGRectMake((self.frame.size.width-size.width-20-10)/2.0, 15.0f, 20.0f, 20.0f);
            _statusLabel.frame = CGRectMake(CGRectGetMaxX(_activityView.frame)+10, 15.0f, size.width, 20.0f);
            _statusLabel.text = showText;
			[_activityView startAnimating];
            break;
        }
		default:
			break;
	}
	_state = aState;
}

#pragma mark ==================================================
#pragma mark == 滚动
#pragma mark ==================================================
- (void)refreshScrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.y<0) {
        return;
    }
    
    if (scrollView.contentSize.height < scrollView.frame.size.height) {
        self.frame = CGRectMake(0, scrollView.frame.size.height, [[UIScreen mainScreen] applicationFrame].size.width, 416);
    }
    else {
        self.frame = CGRectMake(0, scrollView.contentSize.height,[[UIScreen mainScreen] applicationFrame].size.width, scrollView.contentSize.height);
    }
    
    if (_state == KKFAutoRefreshState_Loading) {
        return;
    }
    
    if (scrollView.contentSize.height-scrollView.contentOffset.y>=scrollView.frame.size.height) {
        return;
    }
    
    if (scrollView.contentSize.height>scrollView.frame.size.height) {
        if (scrollView.contentSize.height-scrollView.contentOffset.y<=scrollView.frame.size.height) {
            
            Class currentClass = object_getClass(_delegate);
            if ((currentClass == delegateClass) && [_delegate respondsToSelector:@selector(refreshTableFooterAutoViewDidTriggerRefresh:)]) {
                [self setState:KKFAutoRefreshState_Loading];
                [_delegate refreshTableFooterAutoViewDidTriggerRefresh:self];
                [UIView beginAnimations:nil context:NULL];
                [UIView setAnimationDuration:0.3];
                UIEdgeInsets edgeInsets = scrollView.contentInset;
                [scrollView setContentInset:UIEdgeInsetsMake(edgeInsets.top, 0.0f,50.0f, 0.0f)];
                [UIView commitAnimations];
            }
        }
        else{
            [self setState:KKFAutoRefreshState_Normal];
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:0.3];
            UIEdgeInsets edgeInsets = scrollView.contentInset;
            [scrollView setContentInset:UIEdgeInsetsMake(edgeInsets.top, 0.0f,0.0f, 0.0f)];
            [UIView commitAnimations];
        }
    }
    else{
        if (scrollView.contentOffset.y>0) {
            
            Class currentClass = object_getClass(_delegate);
            if ((currentClass == delegateClass) && [_delegate respondsToSelector:@selector(refreshTableFooterAutoViewDidTriggerRefresh:)]) {
                [self setState:KKFAutoRefreshState_Loading];
                [_delegate refreshTableFooterAutoViewDidTriggerRefresh:self];
                [UIView beginAnimations:nil context:NULL];
                [UIView setAnimationDuration:0.3];
                UIEdgeInsets edgeInsets = scrollView.contentInset;
                [scrollView setContentInset:UIEdgeInsetsMake(edgeInsets.top,
                                                             0.0f,
                                                             scrollView.frame.size.height-scrollView.contentSize.height+50,
                                                             0.0f)];
                [UIView commitAnimations];
            }
        }
        else{
            [self setState:KKFAutoRefreshState_Normal];
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:0.3];
            UIEdgeInsets edgeInsets = scrollView.contentInset;
            [scrollView setContentInset:UIEdgeInsetsMake(edgeInsets.top, 0.0f,0.0f, 0.0f)];
            [UIView commitAnimations];
        }
    }

}

- (void)refreshScrollViewDidEndDragging:(UIScrollView *)scrollView {

}

- (void)refreshScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView{
    if (scrollView.contentSize.height < scrollView.frame.size.height) {
        self.frame = CGRectMake(0, scrollView.frame.size.height, [[UIScreen mainScreen] applicationFrame].size.width, 416);
    }
    else {
        self.frame = CGRectMake(0, scrollView.contentSize.height,[[UIScreen mainScreen] applicationFrame].size.width, scrollView.contentSize.height);
    }
    
    [self setState:KKFAutoRefreshState_Normal];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    UIEdgeInsets edgeInsets = scrollView.contentInset;
    [scrollView setContentInset:UIEdgeInsetsMake(edgeInsets.top, 0.0f,0.0f, 0.0f)];
    [UIView commitAnimations];
}

@end

#pragma mark ==================================================
#pragma mark == UIScrollView扩展
#pragma mark ==================================================
@implementation UIScrollView (KKUIScrollViewFooterAExtension)
@dynamic refreshFooterAuto;
@dynamic haveFooterAuto;

- (void)setHaveFooterAuto:(NSNumber *)haveFooterAuto{
    objc_setAssociatedObject(self, @"haveFooterAuto", haveFooterAuto, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(NSNumber *)haveFooterAuto{
    return objc_getAssociatedObject(self, @"haveFooterAuto");
}

- (void)setRefreshFooterAuto:(KKRefreshFooterAutoView *)refreshFooterAuto{
    objc_setAssociatedObject(self, @"refreshFooterAuto", refreshFooterAuto, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(KKRefreshFooterAutoView *)refreshFooterAuto{
    if ([objc_getAssociatedObject(self, @"haveFooterAuto") boolValue]) {
        return objc_getAssociatedObject(self, @"refreshFooterAuto");
    }
    else{
        return nil;
    }
}

/*开启 加载更多*/
- (void)showRefreshFooterAutoWithDelegate:(id<KKRefreshFooterAutoViewDelegate>)aDelegate{
    if (!self.refreshFooterAuto) {
        KKRefreshFooterAutoView *footerView = [[KKRefreshFooterAutoView alloc] initWithScrollView:self delegate:aDelegate];
        self.haveFooterAuto = [NSNumber numberWithBool:YES];
        [footerView release];
    }
}

/*关闭 加载更多*/
- (void)hideRefreshFooterAuto{
    if (self.refreshFooterAuto) {
        KKRefreshFooterAutoView *footer = self.refreshFooterAuto;
        objc_removeAssociatedObjects(self.refreshFooterAuto);
        [footer removeFromSuperview];
        self.haveFooterAuto = [NSNumber numberWithBool:NO];
    }
}

/*开始 加载更多*/
- (void)startRefreshFooterAuto{
    if (self.refreshFooterAuto) {
        [self.refreshFooterAuto startLoadingMore];
    }
}


/*停止 加载更多*/
- (void)stopRefreshFooterAuto{
    if (self.refreshFooterAuto) {
        [self.refreshFooterAuto refreshScrollViewDataSourceDidFinishedLoading:self];
    }
}



@end



