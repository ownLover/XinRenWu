//
//  KKRefreshFooterDraggingView.m
//  TableViewRefreshDemo
//
//  Created by bear on 13-6-27.
//  Copyright (c) 2013年 可可工作室. All rights reserved.
//

#import "KKRefreshFooterDraggingView.h"
#define TEXT_COLOR  [UIColor colorWithRed:0.49f green:0.50f blue:0.49f alpha:1.00f]
#define TEXT_FONT   [UIFont systemFontOfSize:14]
#define FLIP_ANIMATION_DURATION 0.18f
#define EdgeInsets_Y 50.0f


@interface KKRefreshFooterDraggingView ()

- (id)initWithScrollView:(UIScrollView*)scrollView delegate:(id<KKRefreshFooterDraggingViewDelegate>)aDelegate;

- (void)startLoadingMore;

- (void)refreshScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView text:(NSString*)aText;
- (void)refreshScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView;


@end

@implementation KKRefreshFooterDraggingView
@synthesize delegate=_delegate;
@synthesize state = _state;
@synthesize statusLabel = _statusLabel;
@synthesize arrowImageView = _arrowImageView;
@synthesize activityView = _activityView;

@synthesize statusTextForPulling = _statusTextForPulling;
@synthesize statusTextForNormal = _statusTextForNormal;
@synthesize statusTextForLoading = _statusTextForLoading;
@synthesize refreshImageCustomer = _refreshImageCustomer;
@synthesize refreshImageStyle = _refreshImageStyle;

- (void)dealloc{
    [_statusLabel release];
    _statusLabel = nil;
    [_arrowImageView release];
    _arrowImageView = nil;
    [_activityView release];
    _activityView = nil;
    
    [_statusTextForPulling release];
    _statusTextForPulling = nil;
    [_statusTextForNormal release];
    _statusTextForNormal = nil;
    [_statusTextForLoading release];
    _statusTextForLoading = nil;
    [_refreshImageCustomer release];
    _refreshImageCustomer = nil;
    
    [super dealloc];
}

#pragma mark ==================================================
#pragma mark == 实例化
#pragma mark ==================================================
- (id)initWithScrollView:(UIScrollView*)scrollView delegate:(id<KKRefreshFooterDraggingViewDelegate>)aDelegate{
    CGRect frame = scrollView.bounds;
    if(self = [super initWithFrame:CGRectMake(0, MAX(scrollView.contentSize.height, scrollView.frame.size.height), scrollView.frame.size.width, scrollView.frame.size.height)]) {

        _delegate = aDelegate;
        delegateClass = object_getClass(_delegate);

        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.backgroundColor = [UIColor colorWithRed:0.97f green:0.97f blue:0.97f alpha:1.00f];
        
        _statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(20.0f, frame.size.height - 48.0f, self.frame.size.width, 20.0f)];
        _statusLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _statusLabel.font = [UIFont systemFontOfSize:14.0f];
        _statusLabel.textColor = TEXT_COLOR;
        _statusLabel.backgroundColor = [UIColor clearColor];
        _statusLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_statusLabel];
        
        _arrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(65.0f, 5, 15.0f, 40.0f)];
        NSString *filepath = [NSString stringWithFormat:@"%@/KKScrollVewRefresh.bundle/whiteArrow.png", [[NSBundle mainBundle] bundlePath]];
        UIImage *image = [UIImage imageWithContentsOfFile:filepath];
        _arrowImageView.image = image;
        _arrowImageView.image = KKThemeImage(@"btn_Refresh");
        [self addSubview:_arrowImageView];
        
        _activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _activityView.frame = CGRectMake(105.0f, 15.0f, 20.0f, 20.0f);
        [self addSubview:_activityView];
        
        [self setState:KKFDraggingRefreshState_Normal];
        
        [scrollView addSubview:self];
        [scrollView setValue:self forKey:@"refreshFooterDragging"];
    }
    return self;
}

#pragma mark ==================================================
#pragma mark == 自定义
#pragma mark ==================================================
- (void)setRefreshImageCustomer:(UIImage *)refreshImageCustomer{
    [refreshImageCustomer retain];
    [_refreshImageCustomer release];
    _refreshImageCustomer = nil;
    _refreshImageCustomer = refreshImageCustomer;
    [self reload];
}

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

