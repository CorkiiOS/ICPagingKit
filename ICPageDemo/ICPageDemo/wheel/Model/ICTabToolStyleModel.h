//
//  ICTabToolStyleModel.h
//  ICPagerComponent
//
//  Created by mac on 2017/5/1.
//  Copyright © 2017年 iCorki. All rights reserved.
//


#import <UIKit/UIKit.h>

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
 默认配置

 @return ICTabToolStyleModel
 */
+ (instancetype)defultCongfig;

@end
