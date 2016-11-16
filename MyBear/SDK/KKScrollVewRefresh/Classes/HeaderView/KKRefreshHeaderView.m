//
//  KKRefreshHeaderView.m
//  TableViewRefreshDemo
//
//  Created by bear on 13-6-27.
//  Copyright (c) 2013年 可可工作室. All rights reserved.
//

#import "KKRefreshHeaderView.h"
#define TEXT_COLOR  [UIColor colorWithRed:0.49f green:0.50f blue:0.49f alpha:1.00f]
#define TEXT_FONT   [UIFont systemFontOfSize:14]
#define FLIP_ANIMATION_DURATION 0.18f
#define EdgeInsets_Y 50.0f

@interface KKRefreshHeaderView ()

- (id)initWithScrollView:(UIScrollView*)scrollView delegate:(id<KKRefreshHeaderViewDelegate>)aDelegate;

- (void)startRefresh;

- (void)refreshScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView text:(NSString*)aText;
- (void)refreshScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView;

@end


@implementation KKRefreshHeaderView
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
- (id)initWithScrollView:(UIScrollView*)scrollView delegate:(id<KKRefreshHeaderViewDelegate>)aDelegate{
    CGRect frame = scrollView.bounds;
    if(self = [super initWithFrame:CGRectMake(0, -frame.size.height, frame.size.width, frame.size.height)]) {
        
        _delegate = aDelegate;
        delegateClass = object_getClass(_delegate);

        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.backgroundColor = [UIColor colorWithRed:0.97f green:0.97f blue:0.97f alpha:1.00f];
                
        _statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(20.0f, frame.size.height - 48.0f, self.frame.size.width, 20.0f)];
        _statusLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _statusLabel.font = TEXT_FONT;
        _statusLabel.textColor = TEXT_COLOR;
        _statusLabel.backgroundColor = [UIColor clearColor];
        _statusLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_statusLabel];
        
        _arrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(65.0f, frame.size.height - 50.0f, 15.0f, 40.0f)];
        NSString *filepath = [NSString stringWithFormat:@"%@/KKScrollVewRefresh.bundle/whiteArrow.png", [[NSBundle mainBundle] bundlePath]];
        UIImage *image = [UIImage imageWithContentsOfFile:filepath];
        _arrowImageView.image = image;
        _arrowImageView.image = KKThemeImage(@"btn_Refresh");
        [self addSubview:_arrowImageView];
        
        _activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _activityView.frame = CGRectMake(65.0f, frame.size.height - 38.0f, 20.0f, 20.0f);
        [self addSubview:_activityView];
        
        [scrollView addSubview:self];
        [scrollView setValue:self forKey:@"refreshHeader"];
        
        [self setState:KKHPullRefreshState_Normal];
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

- (void)setRefreshImageStyle:(KKHPullRefreshImageStyle)refreshImageStyle{
    _refreshImageStyle = refreshImageStyle;
    [self reload];
}

