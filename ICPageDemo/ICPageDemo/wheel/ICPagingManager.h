//
//  ICPagingManager.h
//  Pods
//
//  Created by mac on 2017/6/6.
//
//

#import <Foundation/Foundation.h>
#import "ICPagingManagerProtocol.h"
#import "ICTabToolStyleModel.h"
#import "ICTabToolSetter.h"

@protocol ICTabToolProtocol, ICPagingManagerProtocol;
@class ICTabToolTemplate;


@interface ICPagingManager : NSObject

/**
 UIVIewController
 */
@property (nonatomic, weak) id<ICPagingManagerProtocol>delegate;


/**
 默认YES
 */
@property (nonatomic, assign) BOOL scrollEnabled;


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
@end


@protocol ICPagingManagerProtocol <NSObject>

@optional
/**
 客户端使用的风格 默认ICPagingComponentStyleNormal
 
 @return ICPagingComponentStyle
 */
- (ICTabToolStyle)style;


/**
 frame
 
 @return 标题位置
 */
- (CGRect)tabToolFrame;

- (UIView *)superViewForTabTool;

- (ICTabToolTemplate *)customTabTool;

@required
/**
 数据源方法
 
 @return 子控制器数组
 */
- (NSArray <UIViewController *>*)pagingControllerComponentChildViewControllers;

/**
 标题
 
 @return 标题数组
 */
- (NSArray <NSString *>*)pagingControllerComponentTabToolTitles;

/**
 内容
 
 @return 内容高度
 */
- (CGFloat)pagingControllerComponentContainerViewHeight;

@end
