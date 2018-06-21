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
@interface ICPagingManager()<ICViewSetterDelegate, ICTabToolTemplateDelegate>

@property(nonatomic, strong) ICTabToolTemplate *bar;
@property(nonatomic, strong) ICViewSetter *container;
@property(nonatomic, strong) NSArray<UIViewController *> *childVCs;


/*选项卡风格*/
- (ICTabToolStyle)style;

/*选项卡frame*/
- (CGRect)pagingBarFrame;
/*选项卡标题集合*/
- (NSArray <NSString *>*)pagingBarTitles;
/*子控制器集合*/
- (NSArray <UIViewController *>*)pagingChildVCs;
/*子控制器view*/
- (CGFloat)pagingContentHeight;

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

- (void)setupPager{
    [self checkConditions];
    [self setTabTool];
    [self setContainerView];
}

- (void)checkConditions {
    self.childVCs = self.pagingChildVCs;
    NSAssert([self.delegate isKindOfClass:[UIViewController class]], @"delegate 必须继承 UIViewController");
    NSAssert(self.delegate, @"请先设置manager的delegate");
    NSAssert([self.delegate isKindOfClass:[UIViewController class]], @"manager的delegate必须是UIViewController Class");
    NSAssert(self.childVCs.count ==  self.pagingBarTitles.count, @"仔细确定控制器个数和标题个数是否相等");
}

- (void)setDelegate:(id<ICPagingManagerProtocol>)delegate {
    _delegate = delegate;
    [self setupPager];
}

/**
 设置选项卡
 */
- (void)setTabTool {
    
    if ([self.delegate respondsToSelector:@selector(customTabTool)]) {
        self.bar = [self.delegate customTabTool];
    }else {
        self.bar = [ICTabToolSetter manufacturingWithStyle:self.style
                                                     frame:self.pagingBarFrame
                                                     items:self.pagingBarTitles];
    }
    self.bar.delegate = self;
    
    UIViewController *delegate = (UIViewController *)self.delegate;
    [delegate.view addSubview:self.bar];

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
 内容
 */
- (void)setContainerView {
    UIViewController *delegate = (UIViewController *)self.delegate;
    CGRect frame = self.pagingBarFrame;
    frame.origin.y = CGRectGetMaxY(frame);
    frame.size.height = self.pagingContentHeight;

    ICViewSetter *container = [ICViewSetter containerWithFrame:frame];
    container.scrollEnable = self.scrollEnabled;
    container.delegate = self;
    [self.childVCs enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [delegate addChildViewController:obj];
    }];
    
    container.childControllers = self.childVCs;
    [delegate.view addSubview:container];
    self.container = container;
}

- (void)setScrollEnabled:(BOOL)scrollEnabled {
    _scrollEnabled = scrollEnabled;
    self.container.scrollEnable = scrollEnabled;
}

/**
 选项卡被点击 触发
 
 @param index 索引
 @param formIndex 索引
 */
- (void)tabToolDidSelectIndex:(NSInteger)index fromIndex:(NSInteger)formIndex {
    [self.container setContainerViewContentOffsetAtIndex:index];
}

- (void)IC_containerView:(ICViewSetter *)containerView
            didEndScroll:(UIScrollView *)scrollView
{
    NSInteger index = scrollView.contentOffset.x / scrollView.bounds.size.width;
    [self.bar setSelectedIndex:index];
}

- (void)IC_containerView:(ICViewSetter *)containerView
                progress:(CGFloat)progress
             sourceIndex:(NSInteger)sourceIndex
             targetIndex:(NSInteger)targetIndex
{
    [self.bar setSourceIndex:sourceIndex targetIndex:targetIndex progress:progress];
}

/**
 获取数据源
 */
- (ICTabToolStyle)style
{
    if ([self.delegate respondsToSelector:@selector(style)])
    {
        return  [self.delegate style];
    }
    return ICTabToolStyleNormal;
}

- (NSArray <UIViewController *>*)pagingChildVCs
{
    return [self.delegate pagingControllerComponentChildViewControllers];
}

- (NSArray <NSString *>*)pagingBarTitles
{
    return [self.delegate pagingControllerComponentSegmentTitles];
}

- (CGRect)pagingBarFrame
{
    NSAssert([self.delegate respondsToSelector:@selector(pagingControllerComponentSegmentFrame)], @"自定义风格需要实现pagingControllerComponentSegmentFrame协议");
    return [self.delegate pagingControllerComponentSegmentFrame];
}

- (CGFloat)pagingContentHeight
{
    return [self.delegate pagingControllerComponentContainerViewHeight];
}

@end
