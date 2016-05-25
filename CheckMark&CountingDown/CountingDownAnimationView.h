//
//  CountingDownAnimationView.h
//  CheckMark&CountingDown
//
//  Created by 李亚坤 on 16/5/21.
//  Copyright © 2016年 李亚坤. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ParticipateState) {
    ParticipateStateContinue  = 0,   //正在参与
    ParticipateStateSuccess   = 1,   //参与成功
    ParticipateStateFailure   = 2,   //参与失败
    ParticipateStateFinish    = 3    //参与结束
};

@class CountingDownAnimationView;

@protocol CountingDownAnimationViewDelegate <NSObject>

- (void)finishCountingDown:(CountingDownAnimationView *)countingDownView;

@end

@interface CountingDownAnimationView : UIView

@property (nonatomic, weak) id<CountingDownAnimationViewDelegate> delegate;

@property (nonatomic, assign) ParticipateState state;

- (instancetype)initWithFrame:(CGRect)frame;

- (void)startCountDownTimer;

- (void)stopCountdown;

@end
