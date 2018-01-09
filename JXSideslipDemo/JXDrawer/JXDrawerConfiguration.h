//
//  JXDrawerConfiguration.h
//  JXSideslipDemo
//
//  Created by yituiyun on 2018/1/8.
//  Copyright © 2018年 yituiyun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define kScreenWidth [UIScreen mainScreen].bounds.size.width

typedef NS_ENUM(NSUInteger,JXDrawerTransitionDirection) {
    JXDrawerTransitionDirectionLeft = 0, // 左侧滑出
    JXDrawerTransitionDirectionRight     // 右侧滑出
};

@interface JXDrawerConfiguration : NSObject

/**
 根控制器可偏移的距离，默认为屏幕的0.75
 */
@property (nonatomic,assign)float distance;

/**
 遮罩的透明度,默认0.1
 */
@property (nonatomic,assign)float maskAlpha;

/**
 根控制器在y方向的缩放，默认为不缩放
 */
@property (nonatomic,assign)float scaleY;

/**
 菜单滑出的方向，默认为从左侧滑出
 */
@property (nonatomic,assign)JXDrawerTransitionDirection direction;

/**
 动画切换过程中，最底层的背景图片
 */
@property (nonatomic,strong)UIImage *backImage;


/**
 默认配置
 
 @return 配置对象本身
 */
+ (instancetype)defaultConfiguration;

/**
 创建一个配置对象的实例方法
 
 @param distance 偏移距离
 @param alpha 遮罩的透明度
 @param scaleY y方向的缩放 (仅JXDrawerAnimationTypeDefault动画模式有效)
 @param direction 滑出方向
 @param backImage 动画切换过程中，最底层的背景图片 (仅JXDrawerAnimationTypeDefault动画模式有效)
 @return 配置对象本身
 */
- (instancetype)initWithDistance:(float)distance
                       maskAlpha:(float)alpha
                          scaleY:(float)scaleY
                       direction:(JXDrawerTransitionDirection)direction
                       backImage:(UIImage *)backImage;

/**
 创建一个配置对象的类方法
 
 @param distance 偏移距离
 @param alpha 遮罩的透明度
 @param scaleY y方向的缩放
 @param direction 滑出方向
 @param backImage 动画切换过程中，最底层的背景图片
 @return 配置对象本身
 */
+ (instancetype)configurationWithDistance:(float)distance
                                maskAlpha:(float)alpha
                                   scaleY:(float)scaleY
                                direction:(JXDrawerTransitionDirection)direction
                                backImage:(UIImage *)backImage;

@end
