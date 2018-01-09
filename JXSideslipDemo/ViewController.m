//
//  ViewController.m
//  JXSideslipDemo
//
//  Created by yituiyun on 2018/1/8.
//  Copyright © 2018年 yituiyun. All rights reserved.
//

#import "ViewController.h"
#import "UIViewController+JXDrawer.h"
#import "LeftViewController.h"
#import <JXPageView.h>
#import "RightViewController.h"
#import "NavigationController.h"

/// 底部宏，吃一见长一智吧，别写数字了
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define iPhoneX ([UIScreen mainScreen].bounds.size.width>=375.0f && [UIScreen mainScreen].bounds.size.height>=812.0f && IS_IPHONE)

// 导航栏默认高度
#define  E_StatusBarAndNavigationBarHeight  (iPhoneX ? 88.f : 64.f)

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray *titles = @[@"适合",@"十二班",@"的华",@"推荐爱推荐爱\n酒店",@"人丹33",@"适合",@"十二班",@"的华"];
    JXPageStyle *style = [[JXPageStyle alloc]init];
    
    style.titleFont = [UIFont systemFontOfSize:18];
    style.isScrollEnable = YES;
    style.isShowBottomLine = YES;
    style.multilineEnable = YES;
    style.titleHeight = 60;
    style.titleMargin = 30;
    style.isShowSeparatorLine = NO;
    style.separatorLineSize = CGSizeMake(1, 44);
    style.separatorLineColor = [UIColor blueColor];
    style.titleGradientEffectEnable = NO;
    style.normalColor = [UIColor blackColor];
    style.selectColor = [UIColor orangeColor];
    style.titeViewBackgroundColor = [UIColor whiteColor];
    
    NSMutableArray *childVcs = [NSMutableArray array];
    
    for (int i = 0; i < titles.count; i++){
        UIViewController *vc = [[UIViewController alloc]init];
        vc.view.backgroundColor = [UIColor randomColor];
        
        [childVcs addObject:vc];
    }
    
    CGRect pageViewFrame = CGRectMake(0, E_StatusBarAndNavigationBarHeight, self.view.bounds.size.width, self.view.bounds.size.height - E_StatusBarAndNavigationBarHeight);
    
    JXPageView *pageView = [[JXPageView alloc]initWithFrame:pageViewFrame titles:titles style:style childVcs:childVcs parentVc:self];
    
    
    [self.view addSubview:pageView];
    
    [self setupNav];
}

- (void)setupNav{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"left" style:UIBarButtonItemStyleDone target:self action:@selector(leftClick)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"right" style:UIBarButtonItemStyleDone target:self action:@selector(rightClick)];
}



// 导航栏左边按钮的点击事件
- (void)leftClick {
    // 自己随心所欲创建的一个控制器
    LeftViewController *vc = [[LeftViewController alloc] init];
    
    // 这个代码与框架无关，与demo相关，因为有兄弟在侧滑出来的界面，使用present到另一个界面返回的时候会有异常，这里提供各个场景的解决方式，需要在侧滑的界面present的同学可以借鉴一下！处理方式在leftViewController的viewDidAppear:方法内
//    vc.drawerType = DrawerDefaultLeft;
    
    // 调用这个方法
    [self jx_showDrawerViewController:vc animationType:JXDrawerAnimationTypeDefault configuration:nil];
    
}

- (void)rightClick{
    
    RightViewController *vc = [[RightViewController alloc]init];
    
    JXDrawerConfiguration *configuration = [JXDrawerConfiguration configurationWithDistance:300 maskAlpha:0.5 scaleY:0.8 direction:JXDrawerTransitionDirectionRight backImage:[UIImage imageNamed:@"桌面4.jpg"]];
    
    
    // 调用这个方法
    [self jx_showDrawerViewController:vc animationType:JXDrawerAnimationTypeMask configuration:configuration];
}
@end