- (void)reload{
    if (_refreshImageCustomer) {
        _arrowImageView.image = _refreshImageCustomer;
    }
    else{
        if (_refreshImageStyle==KKHPullRefreshImageStyle_Default) {
            NSString *filepath = [NSString stringWithFormat:@"%@/KKScrollVewRefresh.bundle/whiteArrow.png", [[NSBundle mainBundle] bundlePath]];
            UIImage *image = [UIImage imageWithContentsOfFile:filepath];
            _arrowImageView.image = image;
            _arrowImageView.image = KKThemeImage(@"btn_Refresh");
        }
        else if (_refreshImageStyle==KKHPullRefreshImageStyle_Black){
            NSString *filepath = [NSString stringWithFormat:@"%@/KKScrollVewRefresh.bundle/blackArrow.png", [[NSBundle mainBundle] bundlePath]];
            UIImage *image = [UIImage imageWithContentsOfFile:filepath];
            _arrowImageView.image = image;
            _arrowImageView.image = KKThemeImage(@"btn_Refresh");
        }
        else if (_refreshImageStyle==KKHPullRefreshImageStyle_Blue){
            NSString *filepath = [NSString stringWithFormat:@"%@/KKScrollVewRefresh.bundle/blueArrow.png", [[NSBundle mainBundle] bundlePath]];
            UIImage *image = [UIImage imageWithContentsOfFile:filepath];
            _arrowImageView.image = image;
            _arrowImageView.image = KKThemeImage(@"btn_Refresh");
        }
        else if (_refreshImageStyle==KKHPullRefreshImageStyle_Gray){
            NSString *filepath = [NSString stringWithFormat:@"%@/KKScrollVewRefresh.bundle/grayArrow.png", [[NSBundle mainBundle] bundlePath]];
            UIImage *image = [UIImage imageWithContentsOfFile:filepath];
            _arrowImageView.image = image;
            _arrowImageView.image = KKThemeImage(@"btn_Refresh");
        }
        else if (_refreshImageStyle==KKHPullRefreshImageStyle_White){
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
- (void)startRefresh{
    UIView *v = self.superview;
    if ([v isKindOfClass:[UIScrollView class]]) {
        UIScrollView *scr = (UIScrollView*)v;
        if (!(_state == KKHPullRefreshState_Loading)) {
            
            Class currentClass = object_getClass(_delegate);
            if ((currentClass == delegateClass) && [_delegate respondsToSelector:@selector(refreshTableHeaderDidTriggerRefresh:)]) {
                [_delegate refreshTableHeaderDidTriggerRefresh:self];
            }
            [self setState:KKHPullRefreshState_Loading];
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:0.2];
            scr.contentInset = UIEdgeInsetsMake(60.0f, 0.0f, 0.0f, 0.0f);
            [UIView commitAnimations];
        }
        [scr setContentOffset:CGPointMake(0, -EdgeInsets_Y) animated:YES];
    }
}

#pragma mark ==================================================
#pragma mark == 状态设置
#pragma mark ==================================================
- (void)setState:(KKHPullRefreshState)aState{
    switch (aState) {
        case KKHPullRefreshState_Pulling:{
            if (_statusTextForPulling) {
                _statusLabel.text = _statusTextForPulling;
            }
            else{
                _statusLabel.text = @"释放更新";
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
        }
        case KKHPullRefreshState_Normal:{
            if (_statusTextForNormal) {
                _statusLabel.text = _statusTextForNormal;
            }
            else{
                _statusLabel.text = @"下拉刷新";
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
        }
        case KKHPullRefreshState_Loading:{
            if (_statusTextForLoading) {
                _statusLabel.text = _statusTextForLoading;
            }
            else{
                _statusLabel.text = @"加载中…";
            }
            [_activityView startAnimating];
            _arrowImageView.hidden = YES;
            
            [self reloadSubviewsFrame];
            break;
        }
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
        if (size01.height>arrowImageSize.height) {
            _activityView.frame = CGRectMake((self.frame.size.width-size01.width-arrowImageSize.width-5)/2.0,
                                             self.frame.size.height-15-size01.height+(size01.height-arrowImageSize.height)/2.0,
                                             arrowImageSize.width,
                                             arrowImageSize.height);
            _statusLabel.frame = CGRectMake(CGRectGetMaxX(_activityView.frame)+5,
                                            self.frame.size.height-15-size01.height,
                                            size01.width,
                                            size01.height);
        }
        else{
            _activityView.frame = CGRectMake((self.frame.size.width-size01.width-arrowImageSize.width-5)/2.0,
                                             self.frame.size.height-15-arrowImageSize.height,
                                             arrowImageSize.width,
                                             arrowImageSize.height);
            _statusLabel.frame = CGRectMake(CGRectGetMaxX(_activityView.frame)+5,
                                            self.frame.size.height-15-arrowImageSize.height+(arrowImageSize.height-size01.height)/2.0,
                                            size01.width,
                                            size01.height);
        }
    }
    else{
        _statusLabel.font = TEXT_FONT;
        
        CGSize size01 = [_statusLabel.text sizeWithFont:_statusLabel.font maxSize:CGSizeMake(self.frame.size.width, 100)];
        
        CGSize arrowImageSize = _arrowImageView.image.size;
        _arrowImageView.frame = CGRectMake((self.frame.size.width-size01.width-arrowImageSize.width)/2.0,
                                         self.frame.size.height-15-arrowImageSize.height,
                                         arrowImageSize.width,
                                         arrowImageSize.height);
        _statusLabel.frame = CGRectMake(CGRectGetMaxX(_arrowImageView.frame),
                                        self.frame.size.height-15-arrowImageSize.width+(arrowImageSize.height-size01.height)/2.0,
                                        size01.width,
                                        size01.height);
    }
}

#pragma mark ==================================================
#pragma mark == 滚动
#pragma mark ==================================================
- (void)refreshScrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.y>=0) {
        return;
    }
    
    if (_state == KKHPullRefreshState_Loading) {
        CGFloat offset = MAX(scrollView.contentOffset.y * -1, 0);
        offset = MIN(offset, 60);
        UIEdgeInsets edgeInsets = scrollView.contentInset;
        [scrollView setContentInset:UIEdgeInsetsMake(offset, 0.0f, edgeInsets.bottom, 0.0f)];
    }
    else if (scrollView.isDragging) {
        if (_state == KKHPullRefreshState_Pulling && scrollView.contentOffset.y > -EdgeInsets_Y && scrollView.contentOffset.y < 0.0f) {
            [self setState:KKHPullRefreshState_Normal];
        } else if (_state == KKHPullRefreshState_Normal && scrollView.contentOffset.y < -EdgeInsets_Y) {
            [self setState:KKHPullRefreshState_Pulling];
        }
        
        if (scrollView.contentInset.top != 0) {
            scrollView.contentInset = UIEdgeInsetsZero;
        }
    }
}

- (void)refreshScrollViewDidEndDragging:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.y>=0) {
        return;
    }
    
    if (_state == KKHPullRefreshState_Loading) {
        [self setState:KKHPullRefreshState_Loading];
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.2];
        UIEdgeInsets edgeInsets = scrollView.contentInset;
        [scrollView setContentInset:UIEdgeInsetsMake(60.0f, 0.0f, edgeInsets.bottom, 0.0f)];
        [UIView commitAnimations];
    }
    else{
        if (scrollView.contentOffset.y <= - EdgeInsets_Y && !(_state == KKHPullRefreshState_Loading)) {
            Class currentClass = object_getClass(_delegate);
            if ((currentClass == delegateClass) && [_delegate respondsToSelector:@selector(refreshTableHeaderDidTriggerRefresh:)]) {
                [_delegate refreshTableHeaderDidTriggerRefresh:self];
            }
            [self setState:KKHPullRefreshState_Loading];
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:0.2];
            UIEdgeInsets edgeInsets = scrollView.contentInset;
            [scrollView setContentInset:UIEdgeInsetsMake(60.0f, 0.0f, edgeInsets.bottom, 0.0f)];
            [UIView commitAnimations];
        }
    }
    //    [MediaController playMedia:@"playend" type:@"wav" loopsNum:0];
}


