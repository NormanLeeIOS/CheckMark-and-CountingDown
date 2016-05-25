//
//  CountingDownAnimationView.m
//  CheckMark&CountingDown
//
//  Created by 李亚坤 on 16/5/21.
//  Copyright © 2016年 李亚坤. All rights reserved.
//

#import "CountingDownAnimationView.h"



@interface CountingDownAnimationView()

@property (nonatomic, strong) UILabel *numberLabel;

@property (nonatomic, strong) UIView *round;

@property (nonatomic, assign) NSInteger secondsCountDown;

@property (nonatomic, strong) NSTimer *countDownTimer;

@property (nonatomic, strong) CAShapeLayer *arcLayer;

@end

@implementation CountingDownAnimationView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        _state = ParticipateStateContinue;
        [self createCountDownNumber:frame];
        [self createArcBackground:frame];
        [self startCountDownTimer];
    }
    return self;
}

#pragma mark - setup UI

- (void)createCountDownNumber: (CGRect)frame
{
    CGRect numberRect = CGRectMake(frame.size.width/2 - 40.0f, frame.size.height/2 - 40.0f, 80.0f, 80.0f);
    _numberLabel = [[UILabel alloc] initWithFrame: numberRect];
    _numberLabel.font = [UIFont systemFontOfSize:45.0f];
    _numberLabel.textColor = [UIColor redColor];
    _numberLabel.textAlignment = NSTextAlignmentCenter;
    self.numberLabel.text = [NSString stringWithFormat:@"29"];
    [self addSubview:_numberLabel];
}

- (void)createRoundShapeLayer: (CGRect)frame
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path addArcWithCenter:CGPointMake(self.frame.size.width/2, self.frame.size.height/2) radius:70 startAngle:radiansForHour(12) endAngle:radiansForHour(24) clockwise:YES];
    _arcLayer=[CAShapeLayer layer];
    _arcLayer.path = path.CGPath;
    _arcLayer.fillColor = [UIColor clearColor].CGColor;
    _arcLayer.strokeColor = [UIColor clearColor].CGColor;
    _arcLayer.lineWidth = 2.4;
    _arcLayer.frame = frame;
    [self.layer addSublayer:_arcLayer];
}

- (void)createArcBackground: (CGRect)frame
{
    // ArcBackground
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(200,200), NO, [UIScreen mainScreen].scale);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(ctx, [UIColor redColor].CGColor);
    CGContextSetLineWidth(ctx, 2.0f);
    CGContextAddArc(ctx, 100, 100, 70, 0, 2*M_PI, 1);
    CGContextDrawPath(ctx, kCGPathStroke);
    UIImage *curve = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(frame.size.width/2 - 100.0f, frame.size.height/2 - 100.0f, 200.0f, 200.0f)];
    imageView.image = curve;
    [self addSubview:imageView];
    [self createRoundShapeLayer:frame];
    
    // RedRound
    _round = [[UIView alloc] initWithFrame:CGRectMake(frame.size.width/2 - 5.0f, frame.size.height/2 - 70.0f - 5.0f, 10.0f, 10.0f)];
    _round.layer.masksToBounds = YES;
    _round.layer.cornerRadius = 5.0f;
    _round.backgroundColor = [UIColor redColor];
    [self addSubview:_round];
}

#pragma mark - public methods

- (void)startCountDownTimer
{
    if ([self.countDownTimer isValid]) {
        [self invalidateTimer];
    }
    
    self.secondsCountDown = 29;
    [self roundAnimate];
    
    // init timer
    self.countDownTimer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(updateCountDown:) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.countDownTimer forMode:NSRunLoopCommonModes];

}

- (void)stopCountdown
{
    [self invalidateTimer];
}

#pragma mark - animate methods

CGFloat radiansForHour(CGFloat hour)
{
    return 2 * M_PI * (hour - 3) / 12;
}

- (void)roundAnimate
{
    CFTimeInterval baseTime; // The zero-time of animation
    baseTime = [self.layer convertTime:CACurrentMediaTime() fromLayer:nil];
    CAKeyframeAnimation *orbit = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    NSValue *keyStart = [NSValue valueWithCGPoint: CGPointMake(self.frame.size.width/2, self.frame.size.height/2 - 70.0)];
    NSValue *keyEnd = [NSValue valueWithCGPoint: CGPointMake(self.frame.size.width/2, self.frame.size.height/2 - 70.0)];
    orbit.values = @[keyStart,keyEnd];

    CGMutablePathRef curvedPath =  CGPathCreateMutable();
    CGPathAddArc(curvedPath, NULL, self.frame.size.width/2, self.frame.size.height/2, 70, radiansForHour(12), radiansForHour(12 + 12), NO);
    orbit.path = curvedPath;
    
    orbit.duration = 1;
    orbit.calculationMode = kCAAnimationPaced;
    orbit.repeatCount = MAXFLOAT;
    orbit.beginTime = baseTime;
    [self.round.layer addAnimation:orbit forKey:@"roundMove"];
}

