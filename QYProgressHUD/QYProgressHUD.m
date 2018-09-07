//
//  QYProgressHUD.m
//
//
//  Created by Joeyoung on 2018/8/22.
//  Copyright © 2018年 Joeyoung. All rights reserved.
//

#import "QYProgressHUD.h"

#define kProgressHUD_W            110.f
#define kProgressHUD_cornerRadius 14.f
#define kProgressHUD_alpha        0.9f
#define kBackgroundView_alpha     0.1f
#define kAnimationInterval        0.2f
#define kTransformScale           0.9f
static QYProgressHUD *_instanceObj = nil;
@interface QYProgressHUD ()
@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;
@property (nonatomic, strong) UIView *foregroundView;
@end

@implementation QYProgressHUD

#pragma mark - Singleton
+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!_instanceObj) _instanceObj = [[self alloc] initWithFrame:[UIScreen mainScreen].bounds];
    });
    return _instanceObj;
}
+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!_instanceObj) _instanceObj = [super allocWithZone:zone];
    });
    return _instanceObj;
}
- (id)copyWithZone:(NSZone *)zone {
    return self;
}
- (id)mutableCopyWithZone:(NSZone *)zone {
    return self;
}
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

#pragma mark - Event
+ (void)show {
    [[self sharedInstance] qy_startAnimating];
}
+ (void)dismiss {
    [[self sharedInstance] qy_stopAnimating];
}

#pragma mark - Animation
- (void)qy_startAnimating {
    __weak QYProgressHUD *weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        __strong QYProgressHUD *strongSelf = weakSelf;
        if (strongSelf) {
            strongSelf.hidden = NO;
            // Add subviews to superview.
            [strongSelf addSubview:strongSelf.backgroundView];
            [strongSelf addSubview:strongSelf.foregroundView];
            [strongSelf.foregroundView addSubview:strongSelf.activityIndicator];
            strongSelf.backgroundView.userInteractionEnabled = NO;
            // Show animation.
            strongSelf.foregroundView.transform = CGAffineTransformMakeScale(kTransformScale, kTransformScale);
            strongSelf.backgroundView.alpha = 0.f;
            strongSelf.foregroundView.alpha = 0.f;
            [UIView animateWithDuration:kAnimationInterval animations:^{
                strongSelf.foregroundView.transform = CGAffineTransformMakeScale(1.f, 1.f);
                strongSelf.backgroundView.alpha = kBackgroundView_alpha;
                strongSelf.foregroundView.alpha = kProgressHUD_alpha;
                [strongSelf.activityIndicator startAnimating];
            }];
        }
    });
}
- (void)qy_stopAnimating {
    __weak QYProgressHUD *weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        __strong QYProgressHUD *strongSelf = weakSelf;
        if (strongSelf) {
            // Dissmass animation.
            [UIView animateWithDuration:kAnimationInterval animations:^{
                strongSelf.foregroundView.transform = CGAffineTransformMakeScale(kTransformScale, kTransformScale);
                strongSelf.backgroundView.alpha = 0.f;
                strongSelf.foregroundView.alpha = 0.f;
            } completion:^(BOOL finished) {
                [strongSelf.activityIndicator stopAnimating];
                // Remove subviews from superview.
                if (strongSelf.activityIndicator.superview) [strongSelf.activityIndicator removeFromSuperview];
                if (strongSelf.foregroundView.superview) [strongSelf.foregroundView removeFromSuperview];
                if (strongSelf.backgroundView.superview) [strongSelf.backgroundView removeFromSuperview];
                strongSelf.hidden = YES;
                strongSelf.backgroundView.userInteractionEnabled = YES;
            }];
        }
    });
}

#pragma mark - Getter
- (UIView *)backgroundView {
    if (!_backgroundView) {
        _backgroundView = [[UIView alloc] initWithFrame:self.bounds];
        _backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _backgroundView.backgroundColor = [UIColor whiteColor];
        _backgroundView.alpha = kBackgroundView_alpha;
    }
    return _backgroundView;
}
- (UIView *)foregroundView {
    if (!_foregroundView) {
        _foregroundView = [[UIView alloc] init];
        _foregroundView.bounds = CGRectMake(0, 0, kProgressHUD_W, kProgressHUD_W);
        _foregroundView.center = self.center;
        _foregroundView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
        _foregroundView.backgroundColor = [UIColor darkGrayColor];
        _foregroundView.alpha = kProgressHUD_alpha;
        _foregroundView.layer.cornerRadius = kProgressHUD_cornerRadius;
        _foregroundView.layer.masksToBounds = YES;
    }
    return _foregroundView;
}
- (UIActivityIndicatorView *)activityIndicator {
    if (!_activityIndicator) {
        _activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        _activityIndicator.frame = self.foregroundView.bounds;
        _activityIndicator.backgroundColor = [UIColor clearColor];
    }
    return _activityIndicator;
}

@end
