//
//  ICViewSetter.h
//  ICPagerComponent
//
//  Created by mac on 2017/5/2.
//  Copyright © 2017年 iCorki. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ICViewSetter;
@protocol ICViewSetterDelegate <NSObject>

@optional

- (void)IC_containerView:(ICViewSetter *)containerView
            didBeginDragging:(UIScrollView *)scrollView;

- (void)IC_containerView:(ICViewSetter *)containerView
            didEndScroll:(UIScrollView *)scrollView;

- (void)IC_containerView:(ICViewSetter *)containerView
               progress:(CGFloat)progress
            sourceIndex:(NSInteger)sourceIndex
            targetIndex:(NSInteger)targetIndex;
@end

@interface ICViewSetter : UIView

@property (nonatomic, strong) NSArray <UIViewController *>*childControllers;
@property (nonatomic, weak) id <ICViewSetterDelegate>delegate;

@property (nonatomic, assign) BOOL scrollEnable;

+ (instancetype)containerWithFrame:(CGRect)frame;

- (void)setContainerViewContentOffsetAtIndex:(NSInteger)index;



@end
