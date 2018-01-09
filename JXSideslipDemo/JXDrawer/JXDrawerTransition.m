//
//  JXDrawerTransition.m
//  JXSideslipDemo
//
//  Created by yituiyun on 2018/1/8.
//  Copyright © 2018年 yituiyun. All rights reserved.
//

#import "JXDrawerTransition.h"

NSString *const JXDrawerMaskViewKey = @"JXDrawerMaskViewKey";
NSString *const JXDrawerDismissingAnimatorKey = @"JXDrawerDismissingAnimatorKey";
NSString *const JXDrawerInterativeKey = @"JXDrawerInterativeKey";

NSString *const JXDrawerPanNotication = @"JXDrawerPanNotication";
NSString *const JXDrawerTapNotication = @"JXDrawerTapNotication";

@interface JXDrawerTransition()
@property (nonatomic,weak) JXDrawerConfiguration *configuration;
@end

@implementation JXDrawerTransition{
     JXDrawerTransitionType _transitionType;
    JXDrawerAnimationType _animationType;
}

#pragma mark - *** init
- (instancetype)initWithTransitionType:(JXDrawerTransitionType)transitionType
                         animationType:(JXDrawerAnimationType)animationType
                         configuration:(JXDrawerConfiguration *)configuration{
    if (self = [super init]) {
        _transitionType = transitionType;
        _animationType = animationType;
        _configuration = configuration;
    }
    return self;
}

+ (instancetype)transitionWithType:(JXDrawerTransitionType)transitionType
                     animationType:(JXDrawerAnimationType)animationType
                     configuration:(JXDrawerConfiguration *)configuration{
    return [[self alloc] initWithTransitionType:transitionType animationType:animationType configuration:configuration];
}

#pragma mark - *** UIViewControllerAnimatedTransitioning
// 转场的时间
- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.25f;
}

// 转场动画实现
- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    
    switch (_transitionType) {
        case JXDrawerTransitionTypeShow:
            [self transitionShow:transitionContext];
            break;
        case JXDrawerTransitionTypeHidden:
            [self transitionHidden:transitionContext];
            break;
        default:
            break;
    }
    
}

#pragma mark - *** show
- (void)transitionShow:(id<UIViewControllerContextTransitioning>)transitionContext{
    switch (_animationType) {
        case JXDrawerAnimationTypeDefault:
             [self defaultShowWithContext:transitionContext];
            break;
            
        case JXDrawerAnimationTypeMask:
            [self maskShowWithContext:transitionContext];
            break;
            
        default:
            break;
    }
    
}

- (void)defaultShowWithContext:(id<UIViewControllerContextTransitioning>)transitionContext{
    
    
    // 通过 key 取到 fromVC 和 toVC
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    
    /// 遮盖
    JXDrawerMaskView *maskView = [JXDrawerMaskView shareInstance];
    maskView.frame = fromVC.view.bounds;
    [fromVC.view addSubview:maskView];
    UIView *containerView = [transitionContext containerView];
    
    /// 背景图片
    UIImageView *imageV;
    if (self.configuration.backImage) {
        imageV = [[UIImageView alloc] initWithFrame:containerView.bounds];
        imageV.image = self.configuration.backImage;
        imageV.transform = CGAffineTransformMakeScale(1.4, 1.4);
        imageV.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    }
    [containerView addSubview:imageV];
    
    /// 根控制器可偏移的距离，默认为屏幕的0.75
    CGFloat width = self.configuration.distance;
    CGFloat x = - width / 2;
    CGFloat ret = 1;
    if (self.configuration.direction == JXDrawerTransitionDirectionRight) {
        x = kScreenWidth - width / 2;
        ret = -1;
    }
    toVC.view.frame = CGRectMake(x, 0, CGRectGetWidth(containerView.frame), CGRectGetHeight(containerView.frame));
    
    // 把 toVC 加入到 containerView
    [containerView addSubview:toVC.view];
    [containerView addSubview:fromVC.view];
    
    CGAffineTransform t1 = CGAffineTransformMakeTranslation(ret * width, 0);
    CGAffineTransform t2 = CGAffineTransformMakeScale(1.0, self.configuration.scaleY);
    CGAffineTransform fromVCTransform = CGAffineTransformConcat(t1, t2);
    CGAffineTransform toVCTransform;
    if (self.configuration.direction == JXDrawerTransitionDirectionRight) {
        toVCTransform = CGAffineTransformMakeTranslation(ret * (x - CGRectGetWidth(containerView.frame) + width), 0);
    }else {
        toVCTransform = CGAffineTransformMakeTranslation(ret * width / 2, 0);
    }
    
    [UIView animateKeyframesWithDuration:[self transitionDuration:transitionContext] delay:0 options:0 animations:^{
        
        [UIView addKeyframeWithRelativeStartTime:0.0 relativeDuration:1.0 animations:^{
            
            fromVC.view.transform = fromVCTransform;
            toVC.view.transform = toVCTransform;
            imageV.transform = CGAffineTransformIdentity;
            maskView.alpha = self.configuration.maskAlpha;
            
        }];
        
    } completion:^(BOOL finished) {
        /// bug: 为什么动画结束之后view会消失，最终我们在动画结束的时候打印根控制器view的父视图发现为nil，所以我们在动画结束之后，又把该view添加到containerView上
        
        if (![transitionContext transitionWasCancelled]) {
            maskView.userInteractionEnabled = YES;
            maskView.toViewSubViews = fromVC.view.subviews;
            [transitionContext completeTransition:YES];
            [containerView addSubview:fromVC.view];
        }else {
            [imageV removeFromSuperview];
            [JXDrawerMaskView releaseInstance];
            [transitionContext completeTransition:NO];
        }
    }];
    
}

