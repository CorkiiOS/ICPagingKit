//
//  ICTabToolSetter.h
//  ICPagingManager
//
//  Created by 万启鹏 on 2018/6/21.
//

#import <UIKit/UIKit.h>
#import "ICPagingKitDefines.h"
@class ICTabToolTemplate;

@interface ICTabToolSetter : NSObject

+ (ICTabToolTemplate *)manufacturingWithStyle:(ICTabToolStyle)style frame:(CGRect)frame items:(NSArray *)items;


@end
