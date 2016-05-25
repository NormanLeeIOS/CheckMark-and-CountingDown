//
//  AnimationViewController.m
//  CheckMark&CountingDown
//
//  Created by 李亚坤 on 16/5/21.
//  Copyright © 2016年 李亚坤. All rights reserved.
//

#import "AnimationViewController.h"
#import "CountingDownAnimationView.h"

@interface AnimationViewController ()<CountingDownAnimationViewDelegate>

@property (nonatomic, strong) CountingDownAnimationView *countingDownView;

@end

@implementation AnimationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib
    
    UIButton *restartBtn = [[UIButton alloc] initWithFrame:CGRectMake(10.0, 30.0, 100.0, 40.0)];
    restartBtn.backgroundColor = [UIColor yellowColor];
    [restartBtn addTarget:self action:@selector(restartCountingTime) forControlEvents:UIControlEventTouchUpInside];
    [restartBtn setTitle:[NSString stringWithFormat:@"restart"] forState:UIControlStateNormal];
    [restartBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    
    UIButton *loadCountDownBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(restartBtn.frame) + 10.0, 30.0, 100.0, 40.0)];
    loadCountDownBtn.backgroundColor = [UIColor yellowColor];
    [loadCountDownBtn addTarget:self action:@selector(loadCountingTime) forControlEvents:UIControlEventTouchUpInside];
    [loadCountDownBtn setTitle:[NSString stringWithFormat:@"load"] forState:UIControlStateNormal];
    [loadCountDownBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    
    UIButton *successBtn = [[UIButton alloc] initWithFrame:CGRectMake(10.0, CGRectGetMaxY(restartBtn.frame) + 10.0, 100.0, 40.0)];
    successBtn.backgroundColor = [UIColor yellowColor];
    [successBtn addTarget:self action:@selector(participateSuccess) forControlEvents:UIControlEventTouchUpInside];
    [successBtn setTitle:[NSString stringWithFormat:@"success"] forState:UIControlStateNormal];
    [successBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    
    UIButton *failureBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(restartBtn.frame) + 10.0, CGRectGetMaxY(restartBtn.frame) + 10.0, 100.0, 40.0)];
    failureBtn.backgroundColor = [UIColor yellowColor];
    [failureBtn addTarget:self action:@selector(participateFailure) forControlEvents:UIControlEventTouchUpInside];
    [failureBtn setTitle:[NSString stringWithFormat:@"failure"] forState:UIControlStateNormal];
    [failureBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];

    [self.view addSubview:loadCountDownBtn];
    [self.view addSubview:restartBtn];
    [self.view addSubview:successBtn];
    [self.view addSubview:failureBtn];
}

- (void)dealloc
{
    self.countingDownView.delegate = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

# pragma -
# pragma mark buttons methods

- (void)loadCountingTime
{
    if (_countingDownView == nil) {
        _countingDownView = [[CountingDownAnimationView alloc] initWithFrame:self.view.frame];
        [self.view insertSubview:_countingDownView atIndex:1];
        self.countingDownView.delegate = self;
        _countingDownView.state = ParticipateStateContinue;
    }
}

- (void)restartCountingTime
{
    [_countingDownView startCountDownTimer];
    _countingDownView.state = ParticipateStateContinue;
}

- (void)participateSuccess
{
    _countingDownView.state = ParticipateStateSuccess;
}

- (void)participateFailure
{
    _countingDownView.state = ParticipateStateFailure;
}

# pragma -
# pragma mark CountingDownAnimationViewDelegate

- (void)finishCountingDown:(CountingDownAnimationView *)countingDownView {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Here" message:@"Finish!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alertView show];
}

@end
