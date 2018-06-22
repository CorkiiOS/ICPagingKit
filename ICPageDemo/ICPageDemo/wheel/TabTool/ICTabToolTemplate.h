//
//  ICTabToolTemplate.h
//  ICPageDemo
//
//  Created by 万启鹏 on 2018/6/21.
//  Copyright © 2018年 iCorki. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class ICTabToolStyleModel;
@protocol ICTabToolTemplateDelegate;

@interface ICTabToolTemplate : UIView

@property (nonatomic, weak)id<ICTabToolTemplateDelegate>delegate;

- (void)setSelectedIndex:(NSInteger)selectedIndex;

- (void)setItems:(NSArray<NSString *> *)items;

- (void)setStyle:(ICTabToolStyleModel *)style;

/**
 设置
 
 @param progress 进度
 @param fromIndex 原来Index
 @param toIndex 目标Index
 */
- (void)setFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex progress:(CGFloat)progress;

+ (instancetype)tabToolWithFrame:(CGRect)frame;

@end

@protocol ICTabToolTemplateDelegate<NSObject>

/**
 选项卡
 
 @param index 点击选项
 @param formIndex 上次点击的选项
 */
- (void)tabToolDidSelectIndex:(NSInteger)index
                    fromIndex:(NSInteger)formIndex;

@end
NS_ASSUME_NONNULL_END
