//
//  JXDrawerDismissingAnimator.h
//  JXSideslipDemo
//
//  Created by yituiyun on 2018/1/8.
//  Copyright © 2018年 yituiyun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JXDrawerConfiguration.h"
#import "JXDrawerInteractiveTransition.h"
@interface JXDrawerDismissingAnimator : NSObject<UIViewControllerTransitioningDelegate>

@property (nonatomic,strong) JXDrawerConfiguration *configuration;
@property (nonatomic,assign) JXDrawerAnimationType animationType;

- (instancetype)initWithConfiguration:(JXDrawerConfiguration *)configuration;

+ (instancetype)dismissingAnimatorWithConfiguration:(JXDrawerConfiguration *)configuration;

@end
