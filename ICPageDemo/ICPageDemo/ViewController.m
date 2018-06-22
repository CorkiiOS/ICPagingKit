//
//  ViewController.m
//  ICPageDemo
//
//  Created by 万启鹏 on 2018/6/21.
//  Copyright © 2018年 iCorki. All rights reserved.
//

#import "ViewController.h"
#import "ICPagingKit.h"
#import "ICTnTViewController.h"
@interface ViewController ()<ICPagingManagerProtocol>
@property (nonatomic, strong) ICPagingManager *manager;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}
- (IBAction)action:(id)sender {
    
    ICTnTViewController *tnt = [ICTnTViewController new];
    [self.navigationController pushViewController:tnt animated:YES];
    
}


@end
