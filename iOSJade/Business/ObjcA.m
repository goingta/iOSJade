//
//  ObjcA.m
//  iOSJade
//
//  Created by goingta on 2019/6/10.
//  Copyright © 2019 goingta. All rights reserved.
//

#import "ObjcA.h"

@implementation ObjcA

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.modelb = [[ModelB alloc] init];
    }
    return self;
}

- (void)dealloc
{
    NSLog(@"ObjcA dealloc");
}

@end
