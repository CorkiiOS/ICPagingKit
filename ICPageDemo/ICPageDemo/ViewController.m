//
//  ViewController.m
//  ICPageDemo
//
//  Created by 万启鹏 on 2018/6/21.
//  Copyright © 2018年 iCorki. All rights reserved.
//

#import "ViewController.h"
#import "ICPagingKit.h"
@interface ViewController ()<ICPagingManagerProtocol>
@property (nonatomic, strong) ICPagingManager *manager;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.manager = [ICPagingManager manager];
    self.manager.delegate = self;
    
    [self.manager updateTabToolStyle:^(ICTabToolStyleModel *style) {
        style.normalColor = [UIColor yellowColor];
    }];
}


- (CGRect)frameForTabTool {
    return CGRectMake(0, 64, self.view.bounds.size.width, 50);
}

- (nonnull NSArray<UIViewController *> *)childViewControllersForMainViewController {
    UIViewController *v = [UIViewController new];
    v.view.backgroundColor = [UIColor redColor];
    
    UIViewController *v1 = [UIViewController new];
    v1.view.backgroundColor = [UIColor cyanColor];
    
    UIViewController *v2 = [UIViewController new];
    v2.view.backgroundColor = [UIColor yellowColor];
    
    
    return @[v,v1,v2];
}

- (CGFloat)heightForViewInChildViewController {
    return self.view.bounds.size.height - 64 - 50;

}

- (nonnull NSArray<NSString *> *)titleArrayForTabTool {
    return @[@"哈哈", @"哈啊哈哈",
             @"hahah"];
}


@end
