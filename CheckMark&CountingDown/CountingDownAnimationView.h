//
//  CountingDownAnimationView.h
//  CheckMark&CountingDown
//
//  Created by 李亚坤 on 16/5/21.
//  Copyright © 2016年 李亚坤. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CountingDownAnimationView;

@protocol CountingDownAnimationViewDelegate <NSObject>

- (void)finishCountingDown:(CountingDownAnimationView *)countingDownView;

@end

@interface CountingDownAnimationView : UIView

@property (nonatomic, weak) id<CountingDownAnimationViewDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame;

- (void)startCountDownTimer;

- (void)stopCountdown;

@end
