//
//  ICViewSetter.h
//  ICPagerComponent
//
//  Created by mac on 2017/5/2.
//  Copyright © 2017年 iCorki. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ICViewSetterDelegate;

NS_ASSUME_NONNULL_BEGIN

@interface ICViewSetter : UIView

@property (nonatomic, weak) id <ICViewSetterDelegate>delegate;
@property (nonatomic, assign) BOOL scrollEnable;
@property (nonatomic, assign) BOOL bounces;

+ (instancetype)containerWithFrame:(CGRect)frame
                 mainViewControler:(UIViewController *)mainViewControler
                  childControllers:(NSArray <UIViewController *>*)childControllers;

- (void)viewScrollToIndex:(NSInteger)index;

@end

@protocol ICViewSetterDelegate <NSObject>

@optional

- (void)view:(ICViewSetter *)view didBeginDragging:(UIScrollView *)scrollView;
- (void)view:(ICViewSetter *)view didEndDragging:(UIScrollView *)scrollView;
- (void)view:(ICViewSetter *)view didScroll:(UIScrollView *)scrollView;
- (void)view:(ICViewSetter *)view didEndScroll:(UIScrollView *)scrollView;

- (void)view:(ICViewSetter *)view srollFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex progress:(CGFloat)progress;

@end

NS_ASSUME_NONNULL_END
