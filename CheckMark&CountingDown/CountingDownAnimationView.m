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

@property (nonatomic, strong) NSInteger secondsCountDown;

@property (nonatomic, strong) NSTimer *countDownTimer;

@property (nonatomic, strong) NSDate *startDate;

@end

@implementation CountingDownAnimationView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        CGRect numberRect = CGRectMake(frame.size.width/2 - 50.0, frame.size.height/2 - 50.0, 50.0f, 50.0f);
        _numberLabel = [[UILabel alloc] initWithFrame: numberRect];
        _numberLabel.font = [UIFont systemFontOfSize:40];
        _numberLabel.textColor = [UIColor redColor];
        _numberLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_numberLabel];
    }
    return self;
}

#pragma mark - public methods

- (void)startCountDownTimer
{
    if ([self.countDownTimer isValid]) {
        return;
    }
    
    self.secondsCountDown = 30;
    
    //每秒钟改变倒计时
    self.countDownTimer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(updateCountDown:) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.countDownTimer forMode:NSRunLoopCommonModes];
}

- (void)updateCountDown:(NSTimer *)timer
{
    if (self.secondsCountDown >= 0) {
        self.numberLabel.text = [NSString stringWithFormat:@"%ld", (long)self.secondsCountDown];
    } else {
        self.numberLabel.text = @"30";
    }
}

- (void)willAppear
{
    [self startCountDownTimer];
    [self updateCountDown:nil];
}

- (void)willDisappear
{
    if ([self.countDownTimer isValid]) {
        [self.countDownTimer invalidate];
    }
    self.countDownTimer = nil;
}

#pragma mark - private methods

@end
