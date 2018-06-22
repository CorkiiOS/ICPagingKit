//
//  ICTabToolNormal.m
//  ICPagingManager
//
//  Created by 万启鹏 on 2018/6/21.
//

#import "ICTabToolNormal.h"
#import "UIView+ICFrame.h"
#import "ICTabToolStyleModel.h"

static CGFloat const ICTabToolMargin = 10;

@interface ICTabToolNormal()
{
    UIButton *_lastBtn;
}
@property (nonatomic, strong) UIScrollView *contentView;
@property (nonatomic, strong) NSMutableArray <UIButton *>*itemBtns;
@property (nonatomic, strong) UIView *indicatorView;
@property (nonatomic, strong) ICTabToolStyleModel *style;

@end

@implementation ICTabToolNormal

@synthesize style = _style;

+ (instancetype)tabToolWithFrame:(CGRect)frame
{
    ICTabToolNormal *tabTool = [[ICTabToolNormal alloc] initWithFrame:frame];
    UIScrollView *contentView = [[UIScrollView alloc] init];
    contentView.showsHorizontalScrollIndicator = NO;
    contentView.showsVerticalScrollIndicator = NO;
    contentView.scrollsToTop = NO;
    [tabTool addSubview:contentView];
    tabTool.contentView = contentView;
    return tabTool;
}

- (void)setItems:(NSArray<NSString *> *)items
{
    _items = items;
    [self.itemBtns makeObjectsPerformSelector:@selector(removeAllObjects)];
    self.itemBtns = nil;
    
    for (NSString *title in items)
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = self.itemBtns.count;
        [btn sizeToFit];
        [btn setTitle:title forState:UIControlStateNormal];
        [btn setTitleColor:self.style.normalColor forState:UIControlStateNormal];
        [btn setTitleColor:self.style.selectColor forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.itemBtns addObject:btn];
        [self.contentView addSubview:btn];
    }
    _lastBtn = self.itemBtns.count > 0?  self.itemBtns[0] : nil;
    [_lastBtn setTitleColor:self.style.selectColor forState:(UIControlStateNormal)];
    [self setNeedsLayout];//标记需要重新布局
    [self layoutIfNeeded];
    
}

- (void)setStyle:(ICTabToolStyleModel *)style {
    _style = style;
    for (UIButton *btn in self.itemBtns)
    {
        [btn sizeToFit];
        [btn setTitleColor:self.style.normalColor forState:UIControlStateNormal];
        [btn.titleLabel setFont:[UIFont systemFontOfSize:self.style.titleFont]];
    }
    [_lastBtn setTitleColor:self.style.selectColor forState:(UIControlStateNormal)];
    self.indicatorView.backgroundColor = self.style.indicatorColor;
    self.contentView.backgroundColor = self.style.backgroundColor;
}

- (void)setSelectedIndex:(NSInteger)selectedIndex
{
    _selectedIndex = selectedIndex;
    [self btnAction:self.itemBtns[selectedIndex]];
}

- (void)btnAction:(UIButton *)sender
{
    if (_lastBtn == sender) return;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(tabToolDidSelectIndex:
                                                                     fromIndex:)]) {
        
        [self.delegate tabToolDidSelectIndex:sender.tag
                                      fromIndex:_lastBtn.tag];
    }
    
    [_lastBtn setTitleColor:self.style.normalColor forState:(UIControlStateNormal)];
    [sender setTitleColor:self.style.selectColor forState:(UIControlStateNormal)];
    _lastBtn = sender;
    
    [UIView animateWithDuration:0.1 animations:^
     {
         self.indicatorView.width = sender.width;
         self.indicatorView.centerX = sender.centerX;
     }];
    
    CGFloat scrollx = sender.centerX - self.contentView.width * 0.5;
    
    if (scrollx < 0)
    {
        scrollx = 0;
    }
    
    if (scrollx > self.contentView.contentSize.width - self.contentView.width)
    {
        scrollx = self.contentView.contentSize.width - self.contentView.width;
    }
    
    [self.contentView setContentOffset:CGPointMake(scrollx, 0) animated:YES];
}

