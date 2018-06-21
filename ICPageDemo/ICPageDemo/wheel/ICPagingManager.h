//
//  ICPagingManager.h
//  Pods
//
//  Created by mac on 2017/6/6.
//
//

#import <UIKit/UIKit.h>
#import "ICPagingKitDefines.h"

NS_ASSUME_NONNULL_BEGIN

@protocol ICPagingManagerProtocol;
@class ICTabToolTemplate,ICTabToolStyleModel;


@interface ICPagingManager : NSObject

/**
 实例化

 @return instancetype
 */
+ (instancetype)manager;


/**
  加载分页管理器

 @param block 提供个性化配置
 */
- (void)updateTabToolStyle:(void(^)(ICTabToolStyleModel *style))block;

/**
 UIVIewController
 */
@property (nonatomic, weak) id<ICPagingManagerProtocol>delegate;


/**
 默认YES
 */
@property (nonatomic, assign) BOOL scrollEnabled;

@end



@protocol ICPagingManagerProtocol <NSObject>

@optional
/**
 客户端使用的风格 默认ICPagingComponentStyleNormal
 
 @return ICPagingComponentStyle
 */
- (ICTabToolStyle)styleForTabTool;


/**
 frame
 
 @return 标题位置
 */
- (CGRect)frameForTabTool;


/**
 选项卡的superview 默认为主控制器的view

 @return UIView
 */
- (UIView *)superViewForTabTool;


/**
 自定义选项卡

 @return 继承 ICTabToolTemplate 的选项卡
 */
- (ICTabToolTemplate *)customTabTool;

@required
/**
 数据源方法
 
 @return 子控制器数组
 */
- (NSArray <UIViewController *>*)childViewControllersForMainViewController;

/**
 标题
 
 @return 标题数组
 */
- (NSArray <NSString *>*)titleArrayForTabTool;

/**
 内容
 
 @return 内容高度
 */
- (CGFloat)heightForViewInChildViewController;

@end

NS_ASSUME_NONNULL_END