- (void)setStatusTextForPulling:(NSString *)statusTextForPulling{
    [statusTextForPulling retain];
    [_statusTextForPulling release];
    _statusTextForPulling = nil;
    _statusTextForPulling = statusTextForPulling;
    [self reload];
}

- (void)setRefreshImageStyle:(KKFDraggingRefreshImageStyle)refreshImageStyle{
    _refreshImageStyle = refreshImageStyle;
    [self reload];
}


- (void)reload{
    
    if (_refreshImageCustomer) {
        _arrowImageView.image = _refreshImageCustomer;
    }
    else{
        if (_refreshImageStyle==KKFDraggingRefreshImageStyle_Default) {
            NSString *filepath = [NSString stringWithFormat:@"%@/KKScrollVewRefresh.bundle/whiteArrow.png", [[NSBundle mainBundle] bundlePath]];
            UIImage *image = [UIImage imageWithContentsOfFile:filepath];
            _arrowImageView.image = image;
            _arrowImageView.image = KKThemeImage(@"btn_Refresh");
        }
        else if (_refreshImageStyle==KKFDraggingRefreshImageStyle_Black){
            NSString *filepath = [NSString stringWithFormat:@"%@/KKScrollVewRefresh.bundle/blackArrow.png", [[NSBundle mainBundle] bundlePath]];
            UIImage *image = [UIImage imageWithContentsOfFile:filepath];
            _arrowImageView.image = image;
            _arrowImageView.image = KKThemeImage(@"btn_Refresh");
        }
        else if (_refreshImageStyle==KKFDraggingRefreshImageStyle_Blue){
            NSString *filepath = [NSString stringWithFormat:@"%@/KKScrollVewRefresh.bundle/blueArrow.png", [[NSBundle mainBundle] bundlePath]];
            UIImage *image = [UIImage imageWithContentsOfFile:filepath];
            _arrowImageView.image = image;
            _arrowImageView.image = KKThemeImage(@"btn_Refresh");
        }
        else if (_refreshImageStyle==KKFDraggingRefreshImageStyle_Gray){
            NSString *filepath = [NSString stringWithFormat:@"%@/KKScrollVewRefresh.bundle/grayArrow.png", [[NSBundle mainBundle] bundlePath]];
            UIImage *image = [UIImage imageWithContentsOfFile:filepath];
            _arrowImageView.image = image;
            _arrowImageView.image = KKThemeImage(@"btn_Refresh");
        }
        else if (_refreshImageStyle==KKFDraggingRefreshImageStyle_White){
            NSString *filepath = [NSString stringWithFormat:@"%@/KKScrollVewRefresh.bundle/whiteArrow.png", [[NSBundle mainBundle] bundlePath]];
            UIImage *image = [UIImage imageWithContentsOfFile:filepath];
            _arrowImageView.image = image;
            _arrowImageView.image = KKThemeImage(@"btn_Refresh");
        }
        else{
            
        }
    }
    
    [self setState:_state];
}

#pragma mark ==================================================
#pragma mark == 手动刷新
#pragma mark ==================================================
- (void)startLoadingMore{
    if (_state == KKFDraggingRefreshState_Loading) {
        return;
    }
    UIView *v = self.superview;
    if ([v isKindOfClass:[UIScrollView class]]) {
        UIScrollView *scrollView = (UIScrollView*)v;
        if (!(_state == KKFDraggingRefreshState_Loading)) {
            
            if (scrollView.contentSize.height>scrollView.frame.size.height) {
                if (scrollView.contentSize.height-scrollView.contentOffset.y<=scrollView.frame.size.height-EdgeInsets_Y) {
                    [self setState:KKFDraggingRefreshState_Loading];
                    [UIView beginAnimations:nil context:NULL];
                    [UIView setAnimationDuration:0.2];
                    UIEdgeInsets edgeInsets = scrollView.contentInset;
                    [scrollView setContentInset:UIEdgeInsetsMake(edgeInsets.top,
                                                                 0.0f,
                                                                 EdgeInsets_Y,
                                                                 0.0f)];
                    [UIView commitAnimations];
                    
                    Class currentClass = object_getClass(_delegate);
                    if ((currentClass == delegateClass) && [_delegate respondsToSelector:@selector(refreshTableFooterDraggingViewDidTriggerRefresh:)]) {
                        [_delegate refreshTableFooterDraggingViewDidTriggerRefresh:self];
                    }
                }
            }
            else{
                if (scrollView.contentOffset.y>EdgeInsets_Y) {
                    
                    [self setState:KKFDraggingRefreshState_Loading];
                    [UIView beginAnimations:nil context:NULL];
                    [UIView setAnimationDuration:0.2];
                    UIEdgeInsets edgeInsets = scrollView.contentInset;
                    [scrollView setContentInset:UIEdgeInsetsMake(edgeInsets.top,
                                                                 0.0f,
                                                                 scrollView.frame.size.height-scrollView.contentSize.height+EdgeInsets_Y,
                                                                 0.0f)];
                    [UIView commitAnimations];
                    
                    Class currentClass = object_getClass(_delegate);
                    if ((currentClass == delegateClass) && [_delegate respondsToSelector:@selector(refreshTableFooterDraggingViewDidTriggerRefresh:)]) {
                        [_delegate refreshTableFooterDraggingViewDidTriggerRefresh:self];
                    }
                }
            }
        }
        [scrollView setContentOffset:CGPointMake(0, MAX(scrollView.contentSize.height, scrollView.frame.size.height)) animated:YES];
    }
}

