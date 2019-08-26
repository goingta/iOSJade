//
//  TestViewController.m
//  iOSJade
//
//  Created by goingta on 2019/6/10.
//  Copyright © 2019 goingta. All rights reserved.
//

#import "TestViewController.h"

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.test = [[TestObj alloc] init];
    self.test.testa.modelb = self.test;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSLog(@"test 对象释放了");
        self.test = nil;
    });
}

@end
