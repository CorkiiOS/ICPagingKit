//
//  ICTabToolSetter.h
//  ICPagingManager
//
//  Created by 万启鹏 on 2018/6/21.
//

#import <UIKit/UIKit.h>

@protocol ICTabToolProtocol, ICPagingManagerProtocol;
@class ICTabToolTemplate;
/**
 选项卡的风格
 */
typedef NS_ENUM(NSInteger , ICTabToolStyle) {
    ICTabToolStyleNormal,//普通
    ICTabToolStyleControl,//系统的pagecontrol
    ICTabToolStyleNavSegment,//导航选项卡
    ICTabToolStyleCustomSuperView//导航选项卡
    
};

@interface ICTabToolSetter : NSObject

+ (ICTabToolTemplate *)manufacturingWithStyle:(ICTabToolStyle)style frame:(CGRect)frame items:(NSArray *)items;


@end
