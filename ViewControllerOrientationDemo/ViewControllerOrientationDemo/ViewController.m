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

@property(nonatomic,assign)BOOL viewPresented;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.orientationButton addTarget:self action:@selector(didClickOrientationButton) forControlEvents:UIControlEventTouchUpInside];
    
    [self getOrientation];
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
    
    if (@available(iOS 16.0, *)) {
        UIInterfaceOrientation orientationM = orientation;
        UIInterfaceOrientationMask orMask = UIInterfaceOrientationMaskPortrait;
        if (orientationM == UIInterfaceOrientationPortrait||UIInterfaceOrientationUnknown) {
            orMask = UIInterfaceOrientationMaskPortrait;
        }
        else if (orientationM == UIInterfaceOrientationPortraitUpsideDown){
            orMask = UIInterfaceOrientationMaskPortraitUpsideDown;
        }
        else if (orientationM == UIInterfaceOrientationLandscapeLeft){
            orMask = UIInterfaceOrientationMaskLandscapeLeft;
        }
        else if (orientationM == UIInterfaceOrientationLandscapeRight){
            orMask = UIInterfaceOrientationMaskLandscapeRight;
        }
        UIViewController *curVC = self;
        UINavigationController *nav = self.navigationController;
        SEL selUpdateSupportedMethod = NSSelectorFromString(@"setNeedsUpdateOfSupportedInterfaceOrientations");
        if ([curVC respondsToSelector:selUpdateSupportedMethod]) {
            (((void (*)(id, SEL))[curVC methodForSelector:selUpdateSupportedMethod])(curVC, selUpdateSupportedMethod));
        }
        if ([nav respondsToSelector:selUpdateSupportedMethod]) {
            (((void (*)(id, SEL))[nav methodForSelector:selUpdateSupportedMethod])(nav, selUpdateSupportedMethod));
        }
        NSArray *array = [[[UIApplication sharedApplication] connectedScenes] allObjects];
        UIWindowScene *ws = (UIWindowScene *)array.firstObject;
        Class GeometryPreferences = NSClassFromString(@"UIWindowSceneGeometryPreferencesIOS");
        id geometryPreferences = [[GeometryPreferences alloc] init];
        [geometryPreferences setValue:@(orMask) forKey:@"interfaceOrientations"];
        SEL selGeometryUpdateMethod = NSSelectorFromString(@"requestGeometryUpdateWithPreferences:errorHandler:");
        void (^ErrorBlock)(NSError *error) = ^(NSError *error){
            NSLog(@"iOS 16 转屏Error===%@",error);
        };
        if ([ws respondsToSelector:selGeometryUpdateMethod]) {
            (((void (*)(id, SEL,id,id))[ws methodForSelector:selGeometryUpdateMethod])(ws, selGeometryUpdateMethod,geometryPreferences,ErrorBlock));
        }
        [UIViewController attemptRotationToDeviceOrientation];
    }else{
        if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
            SEL selector = NSSelectorFromString(@"setOrientation:");
            NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
            [invocation setSelector:selector];
            [invocation setTarget:[UIDevice currentDevice]];
            [invocation setArgument:&(orientation) atIndex:2];
            [invocation invoke];
        }
    }
}

/**
 支持旋转
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

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    NSLog(@"更换方向\n size=%@ \n coordinator = %@",NSStringFromCGSize(size),coordinator);
    if (size.width > size.height) {
        self.isPortrait = NO;
    }else {
        self.isPortrait = YES;
    }
}

- (BOOL)prefersStatusBarHidden {
    if (self.viewPresented == YES) {
        return self.isPortrait;
    }else {
        self.viewPresented = YES;
        return NO;
    }
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];

    [self getOrientation];
    NSLog(@"layout subviews");
}

- (void)getOrientation {
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
