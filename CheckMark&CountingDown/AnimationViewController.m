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
    
    UIButton *restartBtn = [[UIButton alloc] initWithFrame:CGRectMake(50.0, 50.0, 100.0, 50.0)];
    restartBtn.backgroundColor = [UIColor yellowColor];
    [restartBtn addTarget:self action:@selector(restartCountingTime) forControlEvents:UIControlEventTouchUpInside];
    [restartBtn setTitle:[NSString stringWithFormat:@"restartCount"] forState:UIControlStateNormal];
    [restartBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    
    UIButton *loadCountDownBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(restartBtn.frame) + 10.0, 50.0, 100.0, 50.0)];
    loadCountDownBtn.backgroundColor = [UIColor grayColor];
    [loadCountDownBtn addTarget:self action:@selector(loadCountingTime) forControlEvents:UIControlEventTouchUpInside];
    [loadCountDownBtn setTitle:[NSString stringWithFormat:@"loadCount"] forState:UIControlStateNormal];
    [loadCountDownBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];

    [self.view addSubview:loadCountDownBtn];
    [self.view addSubview:restartBtn];
    
}

- (void)dealloc
{
    self.countingDownView.delegate = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadCountingTime
{
    if (_countingDownView == nil) {
        _countingDownView = [[CountingDownAnimationView alloc] initWithFrame:self.view.frame];
        [self.view insertSubview:_countingDownView atIndex:1];
        self.countingDownView.delegate = self;
    }
}

- (void)restartCountingTime
{
    [_countingDownView startCountDownTimer];
}

# pragma -
# pragma CountingDownAnimationViewDelegate

- (void)finishCountingDown:(CountingDownAnimationView *)countingDownView {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Here" message:@"30s Finish!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alertView show];
}

@end
