//
//  ICTabToolNormal.h
//  ICPagingManager
//
//  Created by 万启鹏 on 2018/6/21.
//

#import "ICTabToolTemplate.h"


@class ICTabToolStyleModel;

@interface ICTabToolNormal : ICTabToolTemplate

@property (nonatomic, assign) NSInteger selectedIndex;

@property (nonatomic, strong) NSArray <NSString *>*items;

@end
