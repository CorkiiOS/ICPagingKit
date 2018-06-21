//
//  ICPagingManager.m
//  Pods
//
//  Created by mac on 2017/6/6.
//
//

#import "ICPagingManager.h"
#import "ICViewSetter.h"
#import "ICTabToolSetter.h"
#import "ICTabToolTemplate.h"
#import "ICTabToolStyleModel.h"

@interface ICPagingManager()<ICViewSetterDelegate, ICTabToolTemplateDelegate>

@property(nonatomic, strong) ICTabToolTemplate *bar;
@property(nonatomic, strong) ICViewSetter *container;
@property(nonatomic, strong) NSArray<UIViewController *> *childVCs;


/*选项卡风格*/
- (ICTabToolStyle)tabToolStyle;

/*选项卡frame*/
- (CGRect)tabToolFrame;
/*选项卡标题集合*/
- (NSArray <NSString *>*)tabToolTitleArray;
/*子控制器view*/
- (CGFloat)viewHeight;

- (UIView *)viewInMainViewController;

- (UIViewController *)mainViewController;

- (CGRect)viewFrameInMainViewController;
@end

@implementation ICPagingManager

+ (instancetype)manager {
    ICPagingManager *manager = [[self alloc] init];
    return manager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _scrollEnabled = YES;
    }
    return self;
}

- (void)setDelegate:(id<ICPagingManagerProtocol>)delegate {
    if (_delegate != delegate) {
        _delegate = delegate;
        NSAssert([delegate isKindOfClass:[UIViewController class]], @"delegate 必须继承 UIViewController");
        [self bar];
        [self container];
    }
}

- (void)setScrollEnabled:(BOOL)scrollEnabled {
    _scrollEnabled = scrollEnabled;
    self.container.scrollEnable = scrollEnabled;
}

- (void)updateTabToolStyle:(void(^)(ICTabToolStyleModel *style))block {
    ICTabToolStyleModel *style = [ICTabToolStyleModel defultCongfig];
    if (block) {
        block(style);
        [self.bar setStyle:style];
        
    }else {
        
    }
}

/**
 选项卡被点击 触发
 
 @param index 索引
 @param formIndex 索引
 */
- (void)tabToolDidSelectIndex:(NSInteger)index fromIndex:(NSInteger)formIndex {
    [self.container viewScrollToIndex:index];
}

- (void)view:(ICViewSetter *)view didEndScroll:(UIScrollView *)scrollView {
    NSInteger index = scrollView.contentOffset.x / scrollView.bounds.size.width;
    [self.bar setSelectedIndex:index];
}

- (void)view:(ICViewSetter *)view srollFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex progress:(CGFloat)progress {
    [self.bar setSourceIndex:fromIndex targetIndex:toIndex progress:progress];
}


/**
 获取数据源
 */
- (ICTabToolStyle)tabToolStyle {
    if ([self.delegate respondsToSelector:@selector(styleForTabTool)])
    {
        return  [self.delegate styleForTabTool];
    }
    return ICTabToolStyleNormal;
}

- (NSArray <UIViewController *>*)childVCs {
    if (_childVCs == nil) {
        _childVCs = [self.delegate childViewControllersForMainViewController];
        [_childVCs enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [self.mainViewController addChildViewController:obj];
        }];
    }
    return _childVCs;
}

- (NSArray <NSString *>*)tabToolTitleArray {
    return [self.delegate titleArrayForTabTool];
}

- (CGRect)tabToolFrame {
    NSAssert([self.delegate respondsToSelector:@selector(frameForTabTool)], @"自定义风格需要实现pagingControllerComponentSegmentFrame协议");
    return [self.delegate frameForTabTool];
}

- (CGFloat)viewHeight {
    return [self.delegate heightForViewInChildViewController];
}

- (UIView *)viewInMainViewController {
    UIViewController *delegate = (UIViewController *)self.delegate;
    return delegate.view;
}

- (UIViewController *)mainViewController {
    return (UIViewController *)self.delegate;
}

- (CGRect)viewFrameInMainViewController {
    CGRect viewFrame = CGRectMake(self.tabToolFrame.origin.x, CGRectGetMaxY(self.tabToolFrame), self.tabToolFrame.size.width, self.viewHeight);
    return viewFrame;
}

- (ICTabToolTemplate *)bar {
    if (_bar == nil) {
        if ([self.delegate respondsToSelector:@selector(customTabTool)]) {
            _bar = [self.delegate customTabTool];
        }else {
            _bar = [ICTabToolSetter manufacturingWithStyle:self.tabToolStyle
                                                         frame:self.tabToolFrame
                                                         items:self.tabToolTitleArray];
        }
        _bar.delegate = self;
        [self.viewInMainViewController addSubview:_bar];
    }
    return _bar;
}

- (ICViewSetter *)container {
    if (_container == nil) {
        _container = [ICViewSetter containerWithFrame:self.viewFrameInMainViewController];
        _container.scrollEnable = self.scrollEnabled;
        _container.delegate = self;
        _container.childControllers = self.childVCs;
        [self.viewInMainViewController addSubview:_container];
    }
    return _container;
}
@end