#pragma mark ==================================================
#pragma mark == 状态设置
#pragma mark ==================================================
- (void)setState:(KKFDraggingRefreshState)aState{
	switch (aState) {
		case KKFDraggingRefreshState_Pulling:
            if (_statusTextForPulling) {
                _statusLabel.text = _statusTextForPulling;
            }
            else{
                _statusLabel.text = @"释放加载...";
            }
            [_activityView stopAnimating];
            _arrowImageView.hidden = NO;
            
            [self reloadSubviewsFrame];
            
            CGAffineTransform endAngle = CGAffineTransformMakeRotation(180.0f*(M_PI/180.0f));
            [UIView animateWithDuration:FLIP_ANIMATION_DURATION animations:^{
                _arrowImageView.transform = endAngle;
            } completion:^(BOOL finished) {
                
            }];
			break;
		case KKFDraggingRefreshState_Normal:
            if (_statusTextForNormal) {
                _statusLabel.text = _statusTextForNormal;
            }
            else{
                _statusLabel.text = @"上拉加载更多...";
            }
            
            [_activityView stopAnimating];
            _arrowImageView.hidden = NO;
            
            [self reloadSubviewsFrame];
            
            CGAffineTransform endAngle2 = CGAffineTransformMakeRotation(0.0f*(M_PI/180.0f));
            [UIView animateWithDuration:FLIP_ANIMATION_DURATION animations:^{
                _arrowImageView.transform = endAngle2;
            } completion:^(BOOL finished) {
                
            }];
			break;
		case KKFDraggingRefreshState_Loading:
            if (_statusTextForLoading) {
                _statusLabel.text = _statusTextForLoading;
            }
            else{
                _statusLabel.text = @"加载中...";
            }
            
            [_activityView startAnimating];
            _arrowImageView.hidden = YES;
            
            [self reloadSubviewsFrame];
			break;
		default:
			break;
	}
	_state = aState;
}

- (void)reloadSubviewsFrame{
    
    if (_arrowImageView.hidden) {
        _statusLabel.font = TEXT_FONT;
        
        CGSize size01 = [_statusLabel.text sizeWithFont:_statusLabel.font maxSize:CGSizeMake(self.frame.size.width, 100)];
        
        CGSize arrowImageSize = _activityView.frame.size;
        _activityView.frame = CGRectMake((self.frame.size.width-size01.width-arrowImageSize.width-5)/2.0,
                                         (EdgeInsets_Y-arrowImageSize.height)/2.0,
                                         arrowImageSize.width,
                                         arrowImageSize.height);
        _statusLabel.frame = CGRectMake(CGRectGetMaxX(_activityView.frame)+5,
                                        (EdgeInsets_Y-size01.height)/2.0,
                                        size01.width,
                                        size01.height);
    }
    else{
        _statusLabel.font = TEXT_FONT;
        
        CGSize size01 = [_statusLabel.text sizeWithFont:_statusLabel.font maxSize:CGSizeMake(self.frame.size.width, 100)];
        
        CGSize arrowImageSize = _arrowImageView.image.size;
        _arrowImageView.frame = CGRectMake((self.frame.size.width-size01.width-arrowImageSize.width)/2.0,
                                           (EdgeInsets_Y-arrowImageSize.height)/2.0,
                                           arrowImageSize.width,
                                           arrowImageSize.height);
        _statusLabel.frame = CGRectMake(CGRectGetMaxX(_arrowImageView.frame),
                                        (EdgeInsets_Y-size01.height)/2.0,
                                        size01.width,
                                        size01.height);
    }
}

