//
//  ICViewSetter.m
//  ICPagerComponent
//
//  Created by mac on 2017/5/2.
//  Copyright © 2017年 iCorki. All rights reserved.
//

#import "ICViewSetter.h"
#import "UIView+ICFrame.h"
@interface ICViewSetter()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;

@end

@implementation ICViewSetter {
    
    CGFloat _startOffsetX;
    BOOL _isForbidScrollDelegate;
}

+ (instancetype)containerWithFrame:(CGRect)frame {
    ICViewSetter *container = [[ICViewSetter alloc] initWithFrame:frame];
    return container;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self)
    {
        self.scrollView.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)setScrollEnable:(BOOL)scrollEnable {
    _scrollEnable = scrollEnable;
    self.scrollView.scrollEnabled = scrollEnable;
}

- (void)viewScrollToIndex:(NSInteger)index {
    _isForbidScrollDelegate = YES;
    CGFloat offsetx = index * self.width;
    [_scrollView setContentOffset:CGPointMake(offsetx, 0)];
    [self setupViewWithIndex:index];
}

- (void)setChildControllers:(NSArray<UIViewController *> *)childControllers {
    _childControllers = childControllers;
    
    [self.scrollView setContentSize:CGSizeMake(self.scrollView.width * self.childControllers.count, 0)];
    
    if (self.childControllers.count > 0)
    {
        UIViewController *vc = self.childControllers[0];
        vc.view.frame = self.scrollView.bounds;
        [self.scrollView addSubview:vc.view];
    }
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
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (_isForbidScrollDelegate) { return; }
    
    NSInteger sourceIndex = 0;
    NSInteger targetIndex = 0;
    CGFloat progress = 0;
    
    CGFloat currentOffsetX = scrollView.contentOffset.x;
    CGFloat scrollViewW = scrollView.bounds.size.width;
    
    //左滑动
    if (_startOffsetX > currentOffsetX)
    {
        
        progress = 1- (currentOffsetX / scrollViewW - floor(currentOffsetX / scrollViewW));
        
        sourceIndex = (currentOffsetX/scrollViewW);
        
        targetIndex = sourceIndex + 1;
        if (targetIndex >= self.childControllers.count)
        {
            targetIndex = self.childControllers.count - 1;
        }
        
        // 4.如果完全划过去
        if ((currentOffsetX - _startOffsetX) == scrollViewW)
        {
            progress = 1;
            targetIndex = sourceIndex;
        }
        
    }
    else
    {
        // 1.计算progress
        progress = (currentOffsetX / scrollViewW - floor(currentOffsetX / scrollViewW));
        
        // 2.计算targetIndex
        targetIndex = (currentOffsetX / scrollViewW);
        
        // 3.计算sourceIndex
        sourceIndex = targetIndex + 1;
        
        if ((currentOffsetX - _startOffsetX) == scrollViewW)
        {
            progress = 1;
            sourceIndex -=1;
            targetIndex -=1;
        }
        
        if (sourceIndex >= self.childControllers.count)
        {
            sourceIndex = self.childControllers.count - 1;
        }
        
        
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(view:srollFromIndex:toIndex:progress:)]) {
        [_delegate view:self srollFromIndex:sourceIndex toIndex:targetIndex progress:progress];
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

- (UIScrollView *)scrollView {
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scrollView.delegate = self;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.pagingEnabled = YES;
        _scrollView.bounces = NO;
        [self addSubview:_scrollView];
    }
    
    return _scrollView;
}

@end
