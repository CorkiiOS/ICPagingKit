//
//  ICTnTViewController.m
//  ICPageDemo
//
//  Created by 万启鹏 on 2018/6/22.
//  Copyright © 2018年 iCorki. All rights reserved.
//

#import "ICTnTViewController.h"
#import "ICPagingKit.h"
@interface ICTnTViewController ()<ICPagingManagerProtocol>
@property (nonatomic, strong) ICPagingManager *manager;
@end

@implementation ICTnTViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.manager = [ICPagingManager manager];
    self.manager.delegate = self;
    
    [self.manager updateTabToolStyle:^(ICTabToolStyleModel *style) {
        style.backgroundColor = [UIColor purpleColor];
    }];
}

- (nonnull NSArray<UIViewController *> *)childViewControllersForMainViewController {
    UIViewController *v = [UIViewController new];
    v.view.backgroundColor = [UIColor redColor];
    
    UIViewController *v1 = [UIViewController new];
    v1.view.backgroundColor = [UIColor cyanColor];
    
    UIViewController *v2 = [UIViewController new];
    v2.view.backgroundColor = [UIColor yellowColor];
    
    
    return @[v,v1,v2,v,v1,v2,v,v1,v2,v,v1,v2];
}

- (nonnull NSArray<NSString *> *)titleArrayForTabTool {
    return @[@"哈哈",
             @"哈啊哈哈",
             @"hahah",@"哈哈",
             @"哈啊哈哈",
             @"hahah",@"哈哈",
             @"哈啊哈哈",
             @"hahah",@"哈哈",
             @"哈啊哈哈",
             @"hahah"];
}

@end
