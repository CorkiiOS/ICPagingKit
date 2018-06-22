//
//  ICTabToolStyleModel.h
//  ICPagerComponent
//
//  Created by mac on 2017/5/1.
//  Copyright © 2017年 iCorki. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "ICPagingKitDefines.h"
@interface ICTabToolStyleModel : NSObject

/**
 标题普通颜色
 */
@property (nonatomic, strong) UIColor *normalColor;


/**
 标题选中颜色
 */
@property (nonatomic, strong) UIColor *selectColor;

/**
 下划线颜色
 */
@property (nonatomic, strong) UIColor *indicatorColor;

/**
 背景颜色
 */
@property (nonatomic, strong) UIColor *backgroundColor;

/**
 标题字号
 */
@property (nonatomic, assign) CGFloat titleFont;

/**
 下划线风格
 */
@property (nonatomic, assign) ICTabToolUnderLineStyle underLineStyle;


/**
 文字动画
 */
@property (nonatomic, assign) ICTabToolTextAnimatedStyle textAnimatedStyle;


/**
 下划线动画风格
 */
@property (nonatomic, assign) ICTabToolUnderLineAnimatedStyle underLineAnimatedStyle;



/**
 默认配置

 @return ICTabToolStyleModel
 */
+ (instancetype)defultCongfig;

@end
