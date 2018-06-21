//
//  ICTabToolProtocol.h
//  ICPagingManager
//
//  Created by 万启鹏 on 2018/6/21.
//

#import <Foundation/Foundation.h>

@class ICTabToolStyleModel;

@protocol ICTabToolProtocol <NSObject>

@optional
/**
 标题
 */
@property (nonatomic, strong) NSArray <NSString *>*items;


/**
 选择Index
 */
@property (nonatomic, assign) NSInteger selectedIndex;

/**
 选项卡
 
 @param index 点击选项
 @param formIndex 上次点击的选项
 */
- (void)segmentBarDidSelectIndex:(NSInteger)index
                       fromIndex:(NSInteger)formIndex;



/**
 设置选项卡代理
 
 @param delegate 代理
 */
- (void)setDelegate:(id)delegate;


/**
 更新标题属性
 
 @param block 配置
 */
- (void)updateWithConfig:(void(^)(ICTabToolStyleModel *config))block;


/**
 设置
 
 @param progress 进度
 @param sourceIndex 原来Index
 @param targetIndex 目标Index
 */
- (void)setTitleWithProgress:(CGFloat)progress
                 sourceIndex:(NSInteger)sourceIndex
                 targetIndex:(NSInteger)targetIndex;

- (void)contentViewBeginDragging;

@end
