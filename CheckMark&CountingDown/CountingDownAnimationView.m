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

@end

@implementation CountingDownAnimationView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self createCountDownNumber:frame];
        [self createArcBackground:frame];
        [self startCountDownTimer];
    }
    return self;
}

#pragma mark - init

- (void)createCountDownNumber: (CGRect)frame
{
    CGRect numberRect = CGRectMake(frame.size.width/2 - 40.0f, frame.size.height/2 - 40.0f, 80.0f, 80.0f);
    _numberLabel = [[UILabel alloc] initWithFrame: numberRect];
    _numberLabel.font = [UIFont systemFontOfSize:45.0f];
    _numberLabel.textColor = [UIColor redColor];
    _numberLabel.textAlignment = NSTextAlignmentCenter;
    self.numberLabel.text = [NSString stringWithFormat:@"30"];
    [self addSubview:_numberLabel];
}

- (void)createArcBackground: (CGRect)frame
{
    // ArcBackground
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(200,200), NO, [UIScreen mainScreen].scale);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(ctx, [UIColor redColor].CGColor);
    CGContextSetLineWidth(ctx, 2.0f);
    CGContextAddArc(ctx, 100, 100, 70, 0, 2*M_PI, 1);  // radius = 80.0
    CGContextDrawPath(ctx, kCGPathStroke);
    UIImage *curve = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(frame.size.width/2 - 100.0f, frame.size.height/2 - 100.0f, 200.0f, 200.0f)];
    imageView.image = curve;
    [self addSubview:imageView];
    
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
    
    self.secondsCountDown = 30;
    [self roundAnimate];
    
    // init timer
    self.countDownTimer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(updateCountDown:) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.countDownTimer forMode:NSRunLoopCommonModes];

}

- (void)stopCountdown
{
    [self invalidateTimer];
}

#pragma mark - private methods

- (void)roundAnimate
{
    CFTimeInterval baseTime; // The zero-time of animation
    baseTime = [self.layer convertTime:CACurrentMediaTime() fromLayer:nil];
    CGRect boundingRect = CGRectMake(self.frame.size.width/2 - 70.0, self.frame.size.height/2 - 70.0, 140, 140);
    CAKeyframeAnimation *orbit = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    NSValue *keyStart = [NSValue valueWithCGPoint: CGPointMake(_round.layer.position.x, _round.layer.position.y - 70.0f)];
    NSValue *keyEnd = [NSValue valueWithCGPoint: CGPointMake(_round.layer.position.x - 70.0f, _round.layer.position.y)];
    orbit.values = @[keyStart,keyEnd];
    orbit.duration = 1;
    orbit.path = CGPathCreateWithEllipseInRect(boundingRect, nil);
    orbit.calculationMode = kCAAnimationPaced;
    orbit.repeatCount = MAXFLOAT;
    orbit.beginTime = baseTime;
    [UIView commitAnimations];
    [self.round.layer addAnimation:orbit forKey:@"move"];
}

- (void)invalidateTimer
{
    if (self.countDownTimer) {
        [self.countDownTimer invalidate];
        self.countDownTimer = nil;
    }
}

- (void)updateCountDown:(NSTimer *)timer
{
    if (self.secondsCountDown == 30) {
        [self roundAnimate];
    }
    
    if (self.secondsCountDown >= 0) {
        self.numberLabel.text = [NSString stringWithFormat:@"%ld", (long)self.secondsCountDown];
        self.secondsCountDown --;
    } else {
        // 30s counting down finshed
        [self finishCountingDown];
    }
}

- (void)finishCountingDown
{
    [self stopCountdown];
    if (self.delegate && [self.delegate respondsToSelector:@selector(finishCountingDown:)])
    {
        [self.delegate finishCountingDown:self];
    }
}

@end