#pragma mark ==================================================
#pragma mark == 滚动
#pragma mark ==================================================
- (void)refreshScrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.y<0) {
        return;
    }
    
    if (scrollView.contentSize.height < scrollView.frame.size.height) {
        self.frame = CGRectMake(0, scrollView.frame.size.height, [[UIScreen mainScreen] applicationFrame].size.width, scrollView.frame.size.height);
    }
    else {
        self.frame = CGRectMake(0, scrollView.contentSize.height,[[UIScreen mainScreen] applicationFrame].size.width, scrollView.contentSize.height);
    }
    
    if (scrollView.contentSize.height-scrollView.contentOffset.y>=scrollView.frame.size.height) {
        return;
    }
    
    if (scrollView.isDragging) {
        if (scrollView.contentSize.height>scrollView.frame.size.height) {
            if (_state == KKFDraggingRefreshState_Pulling
                && (scrollView.contentSize.height-scrollView.contentOffset.y<scrollView.frame.size.height)
                && (scrollView.contentSize.height-scrollView.contentOffset.y>scrollView.frame.size.height-EdgeInsets_Y)) {
                
                [self setState:KKFDraggingRefreshState_Normal];
            }
            else if (_state == KKFDraggingRefreshState_Normal
                     && (scrollView.contentSize.height-scrollView.contentOffset.y<scrollView.frame.size.height)
                     && (scrollView.contentSize.height-scrollView.contentOffset.y<scrollView.frame.size.height-EdgeInsets_Y)) {
                
                [self setState:KKFDraggingRefreshState_Pulling];
            }
        }
        else{
            if (_state == KKFDraggingRefreshState_Pulling
                && (scrollView.contentOffset.y>0)
                && (scrollView.contentOffset.y<EdgeInsets_Y)) {
                
                [self setState:KKFDraggingRefreshState_Normal];
            }
            else if (_state == KKFDraggingRefreshState_Normal
                     && (scrollView.contentOffset.y>EdgeInsets_Y)) {
                
                [self setState:KKFDraggingRefreshState_Pulling];
            }
        }
	}
}

- (void)refreshScrollViewDidEndDragging:(UIScrollView *)scrollView {
    if (scrollView.contentSize.height-scrollView.contentOffset.y>=scrollView.frame.size.height) {
        return;
    }
    
    if (_state != KKFDraggingRefreshState_Loading) {
        if (scrollView.contentSize.height>scrollView.frame.size.height) {
            if (scrollView.contentSize.height-scrollView.contentOffset.y<=scrollView.frame.size.height-EdgeInsets_Y) {
                [self setState:KKFDraggingRefreshState_Loading];
                [UIView beginAnimations:nil context:NULL];
                [UIView setAnimationDuration:0.2];
                UIEdgeInsets edgeInsets = scrollView.contentInset;
                [scrollView setContentInset:UIEdgeInsetsMake(edgeInsets.top,
                                                             0.0f,
                                                             EdgeInsets_Y,
                                                             0.0f)];
                [UIView commitAnimations];
                
                Class currentClass = object_getClass(_delegate);
                if ((currentClass == delegateClass) && [_delegate respondsToSelector:@selector(refreshTableFooterDraggingViewDidTriggerRefresh:)]) {
                    [_delegate refreshTableFooterDraggingViewDidTriggerRefresh:self];
                }
            }
        }
        else{
            if (scrollView.contentOffset.y>EdgeInsets_Y) {
                
                [self setState:KKFDraggingRefreshState_Loading];
                [UIView beginAnimations:nil context:NULL];
                [UIView setAnimationDuration:0.2];
                UIEdgeInsets edgeInsets = scrollView.contentInset;
                [scrollView setContentInset:UIEdgeInsetsMake(edgeInsets.top,
                                                             0.0f,
                                                             scrollView.frame.size.height-scrollView.contentSize.height+EdgeInsets_Y,
                                                             0.0f)];
                [UIView commitAnimations];
                Class currentClass = object_getClass(_delegate);
                if ((currentClass == delegateClass) && [_delegate respondsToSelector:@selector(refreshTableFooterDraggingViewDidTriggerRefresh:)]) {
                    [_delegate refreshTableFooterDraggingViewDidTriggerRefresh:self];
                }
            }
        }
        
    }
    
    //    [MediaController playMedia:@"playend" type:@"wav" loopsNum:0];
}

