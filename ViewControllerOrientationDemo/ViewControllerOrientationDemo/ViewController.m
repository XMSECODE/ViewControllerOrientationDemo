//
//  ViewController.m
//  APPStatusBarOrientationDemo
//
//  Created by xiang on 2018/7/21.
//  Copyright © 2018年 xiang. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (strong, nonatomic) IBOutlet UILabel *orientationLabel;

@property (strong, nonatomic) IBOutlet UIButton *orientationButton;

@property(nonatomic,assign)BOOL isPortrait;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.orientationButton addTarget:self action:@selector(didClickOrientationButton) forControlEvents:UIControlEventTouchUpInside];
}

- (void)didClickOrientationButton {
    UIInterfaceOrientation orientation ;
    if (self.isPortrait == YES) {
        orientation = UIInterfaceOrientationLandscapeRight;
    }else {
        orientation = UIInterfaceOrientationPortrait;
    }
    [self interfaceOrientation:orientation];
}

/**
 切换当前屏幕方向
 */
- (void)interfaceOrientation:(UIInterfaceOrientation)orientation {
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        SEL selector = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        int val = orientation;
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
    }
}

/**
 允许字段旋转
 */
- (BOOL)shouldAutorotate {
    return YES;
}

/**
 支持旋转的方向
 */
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskLandscapeLeft | UIInterfaceOrientationMaskLandscapeRight;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    
    if (orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown) {
        self.orientationLabel.text = @"竖屏";
        self.isPortrait = YES;
    }else if((orientation == UIInterfaceOrientationLandscapeLeft || orientation == UIInterfaceOrientationLandscapeRight)){
        self.orientationLabel.text = @"横屏";
        self.isPortrait = NO;
    }else {
        self.orientationLabel.text = @"未知";
        self.isPortrait = NO;
    }
}

@end