- (void)refreshScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView text:(NSString*)aText{
    [self setState:KKHPullRefreshState_Normal];
    [self performSelector:@selector(finished:) withObject:scrollView afterDelay:0.5];
}

- (void)refreshScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView{
    [self setState:KKHPullRefreshState_Normal];
    [self performSelector:@selector(finished:) withObject:scrollView afterDelay:0.5];
}


- (void)finished:(UIScrollView*)scrollView{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    UIEdgeInsets edgeInsets = scrollView.contentInset;
    [scrollView setContentInset:UIEdgeInsetsMake(0.0f, 0.0f, edgeInsets.bottom, 0.0f)];
    [UIView commitAnimations];
}


@end
#pragma mark ==================================================
#pragma mark == UIScrollView扩展
#pragma mark ==================================================
@implementation UIScrollView (KKUIScrollViewHeaderExtension)
@dynamic refreshHeader;
@dynamic haveHeader;

- (void)setHaveHeader:(NSNumber *)haveHeader{
    objc_setAssociatedObject(self, @"haveHeader", haveHeader, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(NSNumber *)haveHeader{
    return objc_getAssociatedObject(self, @"haveHeader");
}

- (void)setRefreshHeader:(KKRefreshHeaderView *)refreshHeader{
    objc_setAssociatedObject(self, @"refreshHeader", refreshHeader, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(KKRefreshHeaderView *)refreshHeader{
    if ([objc_getAssociatedObject(self, @"haveHeader") boolValue]) {
        return objc_getAssociatedObject(self, @"refreshHeader");
    }
    else{
        return nil;
    }
}

/*开启 刷新数据*/
- (void)showRefreshHeaderWithDelegate:(id<KKRefreshHeaderViewDelegate>)aDelegate{
    if (!self.refreshHeader) {
        KKRefreshHeaderView *headView = [[KKRefreshHeaderView alloc] initWithScrollView:self delegate:aDelegate];
        //        UIView *headView = [[UIView alloc] initWithFrame:self.bounds];
        //        headView.backgroundColor = [UIColor redColor];
        //        [self addSubview:headView];
        self.haveHeader = [NSNumber numberWithBool:YES];
        [headView release];
    }
}

/*关闭 刷新数据*/
- (void)hideRefreshHeader{
    if (self.refreshHeader) {
        KKRefreshHeaderView *header = self.refreshHeader;
        objc_removeAssociatedObjects(self.refreshHeader);
        [header removeFromSuperview];
        self.haveHeader = [NSNumber numberWithBool:NO];
    }
}

/*开始 刷新数据*/
- (void)startRefreshHeader{
    if (self.refreshHeader) {
        [self.refreshHeader startRefresh];
    }
}

/*停止 刷新数据*/
- (void)stopRefreshHeader:(NSString*)aText{
    if (self.refreshHeader) {
        [self.refreshHeader refreshScrollViewDataSourceDidFinishedLoading:self text:aText];
    }
}

- (void)stopRefreshHeader{
    if (self.refreshHeader) {
        [self.refreshHeader refreshScrollViewDataSourceDidFinishedLoading:self];
    }
}


@end
























