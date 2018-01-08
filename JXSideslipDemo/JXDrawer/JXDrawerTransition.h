//
//  JXDrawerTransition.h
//  JXSideslipDemo
//
//  Created by yituiyun on 2018/1/8.
//  Copyright © 2018年 yituiyun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "JXDrawerConfiguration.h"


UIKIT_EXTERN NSString *const JXDrawerDismissingAnimatorKey;
UIKIT_EXTERN NSString *const JXDrawerMaskViewKey;
UIKIT_EXTERN NSString *const JXDrawerInterativeKey;

UIKIT_EXTERN NSString *const JXDrawerPanNotication;
UIKIT_EXTERN NSString *const JXDrawerTapNotication;

typedef NS_ENUM(NSUInteger,JXDrawerTransitionType) {
    JXDrawerTransitionTypeShow = 0,
    JXDrawerTransitionTypeHidden
};

typedef NS_ENUM(NSUInteger,JXDrawerAnimationType) {
    JXDrawerAnimationTypeDefault = 0,
    JXDrawerAnimationTypeMask
};

@interface JXDrawerTransition : NSObject<UIViewControllerAnimatedTransitioning>

- (instancetype)initWithTransitionType:(JXDrawerTransitionType)transitionType
                         animationType:(JXDrawerAnimationType)animationType
                         configuration:(JXDrawerConfiguration *)configuration;

+ (instancetype)transitionWithType:(JXDrawerTransitionType)transitionType
                     animationType:(JXDrawerAnimationType)animationType
                     configuration:(JXDrawerConfiguration *)configuration;

@end




@interface JXDrawerMaskView : UIView<UIGestureRecognizerDelegate>

@property (nonatomic,copy) NSArray *toViewSubViews;

+ (instancetype)shareInstance;

+ (void)releaseInstance;

@end



