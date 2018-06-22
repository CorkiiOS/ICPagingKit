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

- (instancetype)init {
    self = [super init];
    if (self) {
        _scrollEnabled = YES;
        _bounces = YES;
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

- (void)setBounces:(BOOL)bounces {
    _bounces = bounces;
    self.container.bounces = bounces;
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
    [self.bar setFromIndex:fromIndex toIndex:toIndex progress:progress];
}


/**
 获取数据源
 */
- (ICTabToolStyle)tabToolStyle {
    if ([self.delegate respondsToSelector:@selector(styleForTabTool)]) {
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
    CGFloat navH = [UIApplication sharedApplication].statusBarFrame.size.height + 44;
    CGSize size = [UIScreen mainScreen].bounds.size;
    CGRect tabToolFrame = CGRectMake(0, navH, size.width, 49);
    if ([self.delegate respondsToSelector:@selector(frameForTabTool)]) {
        tabToolFrame = [self.delegate frameForTabTool];
    }
    return tabToolFrame;
}

- (CGFloat)viewHeight {
    CGFloat navH = [UIApplication sharedApplication].statusBarFrame.size.height + 44;
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    CGFloat offset = IC_iPhoneX? 34 : 0;
    CGFloat viewHeight = height - navH - 49 - offset;
    if ([self.delegate respondsToSelector:@selector(heightForViewInChildViewController)]) {
        viewHeight = [self.delegate heightForViewInChildViewController];
    }
    return viewHeight;
}

- (UIView *)viewInMainViewController {
    UIViewController *delegate = (UIViewController *)self.delegate;
    return delegate.view;
}

- (UIViewController *)mainViewController {
    return (UIViewController *)self.delegate;
}

- (CGRect)viewFrameInMainViewController {
    CGRect viewFrame = CGRectMake(self.tabToolFrame.origin.x,
                                  CGRectGetMaxY(self.tabToolFrame),
                                  self.tabToolFrame.size.width,
                                  self.viewHeight);
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
        _container = [ICViewSetter containerWithFrame:self.viewFrameInMainViewController
                                    mainViewControler:self.mainViewController
                                     childControllers:self.childVCs];
        _container.scrollEnable = self.scrollEnabled;
        _container.delegate = self;
        _container.bounces = self.bounces;
        [self.viewInMainViewController addSubview:_container];
    }
    return _container;
}
@end
