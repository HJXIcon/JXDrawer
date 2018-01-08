//
//  JXDrawerInteractiveTransition.h
//  JXSideslipDemo
//
//  Created by yituiyun on 2018/1/8.
//  Copyright © 2018年 yituiyun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JXDrawerTransition.h"

@interface JXDrawerInteractiveTransition : UIPercentDrivenInteractiveTransition
@property (nonatomic,weak) JXDrawerConfiguration *configuration;
@property (nonatomic,assign) BOOL interacting;


- (instancetype)initWithTransitionType:(JXDrawerTransitionType)type;

+ (instancetype)interactiveWithTransitionType:(JXDrawerTransitionType)type;

- (void)addPanGestureForViewController:(UIViewController *)viewController;

@end
