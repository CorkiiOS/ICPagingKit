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
    _lastBtn.selected = YES;
    [self setNeedsLayout];//标记需要重新布局
    [self layoutIfNeeded];
    
}

- (void)setStyle:(ICTabToolStyleModel *)style {
    _style = style;
    for (UIButton *btn in self.itemBtns)
    {
        [btn sizeToFit];
        [btn setTitleColor:self.style.normalColor forState:UIControlStateNormal];
        [btn setTitleColor:self.style.selectColor forState:UIControlStateSelected];
        [btn.titleLabel setFont:[UIFont systemFontOfSize:self.style.titleFont]];
    }
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
    
    _lastBtn.selected = NO;
    sender.selected = YES;
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
- (void)setTitleWithProgress:(CGFloat)progress
                 sourceIndex:(NSInteger)sourceIndex
                 targetIndex:(NSInteger)targetIndex
{
    // 1.取出sourceLabel/targetLabel
    UIButton *sourceBtn = self.itemBtns[sourceIndex];
    UIButton *targetBtn =  self.itemBtns[targetIndex];
    
    // 2.处理滑块的逻辑
    CGFloat moveTotalX = sourceBtn.frame.origin.x - targetBtn.frame.origin.x ;
    CGFloat moveX = moveTotalX * progress;
    
    CGRect scrollLineFrame = self.indicatorView.frame;
    
    scrollLineFrame.origin.x = targetBtn.frame.origin.x + moveX;;
    
    self.indicatorView.frame = scrollLineFrame;
    // 3.颜色的渐变(复杂)
    // 3.1.取出变化的范围
    //    CGFloat normalR, normalG, normalB = 0;
    //    CGFloat selectedR, selectedG, selectedB = 0;
    //
    //    [self getRGBColor:self.style.normalColor r:&normalR g:&normalG b:&normalB];
    //    [self getRGBColor:self.style.selectColor r:&selectedR g:&selectedG b:&selectedB];
    //
    //    CGFloat r = (selectedR - normalR) * progress;
    //    CGFloat g = (selectedG - normalG) * progress;
    //    CGFloat b = (selectedB - normalB) * progress;
    //
    //    // 3.2.变化targetLabel
    //
    //    [sourceBtn setTitleColor:[UIColor colorWithRed:normalR + r green:normalG + g blue:normalB + b alpha:1.0] forState:UIControlStateNormal];
    //
    //    [targetBtn setTitleColor:[UIColor colorWithRed:selectedR + r green:selectedG + g blue:selectedB + b alpha:1.0] forState:UIControlStateNormal];
    
    // 4.记录最新的index
}

- (void)getRGBColor:(UIColor *)color
                  r:(CGFloat *)r
                  g:(CGFloat *)g
                  b:(CGFloat *)b
{
    CGColorRef cgColor = [color CGColor];
    NSInteger numComponents = CGColorGetNumberOfComponents(cgColor);
    
    if (numComponents == 4) {
        
        const CGFloat *components = CGColorGetComponents(cgColor);
        *r = components[0];
        *g = components[1];
        *b = components[2];
    }
    
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

