//
//  CountingDownAnimationView.h
//  CheckMark&CountingDown
//
//  Created by 李亚坤 on 16/5/21.
//  Copyright © 2016年 李亚坤. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CountingDownAnimationView : UIView

@property (nonatomic, assign) CGFloat timeNumber;

- (instancetype)initWithFrame:(CGRect)frame;

- (void)willAppear;

- (void)willDisappear;

@end
