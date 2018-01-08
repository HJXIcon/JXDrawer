//
//  JXDrawerDismissingAnimator.m
//  JXSideslipDemo
//
//  Created by yituiyun on 2018/1/8.
//  Copyright © 2018年 yituiyun. All rights reserved.
//

#import "JXDrawerDismissingAnimator.h"
#import "JXDrawerTransition.h"
@interface JXDrawerDismissingAnimator ()

@property (nonatomic,strong)JXDrawerInteractiveTransition *interactiveHidden;
@property (nonatomic,strong)JXDrawerInteractiveTransition *interactiveShow;

@end
@implementation JXDrawerDismissingAnimator

- (instancetype)initWithConfiguration:(JXDrawerConfiguration *)configuration {
    if (self = [super init]) {
        _configuration = configuration;
    }
    return self;
}

+ (instancetype)dismissingAnimatorWithConfiguration:(JXDrawerConfiguration *)configuration{
    return [[self alloc] initWithConfiguration:configuration];
}

- (void)dealloc {
//    NSLog(@"%s",__func__);
}

- (void)setConfiguration:(JXDrawerConfiguration *)configuration {
    _configuration = configuration;
    [self.interactiveShow setValue:configuration forKey:@"configuration"];
    [self.interactiveHidden setValue:configuration forKey:@"configuration"];
    
}

#pragma mark - *** UIViewControllerTransitioningDelegate
- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    return [JXDrawerTransition transitionWithType:JXDrawerTransitionTypeShow animationType:_animationType configuration:_configuration];
}

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    return [JXDrawerTransition transitionWithType:JXDrawerTransitionTypeHidden animationType:_animationType configuration:_configuration];
}

- (nullable id <UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:(id <UIViewControllerAnimatedTransitioning>)animator {
    return self.interactiveShow.interacting ? self.interactiveShow : nil;
}

- (nullable id <UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id <UIViewControllerAnimatedTransitioning>)animator {
    //    NSLog(@"----------------------%@",self.interactiveHidden);
    return self.interactiveHidden.interacting ? self.interactiveHidden : nil;
}

@end
