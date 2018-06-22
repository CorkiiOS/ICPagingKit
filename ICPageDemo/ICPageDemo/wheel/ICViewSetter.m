//
//  ICViewSetter.m
//  ICPagerComponent
//
//  Created by mac on 2017/5/2.
//  Copyright © 2017年 iCorki. All rights reserved.
//

#import "ICViewSetter.h"
#import "UIView+ICFrame.h"

@interface ICGesScrollView :UIScrollView

@property (nonatomic, copy) BOOL(^shouldBeginPanGestureHandler)(UIScrollView *scorllView, UIPanGestureRecognizer *pan);

@end


@interface ICViewSetter()<UIScrollViewDelegate,UIGestureRecognizerDelegate>

@property (nonatomic, strong) ICGesScrollView *scrollView;
@property (nonatomic, weak) UIViewController *mainViewController;
@property (nonatomic, strong) NSArray <UIViewController *>*childControllers;

@end


@implementation ICViewSetter {
    
    CGFloat _startOffsetX;
    BOOL _isForbidScrollDelegate;
}

+ (instancetype)containerWithFrame:(CGRect)frame mainViewControler:(nonnull UIViewController *)mainViewControler childControllers:(NSArray<UIViewController *> *)childControllers {
    ICViewSetter *container = [[ICViewSetter alloc] initWithFrame:frame cmainViewControler:mainViewControler childControllers:childControllers];
    return container;
}

- (instancetype)initWithFrame:(CGRect)frame cmainViewControler:(nonnull UIViewController *)mainViewControler childControllers:(NSArray<UIViewController *> *)childControllers {
    self = [super initWithFrame:frame];
    if (self) {
        _mainViewController = mainViewControler;
        _childControllers = childControllers;
        
        self.scrollView.backgroundColor = [UIColor whiteColor];
        [self.scrollView setContentSize:CGSizeMake(self.scrollView.width * childControllers.count, 0)];
        
        if (childControllers.count > 0) {
            UIViewController *vc = childControllers[0];
            vc.view.frame = self.scrollView.bounds;
            [self.scrollView addSubview:vc.view];
        }
        
        UINavigationController *nav = (UINavigationController *)_mainViewController.parentViewController;
        
        if ([nav isKindOfClass:[UINavigationController class]]) {
            if (nav.childViewControllers.count > 1) {
                [self.scrollView setShouldBeginPanGestureHandler:^BOOL(UIScrollView *scorllView, UIPanGestureRecognizer *pan) {
                    CGFloat transionX = [pan translationInView:pan.view].x;
                    if (scorllView.contentOffset.x == 0 && transionX > 0) {
                        nav.interactivePopGestureRecognizer.enabled = YES;
                    }
                    else {
                        nav.interactivePopGestureRecognizer.enabled = NO;
                    }
                    return YES;
                }];
                
            }
            
        }

    }
    return self;
}

- (void)setScrollEnable:(BOOL)scrollEnable {
    _scrollEnable = scrollEnable;
    self.scrollView.scrollEnabled = scrollEnable;
}

- (void)setBounces:(BOOL)bounces {
    _bounces = bounces;
    self.scrollView.bounces = bounces;
}

- (void)viewScrollToIndex:(NSInteger)index {
    _isForbidScrollDelegate = YES;
    CGFloat offsetx = index * self.width;
    [_scrollView setContentOffset:CGPointMake(offsetx, 0)];
    [self setupViewWithIndex:index];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    _startOffsetX = scrollView.contentOffset.x;
    _isForbidScrollDelegate = NO;
    
    if ([self.delegate respondsToSelector:@selector(view:didBeginDragging:)]) {
        [self.delegate view:self didBeginDragging:scrollView];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if ([self.delegate respondsToSelector:@selector(view:didEndDragging:)]) {
        [self.delegate view:self didEndDragging:scrollView];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger index = scrollView.contentOffset.x / self.width;
    [self setupViewWithIndex:index];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(view:didEndScroll:)]){
        [self.delegate view:self didEndScroll:scrollView];
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(view:srollFromIndex:toIndex:progress:)]) {
        [_delegate view:self srollFromIndex:index toIndex:index progress:1.0];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (_isForbidScrollDelegate || scrollView.contentOffset.x <= 0 || scrollView.contentOffset.x >= scrollView.contentSize.width - scrollView.bounds.size.width){ return; }
    
    CGFloat tempProgress = scrollView.contentOffset.x / self.bounds.size.width;
    NSInteger tempIndex = tempProgress;
    CGFloat progress = tempProgress - floor(tempProgress);
    CGFloat deltaX = scrollView.contentOffset.x - _startOffsetX;
    NSInteger fromIndex = 0;
    NSInteger toIndex = 0;
    
    if (deltaX > 0) {
        if (progress == 0.0) {
            return;
        }
        toIndex = tempIndex + 1;
        fromIndex = tempIndex;
        
    }else if (deltaX < 0) {
        progress = 1.0 - progress;
        fromIndex = tempIndex + 1;
        toIndex = tempIndex;
        
    }else {
        return;
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(view:srollFromIndex:toIndex:progress:)]) {
        [_delegate view:self srollFromIndex:fromIndex toIndex:toIndex progress:progress];
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(view:didScroll:)]) {
        [self.delegate view:self didScroll:scrollView];
    }
    
}

- (void)setupViewWithIndex:(NSInteger)index {
    UIViewController *vc = self.childControllers[index];
    vc.view.frame = self.scrollView.bounds;
    if (vc.view.superview) return;
    [self.scrollView addSubview:vc.view];
}

- (ICGesScrollView *)scrollView {
    if (_scrollView == nil) {
        _scrollView = [[ICGesScrollView alloc] initWithFrame:self.bounds];
        _scrollView.delegate = self;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.pagingEnabled = YES;
        _scrollView.bounces = YES;
        [self addSubview:_scrollView];
    }
    
    return _scrollView;
}

@end

@implementation ICGesScrollView

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if (self.shouldBeginPanGestureHandler && gestureRecognizer == self.panGestureRecognizer){
        return self.shouldBeginPanGestureHandler(self,self.panGestureRecognizer);
    }
    else {
        return [super gestureRecognizerShouldBegin:gestureRecognizer];
    }
}


@end
