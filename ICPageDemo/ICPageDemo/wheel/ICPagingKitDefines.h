//
//  ICPagingKitDefines.h
//  ICPageDemo
//
//  Created by 王志刚 on 2018/6/21.
//  Copyright © 2018年 iCorki. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 选项卡的风格
 */
typedef NS_ENUM(NSInteger , ICTabToolStyle) {
    ICTabToolStyleNormal,//普通
    ICTabToolStyleControl,//系统的pagecontrol
    ICTabToolStyleNavSegment,//导航选项卡
    ICTabToolStyleCustomSuperView//导航选项卡
    
};

/**
 下划线的风格
 */
typedef NS_ENUM(NSInteger , ICTabToolUnderLineStyle) {
    ICTabToolUnderLineStyleNone,//无下划线
    ICTabToolUnderLineStyleNormal,//普通
    ICTabToolUnderLineStyleWidthEqual,//宽度和文字大小相同
    ICTabToolUnderLineStyleSplitScreen//平分屏幕
};

/**
 文字动画
 */
typedef NS_OPTIONS(NSInteger , ICTabToolTextAnimatedStyle) {
    ICTabToolTextAnimatedNone = 0,//无动画
    ICTabToolTextAnimatedScale = 1 << 0,//放大
    ICTabToolTextAnimatedColorGradient = 1 << 1,//颜色渐变
};

/**
 下划线动画
 */
typedef NS_ENUM(NSInteger , ICTabToolUnderLineAnimatedStyle) {
    ICTabToolUnderLineAnimatedStyleNormal,//普通平移
    ICTabToolUnderLineAnimatedStyleEarthworm,//蚯蚓
};

#define IC_iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)