- (void)refreshScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView text:(NSString*)aText{
    if (scrollView.contentSize.height < scrollView.frame.size.height) {
        self.frame = CGRectMake(0, scrollView.frame.size.height, [[UIScreen mainScreen] applicationFrame].size.width, scrollView.frame.size.height);
    }
    else {
        self.frame = CGRectMake(0, scrollView.contentSize.height,[[UIScreen mainScreen] applicationFrame].size.width, scrollView.contentSize.height);
    }
    
    [self setState:KKFDraggingRefreshState_Normal];
    [self finished:scrollView];
}

- (void)refreshScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView{
    if (scrollView.contentSize.height < scrollView.frame.size.height) {
        self.frame = CGRectMake(0, scrollView.frame.size.height, [[UIScreen mainScreen] applicationFrame].size.width, scrollView.frame.size.height);
    }
    else {
        self.frame = CGRectMake(0, scrollView.contentSize.height,[[UIScreen mainScreen] applicationFrame].size.width, scrollView.contentSize.height);
    }
        
    [self setState:KKFDraggingRefreshState_Normal];
    [self finished:scrollView];
}

- (void)finished:(UIScrollView*)scrollView{
    
    [UIView animateWithDuration:0.3 animations:^{
        UIEdgeInsets edgeInsets = scrollView.contentInset;
        [scrollView setContentInset:UIEdgeInsetsMake(edgeInsets.top, 0.0f,0.0f, 0.0f)];
    } completion:^(BOOL finished) {
        
    }];
}

@end


#pragma mark ==================================================
#pragma mark == UIScrollView扩展
#pragma mark ==================================================
@implementation UIScrollView (KKUIScrollViewFooterDExtension)
@dynamic refreshFooterDragging;
@dynamic haveFooterDragging;

- (void)setHaveFooter:(NSNumber *)haveFooterDragging{
    objc_setAssociatedObject(self, @"haveFooterDragging", haveFooterDragging, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(NSNumber *)haveFooterDragging{
    return objc_getAssociatedObject(self, @"haveFooterDragging");
}

- (void)setRefreshFooterDragging:(KKRefreshFooterDraggingView *)refreshFooterDragging{
    objc_setAssociatedObject(self, @"refreshFooterDragging", refreshFooterDragging, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(KKRefreshFooterDraggingView *)refreshFooterDragging{
    if ([objc_getAssociatedObject(self, @"haveFooterDragging") boolValue]) {
        return objc_getAssociatedObject(self, @"refreshFooterDragging");
    }
    else{
        return nil;
    }
}

/*开启 加载更多*/
- (void)showRefreshFooterDraggingWithDelegate:(id<KKRefreshFooterDraggingViewDelegate>)aDelegate{
    if (!self.refreshFooterDragging) {
        KKRefreshFooterDraggingView *footerView = [[KKRefreshFooterDraggingView alloc] initWithScrollView:self delegate:aDelegate];
        self.haveFooter = [NSNumber numberWithBool:YES];
        [footerView release];
    }
}

/*关闭 加载更多*/
- (void)hideRefreshFooterDragging{
    if (self.refreshFooterDragging) {
        KKRefreshFooterDraggingView *footer = self.refreshFooterDragging;
        objc_removeAssociatedObjects(self.refreshFooterDragging);
        [footer removeFromSuperview];
        self.haveFooter = [NSNumber numberWithBool:NO];
    }
}

/*开始 加载更多*/
- (void)startRefreshFooterDragging{
    if (self.refreshFooterDragging) {
        [self.refreshFooterDragging startLoadingMore];
    }
}


/*停止 加载更多*/
- (void)stopRefreshFooterDragging:(NSString*)aText{
    if (self.refreshFooterDragging) {
        [self.refreshFooterDragging refreshScrollViewDataSourceDidFinishedLoading:self text:aText];
    }
}

- (void)stopRefreshFooterDragging{
    if (self.refreshFooterDragging) {
        [self.refreshFooterDragging refreshScrollViewDataSourceDidFinishedLoading:self];
    }
}



@end


