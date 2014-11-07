//
//  TYMActivityIndicatorView.m
//  TYMActivityIndicatorView
//
//  Created by Yiming Tang on 14-2-9.
//  Copyright (c) 2014 Yiming Tang. All rights reserved.
//

#import "TYMActivityIndicatorView.h"

@interface TYMActivityIndicatorView ()

@property (nonatomic, assign) BOOL animating;
@property (nonatomic, strong) UIImageView *indicatorImageView;
@property (nonatomic, strong) UIImageView *backgroundImageView;

@end

@implementation TYMActivityIndicatorView

+ (instancetype) showTYActiveIndicatorViewAddTo:(UIView *)view
{
    TYMActivityIndicatorView *activityIndicatorView = [[TYMActivityIndicatorView alloc] initWithActivityIndicatorStyle:TYMActivityIndicatorViewStyleNormal];
    
    activityIndicatorView.autoresizingMask = (UIViewAutoresizingFlexibleTopMargin |
                        UIViewAutoresizingFlexibleBottomMargin |
                        UIViewAutoresizingFlexibleLeftMargin |
                        UIViewAutoresizingFlexibleRightMargin);
    
    activityIndicatorView.hidesWhenStopped = YES;
    activityIndicatorView.center =  view.center;
    activityIndicatorView.backgroundColor = [UIColor clearColor];
    activityIndicatorView.fullRotationDuration = 0.4f;

    if (view) {
        [view addSubview:activityIndicatorView];
        [activityIndicatorView startAnimating];
    }
   
    return activityIndicatorView;
    
}

+ (NSInteger) hideAllTYActiveIndicatorViewFromView :(UIView *)view animated:(BOOL) animated {
    if (view) {
        NSUInteger count = 0;
        
        for (UIView *aView in view.subviews)
        {
            if ([aView isKindOfClass:self]) {
                [(TYMActivityIndicatorView*)aView hideUsingAnimation:animated];
                count++;
            }
            
        }
        
        return count;
    }
    
    return 0;
}

- (void)hideUsingAnimation:(BOOL)animated {
    if (animated) {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.30];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(animationFinished:finished:context:)];
        
        self.transform = CGAffineTransformConcat(self->rotationTransform, CGAffineTransformMakeScale(0.5f, 0.5f));
        
        self.alpha = 0.02f;
        [UIView commitAnimations];
    } else {
        [self  removeFromSuperview];
    }
    
    
    
    }

- (void) animationFinished:(NSString *)animationID finished:(BOOL)finished context:(void*)context {
        [self  removeFromSuperview];
    }
    
#pragma mark - Accessors

- (UIImageView *)backgroundImageView
{
    if (!_backgroundImageView) {
        _backgroundImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _backgroundImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    return _backgroundImageView;
}


- (UIImageView *)indicatorImageView
{
    if (!_indicatorImageView) {
        _indicatorImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _indicatorImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    return _indicatorImageView;
}


- (void)setBackgroundImage:(UIImage *)backgroundImage
{
    _backgroundImage = backgroundImage;
    self.backgroundImageView.image = _backgroundImage;
    [self setNeedsLayout];
}


- (void)setIndicatorImage:(UIImage *)indicatorImage
{
    _indicatorImage = indicatorImage;
    self.indicatorImageView.image = _indicatorImage;
    [self setNeedsLayout];
}


- (void)setActivityIndicatorViewStyle:(TYMActivityIndicatorViewStyle)activityIndicatorViewStyle
{
    _activityIndicatorViewStyle = activityIndicatorViewStyle;
    
    NSString *backgroundImageName;
    NSString *indicatorImageName;
    switch (_activityIndicatorViewStyle) {
        case TYMActivityIndicatorViewStyleNormal:
            backgroundImageName = @"TYMActivityIndicatorView.bundle/background";
            indicatorImageName = @"TYMActivityIndicatorView.bundle/spinner";
            break;
        case TYMActivityIndicatorViewStyleLarge:
            backgroundImageName = @"TYMActivityIndicatorView.bundle/background-large";
            indicatorImageName = @"TYMActivityIndicatorView.bundle/spinner-large";
            break;
    }
    
    _backgroundImage = [UIImage imageNamed:backgroundImageName];
    _indicatorImage = [UIImage imageNamed:indicatorImageName];
    self.backgroundImageView.image = _backgroundImage;
    self.indicatorImageView.image = _indicatorImage;
    [self setNeedsLayout];
}


- (BOOL)isAnimating
{
    return self.animating;
}


#pragma mark - UIView

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder])) {
        [self _initialize];
    }
    return self;
}


- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame])) {
        [self _initialize];
    }
    return self;
}


- (id)initWithActivityIndicatorStyle:(TYMActivityIndicatorViewStyle)style
{
    if ((self = [self initWithFrame:CGRectZero])) {
        self.activityIndicatorViewStyle = style;
        [self sizeToFit];
    }
    
    return self;
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGSize size = self.bounds.size;
    CGSize backgroundImageSize = self.backgroundImageView.image.size;
    CGSize indicatorImageSize = self.indicatorImageView.image.size;
    
    // Center
    self.backgroundImageView.frame = CGRectMake(roundf((size.width - backgroundImageSize.width) / 2.0f), roundf((size.height - backgroundImageSize.height) / 2.0f), backgroundImageSize.width, backgroundImageSize.height);
    self.indicatorImageView.frame = CGRectMake(roundf((size.width - indicatorImageSize.width) / 2.0f), roundf((size.height - indicatorImageSize.height) / 2.0f), indicatorImageSize.width, indicatorImageSize.height);
}


- (CGSize)sizeThatFits:(CGSize)size
{
    CGSize backgroundImageSize = self.backgroundImageView.image.size;
    CGSize indicatorImageSize = self.indicatorImageView.image.size;
    
    return CGSizeMake(MAX(backgroundImageSize.width, indicatorImageSize.width), MAX(backgroundImageSize.height, indicatorImageSize.height));
}


#pragma mark - Public

- (void)startAnimating
{
    if (self.animating) return;
    
    self.animating = YES;
    self.hidden = NO;
    [self _rotateImageViewFrom:0.0f to:M_PI*2 duration:self.fullRotationDuration repeatCount:HUGE_VALF];
}


- (void)stopAnimating
{
    if (!self.animating) return;
    
    self.animating = NO;
    [self.indicatorImageView.layer removeAllAnimations];
    if (self.hidesWhenStopped) {
        self.hidden = YES;
    }
}


- (void)setProgress:(CGFloat)progress
{
    if (progress < 0.0f || progress > 1.0f) return;
    if (fabsf(_progress - progress) < self.minProgressUnit) return;
    
    CGFloat fromValue = M_PI * 2 * _progress;
    CGFloat toValue = M_PI * 2 * progress;
    [self _rotateImageViewFrom:fromValue to:toValue duration:0.15f repeatCount:0];
    
    _progress = progress;
}


#pragma mark - Private

- (void)_initialize
{
    self.userInteractionEnabled = NO;
    
    _animating = NO;
    _hidesWhenStopped = YES;
    _fullRotationDuration = 1.0f;
    _minProgressUnit = 0.01f;
    _progress = 0.0f;
    
    self.hidden = YES;
    
    rotationTransform = CGAffineTransformIdentity;
    
    [self addSubview:self.backgroundImageView];
    [self addSubview:self.indicatorImageView];
}


- (void)_rotateImageViewFrom:(CGFloat)fromValue to:(CGFloat)toValue duration:(CFTimeInterval)duration repeatCount:(CGFloat)repeatCount
{
    CABasicAnimation *rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.fromValue = [NSNumber numberWithFloat:fromValue];
    rotationAnimation.toValue = [NSNumber numberWithFloat:toValue];
    rotationAnimation.duration = duration;
    rotationAnimation.RepeatCount = repeatCount;
    rotationAnimation.removedOnCompletion = NO;
    rotationAnimation.fillMode = kCAFillModeForwards;
    [self.indicatorImageView.layer addAnimation:rotationAnimation forKey:@"rotation"];
}

@end
