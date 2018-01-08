//
//  JXDrawerConfiguration.m
//  JXSideslipDemo
//
//  Created by yituiyun on 2018/1/8.
//  Copyright © 2018年 yituiyun. All rights reserved.
//

#import "JXDrawerConfiguration.h"

@implementation JXDrawerConfiguration

+ (instancetype)defaultConfiguration {
    return [JXDrawerConfiguration configurationWithDistance:kScreenWidth * 0.75 maskAlpha:0.4 scaleY:1.0 direction:JXDrawerTransitionDirectionLeft backImage:nil];
}

- (instancetype)initWithDistance:(float)distance
                       maskAlpha:(float)alpha
                          scaleY:(float)scaleY
                       direction:(JXDrawerTransitionDirection)direction
                       backImage:(UIImage *)backImage {
    if (self = [super init]) {
        _distance = distance;
        _maskAlpha = alpha;
        _direction = direction;
        _backImage = backImage;
        _scaleY = scaleY;
    }
    return self;
}

+ (instancetype)configurationWithDistance:(float)distance
                                maskAlpha:(float)alpha
                                   scaleY:(float)scaleY
                                direction:(JXDrawerTransitionDirection)direction
                                backImage:(UIImage *)backImage {
    return [[self alloc] initWithDistance:distance maskAlpha:alpha scaleY:scaleY direction:direction backImage:backImage];
}

- (float)distance {
    if (_distance == 0)
        return kScreenWidth * 0.75;
    return _distance;
}

- (float)maskAlpha {
    if (_maskAlpha == 0)
        return 0.1;
    return _maskAlpha;
}

- (float)scaleY {
    if (_scaleY == 0)
        return 1.0;
    return _scaleY;
}

- (void)dealloc {
//    NSLog(@"%s",__func__);
}

@end
