//
//  ICTabToolStyleModel.m
//  ICPagerComponent
//
//  Created by mac on 2017/5/1.
//  Copyright © 2017年 iCorki. All rights reserved.
//

#import "ICTabToolStyleModel.h"

@interface ICTabToolStyleModel()
@end

@implementation ICTabToolStyleModel

+ (instancetype)defultCongfig {
    
    ICTabToolStyleModel *config = [ICTabToolStyleModel new];
    config.normalColor = [UIColor blackColor];
    config.selectColor = [UIColor redColor];
    config.indicatorColor = [UIColor redColor];
    config.backgroundColor = [UIColor whiteColor];
    config.titleFont = 15;
    
    return config;
}
//
//- (ICTabToolStyleModel *(^)(UIColor *))nor_color {
//    
//    return ^ICTabToolStyleModel * (UIColor *color) {
//        
//        self.normalColor = color;
//        return self;
//    };
//}
//
//- (ICTabToolStyleModel *(^)(UIColor *))sel_color {
//    
//    return ^ICTabToolStyleModel * (UIColor *color) {
//        
//        self.selectColor = color;
//        return self;
//    };
//}
//
//- (ICTabToolStyleModel *(^)(UIColor *))line_color {
//    
//    return ^ICTabToolStyleModel * (UIColor *color) {
//        
//        self.indicatorColor = color;
//        return self;
//    };
//}
//
//- (ICTabToolStyleModel *(^)(UIColor *))bg_color {
//    
//    return ^ICTabToolStyleModel * (UIColor *color) {
//        
//        self.backgroundColor = color;
//        return self;
//    };
//}
//
//- (ICTabToolStyleModel *(^)(CGFloat))tt_font {
//    
//    return ^ICTabToolStyleModel * (CGFloat font) {
//        
//        self.titleFont = font;
//        return self;
//    };
//}
@end