- (void)maskShowWithContext:(id<UIViewControllerContextTransitioning>)transitionContext{
    
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    JXDrawerMaskView *maskView = [JXDrawerMaskView shareInstance];
    maskView.frame = fromVC.view.bounds;
    [fromVC.view addSubview:maskView];
    
    UIView *containerView = [transitionContext containerView];
    
    CGFloat width = self.configuration.distance;
    CGFloat x = - width;
    CGFloat ret = 1;
    if (self.configuration.direction == JXDrawerTransitionDirectionRight) {
        x = kScreenWidth;
        ret = -1;
    }
    toVC.view.frame = CGRectMake(x, 0, width, CGRectGetHeight(containerView.frame));
    
    [containerView addSubview:fromVC.view];
    [containerView addSubview:toVC.view];
    
    CGAffineTransform toVCTransiform = CGAffineTransformMakeTranslation(ret * width , 0);
    
    [UIView animateKeyframesWithDuration:[self transitionDuration:transitionContext] delay:0 options:0 animations:^{
        
        [UIView addKeyframeWithRelativeStartTime:0.0 relativeDuration:1.0 animations:^{
            toVC.view.transform = toVCTransiform;
            maskView.alpha = self.configuration.maskAlpha;
        }];
        
    } completion:^(BOOL finished) {
        
        if (![transitionContext transitionWasCancelled]) {
            [transitionContext completeTransition:YES];
            maskView.toViewSubViews = fromVC.view.subviews;
            [containerView addSubview:fromVC.view];
            [containerView bringSubviewToFront:toVC.view];
            maskView.userInteractionEnabled = YES;
        }else {
            [JXDrawerMaskView releaseInstance];
            [transitionContext completeTransition:NO];
        }
    }];
}


- (void)transitionHidden:(id<UIViewControllerContextTransitioning>)transitionContext{
    
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    JXDrawerMaskView *maskView = [JXDrawerMaskView shareInstance];
    for (UIView *view in toVC.view.subviews) {
        if (![maskView.toViewSubViews containsObject:view]) {
            [view removeFromSuperview];
        }
    }
    
    UIView *containerView = [transitionContext containerView];
    UIImageView *backImageView;
    if ([containerView.subviews.firstObject isKindOfClass:[UIImageView class]])
        backImageView = containerView.subviews.firstObject;
    
    [UIView animateKeyframesWithDuration:[self transitionDuration:transitionContext] delay:0 options:UIViewKeyframeAnimationOptionCalculationModeCubic animations:^{
        
        [UIView addKeyframeWithRelativeStartTime:0.01 relativeDuration:0.99 animations:^{
            toVC.view.transform = CGAffineTransformIdentity;
            fromVC.view.transform = CGAffineTransformIdentity;
            maskView.alpha = 0;
            backImageView.transform = CGAffineTransformMakeScale(1.4, 1.4);
        }];
        
    } completion:^(BOOL finished) {
        if (![transitionContext transitionWasCancelled]) {
            maskView.toViewSubViews = nil;
            [JXDrawerMaskView releaseInstance];
            [backImageView removeFromSuperview];
        }
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        
    }];
}


@end



@implementation JXDrawerMaskView
static JXDrawerMaskView *_shareInstance = nil;
static dispatch_once_t _onceToken;

+ (instancetype)shareInstance {
    dispatch_once(&_onceToken, ^{
        _shareInstance = [[JXDrawerMaskView alloc] init];
    });
    return _shareInstance;
}


- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor blackColor];
        self.alpha = 0;
        
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap)];
        tap.numberOfTapsRequired = 1;
        [self addGestureRecognizer:tap];
        
        
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
        [self addGestureRecognizer:pan];
        
    }
    return self;
}

- (void)singleTap {
    [[NSNotificationCenter defaultCenter] postNotificationName:JXDrawerTapNotication object:self];
}

- (void)handleGesture:(UIPanGestureRecognizer *)pan {
    [[NSNotificationCenter defaultCenter] postNotificationName:JXDrawerPanNotication object:pan];
    
}

- (void)dealloc {
//     NSLog(@"%s",__func__);
}

+ (void)releaseInstance{
    [_shareInstance removeFromSuperview];
    _onceToken = 0;
    _shareInstance = nil;
}
@end