- (void)successAnimate
{
    self.arcLayer.strokeColor = [UIColor greenColor].CGColor;
    CABasicAnimation *successOrbit = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    successOrbit.repeatCount = 1.0;
    successOrbit.duration = 1;
    successOrbit.delegate = self;
    successOrbit.fromValue = [NSNumber numberWithInteger:0];
    successOrbit.toValue = [NSNumber numberWithInteger:1];
    successOrbit.removedOnCompletion = NO;
    successOrbit.fillMode = kCAFillModeForwards;
    [self.arcLayer addAnimation:successOrbit forKey:@"Success"];
    self.arcLayer.opacity = 1;
    
    CABasicAnimation *gradient = [CABasicAnimation animationWithKeyPath:@"transform"];
    gradient.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    gradient.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(0, 0, 1.0)];
    gradient.delegate = self;
    gradient.duration = 1;
    gradient.repeatCount = 1;
    gradient.removedOnCompletion = NO;
    gradient.fillMode = kCAFillModeForwards;
    [self.round.layer addAnimation:gradient forKey:@"gradientSuccess"];
    [self.numberLabel.layer addAnimation:gradient forKey:@"gradientSuccess"];
    
    CGPoint midPoint = CGPointMake(self.frame.origin.x + self.frame.size.width/2, self.frame.origin.y + self.frame.size.height/2);
    UIBezierPath *successPath = [UIBezierPath bezierPath];
    [successPath moveToPoint:CGPointMake(midPoint.x - 35.0, midPoint.y)];
    [successPath addLineToPoint:CGPointMake(midPoint.x - 10.0, midPoint.y + 25.0)];
    [successPath addLineToPoint:CGPointMake(midPoint.x + 35.0, midPoint.y - 25.0)];
    
    CAShapeLayer *successPathLayer = [CAShapeLayer layer];
    successPathLayer.frame = self.frame;
    successPathLayer.path = successPath.CGPath;
    successPathLayer.strokeColor = [UIColor greenColor].CGColor;
    successPathLayer.fillColor = [UIColor clearColor].CGColor;
    successPathLayer.lineWidth = 2.5f;
    successPathLayer.lineJoin = kCALineJoinBevel;
    [self.layer addSublayer:successPathLayer];
    
    CFTimeInterval baseTime = [successPathLayer convertTime:CACurrentMediaTime() fromLayer:nil]; // The zero-time of animation
    CABasicAnimation *nikeOrbit = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    nikeOrbit.duration = 1.0;
    nikeOrbit.fromValue = [NSNumber numberWithFloat:0.0f];
    nikeOrbit.toValue = [NSNumber numberWithFloat:1.0f];
    nikeOrbit.fillMode = kCAFillModeBackwards;
    nikeOrbit.beginTime = baseTime + 0.5;
    [successPathLayer addAnimation:nikeOrbit forKey:@"nike"];
}

