//
//  TestObj.m
//  iOSJade
//
//  Created by goingta on 2019/6/10.
//  Copyright © 2019 goingta. All rights reserved.
//

#import "TestObj.h"

@implementation TestObj

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.testa = [[ObjcA alloc] init];
    }
    return self;
}

- (void)dealloc
{
    NSLog(@"TestObj dealloc");
}

@end
