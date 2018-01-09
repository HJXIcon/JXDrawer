//
//  ViewController+JXSideslip.h
//  JXSideslipDemo
//
//  Created by yituiyun on 2018/1/8.
//  Copyright © 2018年 yituiyun. All rights reserved.
//

#import "ViewController.h"
#import "JXDrawerTransition.h"

@interface UIViewController (JXDrawer)

/**
 侧滑控制器

 @param viewController 侧滑控制器
 @param animationType  动画类型
 @param configuration  设置参数
 */
- (void)jx_showDrawerViewController:(UIViewController *)viewController
                      animationType:(JXDrawerAnimationType)animationType
                      configuration:(JXDrawerConfiguration *)configuration;


/**
 注册手势驱动方法，侧滑呼出的方向自动确定，一般在viewDidLoad调用，调用之后会添加一个支持侧滑的手势到本控制器

 @param openEdgeGesture 是否开启边缘手势,边缘手势的开始范围为距离边缘50以内
 @param transitionDirectionAutoBlock 手势过程中执行的操作。根据参数direction传整个点击present的事件即可（看demo的使用）
 */
- (void)jx_registerShowIntractiveWithEdgeGesture:(BOOL)openEdgeGesture
                    transitionDirectionAutoBlock:(void(^)(JXDrawerTransitionDirection direction))transitionDirectionAutoBlock;

/**
 自定义的push方法
 因为侧滑出来的控制器实际上是通过present出来的，这个时候是没有导航控制器的，而侧滑出来的控制器上面的一些点击事件需要再push下一个控制器的时候，我们只能通过寻找到根控制器找到对应的导航控制器再进行push操作，QQ的效果能证明是这么实现的
 @param viewController 需要push出来的控制器
 */
- (void)jx_pushViewController:(UIViewController *)viewController;



@end
