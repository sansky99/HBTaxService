//
//  MRCircularProgressView.m
//  MRProgress
//
//  Created by Marius Rackwitz on 10.10.13.
//  Copyright (c) 2013 Marius Rackwitz. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "MRCircularProgressView.h"
#import "MRProgressHelper.h"
#import "MRWeakProxy.h"


@interface MRCircularProgressView ()

@property (nonatomic, strong, readwrite) NSNumberFormatter *numberFormatter;

@property (nonatomic, weak, readwrite) UILabel *valueLabel;
@property (nonatomic, weak, readwrite) UILabel *labDescription;
@property (nonatomic, weak, readwrite) UIView *stopView;

@property (nonatomic, assign, readwrite) float fromProgress;
@property (nonatomic, assign, readwrite) float toProgress;
@property (nonatomic, assign, readwrite) CFTimeInterval startTime;
@property (nonatomic, strong, readwrite) CADisplayLink *displayLink;

@end


@implementation MRCircularProgressView

@synthesize hideProgressValue;


- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInit];
    }
    return self;
}

+ (Class)layerClass {
    return CAShapeLayer.class;
}

- (CAShapeLayer *)shapeLayer {
    return (CAShapeLayer *)self.layer;
}

- (void)commonInit {
    self.foreColor = [UIColor colorWithRed:44/255.0 green:152/255.0 blue:236/255.0 alpha:1];
    self.animationDuration = 0.3;
    self.progress = 0;
   
    NSNumberFormatter *numberFormatter = [NSNumberFormatter new];
    self.numberFormatter = numberFormatter;
    numberFormatter.numberStyle = NSNumberFormatterPercentStyle;
    numberFormatter.locale = NSLocale.currentLocale;
    
//    self.layer.borderWidth = 2.0f;
    self.layer.cornerRadius = 5;
    self.layer.shadowColor =  [[UIColor lightGrayColor] CGColor];
    
    self.shapeLayer.lineWidth = 3.0f;
    self.shapeLayer.fillColor = UIColor.clearColor.CGColor;
    self.shapeLayer.strokeColor = [self.foreColor CGColor];
    
    UILabel *valueLabel = [UILabel new];
    self.valueLabel = valueLabel;
//    valueLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
    valueLabel.font = [UIFont systemFontOfSize:[UIFont smallSystemFontSize]];
    valueLabel.textColor = self.foreColor;
    valueLabel.textAlignment = NSTextAlignmentCenter;
//    [self addSubview:valueLabel];
    
    valueLabel = [UILabel new];
    self.labDescription = valueLabel;
//    valueLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
    valueLabel.textColor = self.foreColor;
    valueLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:valueLabel];
 }

- (void)layoutSubviews {
    [super layoutSubviews];
    
    int nW = self.bounds.size.height / 3;
    
    CGRect valueLabelRect = CGRectMake(nW/2, nW, nW, nW);
    self.valueLabel.frame = valueLabelRect;
    
    valueLabelRect = CGRectMake(nW * 3, nW, self.bounds.size.width - nW * 3, nW);
    self.labDescription.frame = valueLabelRect;

    //    self.layer.cornerRadius = self.frame.size.width / 2.0f;
    self.shapeLayer.path = [self layoutPath].CGPath;
}

- (UIBezierPath *)layoutPath {
    const double TWO_M_PI = 2.0 * M_PI;
    const double startAngle = 0.75 * TWO_M_PI;
    const double endAngle = startAngle + TWO_M_PI * self.progress;
    
    CGFloat width = self.frame.size.height / 2;
    return [UIBezierPath bezierPathWithArcCenter:CGPointMake(width, width)
                                          radius:width/2.0f - 2.5f
                                      startAngle:startAngle
                                        endAngle:endAngle
                                       clockwise:YES];
    
//    CGFloat width = self.frame.size.width;
//    return [UIBezierPath bezierPathWithArcCenter:CGPointMake(width/2.0f, width/2.0f)
//                                          radius:width/2.0f - 2.5f
//                                      startAngle:startAngle
//                                        endAngle:endAngle
//                                       clockwise:YES];
}



//- (void)didTouchUpInside {
//    [UIView animateWithDuration:0.2 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
//        [self layoutSubviews];
//    } completion:nil];
//}

#pragma mark - Control progress

- (void)setProgress:(float)progress {
    NSParameterAssert(progress >= 0 && progress <= 1);
    
    // Stop running animation
    if (self.displayLink) {
        [self.displayLink removeFromRunLoop:NSRunLoop.mainRunLoop forMode:NSRunLoopCommonModes];
        self.displayLink = nil;
    }
    
    _progress = progress;
    
    [self updateProgress];
}

- (void)updateProgress {
    [self updatePath];
    [self updateLabel];
}

- (void)updatePath {
    self.shapeLayer.path = [self layoutPath].CGPath;
}

- (void)updateLabel {
    self.valueLabel.text = [self.numberFormatter stringFromNumber:@(self.progress)];
}

- (void)setProgress:(float)progress animated:(BOOL)animated {
    if (animated) {
        if (self.progress == progress) {
            return;
        }
        
        if (self.displayLink) {
            // Reuse current display link and manipulate animation params
            self.startTime = CACurrentMediaTime();
            self.fromProgress = self.progress;
            self.toProgress = progress;
        } else {
            [self animateToProgress:progress];
        }
    } else {
        self.progress = progress;
    }
}

- (void)setAnimationDuration:(CFTimeInterval)animationDuration {
    NSParameterAssert(animationDuration > 0);
    _animationDuration = animationDuration;
}

- (void)animateToProgress:(float)progress {
    self.fromProgress = self.progress;
    self.toProgress = progress;
    self.startTime = CACurrentMediaTime();
    
    [self.displayLink removeFromRunLoop:NSRunLoop.mainRunLoop forMode:NSRunLoopCommonModes];
    self.displayLink = [CADisplayLink displayLinkWithTarget:[MRWeakProxy weakProxyWithTarget:self] selector:@selector(animateFrame:)];
    [self.displayLink addToRunLoop:NSRunLoop.mainRunLoop forMode:NSRunLoopCommonModes];
}

- (void)animateFrame:(CADisplayLink *)displayLink {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        CGFloat d = (displayLink.timestamp - self.startTime) / self.animationDuration;
        
        if (d >= 1.0) {
            // Order is important! Otherwise concurrency will cause errors, because setProgress: will detect an
            // animation in progress and try to stop it by itself.
            [self.displayLink removeFromRunLoop:NSRunLoop.mainRunLoop forMode:NSRunLoopCommonModes];
            self.displayLink = nil;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                self.progress = self.toProgress;
            });
            
            return;
        }
        
        _progress = self.fromProgress + d * (self.toProgress - self.fromProgress);
        UIBezierPath *path = [self layoutPath];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.shapeLayer.path = path.CGPath;
            [self updateLabel];
        });
    });
}

- (void)dismiss:(BOOL)animated {
    self.hidden = TRUE;
    [self removeFromSuperview];
}

- (void)hide:(BOOL)animated {
    self.hidden = TRUE;
}

- (void)show:(BOOL)animated
{
    self.hidden = FALSE;
}

- (void)setText:(NSString*) text
{
    _labDescription.text = text;
}
@end