- (void) failureAnimate
{
    self.arcLayer.strokeColor = [UIColor yellowColor].CGColor;
    CABasicAnimation *failureOrbit = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    failureOrbit.repeatCount = 1.0;
    failureOrbit.duration = 1;
    failureOrbit.delegate = self;
    failureOrbit.fromValue = [NSNumber numberWithInteger:0];
    failureOrbit.toValue = [NSNumber numberWithInteger:1];
    failureOrbit.removedOnCompletion = NO;
    failureOrbit.fillMode = kCAFillModeForwards;
    [self.arcLayer addAnimation:failureOrbit forKey:@"failure"];
    self.arcLayer.opacity = 1;
    
    CABasicAnimation *gradient = [CABasicAnimation animationWithKeyPath:@"transform"];
    gradient.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    gradient.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(0, 0, 1.0)];
    gradient.delegate = self;
    gradient.duration = 1;
    gradient.repeatCount = 1;
    gradient.removedOnCompletion = NO;
    gradient.fillMode = kCAFillModeForwards;
    [self.round.layer addAnimation:gradient forKey:@"gradientFailure"];
    [self.numberLabel.layer addAnimation:gradient forKey:@"gradientFailure"];
    
    CGPoint midPoint = CGPointMake(self.frame.origin.x + self.frame.size.width/2, self.frame.origin.y + self.frame.size.height/2);
    UIBezierPath *failurePath = [UIBezierPath bezierPath];
    [failurePath moveToPoint:CGPointMake(midPoint.x - 35.0, midPoint.y - 35.0)];
    [failurePath addLineToPoint:CGPointMake(midPoint.x + 35.0, midPoint.y + 35.0)];
    [failurePath moveToPoint:CGPointMake(midPoint.x - 35.0, midPoint.y + 35.0)];
    [failurePath addLineToPoint:CGPointMake(midPoint.x + 35.0, midPoint.y - 35.0)];
    
    CAShapeLayer *failurePathLayer = [CAShapeLayer layer];
    failurePathLayer.frame = self.frame;
    failurePathLayer.path = failurePath.CGPath;
    failurePathLayer.strokeColor = [UIColor yellowColor].CGColor;
    failurePathLayer.fillColor = [UIColor clearColor].CGColor;
    failurePathLayer.lineWidth = 2.5f;
    failurePathLayer.lineJoin = kCALineJoinBevel;
    [self.layer addSublayer:failurePathLayer];
    
    CFTimeInterval baseTime = [failurePathLayer convertTime:CACurrentMediaTime() fromLayer:nil]; // The zero-time of animation
    CABasicAnimation *xOrbit = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    xOrbit.duration = 1.0;
    xOrbit.fromValue = [NSNumber numberWithFloat:0.f];
    xOrbit.toValue = [NSNumber numberWithFloat:M_PI];
    xOrbit.fillMode = kCAFillModeBackwards;
    xOrbit.beginTime = baseTime + 0.5;
    xOrbit.repeatCount = 1;
    [failurePathLayer addAnimation:xOrbit forKey:@"XPath"];
    
    CABasicAnimation *xStrokeColor = [CABasicAnimation animationWithKeyPath:@"strokeColor"];
    xStrokeColor.duration = 0.4;
    xStrokeColor.fromValue = (__bridge id _Nullable)([UIColor clearColor].CGColor);
    xStrokeColor.toValue = (__bridge id _Nullable)([UIColor yellowColor].CGColor);
    xStrokeColor.fillMode = kCAFillModeBackwards;
    xStrokeColor.beginTime = baseTime + 1.1;
    xStrokeColor.repeatCount = 1;
    [failurePathLayer addAnimation:xStrokeColor forKey:@"XStrokeColor"];
}

#pragma mark - counting down methods

- (void)invalidateTimer
{
    if (self.countDownTimer) {
        [self.countDownTimer invalidate];
        self.countDownTimer = nil;
    }
}

- (void)updateCountDown:(NSTimer *)timer
{
    switch (self.state) {
        case ParticipateStateContinue:
            [self stateContinue];
            break;
        case ParticipateStateFailure:
            [self stateFailure];
            break;
        case ParticipateStateSuccess:
            [self stateSuccess];
            break;
        case ParticipateStateFinish:
            return;
            break;
        default:
            break;
    }
}

- (void)stateContinue {
    if (self.secondsCountDown < 0) {    // time out
        [self finishCountingDown];
    } else {
        self.numberLabel.text = [NSString stringWithFormat:@"%ld", (long)self.secondsCountDown];
        self.secondsCountDown --;
    }
}

- (void)stateFailure {
    if ([_arcLayer animationForKey:@"failure"]) {
        self.state = ParticipateStateFinish;
    } else {
        [self failureAnimate];
    }
}

- (void)stateSuccess {
    if ([_arcLayer animationForKey:@"Success"]) {
        self.state = ParticipateStateFinish;
    } else {
        [self successAnimate];
    }
}

#pragma mark - delegate method

- (void)finishCountingDown
{
    [self stopCountdown];
    if (self.delegate && [self.delegate respondsToSelector:@selector(finishCountingDown:)])
    {
        [self.delegate finishCountingDown:self];
    }
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    
    if(anim == [_arcLayer animationForKey:@"Success"] || anim == [_arcLayer animationForKey:@"failure"]){
        [self stopCountdown];   // only stop, add delegate method if nessanary
    }

}

@end
