//
//  RunloopObject.m
//  iOSJade
//
//  Created by goingta on 2019/6/4.
//  Copyright © 2019 goingta. All rights reserved.
//

#import "RunloopObject.h"

@implementation RunloopObject

- (void)clock {
    NSTimer *timer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(updateTimer) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
    
//    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateTimer) userInfo:nil repeats:YES];
}

- (void)updateTimer {
    static int num = 0;
    NSLog(@"%@  %d",[NSThread currentThread],num++);
}

@end
