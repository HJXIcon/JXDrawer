//
//  ViewController+JXSideslip.m
//  JXSideslipDemo
//
//  Created by yituiyun on 2018/1/8.
//  Copyright © 2018年 yituiyun. All rights reserved.
//

#import "UIViewController+JXDrawer.h"
#import "JXDrawerDismissingAnimator.h"
#import <objc/runtime.h>
#import "JXDrawerInteractiveTransition.h"

@implementation UIViewController (JXDrawer)

// 显示抽屉
- (void)jx_showDrawerViewController:(UIViewController *)viewController
                      animationType:(JXDrawerAnimationType)animationType
                      configuration:(JXDrawerConfiguration *)configuration {
     
    if (configuration == nil)
        configuration = [JXDrawerConfiguration defaultConfiguration];
    
    JXDrawerDismissingAnimator *animator = objc_getAssociatedObject(self, &JXDrawerDismissingAnimatorKey);
    
    if (animator == nil) {
        animator = [JXDrawerDismissingAnimator dismissingAnimatorWithConfiguration:configuration];
        objc_setAssociatedObject(viewController, &JXDrawerDismissingAnimatorKey, animator, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    viewController.transitioningDelegate = animator;
    
    
    JXDrawerInteractiveTransition *interactiveHidden = [JXDrawerInteractiveTransition interactiveWithTransitionType:JXDrawerTransitionTypeHidden];
    [interactiveHidden setValue:viewController forKey:@"weakVC"];
    [interactiveHidden setValue:@(configuration.direction) forKey:@"direction"];
    
    [animator setValue:interactiveHidden forKey:@"interactiveHidden"];
    animator.configuration = configuration;
    animator.animationType = animationType;
    
    [self presentViewController:viewController animated:YES completion:nil];
    
}

// 注册抽屉手势
- (void)jx_registerShowIntractiveWithEdgeGesture:(BOOL)openEdgeGesture transitionDirectionAutoBlock:(void(^)(JXDrawerTransitionDirection direction))transitionDirectionAutoBlock {
    
    JXDrawerDismissingAnimator *animator = [JXDrawerDismissingAnimator dismissingAnimatorWithConfiguration:nil];
    self.transitioningDelegate = animator;
    
    objc_setAssociatedObject(self, &JXDrawerDismissingAnimatorKey, animator, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    JXDrawerInteractiveTransition *interactiveShow = [JXDrawerInteractiveTransition interactiveWithTransitionType:JXDrawerTransitionTypeShow];
    [interactiveShow addPanGestureForViewController:self];
    [interactiveShow setValue:@(openEdgeGesture) forKey:@"openEdgeGesture"];
    [interactiveShow setValue:transitionDirectionAutoBlock forKey:@"transitionDirectionAutoBlock"];
    [interactiveShow setValue:@(JXDrawerTransitionDirectionLeft) forKey:@"direction"];
    
    [animator setValue:interactiveShow forKey:@"interactiveShow"];
}

// 抽屉内push界面
- (void)jx_pushViewController:(UIViewController *)viewController{
    
    UIViewController *rootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    UINavigationController *nav;
    if ([rootVC isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tabbar = (UITabBarController *)rootVC;
        NSInteger index = tabbar.selectedIndex;
        UIViewController *vc = tabbar.childViewControllers[index];
        if ([vc isKindOfClass:[UINavigationController class]]) {
            nav = (UINavigationController *)vc;
        }
        else{
            NSLog(@"This no UINavigationController...");
            return;
        }
        
    }else if ([rootVC isKindOfClass:[UINavigationController class]]) {
        nav = (UINavigationController *)rootVC;
        
    }else if ([rootVC isKindOfClass:[UIViewController class]]) {
        NSLog(@"This no UINavigationController...");
        return;
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
    [nav pushViewController:viewController animated:NO];
}





@end
