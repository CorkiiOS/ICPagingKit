//
//  ICTabToolSetter.m
//  ICPagingManager
//
//  Created by 万启鹏 on 2018/6/21.
//

#import "ICTabToolSetter.h"
#import "ICTabToolNormal.h"

@interface ICTabToolSetter()

@end

@implementation ICTabToolSetter

+ (ICTabToolTemplate *)manufacturingWithStyle:(ICTabToolStyle)style frame:(CGRect)frame items:(NSArray *)items {
    ICTabToolTemplate *bar = nil;
    switch (style) {
        case ICTabToolStyleNormal:
        {
            bar = [ICTabToolNormal tabToolWithFrame:frame];
        }
            break;
            
        case ICTabToolStyleControl:
        {
            //            bar = [[SegmentControl alloc] initWithFrame:frame];
        }
            break;
            
        case ICTabToolStyleNavSegment:
        {
            //            ICSystemSegmentedControl *segBar = [[ICSystemSegmentedControl alloc] initWithItems:items];
            //            segBar.frame = CGRectMake(0, 7, 150, 30);
            //            segBar.selectedSegmentIndex = 0;
            //            segBar.tintColor = [UIColor colorWithRed:250/255.0 green:79/255.0 blue:71/255.0 alpha:1.0];
            //
            //            bar = segBar;
        }
            break;
            
        case ICTabToolStyleCustomSuperView:
        {
            //            CGFloat statusBarH = [UIApplication sharedApplication].statusBarFrame.size.height;
            //            CGFloat w = [UIScreen mainScreen].bounds.size.width;
            //            ICSystemSegmentedControl *segBar = [[ICSystemSegmentedControl alloc] initWithItems:items];
            //            segBar.frame = CGRectMake(w / 2 - 75, statusBarH + 7, 150, 30);
            //            segBar.selectedSegmentIndex = 0;
            //            segBar.tintColor = [UIColor whiteColor];
        }
            break;
            
        default:
            break;
    }
    
    //    [bar setDelegate:manager];
        [bar setItems:items];
    
    return bar;
}


@end