- (void)setFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex progress:(CGFloat)progress {
    if (fromIndex < 0 ||
        fromIndex >= self.itemBtns.count ||
        toIndex < 0 ||
        toIndex >= self.itemBtns.count
        ) {
        return;
    }
    UIButton *fromBtn = self.itemBtns[fromIndex];
    UIButton *toBtn =  self.itemBtns[toIndex];
    
    CGFloat xDistance = toBtn.x - fromBtn.x;
    CGFloat wDistance = toBtn.width - fromBtn.width;
    
    self.indicatorView.x = fromBtn.x + xDistance *progress;
    self.indicatorView.width = fromBtn.width + wDistance * progress;
    
    
    
    NSArray *selArray = [self getRGBColor:self.style.selectColor];
    NSArray *norArray = [self getRGBColor:self.style.normalColor];

    CGFloat to_r = [norArray[0] floatValue];
    CGFloat to_g = [norArray[1] floatValue];
    CGFloat to_b = [norArray[2] floatValue];
    CGFloat from_r = [selArray[0] floatValue];
    CGFloat from_g = [selArray[1] floatValue];
    CGFloat from_b = [selArray[2] floatValue];
    CGFloat mid_r = [norArray[0] floatValue] - [selArray[0] floatValue];
    CGFloat mid_g = [norArray[1] floatValue] - [selArray[1] floatValue];
    CGFloat mid_b = [norArray[2] floatValue] - [selArray[2] floatValue];

    [fromBtn setTitleColor:[UIColor colorWithRed:(from_r + mid_r * progress)
                                           green:(from_g + mid_g * progress)
                                            blue:(from_b + mid_b * progress)
                                           alpha:1.0]
                  forState:(UIControlStateNormal)];
    
    [toBtn setTitleColor:[UIColor colorWithRed:(to_r - mid_r * progress)
                                         green:(to_g - mid_g * progress)
                                          blue:(to_b - mid_b * progress)
                                         alpha:1.0]
                forState:(UIControlStateNormal)];
}


- (NSArray *)getRGBColor:(UIColor *)color {
    CGColorRef cgColor = [color CGColor];
    NSInteger numComponents = CGColorGetNumberOfComponents(cgColor);
    
    if (numComponents == 4) {
        
        const CGFloat *components = CGColorGetComponents(cgColor);
        return @[@(components[0]),
                 @(components[1]),
                 @(components[2])];
    }
    return nil;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.contentView.frame = self.bounds;
    CGFloat totalBtnWidth = 0;
    
    for (UIButton *btn in self.itemBtns)
    {
        [btn sizeToFit];
        totalBtnWidth += btn.width;
    }
    
    CGFloat margin = (self.width - totalBtnWidth) / (self.itemBtns.count + 1);
    
    if (margin < ICTabToolMargin)
    {
        margin = ICTabToolMargin;
    }
    
    CGFloat x = margin;
    
    for (UIButton *btn in self.itemBtns)
    {
        totalBtnWidth += btn.width;
        btn.x = x;
        btn.centerY = self.height / 2;
        x += btn.width + margin;
    }
    
    self.indicatorView.width = _lastBtn.width;
    self.indicatorView.centerX = _lastBtn.centerX;
    self.indicatorView.y = self.height - 2;
    self.indicatorView.height = 2;
    
    [self.contentView setContentSize:CGSizeMake(x, 0)];
}

- (UIView *)indicatorView
{
    if (_indicatorView == nil)
    {
        _indicatorView = [[UIView alloc] init];
        _indicatorView.backgroundColor = [UIColor redColor];
        [self.contentView addSubview:_indicatorView];
    }
    return _indicatorView;
}

- (NSMutableArray *)itemBtns
{
    if (_itemBtns == nil)
    {
        _itemBtns = [NSMutableArray array];
    }
    return _itemBtns;
}

- (ICTabToolStyleModel *)style
{
    if (_style == nil)
    {
        _style = [ICTabToolStyleModel defultCongfig];
    }
    return _style;
}
@end

