//
//  JXDrawerInteractiveTransition.m
//  JXSideslipDemo
//
//  Created by yituiyun on 2018/1/8.
//  Copyright © 2018年 yituiyun. All rights reserved.
//

#import "JXDrawerInteractiveTransition.h"

@interface JXDrawerInteractiveTransition()

@property (nonatomic, weak) UIViewController *weakVC;
@property (nonatomic, assign) JXDrawerTransitionType type;
@property (nonatomic, assign) BOOL openEdgeGesture;
@property (nonatomic, assign) JXDrawerTransitionDirection direction;
@property (nonatomic, strong) CADisplayLink *link;
@property (nonatomic, copy) void(^transitionDirectionAutoBlock)(JXDrawerTransitionDirection direction);
@end

@implementation JXDrawerInteractiveTransition{
    CGFloat _percent;
    CGFloat _remaincount;
    BOOL _toFinish;
    CGFloat _oncePercent;
}

#pragma mark - *** lazy load
- (CADisplayLink *)link {
    if (!_link) {
        _link = [CADisplayLink displayLinkWithTarget:self selector:@selector(cw_update)];
        [_link addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    }
    return _link;
}

#pragma mark - *** Publick Method
- (instancetype)initWithTransitionType:(JXDrawerTransitionType)type{
    if (self = [super init]) {
        _type = type;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(jx_singleTap) name:JXDrawerTapNotication object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(jx_handleHiddenPan:) name:JXDrawerPanNotication object:nil];
    }
    return self;
}

+ (instancetype)interactiveWithTransitionType:(JXDrawerTransitionType)type {
    return [[self alloc] initWithTransitionType:type];
}

- (void)addPanGestureForViewController:(UIViewController *)viewController {
    
    self.weakVC = viewController;
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(jx_handleShowPan:)];
    [viewController.view addGestureRecognizer:pan];
}


- (void)dealloc {
//    NSLog(@"%s",__func__);
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - *** GestureRecognizer
- (void)jx_singleTap {
    
    [self.weakVC dismissViewControllerAnimated:YES completion:nil];
}

- (void)jx_handleHiddenPan:(NSNotification *)note {
    
    if (_type == JXDrawerTransitionTypeShow) return;
    
    UIPanGestureRecognizer *pan = note.object;
    [self handleGesture:pan];
}

- (void)jx_handleShowPan:(UIPanGestureRecognizer *)pan {
    
    if (_type == JXDrawerTransitionTypeHidden) return;
    
    [self handleGesture:pan];
}

- (void)hiddenBeganTranslationX:(CGFloat)x {
    if ((x > 0 && _direction == JXDrawerTransitionDirectionLeft ) ||
        (x < 0 && _direction == JXDrawerTransitionDirectionRight )) return;
    self.interacting = YES;
    [self.weakVC dismissViewControllerAnimated:YES completion:nil];
}

- (void)showBeganTranslationX:(CGFloat)x gesture:(UIPanGestureRecognizer *)pan {
    //    NSLog(@"---->%f", x);
    if (x >= 0) _direction = JXDrawerTransitionDirectionLeft;
    else        _direction = JXDrawerTransitionDirectionRight;
    
    if ((x < 0 && _direction == JXDrawerTransitionDirectionLeft) ||
        (x > 0 && _direction == JXDrawerTransitionDirectionRight)) return;
    
    CGFloat locX = [pan locationInView:_weakVC.view].x;
    //    NSLog(@"locX: %f",locX);
    if (_openEdgeGesture && ((locX > 50 && _direction == JXDrawerTransitionDirectionLeft) || (locX < CGRectGetWidth(_weakVC.view.frame) - 50 && _direction == JXDrawerTransitionDirectionRight))) return;
    
    self.interacting = YES;
    if (_transitionDirectionAutoBlock) {
        _transitionDirectionAutoBlock(_direction);
    }
}

- (void)handleGesture:(UIPanGestureRecognizer *)pan  {
    
    CGFloat x = [pan translationInView:pan.view].x;
    
    _percent = 0;
    //_percent = x / self.configuration.distance;
    _percent = x / pan.view.frame.size.width;
    
    if ((_direction == JXDrawerTransitionDirectionRight && _type == JXDrawerTransitionTypeShow) || (_direction == JXDrawerTransitionDirectionLeft && _type == JXDrawerTransitionTypeHidden)) {
        _percent = -_percent;
    }
    
    switch (pan.state) {
        case UIGestureRecognizerStateBegan:
            break;
        case UIGestureRecognizerStateChanged: {
            if (!self.interacting) { // 保证present只调用一次
                if (_type == JXDrawerTransitionTypeShow) {
                    // 0是零界点，滑动慢的时候向右边滑动可能会导致x为0然后在接下来的自动判断方向识别为向左滑
                    if (x != 0) [self showBeganTranslationX:x gesture:pan];
                }else {
                    [self hiddenBeganTranslationX:x];
                }
            }else {
                _percent = fminf(fmaxf(_percent, 0.001), 1.0);
                [self updateInteractiveTransition:_percent];
            }
            break;
        }
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateEnded:{
            self.interacting = NO;
            if (_percent > 0.5) [self startDisplayerLink:_percent toFinish:YES];
            else                [self startDisplayerLink:_percent toFinish:NO];
            break;
        }
        default:
            break;
    }
}


- (void)startDisplayerLink:(CGFloat)percent toFinish:(BOOL)finish{
    
    _toFinish = finish;
    CGFloat remainDuration = finish ? self.duration * (1 - percent) : self.duration * percent;
    _remaincount = 60 * remainDuration;
    _oncePercent = finish ? (1 - percent) / _remaincount : percent / _remaincount;
    [self starDisplayLink];
}

#pragma mark - displayerLink
- (void)starDisplayLink {
    [self link];
}

- (void)stopDisplayerLink {
    [self.link invalidate];
    self.link = nil;
}

- (void)cw_update {
    
    if (_percent >= 1 && _toFinish) {
        [self stopDisplayerLink];
        [self finishInteractiveTransition];
    }else if (_percent <= 0 && !_toFinish) {
        [self stopDisplayerLink];
        [self cancelInteractiveTransition];
    }else {
        if (_toFinish) {
            _percent += _oncePercent;
        }else {
            _percent -= _oncePercent;
        }
        _percent = fminf(fmaxf(_percent, 0.0), 1.0);
        [self updateInteractiveTransition:_percent];
    }
}


@end
